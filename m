Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620954;
	b=s1nXKQtApakA+zpEqArylmnABo+EWowlB5P1W3/fykCjs6/TmiKu51NENiLS8rWj+G1i
	 y6z9UMTDaX388tJ/PNXnYs/O29OJVVCsXZeDl/uQCIuWIooUOulKLlmRS30EbXTpLXp+R
	 FFtqblbGF8R8XrBH0zrFgkxlmAuwZOCWZcTwF0amFABZvCwuAtWzNLb0O0iO8mbNiPnwM
	 Y/TUFYjSProZD0FDiMtzV+dn0fkQKCtpr5bWo/UNl/YL2Co9juZRb5Aymu+yHbxCrnpKH
	 dBXLwXcgHD2TRzN3BHSdxB+Eddp7lhbtqYn8NZEfwW9WL2FC2S0275G8btXwoFjkYIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620954;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4fletcACAk0JQBQv4Y+PLbasbrRhedWqViNf0fwJCvM=;
	b=rg8G4KEaelbKcH0hJBdRqmHyQYG9fxE4NcWroz/nK1AFSdJHBQ3RkHBnHNTniqjswhSb
	 y8/rTR6osQslbhTlCVMWif9P0cgE9ZJv1DnPLikZAFFC6bzln44+uLtwi8QPFDPvuhp+t
	 e4xUfhyBVmKmFLt2wF3b9RbSjaE3/uoQUVwedzda+6VEvcBCmXn3Jx58LYA/6UoUJXBk+
	 gY8/UM54ME0WmiZVMRMeHdajystD7r0FblAboqgnwKhURSrpk0zK3v2IvHNixMtyVsoVa
	 XOPuvFiBu15ONzR36JfNmYLYWhry3DNgbl22kmMV8Ke2j5L086baMqHs36p/aV+Ysmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U1UCP+7A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A07C660A2617;
	Wed, 25 Nov 2026 15:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U1UCP+7A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95C451F000D8;
	Wed, 25 Nov 2026 15:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620954;
	bh=4fletcACAk0JQBQv4Y+PLbasbrRhedWqViNf0fwJCvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U1UCP+7A0gcRbCFVG1TZWMWDrAY+sYgTNPfEwCWpecLHTsdCbUwGOavyxU07xucgJ
	 Omc/eXNWxWPDNu/F/DBowkna9J10CU6rJ/FXNx2V73PiSLnp/kx+CC93lzZWx79b6j
	 +rdF9LaMGmYp4jVdtNyd4b4nJX5xZFDsvlFnAR6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Barret Rhoden <brho@google.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 076/990] 9p: treat read return values of 0 as EOF
Date: Wed, 25 Nov 2026 15:24:03 +0100
Message-ID: <20261125143823.868176367@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Barret Rhoden <brho@google.com>

[ Upstream commit a3a6212c7d67baebebd0e4c2cf2ae1b75eb9231e ]

If your 9p server shares a synthetic file system such as sysfs, the file
size from stat often disagrees with the actual file size.

Treat non-error reads of 0 as EOF, except in the case where the request
was for 0 bytes.

Tested:
	git@github.com:hugelgupf/p9.git, served "/" on 10.0.2.2

	bash-5.3# mount -t 9p -o trans=tcp,port=12345,cache=none 10.0.2.2 /tmp/foo
	bash-5.3# cat /tmp/foo/sys/devices/system/cpu/online
	0-47

Fixes: eb497943fa21 ("9p: Convert to using the netfs helper lib to do reads and caching")
Signed-off-by: Barret Rhoden <brho@google.com>
Message-ID: <20260702090941.1298188-1-brho@google.com>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/9p/vfs_addr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/9p/vfs_addr.c b/fs/9p/vfs_addr.c
index 0a77ce5d11767..de2b1f8cdc0e6 100644
--- a/fs/9p/vfs_addr.c
+++ b/fs/9p/vfs_addr.c
@@ -100,6 +100,7 @@ static void v9fs_issue_read(struct netfs_io_subrequest *subreq)
 	char *target;
 	unsigned long long pos = subreq->start + subreq->transferred;
 	int total = 0, err, len, n;
+	size_t to_read = iov_iter_count(&subreq->io_iter);
 
 	if (S_ISLNK(rreq->inode->i_mode)) {
 		/* p9_client_readlink() must not be called for legacy protocols
@@ -132,6 +133,8 @@ static void v9fs_issue_read(struct netfs_io_subrequest *subreq)
 		__set_bit(NETFS_SREQ_CLEAR_TAIL, &subreq->flags);
 	if (pos + total >= i_size_read(rreq->inode))
 		__set_bit(NETFS_SREQ_HIT_EOF, &subreq->flags);
+	if (!err && !total && to_read)
+		__set_bit(NETFS_SREQ_HIT_EOF, &subreq->flags);
 	if (!err && total) {
 		subreq->transferred += total;
 		__set_bit(NETFS_SREQ_MADE_PROGRESS, &subreq->flags);
-- 
2.53.0



