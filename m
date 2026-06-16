Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D89EA4508F2;
	Tue, 16 Jun 2026 16:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781627309; cv=none; b=aVanFJ4NgJwGtRHdBCPdGKHekvDOectRW2X7heKeW0UGkYmN6vXvFBkkhHN78F8VU4fdQ8i0vjaavS/WsE2DScuZW64gcJHD1hBTkoKt9HzMwS9YjrXPzRR2pMGFm5T7vkODAIwWZ0lp/pYe6KnYwSU1wPO2pR40MAU+jQ0nYno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781627309; c=relaxed/simple;
	bh=3H891mxWDn7eIGD4SI92m+ancANXAnDXUVo02feI4cI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U/SUK0vbOrNgYXuEkWFIE5ef9VU6KmYvhjvrbcV0oqkTdQeROayRsihIb/L33qG7hwSeWOwm4gwYoDYHWH6/UYA13gJU/wWBnQ4yR0Za2zBFi+xDEBUjRyasEg53OUtSi0PxtWNxRKO2m1h956mmnjmkAjfRGucrPlqzjF5MJI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fUeumGPw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fUeumGPw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDFD61F000E9;
	Tue, 16 Jun 2026 16:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781627308;
	bh=60PNUXhxWldG/RhJSke2IwFZmOalPhXoeHacWTAoEBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fUeumGPwK5lgVaQwT8MVb6YKp+DU73ciA6L4EWY1iIyA355h6ZPuQe34+HrBJLaGy
	 JZleITKZaIVhqvIdtwT3tqhzHFevh01cntWR8lDu3/8rYc/uNCxSEqn/xuYb2gXR5N
	 5iQJMQDxiHqnCVdRR7bHKvsWcsTV6G4MN780a1OY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Dinh Nguyen <dinguyen@kernel.org>
Subject: [PATCH 6.12 153/261] ARM: socfpga: Fix OF node refcount leak in SMP setup
Date: Tue, 16 Jun 2026 20:29:51 +0530
Message-ID: <20260616145052.170164422@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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


