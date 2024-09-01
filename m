Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66647143894;
	Sun,  1 Sep 2024 16:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207960; cv=none; b=hBFXL2YxxQiYg/V8EXTeN7ROWdDJQYbmn3My7wmG77h3Y70YlyrbZzq35Rv9g/kVtv16Dvc7DlcaWBWjueLiaCHYva6HQyQzxdZsf0E8QhhrehP/SsjfDxbFWxiGw93LBr2xWJ99ui2u/spjg3KNHLxx5zxKOY0wqB0Pz3K9yFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207960; c=relaxed/simple;
	bh=btUpvuseOLguA06Ld7KYZI9Fx9MYMcQiGbz5VRrEsXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kjdw9n/N7vLtPJgE7AkTSqYmIDIGucVPJGt6JWNibp1An45O7vC0wksclp+UO90TIuxUptD/hGcZVfIGqnMCYExZa9WDqN5268LQ3e0pu+y8/+Mho07c7mOzFohzgvS29xkg5lfA30OpcPa+kkw68XTnaWuTIkIZU2YE2eVIuEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F9PFswNW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F9PFswNW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB833C4CEC3;
	Sun,  1 Sep 2024 16:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207960;
	bh=btUpvuseOLguA06Ld7KYZI9Fx9MYMcQiGbz5VRrEsXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F9PFswNWsKbdd6BtMKQIUQR4b478KWHIiyRZy87XLfzGdcxC7uGesyIrkuz9Om6Em
	 DPmdA6gho3KD26xJgQVUpEpZnflZeOkhKF+IOEFXwCgpUVeExEIYmKX8JPbSaftGSM
	 zMMuV2vx517wMU7jKuxF0kS1s3+uNRQE40E3KZhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Stefan Metzmacher <metze@samba.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 05/93] smb/client: avoid dereferencing rdata=NULL in smb2_new_read_req()
Date: Sun,  1 Sep 2024 18:15:52 +0200
Message-ID: <20240901160807.557724841@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160807.346406833@linuxfoundation.org>
References: <20240901160807.346406833@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4431,7 +4431,7 @@ smb2_new_read_req(void **buf, unsigned i
 	 * If we want to do a RDMA write, fill in and append
 	 * smbd_buffer_descriptor_v1 to the end of read request
 	 */
-	if (smb3_use_rdma_offload(io_parms)) {
+	if (rdata && smb3_use_rdma_offload(io_parms)) {
 		struct smbd_buffer_descriptor_v1 *v1;
 		bool need_invalidate = server->dialect == SMB30_PROT_ID;
 


