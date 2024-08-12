Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4370C1494B8;
	Mon, 12 Aug 2024 16:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480623; cv=none; b=tfKxtEcRS/5ovP9rA2JoTRpLnHZLbKyz4iEWcKu++piBTGn7IuEvrd27/Q8k28O26rSOdxJIbWsfbdXS6lp1GEPSbqmvNtgipPVEsw605ndeHfPrtllGihe4nbW92BsQ4Z4qFFp4BSoeicozuN1wH+HqpXTYrz7kJK8VZNLeAhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480623; c=relaxed/simple;
	bh=+/K4iVt2ndRcAspcpDaZQyRnwAoizDMjUnVoWuoTFB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L8209+nMT6Q7icXqoyjJ5S9llBsK026PAKaCI0bRC/BeMKT0uIHYIk3LJTrziFEYmTdH8RqWuVcmKiq2eGMFEHUQ9aHf516fZkLCE33485L4Lyw/KWDgSEYpCeoP7FeDLxQ9mI5/3SOCkvmqIDFPoXGDtWCXhMiA/RYEVWB4Tl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ihTCkUHo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ihTCkUHo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAF70C32782;
	Mon, 12 Aug 2024 16:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480623;
	bh=+/K4iVt2ndRcAspcpDaZQyRnwAoizDMjUnVoWuoTFB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ihTCkUHonGmvsYHEnDUUCZKpbWvpbXJANT3uAqHoHUkdj1sZyEJ4QRO//G+hENyfP
	 DnyqZBfS3m1VAmxHpQOkKztQo1ELMXj4izaX4BtwyCwGon+STXvUWpinqFsJZEAOZJ
	 GCdxJ/VvygT6dsSMXE6bQScW6NR0qPDbFPSwaEcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.10 221/263] genirq/irqdesc: Honor caller provided affinity in alloc_desc()
Date: Mon, 12 Aug 2024 18:03:42 +0200
Message-ID: <20240812160154.999135127@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shay Drory <shayd@nvidia.com>

commit edbbaae42a56f9a2b39c52ef2504dfb3fb0a7858 upstream.

Currently, whenever a caller is providing an affinity hint for an
interrupt, the allocation code uses it to calculate the node and copies the
cpumask into irq_desc::affinity.

If the affinity for the interrupt is not marked 'managed' then the startup
of the interrupt ignores irq_desc::affinity and uses the system default
affinity mask.

Prevent this by setting the IRQD_AFFINITY_SET flag for the interrupt in the
allocator, which causes irq_setup_affinity() to use irq_desc::affinity on
interrupt startup if the mask contains an online CPU.

[ tglx: Massaged changelog ]

Fixes: 45ddcecbfa94 ("genirq: Use affinity hint in irqdesc allocation")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/all/20240806072044.837827-1-shayd@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/irq/irqdesc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -530,6 +530,7 @@ static int alloc_descs(unsigned int star
 				flags = IRQD_AFFINITY_MANAGED |
 					IRQD_MANAGED_SHUTDOWN;
 			}
+			flags |= IRQD_AFFINITY_SET;
 			mask = &affinity->mask;
 			node = cpu_to_node(cpumask_first(mask));
 			affinity++;


