Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 330CC4C97;
	Tue, 11 Nov 2025 00:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822129; cv=none; b=N2TjLst9Q1in29HGlw5vCnu3XnSnx7GW/EtH2K6/+sZVGoHwLEXN57uVv0ILMj6O68pWby2P/von4i6C5+/vMZgmU/gPxsiwh1KbWKKU37qSG5r/3XG3RalUWyn5DOuFwK2I5OzW24oO7xYpysNWqO0TgquarXmo1LjXBmd+uHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822129; c=relaxed/simple;
	bh=WrkpoqO0AiSCXGu0jdOpQtaMumtqNZbiUqplvlHxnzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jObjAud8YWCxNrk2WQatR6il2uzSFv7a5NWrEhonXvUnNVgep1ezCw4CMz0X5Luggu8/mBFq442/eYQ736HcsSzuWRmk2jaB7VoofOVHRkh1fpS4zt71HFz5Dv1/0IDib5qhPL17I9s+WsU87zdzBDo9U4jJ1uh4ZxdgkS37OzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2g2mCh8x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2g2mCh8x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8D93C4CEF5;
	Tue, 11 Nov 2025 00:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822129;
	bh=WrkpoqO0AiSCXGu0jdOpQtaMumtqNZbiUqplvlHxnzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2g2mCh8xsiZhvq4CtCCt0ANm+7T8MagnWqmfbo55suFaNV03K6rb0CE3sFxGqt09C
	 44x/oASZugYOQCEPzybnjGa3GAamUOKCG9FftjIKzUnYuvOQf3sZUX62wHD6LUafqW
	 DtuMEjWSAppGWpY+oIyjxJ0/Nz4isiYoFO4YC+pw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gregory Price <gourry@gourry.net>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.17 027/849] x86/CPU/AMD: Add RDSEED fix for Zen5
Date: Tue, 11 Nov 2025 09:33:17 +0900
Message-ID: <20251111004537.106768902@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gregory Price <gourry@gourry.net>

commit 607b9fb2ce248cc5b633c5949e0153838992c152 upstream.

There's an issue with RDSEED's 16-bit and 32-bit register output
variants on Zen5 which return a random value of 0 "at a rate inconsistent
with randomness while incorrectly signaling success (CF=1)". Search the
web for AMD-SB-7055 for more detail.

Add a fix glue which checks microcode revisions.

  [ bp: Add microcode revisions checking, rewrite. ]

Cc: stable@vger.kernel.org
Signed-off-by: Gregory Price <gourry@gourry.net>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20251018024010.4112396-1-gourry@gourry.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/amd.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -1018,8 +1018,18 @@ static void init_amd_zen4(struct cpuinfo
 	}
 }
 
+static const struct x86_cpu_id zen5_rdseed_microcode[] = {
+	ZEN_MODEL_STEP_UCODE(0x1a, 0x02, 0x1, 0x0b00215a),
+	ZEN_MODEL_STEP_UCODE(0x1a, 0x11, 0x0, 0x0b101054),
+};
+
 static void init_amd_zen5(struct cpuinfo_x86 *c)
 {
+	if (!x86_match_min_microcode_rev(zen5_rdseed_microcode)) {
+		clear_cpu_cap(c, X86_FEATURE_RDSEED);
+		msr_clear_bit(MSR_AMD64_CPUID_FN_7, 18);
+		pr_emerg_once("RDSEED32 is broken. Disabling the corresponding CPUID bit.\n");
+	}
 }
 
 static void init_amd(struct cpuinfo_x86 *c)


