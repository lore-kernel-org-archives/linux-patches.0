Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D440A183CD7;
	Sun,  1 Sep 2024 16:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208204; cv=none; b=CZZejSKFkBa3ct1c5ToqYMXd7gfLvYPHKKl0BYJ6KdQmUyKMt6gx31Wvqub43A8qwMst6MNxN8UfpUmU/Yi/nMmOnXhaHhusJWw+raOMdp7RZYeOi25rHliNqoF0KwzDpFJGKM0ag0kNvmSf5fp0T2bk1SDL5Rn0YPfCWcA6x1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208204; c=relaxed/simple;
	bh=d8FhL9h9t8MvNtWDEaYajhtrV884juagukzBpS8pNlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zt0IRFDSavkC9WxdPvY9lW9BI98OEkLN5JKbNXJh5MJK1crNaT+CHAXXlqFZn21nKX0eL9Xlr6ncm04r9pAprDQtRcp0AiGHKzZvhTHbViL6a4rgblUvqXe73gYtrPxIyhm/k8yx+qkblS66Fi8w33FKUbzbGOI0MCcjvoAVziw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hlm5UoRT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hlm5UoRT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40329C4CEC3;
	Sun,  1 Sep 2024 16:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208204;
	bh=d8FhL9h9t8MvNtWDEaYajhtrV884juagukzBpS8pNlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hlm5UoRTCF6mRmc7clTNzsRl54k8L0TRuLgQz5aI1CitLgi31VM2qoaFx18VSjX6g
	 QEH1fmPo+ibHVw1fJd07Qq2KS11ISCj48mN43/P38C437mInwzW9Hr6XNgST52sjBO
	 7NLqfPkZKaYqIrK04FAdnEreV6JLia+JIZMYcVfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Stefan Metzmacher <metze@samba.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.10 011/149] smb/client: avoid dereferencing rdata=NULL in smb2_new_read_req()
Date: Sun,  1 Sep 2024 18:15:22 +0200
Message-ID: <20240901160817.893717114@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4435,7 +4435,7 @@ smb2_new_read_req(void **buf, unsigned i
 	 * If we want to do a RDMA write, fill in and append
 	 * smbd_buffer_descriptor_v1 to the end of read request
 	 */
-	if (smb3_use_rdma_offload(io_parms)) {
+	if (rdata && smb3_use_rdma_offload(io_parms)) {
 		struct smbd_buffer_descriptor_v1 *v1;
 		bool need_invalidate = server->dialect == SMB30_PROT_ID;
 


