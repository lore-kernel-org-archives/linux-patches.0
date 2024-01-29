Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F90115B0E4;
	Mon, 29 Jan 2024 17:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548188; cv=none; b=uykV6GdrpfDZCUBsw/KyamgpVrMKN5crfMfvUrh1HZj9hcjuiCk3rmjP4EURp76+Z03dT0Emy2fpLLbO+Sdgy9tJh43yJpv92H6E9JbRNdj3G/oKOyWE9pm7ygO+7QQBMrY2oAFdpviJ7rzfVbrLk46hP9lt0dNcDe06gb/WfSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548188; c=relaxed/simple;
	bh=5ptod3yk5QVtkIx1RiJLRU4aGgXXTPBt93lvmrN05vk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tr2PJ3aBVomy/Gyx1D1ewcenKTEst7Qxfy1YgF0O6TgUWFhFZGTbWhHKebN7GbR6ffc/KeUor0hKP9BWdCL2oXaVHMuhvD68whssL7eCvuhDrecdXeV6IYhLuwZbJn/yl3EG8QUPW6dq+ASDsFbb98puMcfk0F2lfiTjHhjL59g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dk52yIoM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dk52yIoM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 588CFC433C7;
	Mon, 29 Jan 2024 17:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548188;
	bh=5ptod3yk5QVtkIx1RiJLRU4aGgXXTPBt93lvmrN05vk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dk52yIoM4uLKk8YC9VSZIej6m9mr3ogGY8s36YAGB4UTRdDPrYJi8CE1SvPvsesmJ
	 EOf5IFHi4xDROaTbJeoTZwatJmcxlEq/Gj7EgtvKDIWkYwxizyRkcCo+6o1VxrKySJ
	 7pIDVlhXpoWW1CuV1kS6yhmLj35BEWYZrgXs1unw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 204/346] selftests: net: fix rps_default_mask with >32 CPUs
Date: Mon, 29 Jan 2024 09:03:55 -0800
Message-ID: <20240129170022.396419133@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



