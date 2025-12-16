Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ED0534167A;
	Tue, 16 Dec 2025 11:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884211; cv=none; b=rtY8A9Xk0SWPCHPBdK/Spjw3FEfZASp8Z4Ef4TyOyuAE5zqp448pSeRSxPhyMYGShpEhwBRLwz3VDg1LCDgaSHrmTtdEdc64JMMmAfsRDs+VdcjkRn8YRs8iKCF26a1fQsQ/udyWJa0HHyVAA5KuU/WNBtyKClltmVE3L9Ocxlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884211; c=relaxed/simple;
	bh=NRwXkqof4V/NVpyBlsz6c69V0a9F240r7IHP/TIjtFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FoLIHmwx/JTSqz10rU2bLfIpzLuDkoNKHSCqQeuYEWEffs+ZqFcyxNI82lBa6E3R8IBYxXzpklCHwa7q2CsdClY18kxru2OWBaptaISUyBJwiN1NsEzqaDwAONoU7oY6AjL/KvNIA/40vZqDhmnVieIAfTDLFy1shVmFAlxj3aQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CUqO+2Sy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CUqO+2Sy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D766AC4CEF1;
	Tue, 16 Dec 2025 11:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884211;
	bh=NRwXkqof4V/NVpyBlsz6c69V0a9F240r7IHP/TIjtFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CUqO+2SyK1DAntDiKIELGQVx9ScGan44F+ljHm9xlhd/WUCHlQtQ+6Tm63BlHop4Q
	 Bp8TC6cjY7AY5n5JSueqxB2F5VEU2F37B233VWX2PLO3xwluJaKciSIsXestzxeruh
	 DnBLHXeZPYA+8EP1OtrYazqfUrP644Grj7Nf7ra0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 125/354] mfd: da9055: Fix missing regmap_del_irq_chip() in error path
Date: Tue, 16 Dec 2025 12:11:32 +0100
Message-ID: <20251216111325.451373140@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 1b58acfd067ca16116b9234cd6b2d30cc8ab7502 ]

When da9055_device_init() fails after regmap_add_irq_chip()
succeeds but mfd_add_devices() fails, the error handling path
only calls mfd_remove_devices() but forgets to call
regmap_del_irq_chip(). This results in a resource leak.

Fix this by adding regmap_del_irq_chip() to the error path so
that resources are released properly.

Fixes: 2896434cf272 ("mfd: DA9055 core driver")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20251010011737.1078-1-vulab@iscas.ac.cn
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/da9055-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/da9055-core.c b/drivers/mfd/da9055-core.c
index 1f727ef60d638..8c989b74f924e 100644
--- a/drivers/mfd/da9055-core.c
+++ b/drivers/mfd/da9055-core.c
@@ -388,6 +388,7 @@ int da9055_device_init(struct da9055 *da9055)
 
 err:
 	mfd_remove_devices(da9055->dev);
+	regmap_del_irq_chip(da9055->chip_irq, da9055->irq_data);
 	return ret;
 }
 
-- 
2.51.0



