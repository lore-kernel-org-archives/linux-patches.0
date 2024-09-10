Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9FFB14D431;
	Tue, 10 Sep 2024 10:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963473; cv=none; b=RuNkAGxRXmLnBULM+hUdgODrHASB9ce/NEXmDqASsaANM/WpW2/wzl86x+Gq+Z8qX8uHlp05RsK3TkuFUyq7oh2SZJUWEBELZeG90jEeJo+vtGpKAzlPtd/NZ8ViPzTmtSjJm4WgM2j7wr2zRyccyhmHg7cMnTa3u+LBQTjXf7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963473; c=relaxed/simple;
	bh=weEaM2sYHcGSc5Cbnds7lV1WRs+PgM0SMXLDIe/5lqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lb5HvmrH8Ct9R9JZnwy2dFVkfTh1vW4o29VcNN8BZBgIzMIfjUKjia/1O2NGc9i6Tf/KA73RnOf2qrd05eRSKbnA6wvozSx/9WNCaN9lM0djGc12qxj8ngz2s+XSzkO8yY7zd8SMF51BJWvNW8WPiTxo/9eZyuZk7fONmtRVEhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YV1SJ/eR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YV1SJ/eR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40CA6C4CEC6;
	Tue, 10 Sep 2024 10:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963473;
	bh=weEaM2sYHcGSc5Cbnds7lV1WRs+PgM0SMXLDIe/5lqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YV1SJ/eR7PbRg3gADh/LXDfrD7Dp3V5tFjS+HUDX2G06flvWnPjs3E2PaH2PU9gXb
	 G7osIHPeeMMmgAB6LKvliLMEiGFvCmafMRzIMzrLyVDX9qz7izIjJa9AjrlyyexipA
	 /VBUSVxLOYrevpfR5IBWpjK+JIvA9GVyvnJqh0/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Thomas Gleixner <tglx@linutronix.de>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.15 070/214] irqchip/gic-v2m: Fix refcount leak in gicv2m_of_init()
Date: Tue, 10 Sep 2024 11:31:32 +0200
Message-ID: <20240910092601.604131292@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

commit c5af2c90ba5629f0424a8d315f75fb8d91713c3c upstream.

gicv2m_of_init() fails to perform an of_node_put() when
of_address_to_resource() fails, leading to a refcount leak.

Address this by moving the error handling path outside of the loop and
making it common to all failure modes.

Fixes: 4266ab1a8ff5 ("irqchip/gic-v2m: Refactor to prepare for ACPI support")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20240820092843.1219933-1-make24@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-gic-v2m.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/irqchip/irq-gic-v2m.c
+++ b/drivers/irqchip/irq-gic-v2m.c
@@ -439,12 +439,12 @@ static int __init gicv2m_of_init(struct
 
 		ret = gicv2m_init_one(&child->fwnode, spi_start, nr_spis,
 				      &res, 0);
-		if (ret) {
-			of_node_put(child);
+		if (ret)
 			break;
-		}
 	}
 
+	if (ret && child)
+		of_node_put(child);
 	if (!ret)
 		ret = gicv2m_allocate_domains(parent);
 	if (ret)


