Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8418638AC72;
	Fri,  7 Aug 2026 14:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114486; cv=none; b=ItzFjcBo22GTA+lCBV95GNpa3sqeVzj+cFC6CoeOeDhvenFNluP8qa0hGekw2LZ8zjDJNVhk3uDaMvlt3kH+peCYasKt2A/YC0LsAYn779tzlmdRHgPHBqQJjlWi64QnPl4sCb9C64PF9typouNTVuKkCP0A8zLAJ9jBcoB08DY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114486; c=relaxed/simple;
	bh=AG8y1gkjnU9jg7f3eLFVFvalIFBTdklzsYSqG4iNhBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gKAVs7hBqUBpNenDeB7dqE2A7bbvbXcEtZhP1yBhO4cspDWqnEgegmpNm+pHuhivQcJRWs6CXABVhkAAF1IP3cYRRj1WNPayLeJx8mP2II1Gx3Ex/bEHDMlUKpcX7qif9UVwfL0faqHgbEs8hfEVO3b4uf1ChBCCy758EkMiHJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VQAwhEIo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VQAwhEIo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AE441F000E9;
	Fri,  7 Aug 2026 14:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114481;
	bh=fLmouWaxUtJYBwQwRmL7UoBU+U/tVpT5xeXrRTeSKhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VQAwhEIoVL2fKiKepcMXsXOy3quUo2utPiZxGe5niMMH/O06oDTrlM05iz5khr6U3
	 EboN69YQeRrfdzZGFiLYrhHP/FBuUOik6eeAyxCbwgV+rlIhXRueyL5DHJsZQzSTL9
	 Sd/ydmjITg5XkRBWGkPjMNGVDZ6cuGIQ3JRWQUTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ashutosh Dixit <ashutosh.dixit@intel.com>,
	Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 280/337] drm/xe/rtp: Save OA nonpriv registers to register save/restore lists
Date: Fri,  7 Aug 2026 16:38:03 +0200
Message-ID: <20260807143424.607129524@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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
 drivers/gpu/drm/xe/xe_reg_whitelist.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_reg_whitelist.c b/drivers/gpu/drm/xe/xe_reg_whitelist.c
index 47beb473f6a29..a3a45f470faa1 100644
--- a/drivers/gpu/drm/xe/xe_reg_whitelist.c
+++ b/drivers/gpu/drm/xe/xe_reg_whitelist.c
@@ -148,6 +148,18 @@ void xe_reg_whitelist_process_engine(struct xe_hw_engine *hwe)
 	first_oa_slot = whitelist_apply_to_hwe(hwe, &hwe->reg_whitelist, &hwe->reg_sr, 0);
 
 	xe_rtp_process_to_sr(&ctx, oa_whitelist, &hwe->oa_whitelist);
+
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



