Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA81F2248B8;
	Thu, 12 Dec 2024 17:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025623; cv=none; b=G+vtcASyaX8rYGxlZX1LerKm1Oom2uT1mBSyf/CJtaTytmVZXO/vcriN5opPCMqZya4e+dN79k3yLOUU9GQ8/YrmduO3UGDtcKTU3AKT9R1t3AKHc+OI1+ySlEzZhQzCXQtg3yEW+EdjUJqM1/yj1Cum8EORKLll1PzZsMGz4sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025623; c=relaxed/simple;
	bh=9UtRmJFjyiPHWw80U84CFZ2WuUj7o6TWNz/T2L0+ooQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FHR4oo8imst2OsnSM5sluYx+ofLo2RM9CMuvScP32YTSiuauq/kj2Vwta4YNMUHFW8WFlwyeBuP7BzBFcJo53cFOKMEXszvWv2or7TTP0u4nwdAytAqhl2uzbURvobb5JMmrdJHgQ4zyuvzXguHkZXn+OMl3QCFZOr0fNKS0o+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TTSoYBl+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TTSoYBl+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57309C4CECE;
	Thu, 12 Dec 2024 17:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025622;
	bh=9UtRmJFjyiPHWw80U84CFZ2WuUj7o6TWNz/T2L0+ooQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TTSoYBl+UiGs22L0zHm6GnQiGCbURq/V/aKqUDrVmn4fVAGnWnk3GiAC3D6dGGtp6
	 lrXhqbyHwFyDxG4NEaLWe3pEOWrvGAIsr3tNXjTk0pxIB/DO8yX/oeeM6ZXCRCD+9A
	 z3iw7RbE+pTzCWrY0hWmCRq/tDtyt7+1KjnZXJlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ying Xue <ying.xue@windreiver.com>,
	Jon Maloy <jon.maloy@ericsson.com>,
	Tuong Lien <tuong.t.lien@dektech.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 231/321] tipc: add new AEAD key structure for user API
Date: Thu, 12 Dec 2024 16:02:29 +0100
Message-ID: <20241212144239.100755926@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tuong Lien <tuong.t.lien@dektech.com.au>

[ Upstream commit 134bdac397661a5841d9f27f508190c68b26232b ]

The new structure 'tipc_aead_key' is added to the 'tipc.h' for user to
be able to transfer a key to TIPC in kernel. Netlink will be used for
this purpose in the later commits.

Acked-by: Ying Xue <ying.xue@windreiver.com>
Acked-by: Jon Maloy <jon.maloy@ericsson.com>
Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 6a2fa13312e5 ("tipc: Fix use-after-free of kernel socket in cleanup_bearer().")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/tipc.h | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/include/uapi/linux/tipc.h b/include/uapi/linux/tipc.h
index 7df026ea6affa..a1b64a9167970 100644
--- a/include/uapi/linux/tipc.h
+++ b/include/uapi/linux/tipc.h
@@ -232,6 +232,27 @@ struct tipc_sioc_nodeid_req {
 	char node_id[TIPC_NODEID_LEN];
 };
 
+/*
+ * TIPC Crypto, AEAD
+ */
+#define TIPC_AEAD_ALG_NAME		(32)
+
+struct tipc_aead_key {
+	char alg_name[TIPC_AEAD_ALG_NAME];
+	unsigned int keylen;	/* in bytes */
+	char key[];
+};
+
+#define TIPC_AEAD_KEYLEN_MIN		(16 + 4)
+#define TIPC_AEAD_KEYLEN_MAX		(32 + 4)
+#define TIPC_AEAD_KEY_SIZE_MAX		(sizeof(struct tipc_aead_key) + \
+							TIPC_AEAD_KEYLEN_MAX)
+
+static inline int tipc_aead_key_size(struct tipc_aead_key *key)
+{
+	return sizeof(*key) + key->keylen;
+}
+
 /* The macros and functions below are deprecated:
  */
 
-- 
2.43.0



