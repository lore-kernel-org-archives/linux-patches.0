Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557C833B96B;
	Sat, 12 Sep 2026 09:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204689; cv=none; b=iQDwBwKQDOkjmvSpw+FTHbAlI5quZfzoTKD5QHh5a7c7I1YE3VLB3XvqTR+DUssAca5AWrHcV+Hjj8t5BiHkYneVLn2/4riTE9+Hri98AS7JKWx1wH1ecrTb/+piQJWtV25Wgs46+q+UShjnOs9iU7RfSGS0CIDFwN2BA76zO7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204689; c=relaxed/simple;
	bh=wMUnQVkccQm4ChGpW7mSbB9y5PUDvrf7J9BYNPGOzRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NCbiHO4nEDFMhoAWCfWsDE93fAFovBrCDw753E60PcMYQ849W96g+o6ouLoEksXR5kwaasbbwMedHg/yE0GLhaFGe+bU+V/49GYg7qT5JOPYxi8KvDDAn6c6jHocPtSutlkuqWKvx86RxaNX/q053wLMQNjJ8Wl4HmiX4pym4uQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V5NiMdgs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V5NiMdgs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28F891F000FF;
	Sat, 12 Sep 2026 09:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204688;
	bh=u+oSqqwAJQZO1yGPjRuluxuCuW1c5mXvzr7cvIdWAqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V5NiMdgsWF0Tat71IuEOUKCOBTq4BM62CzfAq/aD1bYWzww8s/ouNn5jpCBI3jSmP
	 00W9Zf/HYJrAl5qcQczpC8Ouf2i6ymhlLW0jx7KwDa56N/ek4qZW9kSC0OwkLmz+3p
	 aFiHH+0vRNJ0wjGjHePb3LPV0KFyFgGd6hHIAkPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1647/1815] irqchip/gic-v5: Check for NULL LPI domain on domain teardown
Date: Sat, 12 Sep 2026 08:56:37 +0200
Message-ID: <20260912065727.658641391@linuxfoundation.org>
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

From: Lorenzo Pieralisi <lpieralisi@kernel.org>

[ Upstream commit aa079dbf4c2598c2613a0e464efcb2c232753c51 ]

In gicv5_free_lpi_domain() the LPI domain being freed can be NULL.

Check it and return before trying to free it if it is.

Fixes: 0f0101325876 ("irqchip/gic-v5: Add GICv5 LPI/IPI support")
Signed-off-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://sashiko.dev/#/message/20260810104747.E5CE71F000E9%40smtp.kernel.org
Link: https://patch.msgid.link/20260812-gicv5-7-2-fixes-v1-2-3743e82c69a4@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v5.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v5.c b/drivers/irqchip/irq-gic-v5.c
index 6a99c541b559b..a7fae93e993e5 100644
--- a/drivers/irqchip/irq-gic-v5.c
+++ b/drivers/irqchip/irq-gic-v5.c
@@ -862,6 +862,9 @@ void __init gicv5_init_lpi_domain(void)
 
 void __init gicv5_free_lpi_domain(void)
 {
+	if (!gicv5_global_data.lpi_domain)
+		return;
+
 	irq_domain_remove(gicv5_global_data.lpi_domain);
 	gicv5_global_data.lpi_domain = NULL;
 }
-- 
2.53.0



