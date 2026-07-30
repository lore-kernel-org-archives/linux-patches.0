Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F74C442FC9;
	Thu, 30 Jul 2026 15:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426920; cv=none; b=AWd3KKGog+jTvb/FGn00alHW7PsDpNZ02QQMCC/V3L0Bw5t8lzBm/sevpPjEXRgKrFhIAG415rDnUf9wjXPkc2Pxy/eK9lvQLd7vfa746FE8EJAxFe9qKEJtLOlF3T4FavEK8wJv8iHCdtvg/Mu2kB20B0yqlYxa0GZ4+Q2atB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426920; c=relaxed/simple;
	bh=popsH/O191DVnctX5zY2KLifW1TxrT41YT+laUorRWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sCNTHaCuxkltoGX0CWTBYassD9neMgAkvm1rEiY+9TVeegtLafzmZSnJNOXJQbC1o9QIbs+03xjff/5+lg5v4s7TbbM6oqmEWI6DLdQpiaoyfQWAj/QfvHgsZfGRH77D9LHF8V/XkxeOyhKQi7RxdspBUnIZe7COZXm3gtSBcrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EV4hOJBL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EV4hOJBL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACFA11F000E9;
	Thu, 30 Jul 2026 15:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426919;
	bh=cnRRs7oMlOV2vC9mqkyS3kPjMRDq1WGraFfrIbtg0i0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EV4hOJBLZ/Zj8GcXzCeGZYlv33AWGuVb2K2vA4GtXlIBrqt/rMd4sHn0+1vhh9m9n
	 +j5zjxinDnS8EZ40ERLzQqREjHjoMFh4UoAL1SWbPmT2ZHrNtmChhsrd+5WCUHt3qC
	 O5FCBfR8UaqYznF6rnxKPLJ4cWIkvu8dsoMTM3zQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Dave Airlie <airlied@redhat.com>,
	intel-xe@lists.freedesktop.org,
	Peter Senna Tschudin <peter.senna@linux.intel.com>,
	Koen Koning <koen.koning@linux.intel.com>
Subject: [PATCH 6.12 588/602] gpu: Fix uninitialized buddy for built-in drivers
Date: Thu, 30 Jul 2026 16:16:20 +0200
Message-ID: <20260730141448.411050188@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2,7 +2,8 @@
 # drm/tegra depends on host1x, so if both drivers are built-in care must be
 # taken to initialize them in the correct order. Link order is the only way
 # to ensure this currently.
+# Similarly, buddy must come first since it is used by other drivers.
+obj-$(CONFIG_GPU_BUDDY)	+= buddy.o
 obj-y			+= host1x/ drm/ vga/ tests/
 obj-$(CONFIG_IMX_IPUV3_CORE)	+= ipu-v3/
 obj-$(CONFIG_TRACE_GPU_MEM)		+= trace/
-obj-$(CONFIG_GPU_BUDDY)		+= buddy.o


