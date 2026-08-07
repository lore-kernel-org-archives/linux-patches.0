Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DEC1477292;
	Fri,  7 Aug 2026 15:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117730; cv=none; b=kzUNVJfoAq9Jp8A2w/rHC5UVxkub9BRyMZ8tPcfvdEQ39eQ3C1k0xTO8bm/j8t7J2cCVjZQpoED3e3s7tiYr0+IEPP23KXjQtZR1KWM1Z0VQS2A2IjQBSjQkGSqmtHNIbaza3xrxB5xCg+5odZotrGhqfuCvy+LfVv0JY8agWDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117730; c=relaxed/simple;
	bh=uMX9douS0Kpi7TQC8wXZgBFjOyenQN+swlJtMAHfUoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ukxGHgVYKUU/ge3N+8RaAFIAwGwv0zhebj2/ZzXKtfMN/D8ZSMu5hr+GikaD/40eCVP5y4Fu8jB4pwXdtqdN50jUfNJYB5+m/ltUqFeVUCYNhbTylLDwCiHCbmOu0XED5u0krrByGtBMZhNiPdGLuJ5KURASpl6JjahBDtHO9BM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=plwYjy4Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="plwYjy4Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 730F91F00A3A;
	Fri,  7 Aug 2026 15:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117729;
	bh=zofGUY7lbnXx2hLEVsTLhWAqgDu4vcjjkqkplcRromw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=plwYjy4Y/fjNfcAGgLnqQ7iQZKjz3uX31i48/2dcl9vbtZjfBFzWeqd0U7xXEou4e
	 +OoVVg6rTzPMrIo6Oe1HCNDAhbSpUNAv4zvFSw+P5C1hnDJIahlxvCHllQ/ezUj1X6
	 qdWoDl1/whJxEgCef24s/VYr0VUr58nxdWA1SnJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ashutosh Dixit <ashutosh.dixit@intel.com>,
	Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 421/438] drm/xe/rtp: Save OA nonpriv registers to register save/restore lists
Date: Fri,  7 Aug 2026 16:40:17 +0200
Message-ID: <20260807143436.939650360@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ashutosh Dixit <ashutosh.dixit@intel.com>

[ Upstream commit a19a83721a28ccaddace846da70da5c53d7dd052 ]

Now we can save OA whitelisting nonpriv registers to register save/restore
lists. OA nonpriv registers are saved to both hwe->oa_sr as well as
hwe->reg_sr.

During probe, resume and gt-reset flows KMD will apply hwe->reg_sr,
ensuring OA registers are de-whitelisted after these events. For
engine-reset, hwe->reg_sr is registered with GuC and GuC will apply these
registers, ensuring OA registers are de-whitelisted after engine resets.

hwe->oa_sr is used for whitelisting or de-whitelisting OA registers during
OA operation, by toggling the 'deny' bit on oa stream open/close.

Fixes: 828a8eaf37c3 ("drm/xe/oa: Add MMIO trigger support")
Cc: stable@vger.kernel.org # v6.12+
Signed-off-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Reviewed-by: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Link: https://patch.msgid.link/20260615224227.34880-6-ashutosh.dixit@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_reg_whitelist.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_reg_whitelist.c b/drivers/gpu/drm/xe/xe_reg_whitelist.c
index 1a7d69ef4fe82..dbaa387a35613 100644
--- a/drivers/gpu/drm/xe/xe_reg_whitelist.c
+++ b/drivers/gpu/drm/xe/xe_reg_whitelist.c
@@ -203,6 +203,17 @@ void xe_reg_whitelist_process_engine(struct xe_hw_engine *hwe)
 
 	xe_rtp_process_to_sr(&ctx, oa_whitelist, ARRAY_SIZE(oa_whitelist),
 			     &hwe->oa_whitelist, false);
+	/*
+	 * Save oa nonpriv registers to hwe->oa_sr, from which oa registers are whitelisted
+	 * or de-whitelisted, by toggling the 'deny' bit on oa stream open/close
+	 */
+	whitelist_apply_to_hwe(hwe, &hwe->oa_whitelist, &hwe->oa_sr, first_oa_slot);
+
+	/*
+	 * Also save oa nonpriv registers to hwe->reg_sr, to ensure oa registers are not
+	 * whitelisted by default after probe, gt reset, resume and engine reset
+	 */
+	whitelist_apply_to_hwe(hwe, &hwe->oa_whitelist, &hwe->reg_sr, first_oa_slot);
 }
 
 /**
-- 
2.53.0



