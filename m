Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81C47364049;
	Sat, 12 Sep 2026 07:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198619; cv=none; b=dxgC2ANk0OWWFVypB9GUdt04TubVrGAsg3+c51Hzh3pPOd9CnkAE5K74v/WQkpFoLAwYxYExY2hDPWpwPzwPqhN1vfd2LN/7mKHGFp7P0Ik6JuzPZ/62I+HJdAyDTrb97Dpu+Pr/iE6XixXgjkhve9R4AMCrw2eZHAgVOIJlWIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198619; c=relaxed/simple;
	bh=NAlvKx/opG4X6q+2IHri7cXMIZJUzmIXzirqVWQE/es=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NVrJiwRUGmaKrNtZpaA5tjyAez+6Yuy8AtNDQYQWE2jfTaJwp5OX/WvtGCKDP8Go7QiuN5h1rN1bHamUAgjpYp4EmGHP88GoBu5IurvrsFF4ZvElI741kgf0x7HQovd7DGzETXvKSpYFNndFVYGXUWFW4utnrBsKKKeoZAyGhtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gGpeLWXl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gGpeLWXl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BCF11F000FF;
	Sat, 12 Sep 2026 07:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198618;
	bh=DUcZ82OUpnYdwbuAaLGhhCNFdrxqiwGl+Vb0eCMxlk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gGpeLWXlAbkpbRVgyjRfU3x2RPmIXJUJbeYVuAsPSdEDIx+MAUb4l+Eif/3+9Vclp
	 Jb2HlbH+1vXzpUB8Tr8YgPF4JQUp2y+62BuyIYIckX7uZxkeLbx+6Evs9RSMNm2V6F
	 j2/5FERmRVbC7JDJPW1/iyhZt9n5Lys40k09ZUbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Cheng <icheng@nvidia.com>,
	John Groves <john@groves.net>,
	Alison Schofield <alison.schofield@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0419/1815] dax/fsdev: clear pgmap ops and owner on unbind
Date: Sat, 12 Sep 2026 08:36:09 +0200
Message-ID: <20260912065658.731818142@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Groves <John@Groves.net>

[ Upstream commit f48884ac31b6bfc99f36b3f207b8c0cbe5d54bd7 ]

fsdev_dax_probe() sets pgmap->ops = &fsdev_pagemap_ops and
pgmap->owner = dev_dax, but nothing ever clears them. For a dynamic
device the pgmap is devm-allocated and freed on unbind, so this is
harmless. For a static device the pgmap is the shared, long-lived one
owned by the dax bus (kill_dev_dax() only NULLs dev_dax->pgmap for the
non-static case), and device.c's probe sets only pgmap->type, never
clearing ops/owner.

So after fsdev unbinds a static device the stale fsdev_pagemap_ops
survives on the shared pgmap. If the device is then rebound to
device_dax (MEMORY_DEVICE_GENERIC, which installs no ->memory_failure),
or the fsdev_dax module is unloaded, a subsequent memory_failure on that
pgmap dispatches through the stale -- and possibly freed -- handler.

Register a devm action that clears pgmap->ops and pgmap->owner on unbind,
symmetric with setting them at probe, so the pgmap carries no fsdev state
once fsdev is detached.

Suggested-by: Richard Cheng <icheng@nvidia.com>
Fixes: d5406bd458b0a ("dax: add fsdev.c driver for fs-dax on character dax")
Signed-off-by: John Groves <john@groves.net>
Reviewed-by: Richard Cheng <icheng@nvidia.com>
Link: https://patch.msgid.link/0100019ecc094b6e-fc163bde-0396-4a33-909f-fb88e740be27-000000@email.amazonses.com
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dax/fsdev.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/dax/fsdev.c b/drivers/dax/fsdev.c
index 0fd5e1293d725..68a4369562f70 100644
--- a/drivers/dax/fsdev.c
+++ b/drivers/dax/fsdev.c
@@ -127,6 +127,23 @@ static void fsdev_clear_ops(void *data)
 	dax_set_ops(dev_dax->dax_dev, NULL);
 }
 
+static void fsdev_clear_pgmap_ops(void *data)
+{
+	struct dev_pagemap *pgmap = data;
+
+	/*
+	 * fsdev installs pgmap->ops and ->owner at probe. For a static device
+	 * the pgmap is shared and long-lived (owned by the dax bus), so
+	 * leaving fsdev's ops behind on unbind would let a later
+	 * memory_failure -- after rebind to another driver, or after this
+	 * module is unloaded -- dispatch through a stale or freed
+	 * ->memory_failure handler. Clear them so the pgmap carries no fsdev
+	 * state once we are unbound.
+	 */
+	pgmap->ops = NULL;
+	pgmap->owner = NULL;
+}
+
 /*
  * Page map operations for FS-DAX mode
  * Similar to fsdax_pagemap_ops in drivers/nvdimm/pmem.c
@@ -306,6 +323,11 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)
 	if (IS_ERR(addr))
 		return PTR_ERR(addr);
 
+	/* Drop fsdev's pgmap->ops/owner on unbind so no stale ops survive. */
+	rc = devm_add_action_or_reset(dev, fsdev_clear_pgmap_ops, pgmap);
+	if (rc)
+		return rc;
+
 	/*
 	 * Clear any stale compound folio state left over from a previous
 	 * driver (e.g., device_dax with vmemmap_shift). Also register this
-- 
2.53.0



