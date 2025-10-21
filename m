Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A5DD2773F4;
	Tue, 21 Oct 2025 20:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077501; cv=none; b=lkxQQnUR8MxOqIAi/YqED9f6U4rK9W9Z+dPmuLU6fgVeJX4LgmZo1y4wwm24txQBBrqwEEBv6r5bIahkYz1ckstQ7pBJ8mdXSRI7ss9DRMS8D8ISIFYT0hW2Of1W5aIg5DHeMJPPO/Edcia59VHE3BQpWjkmR3JsizKhUogxdkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077501; c=relaxed/simple;
	bh=Xy+S0Inu2jn8a0kJ+ETs/X6UGJ8js9PhMhvHIAurSjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=shxTSFfAY7ubnTdP6z9aZKK6LVlKXaT6I5Dc5PAq561kefho++Sv+xTGbBqSBtWcUpSUKr+M3yvGIILTaYkhDtMaROkjcpFJeWQcHddMk1pu5NN1biUy3jwHaXXKaE9N7LD/EiMCK43IX0vpLlF48l7s0SVglaAM02LKUl1XDgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WJwehy+L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WJwehy+L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A98BCC4CEF1;
	Tue, 21 Oct 2025 20:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077501;
	bh=Xy+S0Inu2jn8a0kJ+ETs/X6UGJ8js9PhMhvHIAurSjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WJwehy+L+7kaJVlC5ebtQrUoPMx5XyzPkUY2IMX/y35K9+Qco52T0jLelXcjTP9oP
	 OmoR2yA2zQf8N5Nla93QBfCSOfxAiUajo8Vw6t25M5J86SeV7RjNlXgyH+YHG1aPMY
	 xdESqBJI4FHUHegyViHIbWVcYujf2qH/+kXNVIck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin George <marting@netapp.com>,
	Prashanth Adurthi <prashana@netapp.com>,
	Hannes Reinecke <hare@suse.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 124/159] nvme-auth: update sc_c in host response
Date: Tue, 21 Oct 2025 21:51:41 +0200
Message-ID: <20251021195046.137031807@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

From: Martin George <martinus.gpy@gmail.com>

[ Upstream commit 7e091add9c433bab6912228799bf508e2414acc3 ]

The sc_c field is currently not updated in the host response to the
controller challenge leading to failures while attempting secure
channel concatenation. Fix this by adding a new sc_c variable to the
dhchap queue context structure which is appropriately set during
negotiate and then used in the host response.

Fixes: e88a7595b57f ("nvme-tcp: request secure channel concatenation")
Signed-off-by: Martin George <marting@netapp.com>
Signed-off-by: Prashanth Adurthi <prashana@netapp.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/auth.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/auth.c b/drivers/nvme/host/auth.c
index 012fcfc79a73b..a01178caf15bb 100644
--- a/drivers/nvme/host/auth.c
+++ b/drivers/nvme/host/auth.c
@@ -36,6 +36,7 @@ struct nvme_dhchap_queue_context {
 	u8 status;
 	u8 dhgroup_id;
 	u8 hash_id;
+	u8 sc_c;
 	size_t hash_len;
 	u8 c1[64];
 	u8 c2[64];
@@ -154,6 +155,8 @@ static int nvme_auth_set_dhchap_negotiate_data(struct nvme_ctrl *ctrl,
 	data->auth_protocol[0].dhchap.idlist[34] = NVME_AUTH_DHGROUP_6144;
 	data->auth_protocol[0].dhchap.idlist[35] = NVME_AUTH_DHGROUP_8192;
 
+	chap->sc_c = data->sc_c;
+
 	return size;
 }
 
@@ -489,7 +492,7 @@ static int nvme_auth_dhchap_setup_host_response(struct nvme_ctrl *ctrl,
 	ret = crypto_shash_update(shash, buf, 2);
 	if (ret)
 		goto out;
-	memset(buf, 0, sizeof(buf));
+	*buf = chap->sc_c;
 	ret = crypto_shash_update(shash, buf, 1);
 	if (ret)
 		goto out;
@@ -500,6 +503,7 @@ static int nvme_auth_dhchap_setup_host_response(struct nvme_ctrl *ctrl,
 				  strlen(ctrl->opts->host->nqn));
 	if (ret)
 		goto out;
+	memset(buf, 0, sizeof(buf));
 	ret = crypto_shash_update(shash, buf, 1);
 	if (ret)
 		goto out;
-- 
2.51.0



