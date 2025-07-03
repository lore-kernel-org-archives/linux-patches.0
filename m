Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4495C2D6639;
	Thu,  3 Jul 2025 15:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555810; cv=none; b=sjvrhJwOkOwVvkRwNGs0m1fx3ipfnd4rAFXgY7GjZ9WHfOq1nuSVg1ENICFSSzCRyGF9Pb8rz+YZ0G8uEbWuFW1aFz4l7t6lnfpALoOqSmVnEh0p/T/ytzQm+hqPCtoKHF2KVVaUmSiw/U1EILe7GkdVrlqNYjpYebpSJ29Gv8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555810; c=relaxed/simple;
	bh=KBP4b0eLPYhVfL1pBOAw4//rF8ZpbO+Lz03N5IaHifY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f1dNsMMaYU1muVv/HXUDFbTZHIO/rpFByI9+8ect7MIu3hd+3PsKZ5bgoRd7Ffe8RpuK32XjpdpEfNixY0W6KgP5D7RorvfA0JPWgaw/U0K3u4Vtlaym1SV02jkvUeHfxdWD8v6kwXLiIkKRbWh+NlcOg6xAixk1C9zzrX56PNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2sQRUCmA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2sQRUCmA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBB11C4CEE3;
	Thu,  3 Jul 2025 15:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555810;
	bh=KBP4b0eLPYhVfL1pBOAw4//rF8ZpbO+Lz03N5IaHifY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2sQRUCmAIitsJYDto/okYW6lIdsmQOODHyo1DPjrn7WMinJ++S80nCPFg9fNvVoQ7
	 Bj8BNx6QxM0fRmEw7Y0pg8OpDj+XxaQAkjUCz/IpPnshm+2CQg5Tan4G3dTA1TBNs8
	 FD3Xf4AH8+S2lWWOGeI2qFytNWtCdPim9xUUIZlI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 127/139] ksmbd: Use unsafe_memcpy() for ntlm_negotiate
Date: Thu,  3 Jul 2025 16:43:10 +0200
Message-ID: <20250703143946.152085626@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
References: <20250703143941.182414597@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Namjae Jeon <linkinjeon@kernel.org>

commit dfd046d0ced19b6ff5f11ec4ceab0a83de924771 upstream.

rsp buffer is allocated larger than spnego_blob from
smb2_allocate_rsp_buf().

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1380,7 +1380,8 @@ static int ntlm_negotiate(struct ksmbd_w
 	}
 
 	sz = le16_to_cpu(rsp->SecurityBufferOffset);
-	memcpy((char *)&rsp->hdr.ProtocolId + sz, spnego_blob, spnego_blob_len);
+	unsafe_memcpy((char *)&rsp->hdr.ProtocolId + sz, spnego_blob, spnego_blob_len,
+			/* alloc is larger than blob, see smb2_allocate_rsp_buf() */);
 	rsp->SecurityBufferLength = cpu_to_le16(spnego_blob_len);
 
 out:
@@ -1463,7 +1464,9 @@ static int ntlm_authenticate(struct ksmb
 			return -ENOMEM;
 
 		sz = le16_to_cpu(rsp->SecurityBufferOffset);
-		memcpy((char *)&rsp->hdr.ProtocolId + sz, spnego_blob, spnego_blob_len);
+		unsafe_memcpy((char *)&rsp->hdr.ProtocolId + sz, spnego_blob,
+				spnego_blob_len,
+				/* alloc is larger than blob, see smb2_allocate_rsp_buf() */);
 		rsp->SecurityBufferLength = cpu_to_le16(spnego_blob_len);
 		kfree(spnego_blob);
 	}


