Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE4CF186E38;
	Mon, 12 Aug 2024 16:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479042; cv=none; b=dldgEKKu49v+yeDNABxfwS3AnmuqnlMkcid1I7zXCCxfDEp5JcZ1ejyUd+Bm7WYT+lwX1dUOEIkmMHunTWMQ3gAXLbJNut1csVQLN7vCYWTe/CUupSNKLtYhSXcH7WcXmIOLfMylSI5B1+wPhm6yvuwwFccQmBi2W1P0ga4KwS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479042; c=relaxed/simple;
	bh=7wVy8lxC1Jqcz/EU0jmsJcmeL8VhGvOD6thrQ1xklj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lc7LJaoiwjmV45SmZDbZKW+iT507nTuGY85d7e/m7nL13spWVe1TjhtKjDTqNb+RTiiXWp3bFAHoPPqHhwOag7L5/e1jRHyCAYtXGl/pp6ulcwmFT/BDJHyIeS23wuooOV4fZ7xOy2ahsOpMqNzpzpK+j/WKQr0skygCsfPLFJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j94Shawl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j94Shawl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74F8EC32782;
	Mon, 12 Aug 2024 16:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479041;
	bh=7wVy8lxC1Jqcz/EU0jmsJcmeL8VhGvOD6thrQ1xklj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j94ShawlPIw8utfu7uUHgpqkeJoE2GWRqQiq9XszB/6tynOMF8w1GKFks4x/neOSu
	 h5JhRcESVBLHsrPxMzS2P8lJkAoc9mk51AJTEmnprC0WU4MQchwXjGosGUS8z3BhRW
	 Xt4x/JqGzk2gpxOLj6BbLUbt3m8sZ3eMBm79JI0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.1 114/150] genirq/irqdesc: Honor caller provided affinity in alloc_desc()
Date: Mon, 12 Aug 2024 18:03:15 +0200
Message-ID: <20240812160129.561527886@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
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
@@ -493,6 +493,7 @@ static int alloc_descs(unsigned int star
 				flags = IRQD_AFFINITY_MANAGED |
 					IRQD_MANAGED_SHUTDOWN;
 			}
+			flags |= IRQD_AFFINITY_SET;
 			mask = &affinity->mask;
 			node = cpu_to_node(cpumask_first(mask));
 			affinity++;


