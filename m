Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 383DE2356D1;
	Mon, 10 Mar 2025 18:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630511; cv=none; b=Oj5fikClvTb7pMKlXvah/4mNSe1jSVZNx7+hv+4ymjdx7iy3tFLvknzhzMgFtza9REeJXoQ4+IEhZn1sJ/qcisdNmNC+tb42nsuiOtI9AsZb+Bsu8t+3F8DVPbxMRE7qCm6W5LEnW+VFvlHvV19KjjqlteaJBkIdzJdOd7BGXkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630511; c=relaxed/simple;
	bh=0l14lhOSyDRVDOY/D4CVuiC8Tvm1wFLybd3jrxz7+NU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QFbkuzececxdN+daR7SZatIIZSVtgJrjwTEFm82FTMKc/ASXAfor6e49LvqjcaOhjzUgn/eC8G8aQNDwt3sHu/7v2I9QvZtp1/8EdYGdX0AXW/U+YdCUhiw0VAuXr/xpJySbWCFK1bZ7hWYQujn+0Th0gur+wzmHeAJoohBeD84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=inHMzmDm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="inHMzmDm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5616C4CEE5;
	Mon, 10 Mar 2025 18:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630511;
	bh=0l14lhOSyDRVDOY/D4CVuiC8Tvm1wFLybd3jrxz7+NU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=inHMzmDme8ojOmkhmc9ZBG2NydYCFPcqtQ0YBx+u7gZXFyNE6+mBaOylLP3Um0KST
	 v/CjU9vh4/fzb0hAmXtFkj+6iUxWYYhpf2qzcPQiaEHXhRSwN7IEsN5l+BbkiOqmBm
	 Hu1/rSb7vcBwQtISH0i9Taw5mfsJr1mGIS84kL+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 439/620] ksmbd: fix integer overflows on 32 bit systems
Date: Mon, 10 Mar 2025 18:04:45 +0100
Message-ID: <20250310170602.927918330@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit aab98e2dbd648510f8f51b83fbf4721206ccae45 ]

On 32bit systems the addition operations in ipc_msg_alloc() can
potentially overflow leading to memory corruption.
Add bounds checking using KSMBD_IPC_MAX_PAYLOAD to avoid overflow.

Fixes: 0626e6641f6b ("cifsd: add server handler for central processing and tranport layers")
Cc: stable@vger.kernel.org
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/transport_ipc.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/ksmbd/transport_ipc.c b/fs/ksmbd/transport_ipc.c
index d62ebbff1e0f4..0d096a11ba30e 100644
--- a/fs/ksmbd/transport_ipc.c
+++ b/fs/ksmbd/transport_ipc.c
@@ -566,6 +566,9 @@ ksmbd_ipc_spnego_authen_request(const char *spnego_blob, int blob_len)
 	struct ksmbd_spnego_authen_request *req;
 	struct ksmbd_spnego_authen_response *resp;
 
+	if (blob_len > KSMBD_IPC_MAX_PAYLOAD)
+		return NULL;
+
 	msg = ipc_msg_alloc(sizeof(struct ksmbd_spnego_authen_request) +
 			blob_len + 1);
 	if (!msg)
@@ -745,6 +748,9 @@ struct ksmbd_rpc_command *ksmbd_rpc_write(struct ksmbd_session *sess, int handle
 	struct ksmbd_rpc_command *req;
 	struct ksmbd_rpc_command *resp;
 
+	if (payload_sz > KSMBD_IPC_MAX_PAYLOAD)
+		return NULL;
+
 	msg = ipc_msg_alloc(sizeof(struct ksmbd_rpc_command) + payload_sz + 1);
 	if (!msg)
 		return NULL;
@@ -793,6 +799,9 @@ struct ksmbd_rpc_command *ksmbd_rpc_ioctl(struct ksmbd_session *sess, int handle
 	struct ksmbd_rpc_command *req;
 	struct ksmbd_rpc_command *resp;
 
+	if (payload_sz > KSMBD_IPC_MAX_PAYLOAD)
+		return NULL;
+
 	msg = ipc_msg_alloc(sizeof(struct ksmbd_rpc_command) + payload_sz + 1);
 	if (!msg)
 		return NULL;
-- 
2.39.5



