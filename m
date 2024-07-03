Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EA2617E907;
	Wed,  3 Jul 2024 11:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005479; cv=none; b=WZOlrPR/c52e36UvORVwwufIr+D4m5qH7sNuxEvJBzMk6LQYVR0DmKpvpd/52jPQwyKjsiVg9Nd+8K7FlznyubndRgdZxIUx21HG95B9MWi93U0ARnkzQ8aCDQEDhMI6shkwlzfcbMFAWjMcDrwU3WKNXaZ6otDkTlYpi5XzXqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005479; c=relaxed/simple;
	bh=xLyQPwijlaKI/STzcc0V9uu5jFFOasKaVVrEURncdTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sIohsbBtKG8KEA7vYfHvU8QR3W1oTOvMa0xF/IaFS1TQll57/IybHb4mXFVXdJLZdjkomxM3gLqKW/dX1oIWsOgJQ/yGr2tQp0pMiGqkvV1CKXGserDUz+F3sRvPqtPMw/NpZ6l5Wfqy6I2OWbMXmGzjTibonuqqtk/zDDFE1kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XBbz5V0T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XBbz5V0T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EB5DC2BD10;
	Wed,  3 Jul 2024 11:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005478;
	bh=xLyQPwijlaKI/STzcc0V9uu5jFFOasKaVVrEURncdTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XBbz5V0TG4c5h5V8eDyjtMgfCpJphkWGMFS9qbeEnW1tJNCWXbHLS/w7kEslb5qaG
	 k4ieYJuXQLIwfjMBjt+kYPzF+f+JMuLunTAYVPJSCbUo4H2BNa//J9cryAgAHUfcM9
	 +qUNA/qND4Wgh4FYRtXN6NOOo43H6OaHzkCKnXow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9dfe490c8176301c1d06@syzkaller.appspotmail.com,
	Dave Kleikamp <shaggy@kernel.org>
Subject: [PATCH 5.15 077/356] jfs: xattr: fix buffer overflow for invalid xattr
Date: Wed,  3 Jul 2024 12:36:53 +0200
Message-ID: <20240703102916.017491417@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -557,9 +557,11 @@ static int ea_get(struct inode *inode, s
 
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


