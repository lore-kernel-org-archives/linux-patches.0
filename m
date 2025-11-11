Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8903A2E9EB1;
	Tue, 11 Nov 2025 01:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823844; cv=none; b=dbqwA949/JGZyRxQkXQElc6oEAjfy+KXTUUPNXqlryeCT4pbQLTqgU5+8XkhJVL46V0CT/0AUWO1wLlaOykmkFWfNfKDDYhn/gaJvQ3bjYQ+4XukBStc4sHNi33zpwBC2MDZQEAJjjc45mwFBEzLeS0LUADiGwxiSgwYu/+1xHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823844; c=relaxed/simple;
	bh=2lNlhDhOb7O6S1Ft7rvg8qMajNZApey2i30tqe6AEfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H2ksZJAlJJbECUZ+Dn5S9gSFnPYflGC+BAvKM3/5LutLjEf3ZpAb+co8Y94BXxI1M3tHLXjgezFsOqKITPFasr0tsbE9P342Exxi/gGg7F7YYDkMJgQAWqFpBu1wCthgfLr71n6DkLY1AL8F6hzKMuCNpRhyNBhHvujKtUWAiGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=06XkUsUk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="06XkUsUk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A977C4CEF5;
	Tue, 11 Nov 2025 01:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823844;
	bh=2lNlhDhOb7O6S1Ft7rvg8qMajNZApey2i30tqe6AEfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=06XkUsUklU2sTtjYnfZiz6tBMKHaWal9UjV3E57Cq3mUryDJya2KmngI+CxPnqekW
	 23cjk1TIN9fMNxKL6yqb2lasLDv+wTSP8gAucrr656yj5wRRsauDXg5DwvYEHBgH1x
	 DfkBq+tVufo0F4TPo6inOEaj/lj5161yUrWXzIx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 383/849] platform/x86/intel-uncore-freq: Fix warning in partitioned system
Date: Tue, 11 Nov 2025 09:39:13 +0900
Message-ID: <20251111004545.691949695@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index bfcf92aa4d69d..3e531fd1c6297 100644
--- a/drivers/platform/x86/intel/uncore-frequency/uncore-frequency-tpmi.c
+++ b/drivers/platform/x86/intel/uncore-frequency/uncore-frequency-tpmi.c
@@ -638,7 +638,7 @@ static int uncore_probe(struct auxiliary_device *auxdev, const struct auxiliary_
 
 	auxiliary_set_drvdata(auxdev, tpmi_uncore);
 
-	if (topology_max_dies_per_package() > 1)
+	if (topology_max_dies_per_package() > 1 || plat_info->partition)
 		return 0;
 
 	tpmi_uncore->root_cluster.root_domain = true;
-- 
2.51.0



