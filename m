Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AD2637B036;
	Sat, 12 Sep 2026 10:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207661; cv=none; b=lnbWb5PNybFDet59pStbutSkxZ5wCRzQk0LNj1/18j+qPdP+Z5Nxsid/LV/mVr2cBwh58ZR93Tmnufi3l3WFDLUbGcnbEUoWfEvzLTSUql3K6d5bGH0y60f553vOVPYtKcAK0bZlQD4+LDrN6FKewsom/+F8+75Yj/Qiac3WMhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207661; c=relaxed/simple;
	bh=1tUwE92CgvhEaR1xPRrSobCXcySrtRMrgfl651RMdPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qs8YmF2nr8bn7aHHh8rdGxLUzhoYh68N5ZZrVOq8FF/SW27/uqTCOKMHD5CvX0knjWoDmPVfpEeaU2PEfvB8WxHL/wStDk260ytUwYqksmKe+AM+Fw2thYHo7rbZya2MEhXrCTreY1rDT1VGykuCIx8pYSeBRH7j0auoaYrUxNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BC+Kk5qf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BC+Kk5qf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53E9E1F000FF;
	Sat, 12 Sep 2026 10:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207660;
	bh=WxFP2AX62s9QTGozU0Nre8bimXnhF3r2Z7cVFC+ZUg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BC+Kk5qfKxcQlBFctQbhDVkDKCL3mL38DYUxypnN8+/mS6Ntks74Sa+6k59Aik0jB
	 dr1ruyLwZTVfiOZzwry2bfOwZzqOTF7Jzfp/idfZzjkOuXnTS9Pa8TyHPtDk5dGZCN
	 v5+u5eerHTI2hci0LMGE2aOmmZcKew/VXUL5xadM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre Gondois <pierre.gondois@arm.com>,
	Breno Leitao <leitao@debian.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0456/1518] cacheinfo: dont propagate DT/ACPI error when arch supplies info (arm64)
Date: Sat, 12 Sep 2026 08:43:45 +0200
Message-ID: <20260912065633.765929674@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 274259391c14166fcabae74f9fc0104223ff27a1 ]

cache_setup_properties() sets use_arch_info = true when DT/ACPI
provide no cache nodes and the arch can derive the topology from
CPU registers (e.g. arm64 reading CLIDR_EL1), but still returns the
original -ENOENT. cache_shared_cpu_map_setup() bails on that error
before the new flag can take effect, so the first CPU brought online
always trips a misleading warning:

  cacheinfo: Unable to detect cache hierarchy for CPU 0

Subsequent CPUs skip cache_setup_properties() entirely because
use_arch_info is now true, which is why only CPU0 hits it. This is
reproducible on arm64 with the QEMU 'virt' machine, whose default DT
has no cache nodes.

Clear ret after setting use_arch_info so the caller proceeds and
populates the shared cpu map via the arch-supplied leaves.

Fixes: ef9f643a9f8b ("cacheinfo: Add use_arch[|_cache]_info field/function")
Reviewed-by: Pierre Gondois <pierre.gondois@arm.com>
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Sudeep Holla <sudeep.holla@kernel.org>
Link: https://patch.msgid.link/20260611-cacheinfo-v2-1-6069ef066cf3@debian.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/cacheinfo.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/base/cacheinfo.c b/drivers/base/cacheinfo.c
index 613410705a47e..338804742dce3 100644
--- a/drivers/base/cacheinfo.c
+++ b/drivers/base/cacheinfo.c
@@ -382,9 +382,14 @@ static int cache_setup_properties(unsigned int cpu)
 	else if (!acpi_disabled)
 		ret = cache_setup_acpi(cpu);
 
-	// Assume there is no cache information available in DT/ACPI from now.
-	if (ret && use_arch_cache_info())
+	/*
+	 * No DT/ACPI cache nodes; fall back to arch-derived topology (e.g.
+	 * arm64 CLIDR_EL1) and clear the error to avoid a spurious warning.
+	 */
+	if (ret && use_arch_cache_info()) {
 		use_arch_info = true;
+		ret = 0;
+	}
 
 	return ret;
 }
-- 
2.53.0



