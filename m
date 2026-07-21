Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3157538910F;
	Tue, 21 Jul 2026 18:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658654; cv=none; b=UMNkVA2ILLruVAxX20g2qjpFX4m0bNbJWOEVbMa2oLXN3C9/JbfUCtykwpfR8yix8RxXAI2ozgEj3I/O8IZckV010vKG9LFjDaoyvLafW9aPpJbqigcEU2FfBbRGmWkF1cOFFVO0Fa3rff9JIZOgm6MfvJ04g0r8euap9Z+HyT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658654; c=relaxed/simple;
	bh=vSPH6dhkB8KHVf6pEr/I1slV7kbwztxHTiCtlH31aPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aIQyJIqLekBO53EYAX/Wg1KdnmBMoAIh+IatTeeO57WHiqDsQ2JGDRQych9BTaqXzP65iYr4ULWkMgDrIigbyN5AiZ7ZIyTSjbJ8Ne/9IhSaRlSsvNk+1232HykelKJhr7cXh/Sn7sBo/MSx14CRH9DbdGWDEnaq+Q+AL8p6CDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P8WxflMe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P8WxflMe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 639541F00A3A;
	Tue, 21 Jul 2026 18:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658651;
	bh=fEcSm4WLy2weBDvKRrdzgxD8Bk8Cix3ZJ33ebWDU6S0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P8WxflMeGmq3opM+Z6tqRDQMHxC8VZQntPGvUTiUwlW8GQVa4ItKfL1GqF+JX0wZo
	 JzaTmTMcD02sU6lSSmOPDYOIiehVy4OGYpG7Q1qZfavO/o+0MmRPidljV56x+fauIr
	 +DeYu0uxNmQ9vuUAqn8nF6XUE/Xr+w1RrjQknXC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.18 1224/1611] MIPS: ip22-gio: fix gio device memory leak
Date: Tue, 21 Jul 2026 17:22:20 +0200
Message-ID: <20260721152542.968473714@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 7de9a1b45f5a95b58145653c525c8fb80292d9ab upstream.

The gio device release callback was never wired up so gio devices are
not freed when the last reference is dropped.

Fixes: e84de0c61905 ("MIPS: GIO bus support for SGI IP22/28")
Cc: stable@vger.kernel.org	# 3.3
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/sgi-ip22/ip22-gio.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/mips/sgi-ip22/ip22-gio.c
+++ b/arch/mips/sgi-ip22/ip22-gio.c
@@ -101,6 +101,8 @@ int gio_device_register(struct gio_devic
 {
 	giodev->dev.bus = &gio_bus_type;
 	giodev->dev.parent = &gio_bus;
+	giodev->dev.release = gio_release_dev;
+
 	return device_register(&giodev->dev);
 }
 EXPORT_SYMBOL_GPL(gio_device_register);


