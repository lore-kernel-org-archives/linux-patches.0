Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 881802E540D;
	Tue,  8 Jul 2025 16:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992988; cv=none; b=cBv9ON5go8rulLueIf3MkBbfO9YHgEjCyFkIAR7RWx1ayMeTnvZ/D46jBmo7SG/IUpYmOHyc8ay01rJKIl0UFzF3chPdK8N08PIh81fDt7v2beZm2TgQvsbD0WpsgoBYD3f3tiyKsA5Ayl1GGcTIGH3U/+N7KIxf10tIiwYw6UE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992988; c=relaxed/simple;
	bh=7o0eM4ge8NVHHsljFWv9MHm8dRO36467NHNRYKDklTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qi5cWwoloNVuOo6/g6wbmZE8mGqMPu7DPKGbdMrPISuPWtu8kB/PNx3CDpUgdhXBX3kTfW5LBlN7DuXIyDeZj8PR3e8ngCjVk8s7yCSWMrGJo1cd0iieC1R3Us6p504CFwDtqCdKI5hZAdAHgHC/+ReEgS8iIIrJz369Mdd4GqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MMYcsLXA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MMYcsLXA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 108ABC4CEED;
	Tue,  8 Jul 2025 16:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992988;
	bh=7o0eM4ge8NVHHsljFWv9MHm8dRO36467NHNRYKDklTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MMYcsLXAwhGbGJ5RGR8B18hzsyqDLILsJsnKZfaTzJypR+6jAd2x0g3wgVs2AdJ/+
	 /vLk93ahXR4N5uGDX4SsDLra5tSfIRSv+kpHbWIAcPG4qWFZDPPgwTYP12h6SuMXua
	 yB1pKLEPAXqRfpYbkdVjmP9+N50eZJUzmLTXfHBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Beleswar Padhi <b-padhi@ti.com>,
	Andrew Davis <afd@ti.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 149/232] remoteproc: k3-r5: Use devm_rproc_add() helper
Date: Tue,  8 Jul 2025 18:22:25 +0200
Message-ID: <20250708162245.338910752@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

From: Beleswar Padhi <b-padhi@ti.com>

[ Upstream commit de182d2f5ca0801425919f38ec955033c09c601d ]

Use device lifecycle managed devm_rproc_add() helper function. This
helps prevent mistakes like deleting out of order in cleanup functions
and forgetting to delete on all error paths.

Signed-off-by: Beleswar Padhi <b-padhi@ti.com>
Reviewed-by: Andrew Davis <afd@ti.com>
Link: https://lore.kernel.org/r/20241219110545.1898883-5-b-padhi@ti.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Stable-dep-of: 701177511abd ("remoteproc: k3-r5: Refactor sequential core power up/down operations")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/ti_k3_r5_remoteproc.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/remoteproc/ti_k3_r5_remoteproc.c b/drivers/remoteproc/ti_k3_r5_remoteproc.c
index c38b76b4943d5..055bdd36ef865 100644
--- a/drivers/remoteproc/ti_k3_r5_remoteproc.c
+++ b/drivers/remoteproc/ti_k3_r5_remoteproc.c
@@ -1258,7 +1258,7 @@ static int k3_r5_cluster_rproc_init(struct platform_device *pdev)
 			goto out;
 		}
 
-		ret = rproc_add(rproc);
+		ret = devm_rproc_add(dev, rproc);
 		if (ret) {
 			dev_err_probe(dev, ret, "rproc_add failed\n");
 			goto out;
@@ -1289,7 +1289,7 @@ static int k3_r5_cluster_rproc_init(struct platform_device *pdev)
 			dev_err(dev,
 				"Timed out waiting for %s core to power up!\n",
 				rproc->name);
-			goto err_powerup;
+			goto out;
 		}
 	}
 
@@ -1305,8 +1305,6 @@ static int k3_r5_cluster_rproc_init(struct platform_device *pdev)
 		}
 	}
 
-err_powerup:
-	rproc_del(rproc);
 out:
 	/* undo core0 upon any failures on core1 in split-mode */
 	if (cluster->mode == CLUSTER_MODE_SPLIT && core == core1) {
@@ -1349,8 +1347,6 @@ static void k3_r5_cluster_rproc_exit(void *data)
 		}
 
 		mbox_free_channel(kproc->mbox);
-
-		rproc_del(rproc);
 	}
 }
 
-- 
2.39.5



