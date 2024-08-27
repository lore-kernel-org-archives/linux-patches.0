Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7A8DD517;
	Tue, 27 Aug 2024 15:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772610; cv=none; b=dFpchrL89v+/IrAHEZucvV+EZ/gxf0vdbbb+tuZT1n8aHO3L3ElLBbph4fBjq4A76wNHUA/i24ANwOFFtWJzg5MeFBb2nHOCE0UB6YOEp9JbrfU/GzQkPVcxEzI5lAqOZwjX3ZBrnh7dqkFb+OPh+pPQ6XYavDtv/zNNrLlp4QQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772610; c=relaxed/simple;
	bh=zwrZI+KnGXqsM6SlD3gPmm5X1NVQbBrAEOoETPLhunA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LsRPQPOB4wdbkm3U5rMDpaTVhV4qpectHbuOLAqZE22QUBYbaPQKxPAw8xejJut3wjg0Eomzensb4/6W/9fUFc+iljbh7bCEyFkI57J+EvuLGe4gY2R9Y0fnOI7WR2jWe6H4Qb1qLIesramExjxAD4r1P8a8wHIaZtGd2m/OmbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wJHlM6F9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wJHlM6F9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33601C4AF64;
	Tue, 27 Aug 2024 15:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772610;
	bh=zwrZI+KnGXqsM6SlD3gPmm5X1NVQbBrAEOoETPLhunA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wJHlM6F9WGvPLY8PgH4q1FcvDgQ3HGYyIc+KlP2AH3fzxOZQwtojzJrs14u+hS3Lk
	 r7CxHbW3squHmyjmWSg+Ti5ePJacq44QEOn/AlJjRYpkeqqGTxQ2Al2lyOOI3WC8TZ
	 N99ZxBOrzJ+8sSoJl+2q+uW9A5dBSp6EAIt+e+zY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 265/321] ksmbd: the buffer of smb2 query dir response has at least 1 byte
Date: Tue, 27 Aug 2024 16:39:33 +0200
Message-ID: <20240827143848.337196424@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

commit ce61b605a00502c59311d0a4b1f58d62b48272d0 upstream.

When STATUS_NO_MORE_FILES status is set to smb2 query dir response,
->StructureSize is set to 9, which mean buffer has 1 byte.
This issue occurs because ->Buffer[1] in smb2_query_directory_rsp to
flex-array.

Fixes: eb3e28c1e89b ("smb3: Replace smb2pdu 1-element arrays with flex-arrays")
Cc: stable@vger.kernel.org # v6.1+
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -4169,7 +4169,8 @@ int smb2_query_dir(struct ksmbd_work *wo
 		rsp->OutputBufferLength = cpu_to_le32(0);
 		rsp->Buffer[0] = 0;
 		rc = ksmbd_iov_pin_rsp(work, (void *)rsp,
-				       sizeof(struct smb2_query_directory_rsp));
+				       offsetof(struct smb2_query_directory_rsp, Buffer)
+				       + 1);
 		if (rc)
 			goto err_out;
 	} else {


