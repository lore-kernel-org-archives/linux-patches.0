Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92E5A15442C;
	Thu,  3 Jul 2025 15:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751556237; cv=none; b=UtdK0DsbaktN0UGdSnOU705h+QWxNwLB5gj6lgWBLWY56RiHA5PUUDxK4MRlkOyy87bYwWUjZm2XK0iQ546PnQzARbid9wsBaqGFOol+jPO3H1nXCx4f+FhUju/Y42XR93D8Fzheul2zUbC+91Hbiy1PvJIFKlumLmhsCoW+iqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751556237; c=relaxed/simple;
	bh=FNzsPpR7f8gWMg3YFz4aRcGGeJs+qTMXrE9JoBcjVtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BPbEEVFGyWBjR0JUzk30/xg5hQjw4v+FdvhSoblRwfVswprCOFGpwiagcMa5tMAWBtX0jGtSi2bokyvoPM34FrSB4wkpQihfeH8g5CNrjTXkYJ9BTa6KY41YbtRnFlC2wL8oTre1W6cKoqMkEIje0XxA1taW7aZhfk0LBmDY0uM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dirBr0sR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dirBr0sR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0426FC4CEE3;
	Thu,  3 Jul 2025 15:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751556237;
	bh=FNzsPpR7f8gWMg3YFz4aRcGGeJs+qTMXrE9JoBcjVtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dirBr0sRMp4XvbsTv0RKXIWV3lxc5P/Y10ASMhIgrvnTPz47MVoKECc1VgAiDLNQM
	 2LmmKw39VhRHoXlfVBWYpeoqb6HneDRzkvFk1dzFeCrrfoyp1o0V+ewz4uvZ6z4sH7
	 3G6qpUm+QuH7XoUKGJZ9LaWf26D5KRzCnKddCTX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 117/132] ksmbd: remove unsafe_memcpy use in session setup
Date: Thu,  3 Jul 2025 16:43:26 +0200
Message-ID: <20250703143943.983597580@linuxfoundation.org>
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

commit d782d6e1d9078d6b82f8468dd6421050165e7d75 upstream.

Kees pointed out to just use directly ->Buffer instead of pointing
->Buffer using offset not to use unsafe_memcpy().

Suggested-by: Kees Cook <kees@kernel.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1356,8 +1356,7 @@ static int ntlm_negotiate(struct ksmbd_w
 		return rc;
 
 	sz = le16_to_cpu(rsp->SecurityBufferOffset);
-	chgblob =
-		(struct challenge_message *)((char *)&rsp->hdr.ProtocolId + sz);
+	chgblob = (struct challenge_message *)rsp->Buffer;
 	memset(chgblob, 0, sizeof(struct challenge_message));
 
 	if (!work->conn->use_spnego) {
@@ -1390,9 +1389,7 @@ static int ntlm_negotiate(struct ksmbd_w
 		goto out;
 	}
 
-	sz = le16_to_cpu(rsp->SecurityBufferOffset);
-	unsafe_memcpy((char *)&rsp->hdr.ProtocolId + sz, spnego_blob, spnego_blob_len,
-			/* alloc is larger than blob, see smb2_allocate_rsp_buf() */);
+	memcpy(rsp->Buffer, spnego_blob, spnego_blob_len);
 	rsp->SecurityBufferLength = cpu_to_le16(spnego_blob_len);
 
 out:
@@ -1474,10 +1471,7 @@ static int ntlm_authenticate(struct ksmb
 		if (rc)
 			return -ENOMEM;
 
-		sz = le16_to_cpu(rsp->SecurityBufferOffset);
-		unsafe_memcpy((char *)&rsp->hdr.ProtocolId + sz, spnego_blob,
-				spnego_blob_len,
-				/* alloc is larger than blob, see smb2_allocate_rsp_buf() */);
+		memcpy(rsp->Buffer, spnego_blob, spnego_blob_len);
 		rsp->SecurityBufferLength = cpu_to_le16(spnego_blob_len);
 		kfree(spnego_blob);
 	}


