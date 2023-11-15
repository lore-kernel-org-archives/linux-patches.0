Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 890633A8F3
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GCmlQYjF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C225C433CA;
	Wed, 15 Nov 2023 19:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077953;
	bh=3SF2hc4f7QatSn90G1PzZ2/VVrnLw9j5BJ7IV7KO+tM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GCmlQYjF/uDrAu0jwjBUB6me62RRhaNq5JqiCzyj09Go8Oz7ABnbPPPI2AE2Xvli8
	 yOfQGkQwagI439feDFPI99xZJk7IIZknAliH1qAB9fqGru7UBcRLtYcbpeUh/Baqtg
	 qUb+GYsBfH+Sz0Kwsr/Opvh2xK6hUqocDm5csiQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wendy Wang <wendy.wang@intel.com>,
	Chen Yu <yu.c.chen@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 019/379] genirq/matrix: Exclude managed interrupts in irq_matrix_allocated()
Date: Wed, 15 Nov 2023 14:21:34 -0500
Message-ID: <20231115192646.292821074@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
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

From: Chen Yu <yu.c.chen@intel.com>

[ Upstream commit a0b0bad10587ae2948a7c36ca4ffc206007fbcf3 ]

When a CPU is about to be offlined, x86 validates that all active
interrupts which are targeted to this CPU can be migrated to the remaining
online CPUs. If not, the offline operation is aborted.

The validation uses irq_matrix_allocated() to retrieve the number of
vectors which are allocated on the outgoing CPU. The returned number of
allocated vectors includes also vectors which are associated to managed
interrupts.

That's overaccounting because managed interrupts are:

  - not migrated when the affinity mask of the interrupt targets only
    the outgoing CPU

  - migrated to another CPU, but in that case the vector is already
    pre-allocated on the potential target CPUs and must not be taken into
    account.

As a consequence the check whether the remaining online CPUs have enough
capacity for migrating the allocated vectors from the outgoing CPU might
fail incorrectly.

Let irq_matrix_allocated() return only the number of allocated non-managed
interrupts to make this validation check correct.

[ tglx: Amend changelog and fixup kernel-doc comment ]

Fixes: 2f75d9e1c905 ("genirq: Implement bitmap matrix allocator")
Reported-by: Wendy Wang <wendy.wang@intel.com>
Signed-off-by: Chen Yu <yu.c.chen@intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20231020072522.557846-1-yu.c.chen@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/irq/matrix.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/irq/matrix.c b/kernel/irq/matrix.c
index 1698e77645acf..75d0ae490e29c 100644
--- a/kernel/irq/matrix.c
+++ b/kernel/irq/matrix.c
@@ -466,16 +466,16 @@ unsigned int irq_matrix_reserved(struct irq_matrix *m)
 }
 
 /**
- * irq_matrix_allocated - Get the number of allocated irqs on the local cpu
+ * irq_matrix_allocated - Get the number of allocated non-managed irqs on the local CPU
  * @m:		Pointer to the matrix to search
  *
- * This returns number of allocated irqs
+ * This returns number of allocated non-managed interrupts.
  */
 unsigned int irq_matrix_allocated(struct irq_matrix *m)
 {
 	struct cpumap *cm = this_cpu_ptr(m->maps);
 
-	return cm->allocated;
+	return cm->allocated - cm->managed_allocated;
 }
 
 #ifdef CONFIG_GENERIC_IRQ_DEBUGFS
-- 
2.42.0



