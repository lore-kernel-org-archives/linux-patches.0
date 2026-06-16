Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2156D45BD71;
	Tue, 16 Jun 2026 16:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625699; cv=none; b=BsB7Ld3zLXpE/g59pMa6jHTA/Sur8LZD9IM/H4Hy/x3K+iNApFF2GVT5NdtfZQN6r5TjNAkj0BnBYwWpZ80HUnsKk+WMzXSuc2EWG8Xlb0KQVdheRtOmHFRF96qmZE7TZfgSF/n5S78mwocP2lk2e5jTle6DDizXMFiuQCLlnY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625699; c=relaxed/simple;
	bh=YuAJH/B29+0G2YnO64mWtJvSIxZG+mivTct80BiywPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q4cO+hcylppdj9+5pGtoT1YvBkvXK+QE4D4oUsV9avrzcIrAuA7EzHUjmsVpH0T7YGnatn4f7ahMhxu3FoOchoDq16d67b7S97eCsuNw5ltiEE1c5WJB2wxISAk+q+b2nqvDHRoRw9AGoHjJ/CWLJDXy1Jb7tys1p674hD7sBRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kPTRJj9W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kPTRJj9W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D931B1F000E9;
	Tue, 16 Jun 2026 16:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625697;
	bh=CP+X8Y5hwgdUNG/8fNM9UeeeUcuv2zwgO3tKPqEJKCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kPTRJj9WbibICcr8u+4/HhCllRr0/0f4wFLtKu+Dv5toPBthy5Zb+1rv3CQp5ufjL
	 Z6tigz5tPbiLG0YowUjQmkSEsXg1Vq0FDDlc1kFmpHI2YTZG4Pke+HapJfhrYhA/RP
	 jWIYZIv6KFbGUg+I1hR1TW/uH1eHWIxrwt6bLcX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Dinh Nguyen <dinguyen@kernel.org>
Subject: [PATCH 6.18 191/325] ARM: socfpga: Fix OF node refcount leak in SMP setup
Date: Tue, 16 Jun 2026 20:29:47 +0530
Message-ID: <20260616145107.445025681@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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


