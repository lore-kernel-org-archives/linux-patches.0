Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B78E128CF42;
	Thu, 27 Nov 2025 15:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255851; cv=none; b=Dnyqb4sH6ELW9EAKERoqD0XXYiLTX9U0j1qRMPWmlzUrgXhnvgZCHRZJio+JbEHpPAsB63sj1cwjTGcw0FUhcvBwnwflQGKs8jgu/lY9YiD/SDuzKQvEoFA1xdiQDnV+eKJiCDwfWJZxA0OUhXQFA3lEtJZln+Lh2dzrvGt3OXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255851; c=relaxed/simple;
	bh=skYJjyhHi7jh3ypHB2pAPU3o4dUuAQRLKpskdplJxGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NURN+yK9JDZkzL57Mma2S5ShKXJtSGc5xySmr/3JsRMLK15GCwWn7V/D/okZHlr8x0GOr1HjUyhuOI1p7Db1VMWJLUp8924TeDfSdJzLmtefRmpfAD6dbMijAdH5Ls+obUUcoIVppedqaPkpWgclQz+BexBYq8H6SW+XieW0y5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sn2zfBc1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sn2zfBc1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14A76C4CEF8;
	Thu, 27 Nov 2025 15:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255851;
	bh=skYJjyhHi7jh3ypHB2pAPU3o4dUuAQRLKpskdplJxGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sn2zfBc1SdGc5LkA7i4oT1AHp6wCO1SciWIxizGtMlw5I3mzNu9pcNT9ah9U4BZcy
	 dmIZvPoyF2uRCQ9BX20gLGifqMNTpPmitrcvTZzHptFpRLyRMf3NhZAFqbOzU8/mPA
	 IXg2AFsGHL1EfNonO7SvwmrETVlKd7ivOHIWDV5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Yi Zhang <yi.zhang@redhat.com>,
	Martin George <marting@netapp.com>,
	Christoph Hellwig <hch@lst.de>,
	Hannes Reinecke <hare@suse.de>,
	Alistair Francis <alistair.francis@wdc.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 103/175] nvmet-auth: update sc_c in target host hash calculation
Date: Thu, 27 Nov 2025 15:45:56 +0100
Message-ID: <20251127144046.721013453@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alistair Francis <alistair.francis@wdc.com>

[ Upstream commit 159de7a825aea4242d3f8d32de5853d269dbe72f ]

Commit 7e091add9c43 "nvme-auth: update sc_c in host response" added
the sc_c variable to the dhchap queue context structure which is
appropriately set during negotiate and then used in the host response.

This breaks secure concat connections with a Linux target as the target
code wasn't updated at the same time. This patch fixes this by adding a
new sc_c variable to the host hash calculations.

Fixes: 7e091add9c43 ("nvme-auth: update sc_c in host response")
Tested-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Tested-by: Yi Zhang <yi.zhang@redhat.com>
Reviewed-by: Martin George <marting@netapp.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Alistair Francis <alistair.francis@wdc.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/auth.c             | 4 ++--
 drivers/nvme/target/fabrics-cmd-auth.c | 1 +
 drivers/nvme/target/nvmet.h            | 1 +
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/target/auth.c b/drivers/nvme/target/auth.c
index ceba21684e82c..300d5e032f6d4 100644
--- a/drivers/nvme/target/auth.c
+++ b/drivers/nvme/target/auth.c
@@ -298,7 +298,7 @@ int nvmet_auth_host_hash(struct nvmet_req *req, u8 *response,
 	const char *hash_name;
 	u8 *challenge = req->sq->dhchap_c1;
 	struct nvme_dhchap_key *transformed_key;
-	u8 buf[4], sc_c = ctrl->concat ? 1 : 0;
+	u8 buf[4];
 	int ret;
 
 	hash_name = nvme_auth_hmac_name(ctrl->shash_id);
@@ -367,7 +367,7 @@ int nvmet_auth_host_hash(struct nvmet_req *req, u8 *response,
 	ret = crypto_shash_update(shash, buf, 2);
 	if (ret)
 		goto out;
-	*buf = sc_c;
+	*buf = req->sq->sc_c;
 	ret = crypto_shash_update(shash, buf, 1);
 	if (ret)
 		goto out;
diff --git a/drivers/nvme/target/fabrics-cmd-auth.c b/drivers/nvme/target/fabrics-cmd-auth.c
index bf01ec414c55f..5946681cb0e32 100644
--- a/drivers/nvme/target/fabrics-cmd-auth.c
+++ b/drivers/nvme/target/fabrics-cmd-auth.c
@@ -43,6 +43,7 @@ static u8 nvmet_auth_negotiate(struct nvmet_req *req, void *d)
 		 data->auth_protocol[0].dhchap.halen,
 		 data->auth_protocol[0].dhchap.dhlen);
 	req->sq->dhchap_tid = le16_to_cpu(data->t_id);
+	req->sq->sc_c = data->sc_c;
 	if (data->sc_c != NVME_AUTH_SECP_NOSC) {
 		if (!IS_ENABLED(CONFIG_NVME_TARGET_TCP_TLS))
 			return NVME_AUTH_DHCHAP_FAILURE_CONCAT_MISMATCH;
diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
index 51df72f5e89b7..f3b09f4099f08 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -159,6 +159,7 @@ struct nvmet_sq {
 	bool			authenticated;
 	struct delayed_work	auth_expired_work;
 	u16			dhchap_tid;
+	u8			sc_c;
 	u8			dhchap_status;
 	u8			dhchap_step;
 	u8			*dhchap_c1;
-- 
2.51.0



