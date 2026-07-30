Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B998133438F;
	Thu, 30 Jul 2026 15:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425250; cv=none; b=dmCzh8Xf7viW7tGrlKe/LLmE93wWDvaGEJL6oQ/r2HJbe7Il/cZtWdbdHLkXVQL4HK7gSTFtUq1/3PAQcE8XM5eennszfUe38Hjrsw1KMYmxVwzAC17v7fagbTQg32pL3qUoR4gT7eKDBODWwH3+d4JdqICUigqjWmy3QBIEdQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425250; c=relaxed/simple;
	bh=JDMC0affj3x1RBdIZuUsM7vwhFleJsl6ujTj8/V+4xA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k6GnXVbRD9lmXkHdSmUE1QWBTo6GWC8sLqPYmCfwgypytHtZFQ2W0PCPVKglANwS2tS0oX7bFe3WRSZkTGG9KArTTeR54suE3M85PMjNm3UXN7KbXU1rsOVNhtq+tzv0xGpm16H1OQAi3wEq+yHuMLDL/JuJXa7cEh90Hs9TJYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wQIzRx5N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wQIzRx5N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 213761F00A3A;
	Thu, 30 Jul 2026 15:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425249;
	bh=CUTO3i5sBX9amRiISoUAELmWf7EpbgfY4QAjreas2NY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wQIzRx5NHZid7ET+9OGK15aMedPo9lfAM7EF9i92vVRlylUWHDuCehjR6JSxsnORX
	 3R00nWz5p75wEmjtNxNkhMUbwrF117VDpbCf2f1iIgCSZfHwoEidOaXdcwWZYDvwnt
	 lTMqB9BDoGXQqs9pjjC81aeVl/Q6wpxSZJ5sM5G4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Dave Airlie <airlied@redhat.com>,
	intel-xe@lists.freedesktop.org,
	Peter Senna Tschudin <peter.senna@linux.intel.com>,
	Koen Koning <koen.koning@linux.intel.com>
Subject: [PATCH 6.18 674/675] gpu: Fix uninitialized buddy for built-in drivers
Date: Thu, 30 Jul 2026 16:16:44 +0200
Message-ID: <20260730141459.487176866@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Koen Koning <koen.koning@linux.intel.com>

commit cc27314c67516c138ee3829197d1c3b998e29fae upstream.

Move buddy to the start of the link order, so its __init runs before any
other built-in drivers that may depend on it. Otherwise, a built-in
driver that tries to use the buddy allocator will run into a kernel NULL
pointer dereference because slab_blocks is uninitialized.

Specifically, this fixes drm/xe (as built-in) running into a kernel
panic during boot, because it uses buddy during device probe.

Fixes: ba110db8e1bc ("gpu: Move DRM buddy allocator one level up (part two)")
Cc: Joel Fernandes <joelagnelf@nvidia.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: intel-xe@lists.freedesktop.org
Reviewed-by: Dave Airlie <airlied@redhat.com>
Tested-by: Peter Senna Tschudin <peter.senna@linux.intel.com>
Signed-off-by: Koen Koning <koen.koning@linux.intel.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Link: https://patch.msgid.link/20260213152047.179628-1-koen.koning@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/Makefile |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/Makefile
+++ b/drivers/gpu/Makefile
@@ -2,8 +2,9 @@
 # drm/tegra depends on host1x, so if both drivers are built-in care must be
 # taken to initialize them in the correct order. Link order is the only way
 # to ensure this currently.
+# Similarly, buddy must come first since it is used by other drivers.
+obj-$(CONFIG_GPU_BUDDY)	+= buddy.o
 obj-y			+= host1x/ drm/ vga/ tests/
 obj-$(CONFIG_IMX_IPUV3_CORE)	+= ipu-v3/
 obj-$(CONFIG_TRACE_GPU_MEM)		+= trace/
 obj-$(CONFIG_NOVA_CORE)		+= nova-core/
-obj-$(CONFIG_GPU_BUDDY)		+= buddy.o


