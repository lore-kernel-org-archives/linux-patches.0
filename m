Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBDDF13D24C;
	Tue,  8 Oct 2024 12:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389840; cv=none; b=atUkMyhCgfZhUGHrE85dQDKrWAEe6Cv9qCfKd/tsdqLZRiWX/fy80hsRmCg7dtY5YVyWyf6J6ufuB+u0/hooQBmkI8WJS5feajVoQiX0eTsKdwLx5qPPQUZTJ0tARMrl1Qy+q1w7eRs7F8xbcJ8Lwz6U8XLNtMD7TCZoK4pOyxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389840; c=relaxed/simple;
	bh=dLDEWW3BPd4ALPdUaSdRoLy/igx9idXJdd2YC0hm4kE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kR/zqHPT4ihOU5R4bloON8hZe4pGySRj5c4w4F9ecm/VUO9juOcwQEWNyD9Y1GICQwisIA0uiC/nmDTF7XaLfBAIcAFDvwYrExc1ltRZ6GBTcitmdYcnwI1lB0IjfaTfJzXOiaAHQnF828zEhlpvk0rPsHzFjV+AyoRuGOchwlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EqyM1L+o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EqyM1L+o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2998C4CEC7;
	Tue,  8 Oct 2024 12:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389839;
	bh=dLDEWW3BPd4ALPdUaSdRoLy/igx9idXJdd2YC0hm4kE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EqyM1L+ocfYhGIJp/wjWrQ2Z9GK7ahVCqo64IMgLCKl/tYrMqQBEM+yjqlOo1CXsa
	 5XcBFB32m5MZyZp+uTrZrAhrs06EQqxpxTqrytp2CnhCdWAJmwkhTokGNy/naq2/8o
	 F3XIqgivyLhSvTLOfnQ/Rs0BnwfrzHlsLnVbIR5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 111/482] nvme-tcp: check for invalidated or revoked key
Date: Tue,  8 Oct 2024 14:02:54 +0200
Message-ID: <20241008115652.676217376@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

From: Hannes Reinecke <hare@kernel.org>

[ Upstream commit 5bc46b49c828a6dfaab80b71ecb63fe76a1096d2 ]

key_lookup() will always return a key, even if that key is revoked
or invalidated. So check for invalid keys before continuing.

Signed-off-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/common/keyring.c | 22 ++++++++++++++++++++++
 drivers/nvme/host/Kconfig     |  1 +
 drivers/nvme/host/fabrics.c   |  2 +-
 drivers/nvme/host/tcp.c       |  2 +-
 include/linux/nvme-keyring.h  |  6 +++++-
 5 files changed, 30 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/common/keyring.c b/drivers/nvme/common/keyring.c
index 05e89307c8aa3..ed5167f942d89 100644
--- a/drivers/nvme/common/keyring.c
+++ b/drivers/nvme/common/keyring.c
@@ -20,6 +20,28 @@ key_serial_t nvme_keyring_id(void)
 }
 EXPORT_SYMBOL_GPL(nvme_keyring_id);
 
+static bool nvme_tls_psk_revoked(struct key *psk)
+{
+	return test_bit(KEY_FLAG_REVOKED, &psk->flags) ||
+		test_bit(KEY_FLAG_INVALIDATED, &psk->flags);
+}
+
+struct key *nvme_tls_key_lookup(key_serial_t key_id)
+{
+	struct key *key = key_lookup(key_id);
+
+	if (IS_ERR(key)) {
+		pr_err("key id %08x not found\n", key_id);
+		return key;
+	}
+	if (nvme_tls_psk_revoked(key)) {
+		pr_err("key id %08x revoked\n", key_id);
+		return ERR_PTR(-EKEYREVOKED);
+	}
+	return key;
+}
+EXPORT_SYMBOL_GPL(nvme_tls_key_lookup);
+
 static void nvme_tls_psk_describe(const struct key *key, struct seq_file *m)
 {
 	seq_puts(m, key->description);
diff --git a/drivers/nvme/host/Kconfig b/drivers/nvme/host/Kconfig
index b309c8be720f4..854eb26ac3db9 100644
--- a/drivers/nvme/host/Kconfig
+++ b/drivers/nvme/host/Kconfig
@@ -110,6 +110,7 @@ config NVME_HOST_AUTH
 	bool "NVMe over Fabrics In-Band Authentication in host side"
 	depends on NVME_CORE
 	select NVME_AUTH
+	select NVME_KEYRING if NVME_TCP_TLS
 	help
 	  This provides support for NVMe over Fabrics In-Band Authentication in
 	  host side.
diff --git a/drivers/nvme/host/fabrics.c b/drivers/nvme/host/fabrics.c
index b5a4b5fd573e0..3e3db6a6524e0 100644
--- a/drivers/nvme/host/fabrics.c
+++ b/drivers/nvme/host/fabrics.c
@@ -650,7 +650,7 @@ static struct key *nvmf_parse_key(int key_id)
 		return ERR_PTR(-EINVAL);
 	}
 
-	key = key_lookup(key_id);
+	key = nvme_tls_key_lookup(key_id);
 	if (IS_ERR(key))
 		pr_err("key id %08x not found\n", key_id);
 	else
diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index f551609691807..8c79af3ed1f23 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1596,7 +1596,7 @@ static void nvme_tcp_tls_done(void *data, int status, key_serial_t pskid)
 		goto out_complete;
 	}
 
-	tls_key = key_lookup(pskid);
+	tls_key = nvme_tls_key_lookup(pskid);
 	if (IS_ERR(tls_key)) {
 		dev_warn(ctrl->ctrl.device, "queue %d: Invalid key %x\n",
 			 qid, pskid);
diff --git a/include/linux/nvme-keyring.h b/include/linux/nvme-keyring.h
index e10333d78dbbe..19d2b256180fd 100644
--- a/include/linux/nvme-keyring.h
+++ b/include/linux/nvme-keyring.h
@@ -12,7 +12,7 @@ key_serial_t nvme_tls_psk_default(struct key *keyring,
 		const char *hostnqn, const char *subnqn);
 
 key_serial_t nvme_keyring_id(void);
-
+struct key *nvme_tls_key_lookup(key_serial_t key_id);
 #else
 
 static inline key_serial_t nvme_tls_psk_default(struct key *keyring,
@@ -24,5 +24,9 @@ static inline key_serial_t nvme_keyring_id(void)
 {
 	return 0;
 }
+static inline struct key *nvme_tls_key_lookup(key_serial_t key_id)
+{
+	return ERR_PTR(-ENOTSUPP);
+}
 #endif /* !CONFIG_NVME_KEYRING */
 #endif /* _NVME_KEYRING_H */
-- 
2.43.0



