Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC1CD191F98;
	Tue, 12 Aug 2025 18:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023469; cv=none; b=f130En1l+EM6OgkKjLpzigCv/KcSzCauAb4c8EXL0VFp5ewMyJtPDoE0jL+cO+zOcRm3GheWxu2nIJKghZL2/p91XFq7mGT4QJmj6FFeR9KFt3nTo6qqJTZkRRdBJ+gSdgT354SuCSgXJ2q9OLghOOIEulWtpifDgi77ACpQB1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023469; c=relaxed/simple;
	bh=rLRzejude+AIxMw35oswo7gfb/GQn8OaVeWMtsgOeUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ia9mHU0sBsqsXTvQKtHv8e7a2/5i6LR8dFZTzFL0Bcaa6LLslahdfW8+gO6rym0iPjZwLzNuPZWT4cnd08aQUzhKDlrNsFv0vQxIpGxXGiz9ynMizy+YfnH7zd//1niudeedUnPjKMrWYLsE8QUTmXMS7da4ERmdoKchQCrsRTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H9kHhzNJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H9kHhzNJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 225C0C4CEF0;
	Tue, 12 Aug 2025 18:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023469;
	bh=rLRzejude+AIxMw35oswo7gfb/GQn8OaVeWMtsgOeUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H9kHhzNJESnZM+qCqW1Q5/6m4ebRUozjYWx0CANrqfP77nLuDAXo3Jbq9ME9833cx
	 upoUnfX6SZWwBOj+bcL+zIbX9BKyb2bv9w5JKxOUGGQLrEbVMd1NbZ1kk6kl6JSidx
	 SkFojUPz6ReE8CkqsNDSQ3l9bLJCVJmSEiYORQDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Nikolay Borisov <nik.borisov@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 062/627] x86/bugs: Simplify the retbleed=stuff checks
Date: Tue, 12 Aug 2025 19:25:57 +0200
Message-ID: <20250812173421.683959867@linuxfoundation.org>
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

[ Upstream commit 530e80648bff083e1d19ad7248c0540812a9a35f ]

Simplify the nested checks, remove redundant print and comment.

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
Acked-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/20250611-eibrs-fix-v4-2-5ff86cac6c61@linux.intel.com
Stable-dep-of: ab9f2388e0b9 ("x86/bugs: Allow ITS stuffing in eIBRS+retpoline mode also")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/bugs.c | 24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 0bf2566d21b6..937971fde749 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1267,24 +1267,16 @@ static void __init retbleed_update_mitigation(void)
 	if (!boot_cpu_has_bug(X86_BUG_RETBLEED) || cpu_mitigations_off())
 		return;
 
-	/*
-	 * retbleed=stuff is only allowed on Intel.  If stuffing can't be used
-	 * then a different mitigation will be selected below.
-	 *
-	 * its=stuff will also attempt to enable stuffing.
-	 */
-	if (retbleed_mitigation == RETBLEED_MITIGATION_STUFF ||
-	    its_mitigation == ITS_MITIGATION_RETPOLINE_STUFF) {
-		if (spectre_v2_enabled != SPECTRE_V2_RETPOLINE) {
-			pr_err("WARNING: retbleed=stuff depends on spectre_v2=retpoline\n");
-			retbleed_mitigation = RETBLEED_MITIGATION_NONE;
-		} else {
-			if (retbleed_mitigation != RETBLEED_MITIGATION_STUFF)
-				pr_info("Retbleed mitigation updated to stuffing\n");
+	 /* ITS can also enable stuffing */
+	if (its_mitigation == ITS_MITIGATION_RETPOLINE_STUFF)
+		retbleed_mitigation = RETBLEED_MITIGATION_STUFF;
 
-			retbleed_mitigation = RETBLEED_MITIGATION_STUFF;
-		}
+	if (retbleed_mitigation == RETBLEED_MITIGATION_STUFF &&
+	    spectre_v2_enabled != SPECTRE_V2_RETPOLINE) {
+		pr_err("WARNING: retbleed=stuff depends on spectre_v2=retpoline\n");
+		retbleed_mitigation = RETBLEED_MITIGATION_NONE;
 	}
+
 	/*
 	 * Let IBRS trump all on Intel without affecting the effects of the
 	 * retbleed= cmdline option except for call depth based stuffing
-- 
2.39.5



