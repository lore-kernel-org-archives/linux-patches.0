Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 883244D5AB;
	Mon,  8 Apr 2024 13:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583876; cv=none; b=s9ui38R2E5yUO00N3m/B10CTw5Fk4jeV863JEaL/ovS5SOVAXVtqOQcocjq+Dv3Zf8FhvaXmTIROpw4vcQDknEpfuSONDsc+/51oXXJWyfLbHNV4WmFCgk+2m30seSxn5lqW6UQL+6at/D0rhnVGDGAjZc1gXhd6VZpHEwOR864=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583876; c=relaxed/simple;
	bh=6sBBISFeuMCRkU43hFjnC508FJkgl4Gczk541J2DImA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GCyuINVARHCPrqk24dJCIXKrN1LygbknjjouGFVTIk80T3Xmr0/N1oo0/8Ah8sJdDKEWLOy4blSD+D4ohJYWeZLRmoMpyv6aexDxn5Jj6dWbBT6UL+fpqaUAOtiEzQeTOtYZkUr+ZBs0sb6maQevggDT0WWV7PC5ap4Ch/8ro40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SlPEl3cj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SlPEl3cj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CB96C433C7;
	Mon,  8 Apr 2024 13:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583876;
	bh=6sBBISFeuMCRkU43hFjnC508FJkgl4Gczk541J2DImA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SlPEl3cjNexq4LgjTYXrAiZ1tBhoXjlKrqMKhpv2rb6uyAMcxOTP2RHvWcWKh5GrI
	 I7NreO6+q6vbKs4WZueuZhC32lWMJoGGChyA0JG2vDvYgBlUv6KbMYgnMVPByOHIeP
	 s+FHRUQ6gB1D6F6L7s1yYc4zd8wrG6oh8RnLL4V0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herve Codina <herve.codina@bootlin.com>,
	Saravana Kannan <saravanak@google.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Nuno Sa <nuno.sa@analog.com>,
	Rob Herring <robh@kernel.org>
Subject: [PATCH 6.8 229/273] of: dynamic: Synchronize of_changeset_destroy() with the devlink removals
Date: Mon,  8 Apr 2024 14:58:24 +0200
Message-ID: <20240408125316.530414429@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herve Codina <herve.codina@bootlin.com>

commit 8917e7385346bd6584890ed362985c219fe6ae84 upstream.

In the following sequence:
  1) of_platform_depopulate()
  2) of_overlay_remove()

During the step 1, devices are destroyed and devlinks are removed.
During the step 2, OF nodes are destroyed but
__of_changeset_entry_destroy() can raise warnings related to missing
of_node_put():
  ERROR: memory leak, expected refcount 1 instead of 2 ...

Indeed, during the devlink removals performed at step 1, the removal
itself releasing the device (and the attached of_node) is done by a job
queued in a workqueue and so, it is done asynchronously with respect to
function calls.
When the warning is present, of_node_put() will be called but wrongly
too late from the workqueue job.

In order to be sure that any ongoing devlink removals are done before
the of_node destruction, synchronize the of_changeset_destroy() with the
devlink removals.

Fixes: 80dd33cf72d1 ("drivers: base: Fix device link removal")
Cc: stable@vger.kernel.org
Signed-off-by: Herve Codina <herve.codina@bootlin.com>
Reviewed-by: Saravana Kannan <saravanak@google.com>
Tested-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Reviewed-by: Nuno Sa <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20240325152140.198219-3-herve.codina@bootlin.com
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/dynamic.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/of/dynamic.c
+++ b/drivers/of/dynamic.c
@@ -9,6 +9,7 @@
 
 #define pr_fmt(fmt)	"OF: " fmt
 
+#include <linux/device.h>
 #include <linux/of.h>
 #include <linux/spinlock.h>
 #include <linux/slab.h>
@@ -667,6 +668,17 @@ void of_changeset_destroy(struct of_chan
 {
 	struct of_changeset_entry *ce, *cen;
 
+	/*
+	 * When a device is deleted, the device links to/from it are also queued
+	 * for deletion. Until these device links are freed, the devices
+	 * themselves aren't freed. If the device being deleted is due to an
+	 * overlay change, this device might be holding a reference to a device
+	 * node that will be freed. So, wait until all already pending device
+	 * links are deleted before freeing a device node. This ensures we don't
+	 * free any device node that has a non-zero reference count.
+	 */
+	device_link_wait_removal();
+
 	list_for_each_entry_safe_reverse(ce, cen, &ocs->entries, node)
 		__of_changeset_entry_destroy(ce);
 }


