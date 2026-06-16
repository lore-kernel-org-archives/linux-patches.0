Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEFCA43E490;
	Tue, 16 Jun 2026 17:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629731; cv=none; b=l0u7bf1al2t2Q7CQqAhz+Xjm1aFaCKnSGWIMlrYxHOjTKkJoZ3V+ivcv725dUY0amNeslBK4drhXt5+GEgmlBgb+1D/kV4ypkLrhfE4gsIcPVHn4J770kO5xbKKB6b4AQLUYCCnJQjr+Y4CpvBPuL/KJl+X3JItMPYDj4BeEABk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629731; c=relaxed/simple;
	bh=oak59Z2xcQAeeyv4rNDqgV/uFGRoVl4lJEyQTNs7Vyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DJ8E1TG+SnJZwYYHvS0qC4d5pTmmn5Sy21vHhdzyqO2aNGZzmtxsZT+CqgeXc+8M1kBsmFwtMEl/WDvuvzoG0dwaQbyvPv+LL3Pqswag1hbqElk1sBeSGiLbgaWq47dXsm29dJp1nFEfKNB71XHvKD7Agxu868lMlHVgsF6PcXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SL4Gpt/q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SL4Gpt/q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D674F1F000E9;
	Tue, 16 Jun 2026 17:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629730;
	bh=DEt1bhRqOHy4UYfVbdWSYrHUVk5gDOvmkmnfDU9sBNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SL4Gpt/q8mxcrDOOdMeZU7JJGcS4ELY2zglqy/EfbHNJpVLFJMuYpnHMxfbl4/lNi
	 mzTPZ1nzgqMrSL/eO84hoyPWWfdngHrE53XlCtZoE9PH5A5+kagdj09YdLXwMaew5U
	 eauJ9siWAz+GqM+d7JgslZ6IjOk4SeXt6J4JLoT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Dinh Nguyen <dinguyen@kernel.org>
Subject: [PATCH 6.6 311/452] ARM: socfpga: Fix OF node refcount leak in SMP setup
Date: Tue, 16 Jun 2026 20:28:58 +0530
Message-ID: <20260616145133.856538594@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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


