Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 244592222AE;
	Thu, 13 Feb 2025 14:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457594; cv=none; b=KlpQ+188YwUnOPkp7JU2DHQIc16SX1qlahdqPU3GoGFHIpdbQTtx7dFr7/o0rxLl5dqPyarCiFrkFe03QryS3Lf68rnilU/23vOo3Kp02fccH3297vjEcARV68vLivtWwkXZhcIUo21LIMOLIu3qnHja/pBnPpmkalIhw9xKMTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457594; c=relaxed/simple;
	bh=GFD/oKX1HFEw1X+pbEYYXjUomulJ0xy6keX8cfyOcns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BCcOh7wMSzIPk4lQZiqZqufWUyQKgMtfQT0irqmZW+BGNLwbV47e0g3dosJtPKQ7ZXOvFkjC4QJ3oYEEQOMCPzBpAdqIvad6GNtrb4QFKzOouj1zTgeZgylHWpwC+W8djabMIWyxRIgmC/FI2/NLo4MFdjVBJZEml4yXbZRiVck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cgnca/ir; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cgnca/ir"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28FB2C4CED1;
	Thu, 13 Feb 2025 14:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457593;
	bh=GFD/oKX1HFEw1X+pbEYYXjUomulJ0xy6keX8cfyOcns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cgnca/ir/r+3z8BHZxx97hxnt0XKs6joDeZM14csA4HX51FuE3ZRTyOndkFOjKTSn
	 siwflGjNj/xbBDoGfZyrrpGgtTXZ8WzJEJzuvcQkJoKjGp2sNOT4jo8BOHQRXFXcmN
	 dH9IszgW8Rp56bEe3ceKTW18RDE6XjhChCp8vtsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 155/422] ksmbd: fix integer overflows on 32 bit systems
Date: Thu, 13 Feb 2025 15:25:04 +0100
Message-ID: <20250213142442.527689913@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -626,6 +626,9 @@ ksmbd_ipc_spnego_authen_request(const ch
 	struct ksmbd_spnego_authen_request *req;
 	struct ksmbd_spnego_authen_response *resp;
 
+	if (blob_len > KSMBD_IPC_MAX_PAYLOAD)
+		return NULL;
+
 	msg = ipc_msg_alloc(sizeof(struct ksmbd_spnego_authen_request) +
 			blob_len + 1);
 	if (!msg)
@@ -805,6 +808,9 @@ struct ksmbd_rpc_command *ksmbd_rpc_writ
 	struct ksmbd_rpc_command *req;
 	struct ksmbd_rpc_command *resp;
 
+	if (payload_sz > KSMBD_IPC_MAX_PAYLOAD)
+		return NULL;
+
 	msg = ipc_msg_alloc(sizeof(struct ksmbd_rpc_command) + payload_sz + 1);
 	if (!msg)
 		return NULL;
@@ -853,6 +859,9 @@ struct ksmbd_rpc_command *ksmbd_rpc_ioct
 	struct ksmbd_rpc_command *req;
 	struct ksmbd_rpc_command *resp;
 
+	if (payload_sz > KSMBD_IPC_MAX_PAYLOAD)
+		return NULL;
+
 	msg = ipc_msg_alloc(sizeof(struct ksmbd_rpc_command) + payload_sz + 1);
 	if (!msg)
 		return NULL;


