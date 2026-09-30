Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C12534D7D4C;
	Wed, 30 Sep 2026 16:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786876; cv=none; b=GTc26IRyrtWstOKeAAaB/GAqeCwWpFOQrh2fKJLy+WdQUucLQAXqSG3QX6y/b/BVKR0tUmgiPbzeL6twDA27C+YOPU7ign/WDVVWvPc9OjhsYPII4+klhHsrN9MUGCNfOpxarq5qVq6/BIzB7rUW/uo1isJPrb9sO37Gneaqc94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786876; c=relaxed/simple;
	bh=z0HaXqGQbYjyUHoQvtXWuF+WEMwQXSGUGwIsg+26aJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fRSOLiAGa3JSLbJ61KJfEac0lMt2a6mnuV0LFhqAUgNBh9G5N38ZCNi1hZud5UPz3juM5SA09JUvQXOrpeBknSW1b9NTOiejZEWVYKgCU90IP3FduEu9DcX9SowuTFqOLAhW5dkpV4PkMT/UB9EUYoWwPho9osbxn/FhsF2oAD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IE4id8fP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IE4id8fP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A1A61F000FF;
	Wed, 30 Sep 2026 16:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786875;
	bh=b/6JVAPQof05vKqwHvzkQcxHolsnt/OUVYX9Ln7p8E4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IE4id8fPjt7kWklAxaoVBWOkzWGZhPP9sO0hq8jFSgDvglJ9FwEnN5TjZcmfdM8M4
	 RH+/VvueqbcXREiO3QutXu6R0A4JpXxzl50snJ3knt4/e2ky4Y93d2vcK9hApx6b46
	 0gsj/2TAVhvCZ8Fsjp3v/ku7jN5kzn57084+IEtk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sarah Emery <sarah.emery@canonical.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 033/457] pinctrl: generic: serialise pinctrl_generic_dt_node_to_map()
Date: Wed, 30 Sep 2026 17:22:18 +0200
Message-ID: <20260930152346.748260038@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

From: Sarah Emery <sarah.emery@canonical.com>

[ Upstream commit 51ae99659469edba2e83931efa26b77d36ca02c2 ]

pinctrl_generic_add_group() documents that the caller must take care of
locking, and pinmux_generic_add_function() needs it too, but
pinctrl_generic_dt_node_to_map() calls them without holding
pctldev->mutex, and the core caller in create_pinctrl() does not take it
either.

The driver core calls pinctrl_bind_pins() before probing a device, so
two devices that reference the same pin controller can run
pinctrl_generic_dt_node_to_map() on one pctldev at the same time.

Both `add` functions take the new selector from pctldev->num_groups or
pctldev->num_functions, and radix_tree_insert() at that index.
Two racing callers can read the same selector before either
has inserted, so the second insert collides and fails:

  k1-pinctrl d401e000.pinctrl:
  error -EEXIST: error adding function pcie2-0-cfg
  k1-pinctrl d401e000.pinctrl:
  does not have pin group pcie0-0-cfg.pcie0-0-pins

leaving one consumer without its pin configuration.

This was hit on a SpacemiT K3 board, where PCIe devices probe in parallel
against the single shared pin controller.

Take pctldev->mutex across the whole function, so that the groups and the
function referring are in a single critical section.

Fixes: 43722575e5cd ("pinctrl: add generic functions + pins mapper")
Signed-off-by: Sarah Emery <sarah.emery@canonical.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-generic.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-generic.c b/drivers/pinctrl/pinctrl-generic.c
index fd6bdb74028aa..4277c87485135 100644
--- a/drivers/pinctrl/pinctrl-generic.c
+++ b/drivers/pinctrl/pinctrl-generic.c
@@ -3,8 +3,10 @@
 #define pr_fmt(fmt) "generic pinconfig core: " fmt
 
 #include <linux/array_size.h>
+#include <linux/cleanup.h>
 #include <linux/device.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/of.h>
 #include <linux/slab.h>
 
@@ -196,6 +198,8 @@ static int pinctrl_generic_dt_node_to_map(struct pinctrl_dev *pctldev,
 	int ngroups = 0;
 	int ret;
 
+	guard(mutex)(&pctldev->mutex);
+
 	*maps = NULL;
 	*num_maps = 0;
 
-- 
2.53.0



