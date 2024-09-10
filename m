Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC3C198E69;
	Tue, 10 Sep 2024 10:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963949; cv=none; b=D/wZ7P0aH5O+h3H5ENoyf0gPxMqjuLPyHdmPAx7z8m2YfEtZhsg3S+sjUkwKMrILsaBANsRcKAZxgi0ndrW6bwoTn8GqooV9noQEQaRIi95ZFsawsLCq1JoJwIM+lEoZ226pBu+rq0oH4dR0cpBU7gI1TUIj1k7g8hJpWflyCSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963949; c=relaxed/simple;
	bh=QskNMFt0iYTVPKV/aoetUbI5D5QSTFV8iLoTPYu0d4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ltz6+s/4vSL7/Ydjb6HQ/dFcSJEM063HgZeTozLmmLQvkN6XFqkHVStsmr0HDmDB+43JhRVM+W3mkTUVhEjS89olgsdtAU4bQuRMFy+OJ24GU7A7HCCJkuuMGmUzh2yahYIbYg8DA2CkGMOp7re3POeW+IHKeGMjt+sUtLibLDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DZi/rIHl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DZi/rIHl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B7B4C4CEC3;
	Tue, 10 Sep 2024 10:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963949;
	bh=QskNMFt0iYTVPKV/aoetUbI5D5QSTFV8iLoTPYu0d4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DZi/rIHlF64y4R3QmmvfgOfZQ7dZDoG/LWQZe/z//ytD9J1DAayBSu33hnRtswOFw
	 tjiLBiCREv2N0z63m2g7f/pR1blWpzLnlviTgMWpeZeUucE+4GEuPrippykg7kOO47
	 c48aC34r5gwP9ufVRIQ0Ebkwttuz/pKndNWSzLio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Thomas Gleixner <tglx@linutronix.de>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.6 017/269] irqchip/gic-v2m: Fix refcount leak in gicv2m_of_init()
Date: Tue, 10 Sep 2024 11:30:04 +0200
Message-ID: <20240910092608.875022819@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -438,12 +438,12 @@ static int __init gicv2m_of_init(struct
 
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


