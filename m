Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A987924A05D;
	Wed, 25 Feb 2026 01:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983533; cv=none; b=rC3o7cdQP9joBUZGm3p/81N4oFzezyr7t6ZK+2AYciiX7ziS1ZJpkjolbZ5WWm08d+nGBNuDkEFDU+o6BqUE0CYAkNr3mKcohUghOBi1QHQ1RjvcUWvOKpW596HOSFli8Zn3T6fbI34woGHDyeK7/YUX0Sf9u4aKXGhjj7Cj9rY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983533; c=relaxed/simple;
	bh=8y8INJeTcsz6hIkgvMlTAKvT7/dDMIGFl2bHmhrf/Tc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MwsiiSWEjR2Lte1+zAT4y3DvB3C6C7jxksiw6T5CnMqKfIWLbKGk5x1nKcxzpS2EeAQ7J1b/UztNGbmztEximL1zGGtnksGY495rW/gvlWDsv8n+wnNQP7OXM4H3MJXBHwR/wjTZS77lM8i74aYbZGXdw5mKoeM1F++A1gOs5a4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gkjv7EyF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gkjv7EyF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25AB5C116D0;
	Wed, 25 Feb 2026 01:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983533;
	bh=8y8INJeTcsz6hIkgvMlTAKvT7/dDMIGFl2bHmhrf/Tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gkjv7EyF5BeUEALtLFCB/FF/0FCXxwM5uchgvoNY55hmzMhBmwHnpr8rGx8PxMGAG
	 XDwZBHMaqZEL8CQ/6GVf3HspPLPiC0wzDoZete6QYFj9nFbdGJEEAL87I91e0reoDy
	 A2Ojfr85vCTns9ZnGLOy+HwEsWBxbLbl3f4dj/w8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 621/781] tools/power turbostat: AMD: msr offset 0x611 read failed: Input/output error
Date: Tue, 24 Feb 2026 17:22:10 -0800
Message-ID: <20260225012415.042050924@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Len Brown <len.brown@intel.com>

[ Upstream commit 16cc8f249c702b7cbb4c2c2be7cd8f4fdd5d1d0c ]

Turbostat exits during RAPL probe with:

turbostat: cpu0: msr offset 0x611 read failed: Input/output error

A binary with this bug can be used successfully with
the option "--no-msr"

Fix this regression by trusting the static AMD RAPL MSR offset.

Fixes: 19476a592bf2 ("tools/power turbostat: Validate RAPL MSRs for AWS Nitro Hypervisor")
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 5ad45c2ac5bd8..c4c8b6315fd26 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -2135,7 +2135,7 @@ off_t idx_to_offset(int idx)
 
 	switch (idx) {
 	case IDX_PKG_ENERGY:
-		if (valid_rapl_msrs & RAPL_AMD_F17H)
+		if (platform->plat_rapl_msrs & RAPL_AMD_F17H)
 			offset = MSR_PKG_ENERGY_STAT;
 		else
 			offset = MSR_PKG_ENERGY_STATUS;
-- 
2.51.0



