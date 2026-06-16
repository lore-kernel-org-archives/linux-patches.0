Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 893AA357D14;
	Tue, 16 Jun 2026 15:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624084; cv=none; b=FnPrIui/afEyuRCnePiDoZey4M5m/Z89C3e43sI9w9uQ4Z3DuikaCht3hA1ZD1EeOfmLyphnLLxSW4PKafzJS8/zRu4dkKXXQNJnuaYeRtGSvEzMpJ9x1Ry57iDUL+LyTHy6DfSFc8W2PfpwBJ1T4+N8UjwCdexUnQ+M9yqpJMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624084; c=relaxed/simple;
	bh=MdAGweEENpLFt/NTGTHA0l62i54K7LX8Z8mAKJ9kQhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OdcKtc7aUY8tqBkB6MjH8uSdsgaUzIN83UxdnH4uvQxHXDqSymS/oeIc54LGZvVcLHguuf6qZujan0GKgYTWzRMHEKSxuhGdXDIURzQDTuZFY8zZ9e+v8F7iGqlg9WtspUOwjY17H3fWyaQbnFse4Ecb5icW0CBauKFUpcKjDwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cvmq4S5k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cvmq4S5k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7133C1F000E9;
	Tue, 16 Jun 2026 15:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624083;
	bh=pcuTK/AFOJsr5RNXxON5RiBv6OE6ji6wY5syrXFPz/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cvmq4S5k8wXhBq/n5shPsDKzYOiVyKSENjI96csntmq9mG65bpPLgwFIDqFJfKjrn
	 ++hjGQmfoUazDsrFSCPipJBeO76Xp4T6D8Exm0G5c5z+UjD3BFBKmL8fAEbSOcdvs3
	 gNVfsbg3MWfDOs9Uu3NNQ7mR0STHvwLIpLMGJTtc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Dinh Nguyen <dinguyen@kernel.org>
Subject: [PATCH 7.0 226/378] ARM: socfpga: Fix OF node refcount leak in SMP setup
Date: Tue, 16 Jun 2026 20:27:37 +0530
Message-ID: <20260616145122.185837430@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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


