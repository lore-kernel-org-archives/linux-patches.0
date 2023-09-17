Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A8B6E54A
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:30:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBA2CC433C7;
	Sun, 17 Sep 2023 20:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694982602;
	bh=gPfDgk4wakGINVBhiZ9JVJpxJjzTlNz50naTagVAO1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tuVmWfHWVaZZrrkrVEcB8TScGEGObJN37bwJGf+3UdGMHvLANBhkWnPbehRyJ4poM
	 O5jdQuS5JFNvSjE/E6EgR5C3lykXldhMAsIsapTlnaKCGeaMvUf9g8lXgZMbJwhS12
	 /V54hnnIIQtWPR7JREiY/wHhi0xGN9nwQOufdkKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Zhivich <mzhivich@akamai.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Daniel Sneddon <daniel.sneddon@linux.intel.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 298/511] x86/speculation: Mark all Skylake CPUs as vulnerable to GDS
Date: Sun, 17 Sep 2023 21:12:05 +0200
Message-ID: <20230917191121.030425052@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Hansen <dave.hansen@linux.intel.com>

[ Upstream commit c9f4c45c8ec3f07f4f083f9750032a1ec3eab6b2 ]

The Gather Data Sampling (GDS) vulnerability is common to all Skylake
processors.  However, the "client" Skylakes* are now in this list:

	https://www.intel.com/content/www/us/en/support/articles/000022396/processors.html

which means they are no longer included for new vulnerabilities here:

	https://www.intel.com/content/www/us/en/developer/topic-technology/software-security-guidance/processors-affected-consolidated-product-cpu-model.html

or in other GDS documentation.  Thus, they were not included in the
original GDS mitigation patches.

Mark SKYLAKE and SKYLAKE_L as vulnerable to GDS to match all the
other Skylake CPUs (which include Kaby Lake).  Also group the CPUs
so that the ones that share the exact same vulnerabilities are next
to each other.

Last, move SRBDS to the end of each line.  This makes it clear at a
glance that SKYLAKE_X is unique.  Of the five Skylakes, it is the
only "server" CPU and has a different implementation from the
clients of the "special register" hardware, making it immune to SRBDS.

This makes the diff much harder to read, but the resulting table is
worth it.

I very much appreciate the report from Michael Zhivich about this
issue.  Despite what level of support a hardware vendor is providing,
the kernel very much needs an accurate and up-to-date list of
vulnerable CPUs.  More reports like this are very welcome.

* Client Skylakes are CPUID 406E3/506E3 which is family 6, models
  0x4E and 0x5E, aka INTEL_FAM6_SKYLAKE and INTEL_FAM6_SKYLAKE_L.

Reported-by: Michael Zhivich <mzhivich@akamai.com>
Fixes: 8974eb588283 ("x86/speculation: Add Gather Data Sampling mitigation")
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Daniel Sneddon <daniel.sneddon@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/common.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 54a0b3833ffea..3151c08bb54a5 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1149,11 +1149,11 @@ static const struct x86_cpu_id cpu_vuln_blacklist[] __initconst = {
 	VULNBL_INTEL_STEPPINGS(BROADWELL_G,	X86_STEPPING_ANY,		SRBDS),
 	VULNBL_INTEL_STEPPINGS(BROADWELL_X,	X86_STEPPING_ANY,		MMIO),
 	VULNBL_INTEL_STEPPINGS(BROADWELL,	X86_STEPPING_ANY,		SRBDS),
-	VULNBL_INTEL_STEPPINGS(SKYLAKE_L,	X86_STEPPING_ANY,		SRBDS | MMIO | RETBLEED),
 	VULNBL_INTEL_STEPPINGS(SKYLAKE_X,	X86_STEPPING_ANY,		MMIO | RETBLEED | GDS),
-	VULNBL_INTEL_STEPPINGS(SKYLAKE,		X86_STEPPING_ANY,		SRBDS | MMIO | RETBLEED),
-	VULNBL_INTEL_STEPPINGS(KABYLAKE_L,	X86_STEPPING_ANY,		SRBDS | MMIO | RETBLEED | GDS),
-	VULNBL_INTEL_STEPPINGS(KABYLAKE,	X86_STEPPING_ANY,		SRBDS | MMIO | RETBLEED | GDS),
+	VULNBL_INTEL_STEPPINGS(SKYLAKE_L,	X86_STEPPING_ANY,		MMIO | RETBLEED | GDS | SRBDS),
+	VULNBL_INTEL_STEPPINGS(SKYLAKE,		X86_STEPPING_ANY,		MMIO | RETBLEED | GDS | SRBDS),
+	VULNBL_INTEL_STEPPINGS(KABYLAKE_L,	X86_STEPPING_ANY,		MMIO | RETBLEED | GDS | SRBDS),
+	VULNBL_INTEL_STEPPINGS(KABYLAKE,	X86_STEPPING_ANY,		MMIO | RETBLEED | GDS | SRBDS),
 	VULNBL_INTEL_STEPPINGS(CANNONLAKE_L,	X86_STEPPING_ANY,		RETBLEED),
 	VULNBL_INTEL_STEPPINGS(ICELAKE_L,	X86_STEPPING_ANY,		MMIO | MMIO_SBDS | RETBLEED | GDS),
 	VULNBL_INTEL_STEPPINGS(ICELAKE_D,	X86_STEPPING_ANY,		MMIO | GDS),
-- 
2.40.1



