Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57BC42BB17;
	Tue, 11 Nov 2025 00:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822174; cv=none; b=oDS3gSerbDWzHg0n2EcT1zQ8/FxyQRyL/uX21p54QN24ZA70e9tqRavR5jGN3m82+K2sB5BD3Xfjyg3pPgCaHs25xA28sTsStQhmzQzwueGkb+ErA7gVwr35aPgvbiAY1qMio1j2jl7cwVfCXEC125Cva/79pDLSc7vvZoCAjgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822174; c=relaxed/simple;
	bh=y18lPUL1wgj2uv89gAEvVgUlX3DoLR0CwfRExwh0Wp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MTVZCUYRx+c/uT0DqjMTeWS4F11Ezpz8X3J6I7EP2RnSzqAJiI9v967+cmtheMYgi8NqdVYErm5McIuJMsFGbPO2YhR2ClIeO1eKC8O2Tzo3Ex2+ossulET8VyEhxDqiPmk0zRSnysuAlKnQUqg6AgS/hRrz3e8qiVujn5DoeCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ebB9oUHz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ebB9oUHz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9CCAC19425;
	Tue, 11 Nov 2025 00:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822174;
	bh=y18lPUL1wgj2uv89gAEvVgUlX3DoLR0CwfRExwh0Wp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ebB9oUHzBqmXM3gpjR5zTl+yt4HUvasMZOQzQ8OlyBepRKIOdDfm3BxKDNcJXmxVK
	 drNHXrOygXvZJf77e+wXrNiqseZt2ry35GLTN92D2zIrrehva0bJpN24sypbni3FBf
	 ge6eM1MTQ+4I+FF6exGTIAlJjTQ6fc057S1QBeYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 047/849] nvmet-auth: update sc_c in host response
Date: Tue, 11 Nov 2025 09:33:37 +0900
Message-ID: <20251111004537.576693156@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

From: Hannes Reinecke <hare@suse.de>

[ Upstream commit 60ad1de8e59278656092f56e87189ec82f078d12 ]

The target code should set the sc_c bit in calculating the host response
based on the status of the 'concat' setting, otherwise we'll get an
authentication mismatch for hosts setting that bit correctly.

Fixes: 7e091add9c43 ("nvme-auth: update sc_c in host response")
Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/auth.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/target/auth.c b/drivers/nvme/target/auth.c
index b340380f38922..ceba21684e82c 100644
--- a/drivers/nvme/target/auth.c
+++ b/drivers/nvme/target/auth.c
@@ -298,7 +298,7 @@ int nvmet_auth_host_hash(struct nvmet_req *req, u8 *response,
 	const char *hash_name;
 	u8 *challenge = req->sq->dhchap_c1;
 	struct nvme_dhchap_key *transformed_key;
-	u8 buf[4];
+	u8 buf[4], sc_c = ctrl->concat ? 1 : 0;
 	int ret;
 
 	hash_name = nvme_auth_hmac_name(ctrl->shash_id);
@@ -367,13 +367,14 @@ int nvmet_auth_host_hash(struct nvmet_req *req, u8 *response,
 	ret = crypto_shash_update(shash, buf, 2);
 	if (ret)
 		goto out;
-	memset(buf, 0, 4);
+	*buf = sc_c;
 	ret = crypto_shash_update(shash, buf, 1);
 	if (ret)
 		goto out;
 	ret = crypto_shash_update(shash, "HostHost", 8);
 	if (ret)
 		goto out;
+	memset(buf, 0, 4);
 	ret = crypto_shash_update(shash, ctrl->hostnqn, strlen(ctrl->hostnqn));
 	if (ret)
 		goto out;
-- 
2.51.0



