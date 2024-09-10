Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA6318C00C;
	Tue, 10 Sep 2024 10:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962478; cv=none; b=V7nYggOv7uv1J6b/ofVMadp5Q7U7pqqMYNOBYAlJJK5y36N0bYcWjeo5R9u8yekx7NnfAMUk+JxYA0w02I8DWuDVS6h16ZQ+Ylg9BHHSA0BROzd34FuHD62fEgG6QABkAwJaZbEkMZK4pZo2OEbLPowaBurtNhmALQaf21JR5xE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962478; c=relaxed/simple;
	bh=xGZxiPVpI7KfIHwIspO+TOILApptZ5uxgK0TOhJBA+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bCsT7BzCUR1vvVp0LDZKtMOrMe9TJTSTYH+bO0JqSwvlLUCpHiZKOmxyP2uJSGlbBz9XFlopyI943qYR3qchmQMVoQ2gdJkosIWdRMZfkHrjIb67l2zvtSUEPBznlBjM1bBSK+cYp1rUb9x3ML3kCChsc8+GdKEpJWpWP26n1Qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KoLitnRC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KoLitnRC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9A58C4CEC3;
	Tue, 10 Sep 2024 10:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962478;
	bh=xGZxiPVpI7KfIHwIspO+TOILApptZ5uxgK0TOhJBA+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KoLitnRC/H1xRlIWIR5Djk9xBtcsIlQjuvK+mMpSBDNnF9FaQUfDIw6KzEHkkPBk2
	 bYilFscOfCuBbb40QUqxmW42ZYIa0Mra311Cs6fR1U4ZuLaUiXReU5xuK5WF5NOls2
	 n4ukBtyitTgqb+kA+fHzrtS/OVqTPj4fMXcSB+K0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Thomas Gleixner <tglx@linutronix.de>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.4 030/121] irqchip/gic-v2m: Fix refcount leak in gicv2m_of_init()
Date: Tue, 10 Sep 2024 11:31:45 +0200
Message-ID: <20240910092547.160762185@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092545.737864202@linuxfoundation.org>
References: <20240910092545.737864202@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -441,12 +441,12 @@ static int __init gicv2m_of_init(struct
 
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


