Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FFC7F9D4;
	Tue, 14 May 2024 11:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687876; cv=none; b=kE1W3zPbvv4k8/0hAflc+m26kYYLMpcRm6SdCjGfM/k9MtBNW70TfiIPmBCMKkY4Nn17E5xCZbf08YDZSJ5Nxpw0Pdic+02RV3N55z3sIg9meK3EwjlA2IYfeOPe+dzlcygZCNZmSeudrb8bhpRu9TtsdejT0bhoIdNL/l8K1Qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687876; c=relaxed/simple;
	bh=YMK85uLbYSq8Lzh2q1w7L6aqUdzVIeYLXLMfDAl8T9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kA9uktxp56t3PXIl5OjU9L2+gVcgMrJtgII4wsBuv9j0kiRPz+RL3I/5B8mIpvcmAEZvAb/Xid+r+gPTnDHBb7MQwftN7/l8pXN91sV4R+BNhskrH+vGY1iByMVTPAjear7GkTmVGJtrwKL2psMf4rokhcPtXLa1l4hh8aC/sAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EZ7MUfWy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EZ7MUfWy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB6E6C2BD10;
	Tue, 14 May 2024 11:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687876;
	bh=YMK85uLbYSq8Lzh2q1w7L6aqUdzVIeYLXLMfDAl8T9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EZ7MUfWyQwGGxJ4JGHd84mofOrR4HFpJli8Gbb2TdUTwQsvnviRaKPj65Z7xzIIah
	 9l04qzOtDM9hpupC2fwAghuUyqN4+1Diag4l/aZrOOodtt0rNzK2CcD6Tt3jVVxpv6
	 UpOOjovDH12OF13z1zSErhLskCdSIvDg16i4k9r0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jarred White <jarredwhite@linux.microsoft.com>,
	Vanshidhar Konda <vanshikonda@os.amperecomputing.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Easwar Hariharan <eahariha@linux.microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 135/168] ACPI: CPPC: Fix bit_offset shift in MASK_VAL() macro
Date: Tue, 14 May 2024 12:20:33 +0200
Message-ID: <20240514101011.779700691@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
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

From: Jarred White <jarredwhite@linux.microsoft.com>

commit 05d92ee782eeb7b939bdd0189e6efcab9195bf95 upstream

Commit 2f4a4d63a193 ("ACPI: CPPC: Use access_width over bit_width for
system memory accesses") neglected to properly wrap the bit_offset shift
when it comes to applying the mask. This may cause incorrect values to be
read and may cause the cpufreq module not be loaded.

[   11.059751] cpu_capacity: CPU0 missing/invalid highest performance.
[   11.066005] cpu_capacity: partial information: fallback to 1024 for all CPUs

Also, corrected the bitmask generation in GENMASK (extra bit being added).

Fixes: 2f4a4d63a193 ("ACPI: CPPC: Use access_width over bit_width for system memory accesses")
Signed-off-by: Jarred White <jarredwhite@linux.microsoft.com>
Cc: 5.15+ <stable@vger.kernel.org> # 5.15+
Reviewed-by: Vanshidhar Konda <vanshikonda@os.amperecomputing.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Easwar Hariharan <eahariha@linux.microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/cppc_acpi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/cppc_acpi.c b/drivers/acpi/cppc_acpi.c
index 408b1fda5702d..6aa456cda0ed9 100644
--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -165,8 +165,8 @@ show_cppc_data(cppc_get_perf_ctrs, cppc_perf_fb_ctrs, wraparound_time);
 #define GET_BIT_WIDTH(reg) ((reg)->access_width ? (8 << ((reg)->access_width - 1)) : (reg)->bit_width)
 
 /* Shift and apply the mask for CPC reads/writes */
-#define MASK_VAL(reg, val) ((val) >> ((reg)->bit_offset & 			\
-					GENMASK(((reg)->bit_width), 0)))
+#define MASK_VAL(reg, val) (((val) >> (reg)->bit_offset) & 			\
+					GENMASK(((reg)->bit_width) - 1, 0))
 
 static ssize_t show_feedback_ctrs(struct kobject *kobj,
 		struct kobj_attribute *attr, char *buf)
-- 
2.43.0



