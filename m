Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1B32502554;
	Wed, 30 Sep 2026 17:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788896; cv=none; b=JK5a5ey4r2GTHBESifftE7T3GIKJ24AawMJKfiw+mWM/m0gbEweDYfGLQgHahUHjZ7MIUoaEHFMpHyjYxuFq5sqkMq0mrHQ33H88Ub5jgrydJTKHuvy5gEVds0oLSa1166UvbtzG5vvdmJlOuI7mOFjJFFmwH6hPuquCjTTfNF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788896; c=relaxed/simple;
	bh=0fUQ+4k4Y+scX/vxIb/njQUyV7LZzYNaitiGZaIr+9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PN8cVhfPhIgFosbwCB9dphrsKmqTab1t2E1XfwGh8xri3aWtKroKoxkN+Gxc5PLtWE/M1SOx3oqmHk7HeD8OhEWFxcbpWNmdrKaGRyZr39fSdt4JLPQ7Q4WSgsUgJvGwc4b620svAbnExpkn6BlKxzpW+lDd9PjRHrLYHkkUgMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VnKmWrQ5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VnKmWrQ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 468471F000FF;
	Wed, 30 Sep 2026 17:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788894;
	bh=Oe/EzLrkFHwHOttglRU4/k6wSNzNwwDRl1cpTatEmk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VnKmWrQ5GTompwXdjCRbIwwGDFjdp+pIkQMp2AJMCLaWYfRfIAB8oLqNZ4Ayp97lw
	 3Z8/7OF0Y1fXPCBEFa4mKVoP1p5tZfqj1bojfNfXrsUeXAKnZoF+I2acYjWYd6RjVy
	 2t53kRNBf7k+CmrIzHJ20ZVaqlS2MrSlDOnM/J4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.12 285/877] smb: client: fix missing iov bounds check in parse_posix_sids()
Date: Wed, 30 Sep 2026 17:19:56 +0200
Message-ID: <20260930152420.863931978@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Sorenson <sorenson@redhat.com>

commit b09d092eb24ad0110f16a9b7c1ed5d2a0c1733dc upstream.

In parse_posix_sids(), sidsbuf_end is calculated using the server-supplied
out_len without being validated against the actual length of the received
iov (iov_len).

If a server provides an inflated out_len, sidsbuf_end will point past the
end of the iov. This defeats the bounds guards in posix_info_sid_size(),
allowing out-of-bounds reads into adjacent kernel memory.

Fix this by rejecting responses where the calculated sidsbuf_end would
exceed the received iov boundaries or cause pointer wraparound.

Fixes: a90f37e3d7ac ("smb: client: parse owner/group when creating reparse points")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2inode.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -71,6 +71,17 @@ static int parse_posix_sids(struct cifs_
 
 	sidsbuf = (u8 *)qi + le16_to_cpu(qi->OutputBufferOffset) + qi_len;
 	sidsbuf_end = sidsbuf + out_len - qi_len;
+	if (sidsbuf_end < sidsbuf) {
+		cifs_dbg(VFS, "%s: server-supplied out_len %u caused pointer wraparound\n",
+			 __func__, out_len);
+		return -EINVAL;
+	}
+	if (sidsbuf_end > (u8 *)rsp_iov->iov_base + rsp_iov->iov_len) {
+		cifs_dbg(VFS, "%s: server-supplied out_len %u overruns iov by %td bytes\n",
+			 __func__, out_len,
+			 sidsbuf_end - ((u8 *)rsp_iov->iov_base + rsp_iov->iov_len));
+		return -EINVAL;
+	}
 
 	owner_len = posix_info_sid_size(sidsbuf, sidsbuf_end);
 	if (owner_len == -1)


