Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70CC635A941;
	Fri,  9 Jan 2026 12:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961236; cv=none; b=fTgQaTcHWzStP0/k0mJ762b4mEXkxIMZh2F66D8+EJyGpPoeVpOUB9jhqy8WUXGXr/UA8QcwwvYMR4owAn9JKqxgg3lgoePrmt0S5MyVRzLFEDrBkWQyoGTJLo23CGBp5vNE8TXTwjyOIJMj6m74X8EaCYECHE+iyHlSs+ZTtJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961236; c=relaxed/simple;
	bh=1rBozJdxO96E6vSGX+prPv9MjLnU2l0225EkKNVjv/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AdvhI/c7lALF7vHIJzrUGotq5DiJaYX5oqyBRG3ceYKakl6etuZ73R0hdXAGPAhiYV+swOg/ecwrRVMKu+izDCGPEy4QtrV7VhyJCI6yDeMx+e5l2CG30XnUONNwXbT1Xllo4fhV7pMajS2Dmcit5Qxe8inKAfyegV6e3+3XL00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zOlbsI3p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zOlbsI3p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01596C4CEF1;
	Fri,  9 Jan 2026 12:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961236;
	bh=1rBozJdxO96E6vSGX+prPv9MjLnU2l0225EkKNVjv/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zOlbsI3p8ptHACdqQvqAxGCszx2SCC8HKHZSl8Gl6jp2mn8w80MjWgXOSHusD3+Qv
	 Uk3967rZUublQWhaPdwsRNZCKn81zAOnaYtXgdBspEwRW9t9XwMb4ou9fWPBCrVoJV
	 6gyIsuRNroLMPOUdCp+BMEu9vrPTkL3uHhGXh1SY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gyeyoung Baek <gye976@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Rahul Sharma <black.hawk@163.com>
Subject: [PATCH 6.6 683/737] genirq/irq_sim: Initialize work context pointers properly
Date: Fri,  9 Jan 2026 12:43:42 +0100
Message-ID: <20260109112159.748620931@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gyeyoung Baek <gye976@gmail.com>

[ Upstream commit 8a2277a3c9e4cc5398f80821afe7ecbe9bdf2819 ]

Initialize `ops` member's pointers properly by using kzalloc() instead of
kmalloc() when allocating the simulation work context. Otherwise the
pointers contain random content leading to invalid dereferencing.

Signed-off-by: Gyeyoung Baek <gye976@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/all/20250612124827.63259-1-gye976@gmail.com
[ The context change is due to the commit 011f583781fa
("genirq/irq_sim: add an extended irq_sim initializer")
which is irrelevant to the logic of this patch. ]
Signed-off-by: Rahul Sharma <black.hawk@163.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/irq/irq_sim.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/irq/irq_sim.c
+++ b/kernel/irq/irq_sim.c
@@ -166,7 +166,7 @@ struct irq_domain *irq_domain_create_sim
 {
 	struct irq_sim_work_ctx *work_ctx;
 
-	work_ctx = kmalloc(sizeof(*work_ctx), GFP_KERNEL);
+	work_ctx = kzalloc(sizeof(*work_ctx), GFP_KERNEL);
 	if (!work_ctx)
 		goto err_out;
 


