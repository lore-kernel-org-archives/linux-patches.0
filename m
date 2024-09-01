Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12B29185B4B;
	Sun,  1 Sep 2024 16:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209157; cv=none; b=qdzt6EC2cUeGF3FxqJV6zsrXiD3MsXsDrH7l+Pd3R3NXW5SHKhn+t0fshVbEVCVAkIZ2jb6V26gY8RAVRv9ZiqdYL5NyVIfWZ32BhQ6a/P0YAvl0mZaanM8vy/Hy11YhJFS/C+xVeJbZ/E3fIUZBmMhqcO07ngLE/eDJFXCcp5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209157; c=relaxed/simple;
	bh=1BYOKrIeTyHDGQJSf3mFwoOKNjwX/bxMkq3zp6/KjQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xn+IZSNlBYMDd/E2jFhwKA3zMn5XbXffLcAJ8Ku5oeJopggYGlpsaaGyF5GVIQQ0pUBNA0N1kkpD9qXtz+oOeX5dGXBVAgVjpUSmzhtJIYYxoF+AeVEaKfwWvEoJP9bCkYaCIrBlFZ0UKNetr4Hxca2OEewFmRF3aQ/Sp0qPEz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uMIYiN4H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uMIYiN4H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81646C4CEC3;
	Sun,  1 Sep 2024 16:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209156;
	bh=1BYOKrIeTyHDGQJSf3mFwoOKNjwX/bxMkq3zp6/KjQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uMIYiN4H/IVgwo5dKh3fAilVrgRhDdF942UINbNPHT+kIpAsv4hz3UIYtrj1Iwhgo
	 TE2vEolSK05MJW3eI8s4EgPJibKGhQantwti9AMlYBW7xUokNSDS0X+ui6lwdnKxqy
	 zZ6n+iWYBOM+tz5JPjQxM9K/TEIHa3n5dPoiq9e0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Stefan Metzmacher <metze@samba.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 04/71] smb/client: avoid dereferencing rdata=NULL in smb2_new_read_req()
Date: Sun,  1 Sep 2024 18:17:09 +0200
Message-ID: <20240901160802.051467047@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160801.879647959@linuxfoundation.org>
References: <20240901160801.879647959@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Metzmacher <metze@samba.org>

commit c724b2ab6a46435b4e7d58ad2fbbdb7a318823cf upstream.

This happens when called from SMB2_read() while using rdma
and reaching the rdma_readwrite_threshold.

Cc: stable@vger.kernel.org
Fixes: a6559cc1d35d ("cifs: split out smb3_use_rdma_offload() helper")
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2pdu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -4184,7 +4184,7 @@ smb2_new_read_req(void **buf, unsigned i
 	 * If we want to do a RDMA write, fill in and append
 	 * smbd_buffer_descriptor_v1 to the end of read request
 	 */
-	if (smb3_use_rdma_offload(io_parms)) {
+	if (rdata && smb3_use_rdma_offload(io_parms)) {
 		struct smbd_buffer_descriptor_v1 *v1;
 		bool need_invalidate = server->dialect == SMB30_PROT_ID;
 


