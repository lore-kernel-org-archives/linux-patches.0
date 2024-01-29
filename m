Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F156159578;
	Mon, 29 Jan 2024 17:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548224; cv=none; b=a8xan+OlAYLdgD3nI6lcFXe/7kCzTXObaIfWcavCKyktJXnYiUYWV02GUL3iqVrW/a1sr4ggGowY+bvEWrMgL9pEmrV6ZgkqResWsyT+hh1YfL/AV0rkY5eRUyju+7Q9Zk5vF+3tYHmjAU4VCdv5cQKeDilibaOliXuI0SJ/7P0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548224; c=relaxed/simple;
	bh=DSdeYg336qI8kFMZDowYSB6HLCXjsS23D/ca3AJQ58g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fe9PqMVsvWPtsDzngSIE2ldPPVHDvXfZp8S5kLUQZJZoSyIX2u5mbfElbxpS/0bh+ydgLlhGqOhqlV6meg3M8IsVlmz4bLZPXr2ovCNeNbJZjf4n/doOChUFq9xltNS7iZuWCZW/6sD0d8cidFKMcKDW1E+XJRZG9pPZkTVNWTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g43Nm26F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g43Nm26F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55C2CC43390;
	Mon, 29 Jan 2024 17:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548224;
	bh=DSdeYg336qI8kFMZDowYSB6HLCXjsS23D/ca3AJQ58g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g43Nm26Fz1eZ61FMlXt/vSKMZnvpG6hE2lalr+8UbxPJeYKiOW5bBwVNxwOiVKFJx
	 piqsy9HcTtgCe1zCjSv92+nDaDRTC576iHXeXYHwKUap9X81jvXkTKbFHnux6pADz1
	 mQSE8ytCF/IwPMMSJAW+hI92drQSEzojO8SZODlM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.1 028/185] parisc/power: Fix power soft-off button emulation on qemu
Date: Mon, 29 Jan 2024 09:03:48 -0800
Message-ID: <20240129165959.504611507@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


