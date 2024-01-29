Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 925E96F06C;
	Mon, 29 Jan 2024 17:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548458; cv=none; b=Z7eauPpvAAx3e9UQ4cGwsoYANgS5yAwxLvz0i0xJ3XGz96qUXpZs8pN+5zBVMPP7pkWkkE3XcKc5TpSwMdTQ+IlWK3pzW4p9NQVeyAZ8SJb1RRi6SKZkmOYuXYg9w7EhNUkd+Rj5G6geLpWjWIhw57GtYWDIDibGMQAembn+gjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548458; c=relaxed/simple;
	bh=WeIjyvhzA3X89b8Wyh2JZa9V+NlpVp7SN+Ueb0U0gY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OiapTUqZLzSXNyE0Jd3sgq2E0sZ1R5Yh9Vt9N5QKXxHkB9EC/ogupAphN9Nv2H2adrFZixUl679Zp1/ArLCA6nruBt77hp1VCosEe8/YzFfI+C/cx53aBqY1Sgupw2fYAFuGshJEoJ0Dml4fqSCBtvK5WBSSKyb+0fVnPyuLDQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=emf7Ki3R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="emf7Ki3R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B32BC43390;
	Mon, 29 Jan 2024 17:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548458;
	bh=WeIjyvhzA3X89b8Wyh2JZa9V+NlpVp7SN+Ueb0U0gY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=emf7Ki3R4/+8qYRRZs6lgDIvg6dQmoJOCY62l2p6d+oBcMouwcfhbH//WIAIOq3Co
	 e/r8Vl9Uz7Fo12ltaaFiBsd1dJxP1+H4eQyJxbwBdI9bU6t5uzAGYykxh32IKWlAGh
	 88m2OhW7/6q1I9BQ2XK/bojrPAMK28buY+dsBBeg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.6 071/331] parisc/power: Fix power soft-off button emulation on qemu
Date: Mon, 29 Jan 2024 09:02:15 -0800
Message-ID: <20240129170016.996382217@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

From: Helge Deller <deller@gmx.de>

commit 6472036581f947109b20664121db1d143e916f0b upstream.

Make sure to start the kthread to check the power button on qemu as
well if the power button address was provided.
This fixes the qemu built-in system_powerdown runtime command.

Fixes: d0c219472980 ("parisc/power: Add power soft-off when running on qemu")
Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org # v6.0+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/parisc/power.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/parisc/power.c
+++ b/drivers/parisc/power.c
@@ -238,7 +238,7 @@ static int __init power_init(void)
 	if (running_on_qemu && soft_power_reg)
 		register_sys_off_handler(SYS_OFF_MODE_POWER_OFF, SYS_OFF_PRIO_DEFAULT,
 					qemu_power_off, (void *)soft_power_reg);
-	else
+	if (!running_on_qemu || soft_power_reg)
 		power_task = kthread_run(kpowerswd, (void*)soft_power_reg,
 					KTHREAD_NAME);
 	if (IS_ERR(power_task)) {


