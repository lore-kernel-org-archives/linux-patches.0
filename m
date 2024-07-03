Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D2517B518;
	Wed,  3 Jul 2024 10:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003863; cv=none; b=BO6GpyyUZTh3kR24ZYz7kaeUCydgw4oQUPAuFYQOZmrs/Obgv9rA7t01KL8rjeOk4fagFuiH2A6pLavH1Kq9W+wl26SxSeHMOFWnNi1ZrssqwT6Gn5+NlxYIuiLXQFQHBcKxPCgdF2K7dgbht6/ZdS83D6XIxg6kz7GwiFXSBys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003863; c=relaxed/simple;
	bh=wxLnhTI+QEb+ds6Rb8/gJrGeJ47OlnAoSLjvtfZvOZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sWdF0gzgOn0t2sgtdcb2kMR/4Thw0huWSTTumw845w8TXJzhblmzNTRanntYwwn77ijXk2T/fAOupiMAgp+KL+M9mzdC5UlrUrUw4EZ+sV82MAJNH9nXp0rssyDnYv/tI9zMWLCdNkwzmit8aTgYhg595joWazn9DaNABduq0nY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LSJZdcB7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LSJZdcB7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1D54C2BD10;
	Wed,  3 Jul 2024 10:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003863;
	bh=wxLnhTI+QEb+ds6Rb8/gJrGeJ47OlnAoSLjvtfZvOZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LSJZdcB7tSOt376nrMtWhaD4pIWNxT7f0n3zFrqn3G4/rkQsdqvitGhi8X45qj1RO
	 E+CfsCic/eBQF5C3ccrtmeS6ttej4k6uIlaDkUGOA98yakWZ2RYmsHMNeOgeSnhMiu
	 YuDMoJMj7usTvvuaoG/pw20V+7rFAW71Iy2Sxgy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9dfe490c8176301c1d06@syzkaller.appspotmail.com,
	Dave Kleikamp <shaggy@kernel.org>
Subject: [PATCH 5.4 045/189] jfs: xattr: fix buffer overflow for invalid xattr
Date: Wed,  3 Jul 2024 12:38:26 +0200
Message-ID: <20240703102843.212847276@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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


