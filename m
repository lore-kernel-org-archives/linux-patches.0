Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2718A1A7074;
	Thu, 15 Aug 2024 14:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730540; cv=none; b=XkQPTka9dFSdfaQgHrl6DkRlIDUgzU8JZ0pWhR3p8qIw0FH4FdKAaCnxurWeP2cJ8bvnQQ8NgTQvrDmWxLjphbz6Ke9ljYee5owCu5DrgGJ4LnzAWXWVF/UqyLLfWCRgjWkmZcPABqH9GQ1v6csrrKnNSsb60Zai2N6SyegLSu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730540; c=relaxed/simple;
	bh=rYjAkagvKApOtWj3CED98hKf9ooed0o4hS3aAzzVHhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jzH+qykhk3jpYT8kJJP4E8ygxvTy6aA9HoYps3ctJHKYNW9Mq35UoaFEiez+1csWdmCJlD9pGlEyrl/U+hUGiOwwfuDkx3oric4VXvsko9H0QMbKNIi1sC5cSykSU7Xeejty9qbnTkfB7At6pl/JpZcV5FBhaFazrd4rVJMNLVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EPiPmU+U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EPiPmU+U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F856C4AF0F;
	Thu, 15 Aug 2024 14:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730540;
	bh=rYjAkagvKApOtWj3CED98hKf9ooed0o4hS3aAzzVHhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EPiPmU+U2oL09ak3PQcWiCGGHuczlUwtKL6gAbHQ49lsXtl4XrTfILD5Wilj4f5oM
	 vEnjvp+GMbsHWZwhDIsYNjXmyUKDsUvO3r0PJAHplfBsQzoJBa6d56g4iEVtUNNds5
	 xV3tXwHOf4OpKBzVI4nGmOq5ukySVhHjDHQIXDXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.15 441/484] genirq/irqdesc: Honor caller provided affinity in alloc_desc()
Date: Thu, 15 Aug 2024 15:24:59 +0200
Message-ID: <20240815131958.494876157@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


