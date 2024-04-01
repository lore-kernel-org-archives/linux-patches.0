Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D811C47A57;
	Mon,  1 Apr 2024 16:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987926; cv=none; b=RVCk8o9lppMZOjOLT3RguoeZ+ICcfx94rLphy7fST+Oiy+73gBRuX0g9lhJLl2mHvv0yrZQoOPkQFk9gfY+RZXvZFpY1pMYdjiaTmhWGssaVL734Bn6oGMbFV64ZDRlOhlWGqr8WQ1ImP/RlT1TRr+P7sNfD0Piw4DtbwNCmVgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987926; c=relaxed/simple;
	bh=J0p/HPaGuOoX039QKFBC0R7DL1BtQTrLpBATz0zTvC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZvQ19gd2rDE5WVDsjykePy5KGlXcemM0byQ4Ph7Hia4M58TF2EPCiWoPYbrj5W67EJ97Vpp61J2c4Kn9ojAH+vXrw+75YcgcwH2Gd3jz4GDZaKmgzz8JlhpKhL8nNuT+EbvfDt4kVOglWYyqM4Fb/vQeSfMco8KUVmn4Z7OIhbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DKyVQ+dy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DKyVQ+dy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17A85C433C7;
	Mon,  1 Apr 2024 16:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987926;
	bh=J0p/HPaGuOoX039QKFBC0R7DL1BtQTrLpBATz0zTvC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DKyVQ+dyj9YBbctd7jxRhWiZF+mDtBZvtMm/em1p4+U9gshnZqRRMTZHF9liBb+WB
	 N9RU3/DEnXSgXHT69Dbe85E2ub5nuICbMGjpUrreaAvA1udtpuUQbD0vs9qI2x27k7
	 gJONEzVsIhxDX5KM4bnUONPOwLZ6bGgkaux6eTCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Rui <rui.zhang@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 032/432] powercap: intel_rapl: Fix a NULL pointer dereference
Date: Mon,  1 Apr 2024 17:40:19 +0200
Message-ID: <20240401152554.090476540@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Rui <rui.zhang@intel.com>

[ Upstream commit 2d1f5006ff95770da502f8cee2a224a1ff83866e ]

A NULL pointer dereference is triggered when probing the MMIO RAPL
driver on platforms with CPU ID not listed in intel_rapl_common CPU
model list.

This is because the intel_rapl_common module still probes on such
platforms even if 'defaults_msr' is not set after commit 1488ac990ac8
("powercap: intel_rapl: Allow probing without CPUID match"). Thus the
MMIO RAPL rp->priv->defaults is NULL when registering to RAPL framework.

Fix the problem by adding sanity check to ensure rp->priv->rapl_defaults
is always valid.

Fixes: 1488ac990ac8 ("powercap: intel_rapl: Allow probing without CPUID match")
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Cc: 6.5+ <stable@vger.kernel.org> # 6.5+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/powercap/intel_rapl_common.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/powercap/intel_rapl_common.c b/drivers/powercap/intel_rapl_common.c
index 2feed036c1cd4..1a739afd47d96 100644
--- a/drivers/powercap/intel_rapl_common.c
+++ b/drivers/powercap/intel_rapl_common.c
@@ -759,6 +759,11 @@ static int rapl_config(struct rapl_package *rp)
 	default:
 		return -EINVAL;
 	}
+
+	/* defaults_msr can be NULL on unsupported platforms */
+	if (!rp->priv->defaults || !rp->priv->rpi)
+		return -ENODEV;
+
 	return 0;
 }
 
-- 
2.43.0



