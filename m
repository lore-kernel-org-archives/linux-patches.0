Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C45613DDC0;
	Wed, 19 Jun 2024 13:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718804033; cv=none; b=JTZNi/r4tSiNcfX+Aq1VkNgkeOs4rrpJ7eYU73SpQKkf4MrljVKfp9oiSSRNTSReD+0psWnAhj3aMs3r7lHi/z3bDCAFqICxuKMGRXUiJe4fuNBjCWGFuccyFAqgZFxRVYPXv6VhEAyq/eahP2/22skZp0C6+4gNyNZ7vHqTCvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718804033; c=relaxed/simple;
	bh=uR75YvrNJUgg9ywhrQC0WzpK1q0kRqB0msfUvCt1r7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OnQ30N73mkUoi8LjQf7IMALo3CV4B+tAlY3oSRzEPJFFHOeKZpIrF3DSZ9GgOsISiMB2yNMIbPc2Fi+LzWfP12GwRg14d/i7rFl2Hh3KlETx5n3c2WMBSlC7sV+HHJkrsfVagI4H8IkWG7brIW87VGlWQwt627PDVYIEU26BbjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JRg8LHrB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JRg8LHrB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D64C4C2BBFC;
	Wed, 19 Jun 2024 13:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718804033;
	bh=uR75YvrNJUgg9ywhrQC0WzpK1q0kRqB0msfUvCt1r7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JRg8LHrBf523a8CMpODmCy9tJHIXSRNbQFB15NfRWvRNmh8jPM9ntD1+HRCENwAKi
	 SEnKkolisQVtCKic/rsOpW0QTew2TTQJgqL2HyL4YNEagga768bQ/eHGHVzAJ///TV
	 rI01Xq8sUa+hrwGKFj8dLi32GLwl+9rSUw4WSHuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Hagar Hemdan <hagarhem@amazon.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.1 169/217] irqchip/gic-v3-its: Fix potential race condition in its_vlpi_prop_update()
Date: Wed, 19 Jun 2024 14:56:52 +0200
Message-ID: <20240619125603.210995800@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

From: Hagar Hemdan <hagarhem@amazon.com>

commit b97e8a2f7130a4b30d1502003095833d16c028b3 upstream.

its_vlpi_prop_update() calls lpi_write_config() which obtains the
mapping information for a VLPI without lock held. So it could race
with its_vlpi_unmap().

Since all calls from its_irq_set_vcpu_affinity() require the same
lock to be held, hoist the locking there instead of sprinkling the
locking all over the place.

This bug was discovered using Coverity Static Analysis Security Testing
(SAST) by Synopsys, Inc.

[ tglx: Use guard() instead of goto ]

Fixes: 015ec0386ab6 ("irqchip/gic-v3-its: Add VLPI configuration handling")
Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Hagar Hemdan <hagarhem@amazon.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Reviewed-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20240531162144.28650-1-hagarhem@amazon.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-gic-v3-its.c |   44 ++++++++++-----------------------------
 1 file changed, 12 insertions(+), 32 deletions(-)

--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -1837,28 +1837,22 @@ static int its_vlpi_map(struct irq_data
 {
 	struct its_device *its_dev = irq_data_get_irq_chip_data(d);
 	u32 event = its_get_event_id(d);
-	int ret = 0;
 
 	if (!info->map)
 		return -EINVAL;
 
-	raw_spin_lock(&its_dev->event_map.vlpi_lock);
-
 	if (!its_dev->event_map.vm) {
 		struct its_vlpi_map *maps;
 
 		maps = kcalloc(its_dev->event_map.nr_lpis, sizeof(*maps),
 			       GFP_ATOMIC);
-		if (!maps) {
-			ret = -ENOMEM;
-			goto out;
-		}
+		if (!maps)
+			return -ENOMEM;
 
 		its_dev->event_map.vm = info->map->vm;
 		its_dev->event_map.vlpi_maps = maps;
 	} else if (its_dev->event_map.vm != info->map->vm) {
-		ret = -EINVAL;
-		goto out;
+		return -EINVAL;
 	}
 
 	/* Get our private copy of the mapping information */
@@ -1890,46 +1884,32 @@ static int its_vlpi_map(struct irq_data
 		its_dev->event_map.nr_vlpis++;
 	}
 
-out:
-	raw_spin_unlock(&its_dev->event_map.vlpi_lock);
-	return ret;
+	return 0;
 }
 
 static int its_vlpi_get(struct irq_data *d, struct its_cmd_info *info)
 {
 	struct its_device *its_dev = irq_data_get_irq_chip_data(d);
 	struct its_vlpi_map *map;
-	int ret = 0;
-
-	raw_spin_lock(&its_dev->event_map.vlpi_lock);
 
 	map = get_vlpi_map(d);
 
-	if (!its_dev->event_map.vm || !map) {
-		ret = -EINVAL;
-		goto out;
-	}
+	if (!its_dev->event_map.vm || !map)
+		return -EINVAL;
 
 	/* Copy our mapping information to the incoming request */
 	*info->map = *map;
 
-out:
-	raw_spin_unlock(&its_dev->event_map.vlpi_lock);
-	return ret;
+	return 0;
 }
 
 static int its_vlpi_unmap(struct irq_data *d)
 {
 	struct its_device *its_dev = irq_data_get_irq_chip_data(d);
 	u32 event = its_get_event_id(d);
-	int ret = 0;
 
-	raw_spin_lock(&its_dev->event_map.vlpi_lock);
-
-	if (!its_dev->event_map.vm || !irqd_is_forwarded_to_vcpu(d)) {
-		ret = -EINVAL;
-		goto out;
-	}
+	if (!its_dev->event_map.vm || !irqd_is_forwarded_to_vcpu(d))
+		return -EINVAL;
 
 	/* Drop the virtual mapping */
 	its_send_discard(its_dev, event);
@@ -1953,9 +1933,7 @@ static int its_vlpi_unmap(struct irq_dat
 		kfree(its_dev->event_map.vlpi_maps);
 	}
 
-out:
-	raw_spin_unlock(&its_dev->event_map.vlpi_lock);
-	return ret;
+	return 0;
 }
 
 static int its_vlpi_prop_update(struct irq_data *d, struct its_cmd_info *info)
@@ -1983,6 +1961,8 @@ static int its_irq_set_vcpu_affinity(str
 	if (!is_v4(its_dev->its))
 		return -EINVAL;
 
+	guard(raw_spinlock_irq)(&its_dev->event_map.vlpi_lock);
+
 	/* Unmap request? */
 	if (!info)
 		return its_vlpi_unmap(d);


