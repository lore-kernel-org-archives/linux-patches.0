Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D5274040;
	Mon, 29 Jan 2024 17:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548562; cv=none; b=MKCO0rPm9qV8qmGBCs593yeoEIsnjcIt2dUC923sgMAjSDg70MPEkhJMMQSCdBzIYdQ2ifmRHMuqIGhoY341zCYIMF3rZcJo5paiEF65jajCyBp+AAEgNWzY2maL4fHuweQ0JAokV1bhdg1U2vbZRTPNGAPwJqsQVZ0wiPK3wQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548562; c=relaxed/simple;
	bh=6ipth1cxi4cY7Xe0kSkKVEA930IPaQ/B8JZxd+KDV7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ndp1zN4NQMiodYr7BWxW8/tW9iKlfKaa6Ow0kANf1jq1QJyEi3eINseP9TEbrRR8SpKh2wHQxEjQnSWpwGevCZnvktyHSQNcs6oJeMQ8rVXRzvnQUnVP56gw/mWP/zdeFkoWNIsV7Oj6KX3sPGsLGyR/Q2DA5Ovl2+imEqsiESI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bQDqMKni; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bQDqMKni"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0045BC433C7;
	Mon, 29 Jan 2024 17:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548562;
	bh=6ipth1cxi4cY7Xe0kSkKVEA930IPaQ/B8JZxd+KDV7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bQDqMKnihzYK1AUn+ebI9a0uWdi0x9JcdO3fpoWOjhsw3CtciuFQdE3K7yIX6u1VQ
	 ZCF6gHwiZs70ttClvc8zXSZL1CMazk3MknhQUX0rZN2jNIimNnp4jcYn1R5ist0+fw
	 foLpPIOUT0aQGT370G8eGz1Fqq8LEGYNsnIaX2wU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 210/331] selftests: net: fix rps_default_mask with >32 CPUs
Date: Mon, 29 Jan 2024 09:04:34 -0800
Message-ID: <20240129170021.023356634@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 0719b5338a0cbe80d1637a5fb03d8141b5bfc7a1 ]

If there is more than 32 cpus the bitmask will start to contain
commas, leading to:

./rps_default_mask.sh: line 36: [: 00000000,00000000: integer expression expected

Remove the commas, bash doesn't interpret leading zeroes as oct
so that should be good enough. Switch to bash, Simon reports that
not all shells support this type of substitution.

Fixes: c12e0d5f267d ("self-tests: introduce self-tests for RPS default mask")
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20240122195815.638997-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/rps_default_mask.sh | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/rps_default_mask.sh b/tools/testing/selftests/net/rps_default_mask.sh
index a26c5624429f..4287a8529890 100755
--- a/tools/testing/selftests/net/rps_default_mask.sh
+++ b/tools/testing/selftests/net/rps_default_mask.sh
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 
 readonly ksft_skip=4
@@ -33,6 +33,10 @@ chk_rps() {
 
 	rps_mask=$($cmd /sys/class/net/$dev_name/queues/rx-0/rps_cpus)
 	printf "%-60s" "$msg"
+
+	# In case there is more than 32 CPUs we need to remove commas from masks
+	rps_mask=${rps_mask//,}
+	expected_rps_mask=${expected_rps_mask//,}
 	if [ $rps_mask -eq $expected_rps_mask ]; then
 		echo "[ ok ]"
 	else
-- 
2.43.0



