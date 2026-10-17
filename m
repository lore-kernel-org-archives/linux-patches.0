Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A27A3CB557;
	Sat, 17 Oct 2026 17:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259582; cv=none; b=goGEiCzUAhzJw31GTtyY5BVNapM1tWbcuFViGnfYx+s1LE3/rTSlttWpQB5Y7CfxLd1j32ezLNPmAgfQoV5zrtvmfggvXWXK1r258iPnK12OmMfD1GoXPUG6+/bY+T6cvBaI6wFmGi+gHjG8Fqv3ByKKv+6Rl+lMmnggPndlhz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259582; c=relaxed/simple;
	bh=Psns6flHRxGlQMSfBK3qpw9f7CQfGpbofFOsA7bKzCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uGICZT9XSc+JLIk8qTBNleSbMsDd/DnHY307evJlpN4XxYiNWc1h7CypCugb8RWQcTgfmICU4tFlqr6rR8/uil+urICYhrWE4Jv9OvUQon+WVCqyQ+8QbFuYt/8AdU678uM6ZlLnaHJ9VuFpDGWbqYu5xdpgcETfdwsSKOZvqpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zjjNBtsm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zjjNBtsm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B368A1F000C4;
	Sat, 17 Oct 2026 17:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259580;
	bh=cK98lTFo36BZTGy6njOdGS9oGHdTI5RwUi3X75hXPXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zjjNBtsmMcsXxsuxhFKnDy6P8y/1dSVZzXg1xeK+SjcQJvcdjxIrElxsszaoHRatC
	 kGihSHuk+9ba686xlJC1G0t+HkVYc2rqrHVRB3YV8h6hlDsaioEkKJY7PZjckC2Bff
	 MziAazWkQFJ9QsR2eqLeqoqKKPaNXau3Uf5ZTzsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1261/1674] mfd: sm501: Fix potential memory leaks during remove
Date: Sat, 17 Oct 2026 17:58:53 +0200
Message-ID: <20261017160503.510098574@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

[ Upstream commit 83feedd9d83c0c5199f98c72df0a6196b4aefb4d ]

The memory allocated for struct sm501_devdata in sm501_pci_probe() and
sm501_plat_probe() is not freed by the corresponding remove functions
sm501_pci_remove() and sm501_plat_remove(). Fix that by adding a call to
kfree().

Fixes: b6d6454fdb66 ("[PATCH] mfd: SM501 core driver")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Link: https://patch.msgid.link/20260720113836.73133-1-nihaal@cse.iitm.ac.in
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/sm501.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mfd/sm501.c b/drivers/mfd/sm501.c
index 06e796883189e..5752099683eb4 100644
--- a/drivers/mfd/sm501.c
+++ b/drivers/mfd/sm501.c
@@ -1667,6 +1667,7 @@ static void sm501_pci_remove(struct pci_dev *dev)
 	release_mem_region(sm->io_res->start, 0x100);
 
 	pci_disable_device(dev);
+	kfree(sm);
 }
 
 static void sm501_plat_remove(struct platform_device *dev)
@@ -1677,6 +1678,7 @@ static void sm501_plat_remove(struct platform_device *dev)
 	iounmap(sm->regs);
 
 	release_mem_region(sm->io_res->start, 0x100);
+	kfree(sm);
 }
 
 static const struct pci_device_id sm501_pci_tbl[] = {
-- 
2.53.0



