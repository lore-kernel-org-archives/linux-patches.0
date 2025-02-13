Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED8D156F3F;
	Thu, 13 Feb 2025 15:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460388; cv=none; b=AQjtnX6/Zt3bo6lCTRtxXtQ9UxeeP6p3tWadTuVDRr5njvWmWB3w7zWH/uUBYBdyTx4T/k+/pPBwjv5Yjd4i1Q3IGx0HPe4+7f4aDe5cUDYZyDRjJQU4aUC497JnsRClpIuKz+V7/eUvhEOY4dJNmXToP48ltxNIrH5X5ZL6WIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460388; c=relaxed/simple;
	bh=gETDcpGR63cA1IKSbNs4HXlPgqNM7NyCS4ibmLdioII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VJFDrkN8PZHAVP4Eun51jvAX/m2qPN2KBuEzST7AbSHSIkLQkCBnuzTlbUrneA2fpQxGKEN6A60rcLU8t0GoMNGeFnTHmLDdHdC0z88xoEI09FVoDh3m4ofrvMkLdF6xY3WPwgIjp/Wq+ClZD8ecLU4A2VAUJXg47Y28z1F/X+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l+nizPMA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l+nizPMA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3DC7C4CEE5;
	Thu, 13 Feb 2025 15:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460388;
	bh=gETDcpGR63cA1IKSbNs4HXlPgqNM7NyCS4ibmLdioII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l+nizPMAio57v+34lYeu+E0LtIDZ9tO+X1AbVXxdqrYb8PZHnyXykdKTKtDqUHoPI
	 q8+WKpE8NvNImNUJVD9tsavs4Jq5r89kmQzXBXYyFOcNGVcCIfQflOZQaHdldszlBv
	 dJs2jYtHtL5kgdzG7fpp13k6Z2dsszyN/EHyfX9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 096/273] ksmbd: fix integer overflows on 32 bit systems
Date: Thu, 13 Feb 2025 15:27:48 +0100
Message-ID: <20250213142411.135335023@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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
@@ -570,6 +570,9 @@ ksmbd_ipc_spnego_authen_request(const ch
 	struct ksmbd_spnego_authen_request *req;
 	struct ksmbd_spnego_authen_response *resp;
 
+	if (blob_len > KSMBD_IPC_MAX_PAYLOAD)
+		return NULL;
+
 	msg = ipc_msg_alloc(sizeof(struct ksmbd_spnego_authen_request) +
 			blob_len + 1);
 	if (!msg)
@@ -749,6 +752,9 @@ struct ksmbd_rpc_command *ksmbd_rpc_writ
 	struct ksmbd_rpc_command *req;
 	struct ksmbd_rpc_command *resp;
 
+	if (payload_sz > KSMBD_IPC_MAX_PAYLOAD)
+		return NULL;
+
 	msg = ipc_msg_alloc(sizeof(struct ksmbd_rpc_command) + payload_sz + 1);
 	if (!msg)
 		return NULL;
@@ -797,6 +803,9 @@ struct ksmbd_rpc_command *ksmbd_rpc_ioct
 	struct ksmbd_rpc_command *req;
 	struct ksmbd_rpc_command *resp;
 
+	if (payload_sz > KSMBD_IPC_MAX_PAYLOAD)
+		return NULL;
+
 	msg = ipc_msg_alloc(sizeof(struct ksmbd_rpc_command) + payload_sz + 1);
 	if (!msg)
 		return NULL;


