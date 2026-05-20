Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D193CB2F8;
	Wed, 20 May 2026 17:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299715; cv=none; b=WmM8/OUMZH2uIAZ6bA+XG+qFAwooxHOVF3p8Nv63dNQ0/tvuvpgGpT//Eurj+bbiP+5SqDO+/GEr3ibnpSBy2VBOOOTY0t4lrAZUlr6HFGU+p8hX+7FJHhMDUUZ3FZiHZ0BNU6raI/m3ejHC+hD2cyaMiGoJa0+8OWJFP1UbAyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299715; c=relaxed/simple;
	bh=5+Vm0cAsRGdFQLbr+gNxYrBVpv5xwBDuPaQvVurityk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZPFxkKUl93kZz27HSXgiCz3N6JSi+/4uBoAtAL78EadCK5gE3zKIlf7N4wviNu+IcBYmxqUu2MS17dERLF3bqSTVyZD2evgqh3Q0CNTO2VqfWMsADhSL7m4j8/kH9Zecn2GxUGcqf/U/dVQr+q5zLOZxTV01MgRraL85mA1flNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2dxLz14l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2dxLz14l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ADCD1F000E9;
	Wed, 20 May 2026 17:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299713;
	bh=dxQrXZF4FydedpEIAUba1bTOS/ZXrCNkQC0CoetXf50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2dxLz14lSVG7ga26MKpEAEMfTRwJPaMr0rxaG5ZBmhSq9s5TU/BMcX5hkxb/UITie
	 d3xfcvIf8oq7gGVcP8N+HkPyfCbpr9Zn6Uhmld0VVJKytQ9TSiQ4qXAlxEE6yZKDjO
	 oS0g5uiwETveb2Eopg/S8rIJHeKfONtuwT0qaQ7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erni Sri Satya Vennela <ernis@linux.microsoft.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 876/957] net: mana: Init gf_stats_work before potential error paths in probe
Date: Wed, 20 May 2026 18:22:39 +0200
Message-ID: <20260520162153.563313537@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Erni Sri Satya Vennela <ernis@linux.microsoft.com>

[ Upstream commit 6e8bc03349fe4f09567fa76235abf52bdaf83082 ]

Move INIT_DELAYED_WORK(gf_stats_work) to before mana_create_eq(),
while keeping schedule_delayed_work() at its original location.

Previously, if any function between mana_create_eq() and the
INIT_DELAYED_WORK call failed, mana_probe() would call mana_remove()
which unconditionally calls cancel_delayed_work_sync(gf_stats_work)
in __flush_work() or debug object warnings with
CONFIG_DEBUG_OBJECTS_WORK enabled.

Fixes: be4f1d67ec56 ("net: mana: Add standard counter rx_missed_errors")
Signed-off-by: Erni Sri Satya Vennela <ernis@linux.microsoft.com>
Link: https://patch.msgid.link/20260420124741.1056179-3-ernis@linux.microsoft.com
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 4b7e5acba7f76..d1eb77d540427 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -3607,6 +3607,8 @@ int mana_probe(struct gdma_dev *gd, bool resuming)
 		INIT_WORK(&ac->link_change_work, mana_link_state_handle);
 	}
 
+	INIT_DELAYED_WORK(&ac->gf_stats_work, mana_gf_stats_work_handler);
+
 	err = mana_create_eq(ac);
 	if (err) {
 		dev_err(dev, "Failed to create EQs: %d\n", err);
@@ -3680,7 +3682,6 @@ int mana_probe(struct gdma_dev *gd, bool resuming)
 	if (!err)
 		err = add_adev(gd, "eth");
 
-	INIT_DELAYED_WORK(&ac->gf_stats_work, mana_gf_stats_work_handler);
 	schedule_delayed_work(&ac->gf_stats_work, MANA_GF_STATS_PERIOD);
 
 out:
-- 
2.53.0



