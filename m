Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B1B3876CF;
	Tue, 16 Jun 2026 17:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631865; cv=none; b=jRtpxuYiDuBISiRFIhdWNAa2AcaRpsiUKhMmIDiHnK5y2//b6pst1OG+hBYznXGCFi3OLRuh3bEii+99tbvda5bPzb66U1sOGzvgjuO/TkzrXdO4NiMDD2SIK5Gs4/eP1I9QkySRa/cIp36BhMW4vyqS9dZwuuZ3uAFqQCYjEmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631865; c=relaxed/simple;
	bh=xSIp7d6QwcdQIGj/by1xBuyOOulRkqtz0pufYoeXbeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HspdhlgnvV+9kE8zSuS5B8oqOJYYGjc6MBP6yc3z2Y4VVtmAB7EJWrpA5AKV++ZCJ31ZK8iuKO4/HrbjIFQSVrLE+NmhJOuMA52M/UKcI6wEIanGCtEEqah3nXwuvjZblIZ8+dycL4ctC/LL33zOpR4V+AfN7JKOxjED1WSjHlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uQTIzh0C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uQTIzh0C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B2F71F000E9;
	Tue, 16 Jun 2026 17:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631863;
	bh=a9M/qFA7P0aHR2U0aMJP+cU9svV+V2yI4eBLUofeweg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uQTIzh0CeYGXSqvMoJB1v5ab06kjVq2fk5X8Ey/1MzuPltHEjbTPcqqtTh5frHPOS
	 MeSbJpRvfxWGotMNoFmeE8a5oyLU8akYgeqXzgSQkqq6pnv2qauAsNuH2XYk2h7qbI
	 dRgk7xv8dB24WoXRqd9fJEhCOd4T/3rymQ2OXe5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Dinh Nguyen <dinguyen@kernel.org>
Subject: [PATCH 6.1 282/522] ARM: socfpga: Fix OF node refcount leak in SMP setup
Date: Tue, 16 Jun 2026 20:27:09 +0530
Message-ID: <20260616145139.133118857@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuho Choi <dbgh9129@gmail.com>

commit 63838c323924fe4a78b2323bd45aa1030f72ca60 upstream.

socfpga_smp_prepare_cpus() looks up the Cortex-A9 SCU node with
of_find_compatible_node(), which returns a node reference that must be
released with of_node_put().

The function maps the SCU registers and then returns without dropping
that reference, leaking the node on both the success path and the
of_iomap() failure path.

Drop the reference once the mapping attempt is complete. The returned
MMIO mapping does not depend on keeping the device node reference held.

Fixes: 122694a0c712 ("ARM: socfpga: use of_iomap to map the SCU")
Cc: stable@vger.kernel.org
Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/mach-socfpga/platsmp.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/mach-socfpga/platsmp.c
+++ b/arch/arm/mach-socfpga/platsmp.c
@@ -78,6 +78,7 @@ static void __init socfpga_smp_prepare_c
 	}
 
 	socfpga_scu_base_addr = of_iomap(np, 0);
+	of_node_put(np);
 	if (!socfpga_scu_base_addr)
 		return;
 	scu_enable(socfpga_scu_base_addr);


