Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B22892ECD0C;
	Tue, 17 Jun 2025 15:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174323; cv=none; b=eFtZsqBdeizUNc5FRPdWIhEUIFHaVM9un5sjBUSUigWTbMDtqWZJ+PRsWDXi514pqr9IUc41lk4zeA3h+YulQaqnsqVuWMFwDOBAs+Si0HQguDqzBzpctM3W+SNT+CxO+bUJ8NwvS9jIrzPkDeEHOPXLjhZjxhJ5Z9WIcdnif3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174323; c=relaxed/simple;
	bh=va/mX+LpF4nmV/3QqbPTS3m2Rt/tnSS/hItRWpe+S0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gmGtP7scr9DkDAaok7/QxjNePEsrPf9pejYVovZ0x12Nrp/EOSHsj52DTu5jtgYrsOLZE8i22hT2ZAA3shdfvnqSdHygKuQHYqgWwCh0XOoyK6aanosRV/1GGDGPanRf1nByDhk9+xG8L/hRZ7m0HVzFBZvY6o2OJ2QhO72TWVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zye7Fir9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zye7Fir9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DDCEC4CEE7;
	Tue, 17 Jun 2025 15:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174323;
	bh=va/mX+LpF4nmV/3QqbPTS3m2Rt/tnSS/hItRWpe+S0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zye7Fir9EcirZp4rZwlabB/uyXegcHD+aCoYSeyWOlneMTa3eagOiUqCkNRHAUTt7
	 KOZV4a81cXFbM9SS8NeBlmFFtMpDfEEYhVF8fgubEtY9iwn2K9wcUWkcF1iCKKpFLI
	 rr1wQL/A/d0xoFWL5jFw54zLPQKMf9p583pqw0y4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaqing Zhao <jiaqing.zhao@linux.intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 050/356] x86/mtrr: Check if fixed-range MTRRs exist in mtrr_save_fixed_ranges()
Date: Tue, 17 Jun 2025 17:22:45 +0200
Message-ID: <20250617152340.251565276@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiaqing Zhao <jiaqing.zhao@linux.intel.com>

[ Upstream commit 824c6384e8d9275d4ec7204f3f79a4ac6bc10379 ]

When suspending, save_processor_state() calls mtrr_save_fixed_ranges()
to save fixed-range MTRRs.

On platforms without fixed-range MTRRs like the ACRN hypervisor which
has removed fixed-range MTRR emulation, accessing these MSRs will
trigger an unchecked MSR access error. Make sure fixed-range MTRRs are
supported before access to prevent such error.

Since mtrr_state.have_fixed is only set when MTRRs are present and
enabled, checking the CPU feature flag in mtrr_save_fixed_ranges() is
unnecessary.

Fixes: 3ebad5905609 ("[PATCH] x86: Save and restore the fixed-range MTRRs of the BSP when suspending")
Signed-off-by: Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/20250509170633.3411169-2-jiaqing.zhao@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/mtrr/generic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index 2d6aa5d2e3d77..6839440a4b31e 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -582,7 +582,7 @@ static void get_fixed_ranges(mtrr_type *frs)
 
 void mtrr_save_fixed_ranges(void *info)
 {
-	if (boot_cpu_has(X86_FEATURE_MTRR))
+	if (mtrr_state.have_fixed)
 		get_fixed_ranges(mtrr_state.fixed_ranges);
 }
 
-- 
2.39.5



