Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E902D6622;
	Thu,  3 Jul 2025 15:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751556234; cv=none; b=FVu+2/Rf4yTWaHlPXG/coHV9ukphpgl9c80azm9Y8ZkyKvZwqgVh0Itn+51TRWzfH55wTh1hN8d+dkw0bZ816qAi7myewyC8ZOg8EkAyYbPJW0VR3gxe1toalQuJjzKPIOlgfQhrEIMYR1uTgrync42npK/DobDizdcpKH+qjSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751556234; c=relaxed/simple;
	bh=FbcmOIo6w50/UJZISTDtZLoH6Hnqdnee9MyYhRuRMzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=syMGrhLLTPJuVuf3hgADuElBNn7pVWViBV3ayS56mC0VCWtsvNcmYpvuFv7Eimys+uENdjml3/2YwSisMZnYa6MFjcmsvQ9ValPaMp1G8SaG7uZFyZf7AsJfNSHL3NUjThB81bD3QKnUZLZbrSm+nmvhPfWNEfJwK+NSITeXUws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tate3yae; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tate3yae"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE9A3C4CEE3;
	Thu,  3 Jul 2025 15:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751556234;
	bh=FbcmOIo6w50/UJZISTDtZLoH6Hnqdnee9MyYhRuRMzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tate3yaeBZSNIdr2fAhrmEPKI0ZNKjPDZAmohhQYrbE9LEX4zCoqR/oWdL7sLiGfo
	 Z3BdVRZj7/U4eJ16zqL1rteg9DENIbrAeNQJFWYSMokeMFcW6ZOZfPiuqzKD7HfvFk
	 l5bs+cJMU6rjXDdDw1NV4l14w2Pk1gKn00S8kAaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 116/132] ksmbd: Use unsafe_memcpy() for ntlm_negotiate
Date: Thu,  3 Jul 2025 16:43:25 +0200
Message-ID: <20250703143943.945111408@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143939.370927276@linuxfoundation.org>
References: <20250703143939.370927276@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1391,7 +1391,8 @@ static int ntlm_negotiate(struct ksmbd_w
 	}
 
 	sz = le16_to_cpu(rsp->SecurityBufferOffset);
-	memcpy((char *)&rsp->hdr.ProtocolId + sz, spnego_blob, spnego_blob_len);
+	unsafe_memcpy((char *)&rsp->hdr.ProtocolId + sz, spnego_blob, spnego_blob_len,
+			/* alloc is larger than blob, see smb2_allocate_rsp_buf() */);
 	rsp->SecurityBufferLength = cpu_to_le16(spnego_blob_len);
 
 out:
@@ -1474,7 +1475,9 @@ static int ntlm_authenticate(struct ksmb
 			return -ENOMEM;
 
 		sz = le16_to_cpu(rsp->SecurityBufferOffset);
-		memcpy((char *)&rsp->hdr.ProtocolId + sz, spnego_blob, spnego_blob_len);
+		unsafe_memcpy((char *)&rsp->hdr.ProtocolId + sz, spnego_blob,
+				spnego_blob_len,
+				/* alloc is larger than blob, see smb2_allocate_rsp_buf() */);
 		rsp->SecurityBufferLength = cpu_to_le16(spnego_blob_len);
 		kfree(spnego_blob);
 	}


