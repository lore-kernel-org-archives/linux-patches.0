Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C6CA2EAB97;
	Tue, 12 Aug 2025 18:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023494; cv=none; b=WM4bQLVqahfP1OldjKHF9BnhS1I3L94ut/cELaAWpVH32/0N1owJzGC/rHKg0fwIsN8dpzq6Hh6f+HdGiSyjEtTdT3oehmE/+s31UT+xwjJcwOoBBTJJ5O6igyy1sfeaGvLd8EVSXU/1MNMx4ddw+R1GPJNePp1DRLfBcanwcN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023494; c=relaxed/simple;
	bh=VEBS8EIVk3BJsgOYT1GciK6+EMKi7Ee/PcgmjeY1UsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NBWRKtM03PNYaapqJaiQ/4eXyLYfmUgypU5InHLR5GGyDWq+04vNAjS1CbHV+/EHqVI1WX7S+LyaaZcV2y5nlfvLjTQ90pQJJBtgfmSSL89N+jtRluBbEUBG6jS0C1EhrBOjXY3luV6OSX07e6wM6SoF+PJKFGTFLoqNTko0H9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a1f38v0b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a1f38v0b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEA79C4CEF0;
	Tue, 12 Aug 2025 18:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023494;
	bh=VEBS8EIVk3BJsgOYT1GciK6+EMKi7Ee/PcgmjeY1UsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a1f38v0bhL9BJ/YOKDVMclfR/bqEgxgFHX6wvmyG0xiyVLs6/Gwbz5en89wl3DL88
	 7QfvTlaMxZWuXp+vcuxVehRGUr1Ugq/0Y8mtyVTn3LeCQb4aUlpg/oN9oKIdYvKWan
	 VTD8zSGrsWihv2h3iOQHmC9Oz2zFEJHBCZJEnOsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 063/627] x86/bugs: Introduce cdt_possible()
Date: Tue, 12 Aug 2025 19:25:58 +0200
Message-ID: <20250812173421.720908697@linuxfoundation.org>
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

[ Upstream commit 8374a2719df2a00781e6821e373d7de71390d1b4 ]

In preparation to allow ITS to also enable stuffing aka Call Depth
Tracking (CDT) independently of retbleed, introduce a helper
cdt_possible().

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/20250611-eibrs-fix-v4-5-5ff86cac6c61@linux.intel.com
Stable-dep-of: ab9f2388e0b9 ("x86/bugs: Allow ITS stuffing in eIBRS+retpoline mode also")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/bugs.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 937971fde749..0426500307f0 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1124,6 +1124,19 @@ early_param("nospectre_v1", nospectre_v1_cmdline);
 
 enum spectre_v2_mitigation spectre_v2_enabled __ro_after_init = SPECTRE_V2_NONE;
 
+/* Depends on spectre_v2 mitigation selected already */
+static inline bool cdt_possible(enum spectre_v2_mitigation mode)
+{
+	if (!IS_ENABLED(CONFIG_MITIGATION_CALL_DEPTH_TRACKING) ||
+	    !IS_ENABLED(CONFIG_MITIGATION_RETPOLINE))
+		return false;
+
+	if (mode == SPECTRE_V2_RETPOLINE)
+		return true;
+
+	return false;
+}
+
 #undef pr_fmt
 #define pr_fmt(fmt)     "RETBleed: " fmt
 
@@ -1272,7 +1285,7 @@ static void __init retbleed_update_mitigation(void)
 		retbleed_mitigation = RETBLEED_MITIGATION_STUFF;
 
 	if (retbleed_mitigation == RETBLEED_MITIGATION_STUFF &&
-	    spectre_v2_enabled != SPECTRE_V2_RETPOLINE) {
+	    !cdt_possible(spectre_v2_enabled)) {
 		pr_err("WARNING: retbleed=stuff depends on spectre_v2=retpoline\n");
 		retbleed_mitigation = RETBLEED_MITIGATION_NONE;
 	}
-- 
2.39.5



