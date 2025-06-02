Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B44422A814;
	Mon,  2 Jun 2025 14:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875870; cv=none; b=MbDTFM0mGUABiqbxCWtWI27P6FNDMJ8zj3xL7g53o7Mz3JL21/WZDEYH/VLq+tXsc9J3LBPsMGQPL2PeAk168QZGp56PZ7L4YgrRMNxeuk5kJcIG26R7QXTFFOh582gv/d4IhgJvz5JNXXcNFVIZ7ihOiKXoYS/Rk55zEu3mc/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875870; c=relaxed/simple;
	bh=zxBlhjDfJBf1BWDpcS70keSIxBJ7JdQrAE90zXDPXeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aOvUwZbJLcs+tyC5c22vWTrExma/VmnNZrX3nF0Y7W68P54fnY6fiwTJtQz0w93+EZ1CgsPbLQcb4ZADW2i9DMOMi8aSLPz/mfj8sfaG67Ai5/ONiHv/pkbMWt6ws+/nIOJsmhIdPcHcHPnjUKaQG3ajKR8yH5jvlgg1Z1UWQng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ao0AVxBV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ao0AVxBV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CF0EC4CEEB;
	Mon,  2 Jun 2025 14:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875870;
	bh=zxBlhjDfJBf1BWDpcS70keSIxBJ7JdQrAE90zXDPXeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ao0AVxBV8+bSj+9d19gXomSCrad3E5qVgMkHAU/u6CEzuZAy/rezMy6h1yKwVqhxm
	 RUUytf/Iy9ZLOroqktTUFUfUp/UyCQC4FL4dHsJEuqXkYP29hMVy91X25aSZ8Pov+0
	 ktal7oCWUatVed1m0b4jW90fSDtRukjr0ys7emJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Murphy <robin.murphy@arm.com>,
	Ilkka Koskinen <ilkka@os.amperecomputing.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 5.10 270/270] perf/arm-cmn: Initialise cmn->cpu earlier
Date: Mon,  2 Jun 2025 15:49:15 +0200
Message-ID: <20250602134318.370595510@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robin Murphy <robin.murphy@arm.com>

commit 597704e201068db3d104de3c7a4d447ff8209127 upstream.

For all the complexity of handling affinity for CPU hotplug, what we've
apparently managed to overlook is that arm_cmn_init_irqs() has in fact
always been setting the *initial* affinity of all IRQs to CPU 0, not the
CPU we subsequently choose for event scheduling. Oh dear.

Cc: stable@vger.kernel.org
Fixes: 0ba64770a2f2 ("perf: Add Arm CMN-600 PMU driver")
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Reviewed-by: Ilkka Koskinen <ilkka@os.amperecomputing.com>
Link: https://lore.kernel.org/r/b12fccba6b5b4d2674944f59e4daad91cd63420b.1747069914.git.robin.murphy@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
[ backport past NUMA changes in 5.17 ]
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/perf/arm-cmn.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/perf/arm-cmn.c
+++ b/drivers/perf/arm-cmn.c
@@ -1512,6 +1512,7 @@ static int arm_cmn_probe(struct platform
 		return -ENOMEM;
 
 	cmn->dev = &pdev->dev;
+	cmn->cpu = raw_smp_processor_id();
 	platform_set_drvdata(pdev, cmn);
 
 	if (has_acpi_companion(cmn->dev))
@@ -1533,7 +1534,6 @@ static int arm_cmn_probe(struct platform
 	if (err)
 		return err;
 
-	cmn->cpu = raw_smp_processor_id();
 	cmn->pmu = (struct pmu) {
 		.module = THIS_MODULE,
 		.attr_groups = arm_cmn_attr_groups,


