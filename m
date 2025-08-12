Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61B252EAB97;
	Tue, 12 Aug 2025 18:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023433; cv=none; b=Bg0uOz45h67TS36B21dO9ha7GHcNOG8WRZW1OSwAL6YsUT3ZaF0JoK6v7YM5hylS5pUxzI68YJeskHzRh567GsWZ7MQm2BaH3vLP7l3eX7Uv81JY7iIcg0A0nHjUmI8JV61PcttYNk8gT1bvkZ26le1sQtWU5qMw0r86H5rHS40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023433; c=relaxed/simple;
	bh=vtBo/Jyxv8tJwML59EFapwx2VOd/I73lIte98MWWfnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HdLFDwCea6KCPKOit1annE8xN3/JLfDba1meFPsusTeXh9dl6ZGOKsVjch++G+wzluXvUQv5LxdxyCsLwvB/4kMdtk8JhHvMC6HqXoLQw7ybwAX13HKvgfT4vXogsfHOORzC+hxMWnj54DiSgPV3j1ky7k5YGU7DCswJQXh/xeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J6+vXzYu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J6+vXzYu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FB8FC4CEF0;
	Tue, 12 Aug 2025 18:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023433;
	bh=vtBo/Jyxv8tJwML59EFapwx2VOd/I73lIte98MWWfnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J6+vXzYuwmjRoEeLQhpIkntKrBHPmueA4Pou6yILZiYbJcQP1yL81kdCMmuqeRVyL
	 obvYcpEGcjKHsD3BYbm2iMiwzTFUCkxMFbp+fkSaT1zaok4bup/0ZbWWQJELugP31s
	 uxInsFOHJIKm5wJ85EHtWhmHHMazzUttuYyorRCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Borislav Petkov <bp@alien8.de>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 061/627] x86/bugs: Avoid AUTO after the select step in the retbleed mitigation
Date: Tue, 12 Aug 2025 19:25:56 +0200
Message-ID: <20250812173421.647752381@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

[ Upstream commit 98ff5c071d1cde9426b0bfa449c43d49ec58f1c4 ]

The retbleed select function leaves the mitigation to AUTO in some cases.
Moreover, the update function can also set the mitigation to AUTO. This
is inconsistent with other mitigations and requires explicit handling of
AUTO at the end of update step.

Make sure a mitigation gets selected in the select step, and do not change
it to AUTO in the update step. When no mitigation can be selected leave it
to NONE, which is what AUTO was getting changed to in the end.

Suggested-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Acked-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/20250611-eibrs-fix-v4-1-5ff86cac6c61@linux.intel.com
Stable-dep-of: ab9f2388e0b9 ("x86/bugs: Allow ITS stuffing in eIBRS+retpoline mode also")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/bugs.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index f4d3abb12317..0bf2566d21b6 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1251,6 +1251,14 @@ static void __init retbleed_select_mitigation(void)
 			retbleed_mitigation = RETBLEED_MITIGATION_IBPB;
 		else
 			retbleed_mitigation = RETBLEED_MITIGATION_NONE;
+	} else if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL) {
+		/* Final mitigation depends on spectre-v2 selection */
+		if (boot_cpu_has(X86_FEATURE_IBRS_ENHANCED))
+			retbleed_mitigation = RETBLEED_MITIGATION_EIBRS;
+		else if (boot_cpu_has(X86_FEATURE_IBRS))
+			retbleed_mitigation = RETBLEED_MITIGATION_IBRS;
+		else
+			retbleed_mitigation = RETBLEED_MITIGATION_NONE;
 	}
 }
 
@@ -1259,9 +1267,6 @@ static void __init retbleed_update_mitigation(void)
 	if (!boot_cpu_has_bug(X86_BUG_RETBLEED) || cpu_mitigations_off())
 		return;
 
-	if (retbleed_mitigation == RETBLEED_MITIGATION_NONE)
-		goto out;
-
 	/*
 	 * retbleed=stuff is only allowed on Intel.  If stuffing can't be used
 	 * then a different mitigation will be selected below.
@@ -1272,7 +1277,7 @@ static void __init retbleed_update_mitigation(void)
 	    its_mitigation == ITS_MITIGATION_RETPOLINE_STUFF) {
 		if (spectre_v2_enabled != SPECTRE_V2_RETPOLINE) {
 			pr_err("WARNING: retbleed=stuff depends on spectre_v2=retpoline\n");
-			retbleed_mitigation = RETBLEED_MITIGATION_AUTO;
+			retbleed_mitigation = RETBLEED_MITIGATION_NONE;
 		} else {
 			if (retbleed_mitigation != RETBLEED_MITIGATION_STUFF)
 				pr_info("Retbleed mitigation updated to stuffing\n");
@@ -1298,15 +1303,11 @@ static void __init retbleed_update_mitigation(void)
 			if (retbleed_mitigation != RETBLEED_MITIGATION_STUFF)
 				pr_err(RETBLEED_INTEL_MSG);
 		}
-		/* If nothing has set the mitigation yet, default to NONE. */
-		if (retbleed_mitigation == RETBLEED_MITIGATION_AUTO)
-			retbleed_mitigation = RETBLEED_MITIGATION_NONE;
 	}
-out:
+
 	pr_info("%s\n", retbleed_strings[retbleed_mitigation]);
 }
 
-
 static void __init retbleed_apply_mitigation(void)
 {
 	bool mitigate_smt = false;
-- 
2.39.5



