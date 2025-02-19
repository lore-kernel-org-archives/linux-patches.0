Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B9628629E;
	Wed, 19 Feb 2025 09:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957047; cv=none; b=MY5MxFuOV9Q7rBkEkgIdHz6JGKFoxgmDuIxhPvKamulR4Es6V6l4UlexS07BtjzYA8wm5s3Lt2PYJpyjhJHGJFhRKMqCu37ikVezWHsTYkEhVHv9gaD4MCxCm+fy7bpeSiL7WbxP8AS/134Vd6NTGsguhHwe1UroGpdm9kNXjM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957047; c=relaxed/simple;
	bh=CCpxzaLAqwkfGWZkmjkX6DT+tg82jyPOylvBedoXLvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HGkq37zvdT29wkxpEc3zzGVCd4lREKohkFkp/QQCeFpjvMNE1tUiBNdNlwASDOmBLzAa1WJ1IqMD1GiXH2ktyZ+V4EE4u7xeSzjILnuQ9eFGceCmtC6jwIBkoDBzd4ek0mUypWfFfEn52/QmMRDAgY5bBOBcbh8oAXwEH9raJRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bK5yEg6P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bK5yEg6P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C247C4CED1;
	Wed, 19 Feb 2025 09:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957046;
	bh=CCpxzaLAqwkfGWZkmjkX6DT+tg82jyPOylvBedoXLvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bK5yEg6PCV2l7l1K2YDZk+c5NI32H/7BGv4CaM3er3KN4mb9BJWkwTF21QEsfztn3
	 J7G2uWZPxnL71XH/AOhew7KBV6koOijguJz3FKSos7PJy0SF0LHccZzctQ/ZsBgP8w
	 HXTQalb5eS3e9+Y43SfN0/GpDryZ2upoH0gvlBcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 348/578] ksmbd: fix integer overflows on 32 bit systems
Date: Wed, 19 Feb 2025 09:25:52 +0100
Message-ID: <20250219082706.708091467@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

commit aab98e2dbd648510f8f51b83fbf4721206ccae45 upstream.

On 32bit systems the addition operations in ipc_msg_alloc() can
potentially overflow leading to memory corruption.
Add bounds checking using KSMBD_IPC_MAX_PAYLOAD to avoid overflow.

Fixes: 0626e6641f6b ("cifsd: add server handler for central processing and tranport layers")
Cc: stable@vger.kernel.org
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/transport_ipc.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/fs/smb/server/transport_ipc.c
+++ b/fs/smb/server/transport_ipc.c
@@ -567,6 +567,9 @@ ksmbd_ipc_spnego_authen_request(const ch
 	struct ksmbd_spnego_authen_request *req;
 	struct ksmbd_spnego_authen_response *resp;
 
+	if (blob_len > KSMBD_IPC_MAX_PAYLOAD)
+		return NULL;
+
 	msg = ipc_msg_alloc(sizeof(struct ksmbd_spnego_authen_request) +
 			blob_len + 1);
 	if (!msg)
@@ -746,6 +749,9 @@ struct ksmbd_rpc_command *ksmbd_rpc_writ
 	struct ksmbd_rpc_command *req;
 	struct ksmbd_rpc_command *resp;
 
+	if (payload_sz > KSMBD_IPC_MAX_PAYLOAD)
+		return NULL;
+
 	msg = ipc_msg_alloc(sizeof(struct ksmbd_rpc_command) + payload_sz + 1);
 	if (!msg)
 		return NULL;
@@ -794,6 +800,9 @@ struct ksmbd_rpc_command *ksmbd_rpc_ioct
 	struct ksmbd_rpc_command *req;
 	struct ksmbd_rpc_command *resp;
 
+	if (payload_sz > KSMBD_IPC_MAX_PAYLOAD)
+		return NULL;
+
 	msg = ipc_msg_alloc(sizeof(struct ksmbd_rpc_command) + payload_sz + 1);
 	if (!msg)
 		return NULL;


