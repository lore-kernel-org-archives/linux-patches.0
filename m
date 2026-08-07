Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A9AD386C37;
	Fri,  7 Aug 2026 14:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114485; cv=none; b=LJUBLAzdDJ2CABOWAm8tAGf2hBGI9L1TpG6pj79eEzh6GjMvLPMdvc6iMLUAmQZOKs5zXk2bevKVzBhsFi6eWLoKD9xjjYJQv0sreO+TNNl8ExZ795dXZ9Kkf7Ij3hYDqpFKlthfVQFrye0enJQd+Lpk4oijMMeZiePU5WtKbzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114485; c=relaxed/simple;
	bh=7JqmFs9BKZdoR6j1JPPj8VGXkpM8tZL2g97d2Vo8kWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QlTS/+Q9hsO6Yj0ZlIOFu9g2ZW4gbJ4fYmsMOD/PVlp0/yjOcP7tbPN62b+z9QhyXfZJAnZc0/5TNjRdKvjvheThYYyi3oR2daUd7qcQ3u3mBiS8z9G5cd30K9deu3tYZSdRXSxSVhtQG4VGJjI2Lxtui8Lyv5vgC8OSUIfRuVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G7UbHtkR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G7UbHtkR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67B6E1F00A3E;
	Fri,  7 Aug 2026 14:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114478;
	bh=qpkoQVk4muYCLBIm0NLwq9otfOQpMY/jIaBlnxjK5z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G7UbHtkRUHhjesBb4ntQ/5tViZorwweCWr57NMQ+Tfw7bem46pRm2ejEqnpEQ+zXI
	 NooWl4HGEc6rJnHXgytFDLTndPZWgjyt35lF1kI5FZjyOUSNUD3aL8BRb6A5TJcw+D
	 CjoW6m30O5r9JSWBTXYvydH6jtqSm0td0lunPoWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ashutosh Dixit <ashutosh.dixit@intel.com>,
	Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 279/337] drm/xe/rtp: Generalize whitelist_apply_to_hwe
Date: Fri,  7 Aug 2026 16:38:02 +0200
Message-ID: <20260807143424.586562664@linuxfoundation.org>
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

[ Upstream commit 4fe2844b0f0c7cdc45ca4c4c62ca56b7f26c514c ]

Generalize whitelist_apply_to_hwe to construct both non-OA and OA
whitelist nonpriv registers.

Fixes: 828a8eaf37c3 ("drm/xe/oa: Add MMIO trigger support")
Cc: stable@vger.kernel.org # v6.12+
Signed-off-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Reviewed-by: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Link: https://patch.msgid.link/20260615224227.34880-5-ashutosh.dixit@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_reg_whitelist.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_reg_whitelist.c b/drivers/gpu/drm/xe/xe_reg_whitelist.c
index 12d12d8f0e99c..47beb473f6a29 100644
--- a/drivers/gpu/drm/xe/xe_reg_whitelist.c
+++ b/drivers/gpu/drm/xe/xe_reg_whitelist.c
@@ -94,9 +94,10 @@ static const struct xe_rtp_entry_sr oa_whitelist[] = {
 	{}
 };
 
-static int whitelist_apply_to_hwe(struct xe_hw_engine *hwe)
+static int whitelist_apply_to_hwe(struct xe_hw_engine *hwe, struct xe_reg_sr *in,
+				  struct xe_reg_sr *out, int first_slot)
 {
-	struct xe_reg_sr *sr = &hwe->reg_whitelist;
+	struct xe_reg_sr *sr = in;
 	struct xe_reg_sr_entry *entry;
 	struct drm_printer p;
 	unsigned long reg;
@@ -105,7 +106,7 @@ static int whitelist_apply_to_hwe(struct xe_hw_engine *hwe)
 	xe_gt_dbg(hwe->gt, "Add %s whitelist to engine\n", sr->name);
 	p = xe_gt_dbg_printer(hwe->gt);
 
-	slot = 0;
+	slot = first_slot;
 	xa_for_each(&sr->xa, reg, entry) {
 		struct xe_reg_sr_entry hwe_entry = {
 			.reg = RING_FORCE_TO_NONPRIV(hwe->mmio_base, slot),
@@ -122,7 +123,7 @@ static int whitelist_apply_to_hwe(struct xe_hw_engine *hwe)
 		}
 
 		xe_reg_whitelist_print_entry(&p, 0, reg, entry);
-		xe_reg_sr_add(&hwe->reg_sr, &hwe_entry, hwe->gt);
+		xe_reg_sr_add(out, &hwe_entry, hwe->gt);
 
 		slot++;
 	}
@@ -144,7 +145,7 @@ void xe_reg_whitelist_process_engine(struct xe_hw_engine *hwe)
 	int first_oa_slot;
 
 	xe_rtp_process_to_sr(&ctx, register_whitelist, &hwe->reg_whitelist);
-	first_oa_slot = whitelist_apply_to_hwe(hwe);
+	first_oa_slot = whitelist_apply_to_hwe(hwe, &hwe->reg_whitelist, &hwe->reg_sr, 0);
 
 	xe_rtp_process_to_sr(&ctx, oa_whitelist, &hwe->oa_whitelist);
 }
-- 
2.53.0



