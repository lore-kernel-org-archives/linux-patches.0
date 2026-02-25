Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F44D258ED5;
	Wed, 25 Feb 2026 01:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983643; cv=none; b=LSJNAuxAxEbGZm7kfnhXRKcBC4yO6t79C1k2x/ZKNRebetpKdIz5xClP5a+l9NaLavMilbaGJQ/kWdUZoSmYRzu2jx7n94mlr/xMnYd9eRf7dAjsTCtkLNGtd6DrNCsYYFIC67i0OknjY/aw8wj4iQLljji9xnvXvPjIrfTVUvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983643; c=relaxed/simple;
	bh=THsy3MiMIVrrqTp06gu+6ES7KqNXxccBKx9LCwm8wKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=djI5DoPZjIaYD1uq40JquKEQ80iYjH/dIuapT8l6YC/xswl+m2cUm1F/nTRirqXaH8uEykUj6DDA65/b2X1RLMRaD1Lgwv2rA4GGZ345Do9OumWif9BnIsB12CGviZ0cQQdfvmLJUMKTZcEchVZp34yOGuDoE17c6fmXi0KIwqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IrTaedUb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IrTaedUb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1850DC116D0;
	Wed, 25 Feb 2026 01:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983643;
	bh=THsy3MiMIVrrqTp06gu+6ES7KqNXxccBKx9LCwm8wKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IrTaedUbS8uSl3ivI149HQp87SfoTh3QYkZnJkPcTZxP7BMZIaRf2NveC7zXox0eL
	 EClqTFmYo/Aq4lMJzNVlhyFWTZy2kGxwkk+0p5NW/shmKa6tmfvh6HQNqnJ6dBdDLQ
	 n1TRKWAQi4WKbK4ghN8urcVhNf5JwzOJVtxMb37Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Piotr=20Pi=C3=B3rkowski?= <piotr.piorkowski@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	=?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 731/781] drm/xe/vf: Avoid reading media version when media GT is disabled
Date: Tue, 24 Feb 2026 17:24:00 -0800
Message-ID: <20260225012417.662532290@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Piotr Piórkowski <piotr.piorkowski@intel.com>

[ Upstream commit 5e905ec67214444362b81345ef8fde63e58425b6 ]

When the media GT is not allowed, a VF must not attempt to read
the media version from the GuC. The GuC may not be loaded, and
any attempt to communicate with it would result in a timeout
and a VF probe failure:

(...)
[ 1912.406046] xe 0000:01:00.1: [drm] *ERROR* Tile0: GT1: GuC mmio request 0x5507: no reply 0x5507
[ 1912.407277] xe 0000:01:00.1: [drm] *ERROR* Tile0: GT1: [GUC COMMUNICATION] MMIO send failed (-ETIMEDOUT)
[ 1912.408689] xe 0000:01:00.1: [drm] *ERROR* VF: Tile0: GT1: Failed to reset GuC state (-ETIMEDOUT)
[ 1912.413986] xe 0000:01:00.1: probe with driver xe failed with error -110

Let's skip reading the media version for VFs when the media GT is not
allowed.

v2: move the condition directly to the VF path

Fixes: 7abd69278bb5 ("drm/xe/configfs: Add attribute to disable GT types")
Signed-off-by: Piotr Piórkowski <piotr.piorkowski@intel.com>
Cc: Matt Roper <matthew.d.roper@intel.com>
Cc: Michal Wajdeczko <michal.wajdeczko@intel.com>
Cc: Shuicheng Lin <shuicheng.lin@intel.com>
Reviewed-by: Shuicheng Lin <shuicheng.lin@intel.com>
Link: https://patch.msgid.link/20260202115041.2863357-1-piotr.piorkowski@intel.com
Signed-off-by: Michał Winiarski <michal.winiarski@intel.com>
(cherry picked from commit 0bcacf56dc0b265f9c47056c6a4f0c1394a8a3f0)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_pci.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_pci.c b/drivers/gpu/drm/xe/xe_pci.c
index 2aa883f5ef797..38ea9d7dad091 100644
--- a/drivers/gpu/drm/xe/xe_pci.c
+++ b/drivers/gpu/drm/xe/xe_pci.c
@@ -533,6 +533,12 @@ static int read_gmdid(struct xe_device *xe, enum xe_gmdid_type type, u32 *ver, u
 		struct xe_gt *gt __free(kfree) = NULL;
 		int err;
 
+		/* Don't try to read media ver if media GT is not allowed */
+		if (type == GMDID_MEDIA && !xe_configfs_media_gt_allowed(to_pci_dev(xe->drm.dev))) {
+			*ver = *revid = 0;
+			return 0;
+		}
+
 		gt = kzalloc(sizeof(*gt), GFP_KERNEL);
 		if (!gt)
 			return -ENOMEM;
-- 
2.51.0



