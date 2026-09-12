Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D66C3750D6;
	Sat, 12 Sep 2026 09:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205205; cv=none; b=rzwGARp1BKYYExr69HWQGkXGRqOUG9h2Cp8NnLQDwO1FdW75jvu+SrhpL46LV/2HAXM/B04rJpt3sRASwKL8Jhh/bx1DR1xz9jPMsiiEa4csFozjeIsZbdXbq2z9lvuyoRUWkHRnKg+PVJDBicqXMW5sdh4qYvcAS36J6Qsi97Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205205; c=relaxed/simple;
	bh=vZN0iLHHWwdtTAGOlvSYgh/wTAnbUWiyP0CYingXuFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iurLtzkzUdholAQcKBpEN7ZwG40QATGBlcPlySQtMwuhzNusVBf+s6rAS+NM102CObvjevqBCHCWKSjTBcRT77O1f6JeeF4zxBNnLytGYCCSD2mM+CTgYpfbXlnqE545s9AoymPKzrDjgvltP4u1KL+9nqsCBMD0JG1c7UmWyuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LKIVSxoI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LKIVSxoI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 100051F000FF;
	Sat, 12 Sep 2026 09:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205204;
	bh=xabf5bA3TekpAYEyCPmD6xl1du/MAiN8shA4yzRgnK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LKIVSxoIJgrer+CE8a8ptPnUM2X4+5e+uzKNadQVM88zQ1hdEuomn7RDVFpTOt3fM
	 rryGpoan2M40AwBPJq5R6Vx1l8BvAWFFns1cvfiDXdba+pU7hHhV7QAdSaXDcOQQfa
	 IR9v3Yacjld/dB1BUazxoVDb+WG84NV0pWpfa+qQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <fuad.tabba@linux.dev>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1769/1815] of/irq: Fix device node refcount leak in of_irq_get_affinity()
Date: Sat, 12 Sep 2026 08:58:39 +0200
Message-ID: <20260912065730.533912034@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fuad Tabba <fuad.tabba@linux.dev>

[ Upstream commit fe66c3ff85e85d492673c6dc95c3d624a63e0282 ]

of_irq_parse_one() raises the refcount of the interrupt controller node
on success, and of_irq_get_affinity() returns without putting it, so
every call past the parse leaks one reference. It is reached from
platform_get_irq_affinity(), used by arm_pmu, arm_spe_pmu and
coresight-trbe.

Put it once irq_populate_fwspec_info() has run: no in-tree
->get_fwspec_info() returns a mask that lives in the node.

Fixes: 5404f5c06dd4 ("of/irq: Add interrupt affinity reporting interface")
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
Link: https://patch.msgid.link/20260826112234.1033974-1-fuad.tabba@linux.dev
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/irq.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/of/irq.c b/drivers/of/irq.c
index 967c191008797..ec035367c9500 100644
--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -563,7 +563,9 @@ const struct cpumask *of_irq_get_affinity(struct device_node *dev, int index)
 	of_phandle_args_to_fwspec(oirq.np, oirq.args, oirq.args_count,
 				  &fwspec);
 
-	if (irq_populate_fwspec_info(&fwspec, &info))
+	rc = irq_populate_fwspec_info(&fwspec, &info);
+	of_node_put(oirq.np);
+	if (rc)
 		return NULL;
 
 	return info.affinity;
-- 
2.53.0



