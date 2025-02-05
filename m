Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 468141519AA;
	Wed,  5 Feb 2025 13:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763853; cv=none; b=bXil1IpTOs4wMAOqKTpaXRx9grPBNfZ+UJDggspMUjuO8muYwLJ++nFLVTzFnU/YBCRcojktF26DRp5R1NZRpZqeqzH/LVekj3oV5UssQbw+oSJHbsLEN43D5eijfItHEIIpSMgu5jCY4X/A+/GCa+qlH8Y7ux3pn2hvYGiehpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763853; c=relaxed/simple;
	bh=3i/jnRrzr/h8bXW5YYTDlCiMhOB8rxS3c0vElHXCMQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BovyKoktZzHJC/nCyxQLNz71boRmYSOkoldiexS6fZLHBXMwObngadPQRFk/jUWDgGGV4ES/dGREvhscemD9eOw3UVpLaNtM2scMu6qLb2Hcm0xwZJEUwwwla8pUMdfEDV3yQlvVZB9aktAgG3aSD36uIX7ipxfWsek8iLt/Ny4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rbpplG8j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rbpplG8j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8266C4CEDD;
	Wed,  5 Feb 2025 13:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763853;
	bh=3i/jnRrzr/h8bXW5YYTDlCiMhOB8rxS3c0vElHXCMQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rbpplG8jZhyIm82kzIJI+Dc4NL8bz6+V6+slSBJ1QyWzwuBY2nC4eglZ/hoGx89Db
	 cUJ9qZaG+vSxnbFpWMOe2WwinJqlQlXYEwclzrIQj5YnCInqgHrhEipnHjKHzfAr99
	 qCiE3guEh5HdhsXaJeC8zd4xXnhQa6AXceyVzJWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keisuke Nishimura <keisuke.nishimura@inria.fr>,
	Sagi Grimberg <sagi@grimberg.me>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 024/623] nvme: Add error path for xa_store in nvme_init_effects
Date: Wed,  5 Feb 2025 14:36:06 +0100
Message-ID: <20250205134457.153166328@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keisuke Nishimura <keisuke.nishimura@inria.fr>

[ Upstream commit d4a95adeabc6b5a39405e49c6d5ed14dd83682c4 ]

The xa_store() may fail due to memory allocation failure because there
is no guarantee that the index NVME_CSI_NVM is already used. This fix
introduces a new function to handle the error path.

Fixes: cc115cbe12d9 ("nvme: always initialize known command effects")
Signed-off-by: Keisuke Nishimura <keisuke.nishimura@inria.fr>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 315692cb2e614..7c4a19f5c951a 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3175,6 +3175,25 @@ static int nvme_init_non_mdts_limits(struct nvme_ctrl *ctrl)
 	return ret;
 }
 
+static int nvme_init_effects_log(struct nvme_ctrl *ctrl,
+		u8 csi, struct nvme_effects_log **log)
+{
+	struct nvme_effects_log *effects, *old;
+
+	effects = kzalloc(sizeof(*effects), GFP_KERNEL);
+	if (effects)
+		return -ENOMEM;
+
+	old = xa_store(&ctrl->cels, csi, effects, GFP_KERNEL);
+	if (xa_is_err(old)) {
+		kfree(effects);
+		return xa_err(old);
+	}
+
+	*log = effects;
+	return 0;
+}
+
 static void nvme_init_known_nvm_effects(struct nvme_ctrl *ctrl)
 {
 	struct nvme_effects_log	*log = ctrl->effects;
@@ -3221,10 +3240,9 @@ static int nvme_init_effects(struct nvme_ctrl *ctrl, struct nvme_id_ctrl *id)
 	}
 
 	if (!ctrl->effects) {
-		ctrl->effects = kzalloc(sizeof(*ctrl->effects), GFP_KERNEL);
-		if (!ctrl->effects)
-			return -ENOMEM;
-		xa_store(&ctrl->cels, NVME_CSI_NVM, ctrl->effects, GFP_KERNEL);
+		ret = nvme_init_effects_log(ctrl, NVME_CSI_NVM, &ctrl->effects);
+		if (ret < 0)
+			return ret;
 	}
 
 	nvme_init_known_nvm_effects(ctrl);
-- 
2.39.5



