Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E89117E918;
	Wed,  3 Jul 2024 10:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003382; cv=none; b=aDov4dq7o183MseYSyRO6PjLl8OrIocXZW376Kl7Afl+tTiDEeijBtQPMap8SjkeD1qfRNPolP0gp+jtGZxMd4ePWZ4KqhrM16rh8Joe/KwOKkTJs+4oefu9g7x4gXi8rdp4wnuUBnzAHZg9KX7YfPx2kM4mdQMcmS27C7plzwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003382; c=relaxed/simple;
	bh=8giYXFnlPUDd7KIqMP7JUgOouqhHssnyvWDvUfd9WuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pmy/wszGB/SWxlgDg71UvLe2QxevX6PdhEP+G7KBYZLclkxy7WhBMT7FulK83nIC7ckBI3XDJ17IjLJ7luYI30RumiHWlENFzVzgHxn3CQdPgbhQ76WltSBLdSZENUuNzFEf33u6KvCVB7SuZL7FZn0bcQ+VjjivJhbmxoLbcrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xvIA1M/v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xvIA1M/v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9D49C4AF0D;
	Wed,  3 Jul 2024 10:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003382;
	bh=8giYXFnlPUDd7KIqMP7JUgOouqhHssnyvWDvUfd9WuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xvIA1M/vMwOKf+zfPnJQmL3IxANP6YBi/hR6wlAn73IS05/NvO2WZO3G96KkFPaj2
	 DOV6tOEkpCW41/LwOmlXUDZtcoMZbQtogTfM0bk6cSCmPPIEew+DCJK7g6Hz2eJkqv
	 mDXWRl7fWLd8PzEQtc/GtIRzwyNe3z15co3qzmk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9dfe490c8176301c1d06@syzkaller.appspotmail.com,
	Dave Kleikamp <shaggy@kernel.org>
Subject: [PATCH 4.19 031/139] jfs: xattr: fix buffer overflow for invalid xattr
Date: Wed,  3 Jul 2024 12:38:48 +0200
Message-ID: <20240703102831.617036379@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 7c55b78818cfb732680c4a72ab270cc2d2ee3d0f upstream.

When an xattr size is not what is expected, it is printed out to the
kernel log in hex format as a form of debugging.  But when that xattr
size is bigger than the expected size, printing it out can cause an
access off the end of the buffer.

Fix this all up by properly restricting the size of the debug hex dump
in the kernel log.

Reported-by: syzbot+9dfe490c8176301c1d06@syzkaller.appspotmail.com
Cc: Dave Kleikamp <shaggy@kernel.org>
Link: https://lore.kernel.org/r/2024051433-slider-cloning-98f9@gregkh
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/jfs/xattr.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/jfs/xattr.c
+++ b/fs/jfs/xattr.c
@@ -570,9 +570,11 @@ static int ea_get(struct inode *inode, s
 
       size_check:
 	if (EALIST_SIZE(ea_buf->xattr) != ea_size) {
+		int size = min_t(int, EALIST_SIZE(ea_buf->xattr), ea_size);
+
 		printk(KERN_ERR "ea_get: invalid extended attribute\n");
 		print_hex_dump(KERN_ERR, "", DUMP_PREFIX_ADDRESS, 16, 1,
-				     ea_buf->xattr, ea_size, 1);
+				     ea_buf->xattr, size, 1);
 		ea_release(inode, ea_buf);
 		rc = -EIO;
 		goto clean_up;


