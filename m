Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76D3A34029C;
	Fri, 21 Nov 2025 13:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731732; cv=none; b=S0HSZGyTekUdDo5O9MoErsO5rN0K+KnSvFgdX8hdYgI4n8a70rnoGN/lw4X3mLgHxY2JCeuynRBEPrNSZydgMpNu4LIjXwmAfI7F9tXfMqtY/rfjYBdU1QnJmdJXY7tPZ+i8HxCDxHJKm6uVftzzb+TC2XfTTzJd/sZrrLCYCLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731732; c=relaxed/simple;
	bh=1MdoCz82txPO1LK2NxEEh8wzd/BeUhtqZowCYRsMrhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uqWoE5a5tEr/DKNiUI/c4l4gclZHRrWOp6O+klTUVitU8MnTa6g1rXZXmCPrWCBw74BwrOL1c8fNYDD2JATJYyd1GheBFiI8RPYhw4aR+Y/1o5OG00plJfZh6G7JjZX97GaQyCnvJxYnSNe3nV/Dc16x4HmAv1hZ/OFPzK07FBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RlKcsjOn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RlKcsjOn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0470C4CEF1;
	Fri, 21 Nov 2025 13:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731732;
	bh=1MdoCz82txPO1LK2NxEEh8wzd/BeUhtqZowCYRsMrhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RlKcsjOn3z1PJdarkqbGJHvtNb7Ci8CUTHkDVvndKMI8KrbwVUlgYjwCeHHMuqTjA
	 6C2YOl+SN5nHP3fy3/MF517VQjnpLBf64uxww97CXXbhUSDd3dwGVAU4K0BjhJqRZG
	 39cqTv4yS2ejsd0S80KEPlJmV14HulpZ2B/J4juc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christopher Harris <chris.harris79@gmail.com>,
	"Mario Limonciello (AMD) (kernel.org)" <superm1@kernel.org>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 062/185] ACPI: CPPC: Detect preferred core availability on online CPUs
Date: Fri, 21 Nov 2025 14:11:29 +0100
Message-ID: <20251121130146.114462193@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

From: Gautham R. Shenoy <gautham.shenoy@amd.com>

[ Upstream commit 4fe5934db4a7187d358f1af1b3ef9b6dd59bce58 ]

Commit 279f838a61f9 ("x86/amd: Detect preferred cores in
amd_get_boost_ratio_numerator()") introduced the ability to detect the
preferred core on AMD platforms by checking if there at least two
distinct highest_perf values.

However, it uses for_each_present_cpu() to iterate through all the
CPUs in the platform, which is problematic when the kernel is booted
with "nosmt=force" commandline option.

Hence limit the search to only the online CPUs.

Fixes: 279f838a61f9 ("x86/amd: Detect preferred cores in amd_get_boost_ratio_numerator()")
Reported-by: Christopher Harris <chris.harris79@gmail.com>
Closes: https://lore.kernel.org/lkml/CAM+eXpdDT7KjLV0AxEwOLkSJ2QtrsvGvjA2cCHvt1d0k2_C4Cw@mail.gmail.com/
Reviewed-by: "Mario Limonciello (AMD) (kernel.org)" <superm1@kernel.org>
Tested-by: Chrisopher Harris <chris.harris79@gmail.com>
Signed-off-by: Gautham R. Shenoy <gautham.shenoy@amd.com>
Link: https://patch.msgid.link/20251107074145.2340-2-gautham.shenoy@amd.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/acpi/cppc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/acpi/cppc.c b/arch/x86/kernel/acpi/cppc.c
index aab9d0570841a..147f0d8d54d86 100644
--- a/arch/x86/kernel/acpi/cppc.c
+++ b/arch/x86/kernel/acpi/cppc.c
@@ -194,7 +194,7 @@ int amd_detect_prefcore(bool *detected)
 		break;
 	}
 
-	for_each_present_cpu(cpu) {
+	for_each_online_cpu(cpu) {
 		u32 tmp;
 		int ret;
 
-- 
2.51.0



