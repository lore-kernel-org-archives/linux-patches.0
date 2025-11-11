Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C249246768;
	Tue, 11 Nov 2025 01:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823508; cv=none; b=TwK3ESzA0IboUJ5dTv9i1a5bPGmePVU+urV/C/Qo4owW6dRO1dFuO8dtkAbYW+5JlayYcGr0oq9M2tYw0TOiu4/etPjYD3GG6gyd92qd3QnxnfgWzrk9hAVWIUxADalA6nHBW1IxyXhroFf4NuTWE6Sya01aXC3xf2TuV9ACiN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823508; c=relaxed/simple;
	bh=KIG63C4NLAX9XNMm+A/TWqCXwzrIAUNPwzHS8XiwrpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ayX8HmWklEHAa/KiXy+U+6VHtwEcXFKh7HDlfN5Ca8O9EiJ02A5SiX5aOT2Q1SqN0jXfkTzjuPIm/pIj0l26pQ36IPdOCE3rVnY5IpmhEEbgEs5IRoEzOW21gnPWyISmOcqLgK4noi5VfWxmLUeXfXJTuGnW05/AQKKXOfp6uIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XHJBRddt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XHJBRddt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FAF9C116B1;
	Tue, 11 Nov 2025 01:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823507;
	bh=KIG63C4NLAX9XNMm+A/TWqCXwzrIAUNPwzHS8XiwrpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XHJBRddtz9T/UHAhhBWQHRcFjbYtsozKciTTx7rgn8j6ybBiRWsLRWIKj0yCrEnCY
	 pMSAMEH82qH76zU1e9qXznCrrSnur6pGzc72qL0YxGqAkrB6lDwyMCVRfCjvl7aYxF
	 i7c9P8hLPJSgWUefvglso/lpIq3l28PD+sgy/ASE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 260/565] platform/x86/intel-uncore-freq: Fix warning in partitioned system
Date: Tue, 11 Nov 2025 09:41:56 +0900
Message-ID: <20251111004532.746617295@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

[ Upstream commit 6d47b4f08436cb682fb2644e6265a3897fd42a77 ]

A partitioned system configured with only one package and one compute
die, warning will be generated for duplicate sysfs entry. This typically
occurs during the platform bring-up phase.

Partitioned systems expose dies, equivalent to TPMI compute domains,
through the CPUID. Each partitioned system must contains at least one
compute die per partition, resulting in a minimum of two dies per
package. Hence the function topology_max_dies_per_package() returns at
least two, and the condition "topology_max_dies_per_package() > 1"
prevents the creation of a root domain.

In this case topology_max_dies_per_package() will return 1 and root
domain will be created for partition 0 and a duplicate sysfs warning
for partition 1 as both partitions have same package ID.

To address this also check for non zero partition in addition to
topology_max_dies_per_package() > 1.

Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://lore.kernel.org/r/20250819211034.3776284-1-srinivas.pandruvada@linux.intel.com
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../platform/x86/intel/uncore-frequency/uncore-frequency-tpmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel/uncore-frequency/uncore-frequency-tpmi.c b/drivers/platform/x86/intel/uncore-frequency/uncore-frequency-tpmi.c
index 9a5ff9163988d..e36ae804e21e6 100644
--- a/drivers/platform/x86/intel/uncore-frequency/uncore-frequency-tpmi.c
+++ b/drivers/platform/x86/intel/uncore-frequency/uncore-frequency-tpmi.c
@@ -589,7 +589,7 @@ static int uncore_probe(struct auxiliary_device *auxdev, const struct auxiliary_
 
 	auxiliary_set_drvdata(auxdev, tpmi_uncore);
 
-	if (topology_max_dies_per_package() > 1)
+	if (topology_max_dies_per_package() > 1 || plat_info->partition)
 		return 0;
 
 	tpmi_uncore->root_cluster.root_domain = true;
-- 
2.51.0



