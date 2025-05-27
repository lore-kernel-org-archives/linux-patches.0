Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD4942A9B;
	Tue, 27 May 2025 17:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368169; cv=none; b=JTnepgck6zGaFQdlc+KbJT40s9qM2XK7QRTv6Bqwy/0p1L1rCDmkD0B8+42/28fIHFW3ePcZiZYCKzexJrW4G1i1x+GFG44ARiceO+1dtS2tSpnyrreJD1pTqDGPRBLi/pLGTyz/1CwZiAtD508KMahIz3a1fPwG0rNXmqmk1hA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368169; c=relaxed/simple;
	bh=NUYE7fL0DuwP/cm8Z45U2691IwePRZsGY+1nT7A4v0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sfDGy1pNDiU3PN30Tgp7a3DfYehGybtC7X95CPt09J7QRQoXFMBwXeVkTj01Htrb5IF7hDKlAeVXfM7vOTKi9kL1Z6CyevaVq1LE8pjvo1B3qcrNj+gUCUpfnhgE8MOs0p6z5cZh5cwrnQfGwueuBdEVZb/L8zgTM6ETXF1tSVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yDD6HQo0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yDD6HQo0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD509C4CEE9;
	Tue, 27 May 2025 17:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368169;
	bh=NUYE7fL0DuwP/cm8Z45U2691IwePRZsGY+1nT7A4v0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yDD6HQo0ma5dqTcnEOlIFM+KiYgzh0RgoaCpFbu5N+fZJF96FR0tFlbHNwKFzmQR6
	 g4xdv5tKgJtOxsU71ZW68hV9iYDDI55v8H76W5wxrclMgz0ThePkhKBrSt7eq3ATxb
	 T00tPJN4KWvNzSEuN89BEJHHmGhnygdErzgBtJoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	=?UTF-8?q?Piotr=20Pi=C3=B3rkowski?= <piotr.piorkowski@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 621/783] drm/xe/vf: Perform early GT MMIO initialization to read GMDID
Date: Tue, 27 May 2025 18:26:58 +0200
Message-ID: <20250527162538.442301524@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Wajdeczko <michal.wajdeczko@intel.com>

[ Upstream commit 13265fe7426ec9ba5aa86baab913417ca361e8a4 ]

VFs need to communicate with the GuC to obtain the GMDID value
and existing GuC functions used for that assume that the GT has
it's MMIO members already setup. However, due to recent refactoring
the gt->mmio is initialized later, and any attempt by the VF to use
xe_mmio_read|write() from GuC functions will lead to NPD crash due
to unset MMIO register address:

[] xe 0000:00:02.1: [drm] Running in SR-IOV VF mode
[] xe 0000:00:02.1: [drm] GT0: sending H2G MMIO 0x5507
[] BUG: unable to handle page fault for address: 0000000000190240

Since we are already tweaking the id and type of the primary GT to
mimic it's a Media GT before initializing the GuC communication,
we can also call xe_gt_mmio_init() to perform early setup of the
gt->mmio which will make those GuC functions work again.

Signed-off-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
Cc: Matt Roper <matthew.d.roper@intel.com>
Cc: Piotr Piórkowski <piotr.piorkowski@intel.com>
Reviewed-by: Piotr Piórkowski <piotr.piorkowski@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250114211347.1083-1-michal.wajdeczko@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/xe/xe_pci.c b/drivers/gpu/drm/xe/xe_pci.c
index 9b8813a518d72..d92b2e5885b98 100644
--- a/drivers/gpu/drm/xe/xe_pci.c
+++ b/drivers/gpu/drm/xe/xe_pci.c
@@ -490,6 +490,7 @@ static void read_gmdid(struct xe_device *xe, enum xe_gmdid_type type, u32 *ver,
 			gt->info.type = XE_GT_TYPE_MAIN;
 		}
 
+		xe_gt_mmio_init(gt);
 		xe_guc_comm_init_early(&gt->uc.guc);
 
 		/* Don't bother with GMDID if failed to negotiate the GuC ABI */
-- 
2.39.5



