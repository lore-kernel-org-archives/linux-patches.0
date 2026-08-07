Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FD48378D76;
	Fri,  7 Aug 2026 14:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114481; cv=none; b=L1tBsi3QSb1hFCZU5+WKUu9dDtVkwa8i8RDSheh2GA70DEKSEQAJvf/LVcgHRPxGHoO1cCHsasXTzWsbXHlhLL83Hm0/oa8L2GiGI9BN0N0lOKGNzJc5g4DwFhPI/7N24HRcgentTrwZWM/LuumxNZoqX+sL429y/gwq6S47sKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114481; c=relaxed/simple;
	bh=C9ksAqL9n4IKDueHH0Li8dGhf99ByNnFPtH3cepSvJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qog/e0rIqeIAEePhrVOAKAa7HyDFJo9W8uVQBo1uk27UNtfPSQBtagmalKBz84TIWGTpjqE8wxHXJLbmrTMM0F8nFW2vrV+pFBhL2cTybK8OaiRXp0KIoqmCbcQXDQWzT7XiAogWqDct7nfCuwZsCHPvRCLKvRUX8aC/P+aU4zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yH5yU6qX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yH5yU6qX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95EF31F000E9;
	Fri,  7 Aug 2026 14:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114476;
	bh=An+uwjCt/zlPqF5dhFR2sm4j0vDIjmsT6GaZsFcoXXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yH5yU6qXRpOi1YheWRo3pP8T4IbuHV/1tSFeKqTECm8Wif40UhyUlbDjH80xdTtOC
	 nWME6CE6pvATDpICPbREQePQp9XgIkA7AN3GF1qxiYeWvQg/XrvYuM0aWRjysNkoIb
	 E1JvwKgWVkF5gSLxDwUzSkXdFuzx4oZSyb+KG+bE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ashutosh Dixit <ashutosh.dixit@intel.com>,
	Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 278/337] drm/xe/rtp: Keep track of non-OA nonpriv slots
Date: Fri,  7 Aug 2026 16:38:01 +0200
Message-ID: <20260807143424.564939650@linuxfoundation.org>
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

[ Upstream commit 60d49ea28bb190a640bd8dc3f4c946e0811a948c ]

In order to dynamically whitelist/dewhitelist OA registers on OA stream
open/close, we need to keep track of nonpriv slots occupied by non-OA
register whitelists.

Fixes: 828a8eaf37c3 ("drm/xe/oa: Add MMIO trigger support")
Cc: stable@vger.kernel.org # v6.12+
Signed-off-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Reviewed-by: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Link: https://patch.msgid.link/20260615224227.34880-4-ashutosh.dixit@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_reg_whitelist.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_reg_whitelist.c b/drivers/gpu/drm/xe/xe_reg_whitelist.c
index d82b14f8d0716..12d12d8f0e99c 100644
--- a/drivers/gpu/drm/xe/xe_reg_whitelist.c
+++ b/drivers/gpu/drm/xe/xe_reg_whitelist.c
@@ -94,7 +94,7 @@ static const struct xe_rtp_entry_sr oa_whitelist[] = {
 	{}
 };
 
-static void whitelist_apply_to_hwe(struct xe_hw_engine *hwe)
+static int whitelist_apply_to_hwe(struct xe_hw_engine *hwe)
 {
 	struct xe_reg_sr *sr = &hwe->reg_whitelist;
 	struct xe_reg_sr_entry *entry;
@@ -126,6 +126,8 @@ static void whitelist_apply_to_hwe(struct xe_hw_engine *hwe)
 
 		slot++;
 	}
+
+	return slot;
 }
 
 /**
@@ -139,9 +141,10 @@ static void whitelist_apply_to_hwe(struct xe_hw_engine *hwe)
 void xe_reg_whitelist_process_engine(struct xe_hw_engine *hwe)
 {
 	struct xe_rtp_process_ctx ctx = XE_RTP_PROCESS_CTX_INITIALIZER(hwe);
+	int first_oa_slot;
 
 	xe_rtp_process_to_sr(&ctx, register_whitelist, &hwe->reg_whitelist);
-	whitelist_apply_to_hwe(hwe);
+	first_oa_slot = whitelist_apply_to_hwe(hwe);
 
 	xe_rtp_process_to_sr(&ctx, oa_whitelist, &hwe->oa_whitelist);
 }
-- 
2.53.0



