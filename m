Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 861141487E9;
	Tue, 25 Jun 2024 09:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309089; cv=none; b=gtF6PQAL4ijbZDbaxrkhwYHSEtpLPh8JpH5Qk/3NlvzvoOmQ2R9sxOByiV3/qqfjOqioLL8B4kAPYaDH3yI3aUJ0BqYQmr7Cky9P8/zdlraJGnsBEy66tE9nWZtbrXZNyWYmrDDFUrKIlKauxMP8WPzOOc0Zkavd2AGN+ptrric=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309089; c=relaxed/simple;
	bh=NxE1BDarfzUbvXoOrStFE9GZKVGwpj7rJDY2kiMkr08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a4nqk9wHWnbq+pU4mc2j+tM4jfIZBM7MYbEU14Kz2zuasJ1dQTyBprGmhrR1HzOyfZpiaUGHtchlfKcV6YqnLUHqrUDFu2GpHwxzYzbY2fRAqPT7tz5qvKPGhKbv9W3UCToFYvEd1a1EB6JWfNpuQo4oZZo7ms8jguYcgd7Pwv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YLwlZmTv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YLwlZmTv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C5D4C32781;
	Tue, 25 Jun 2024 09:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309089;
	bh=NxE1BDarfzUbvXoOrStFE9GZKVGwpj7rJDY2kiMkr08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YLwlZmTvEY8SliHuE5mLpvqrqqPCvNxggA2f+42qN3tYS1R+IEiKW/h4to69a9+ap
	 RtznWB/3cX8MU6NFTYre7/DSAeihzs2JzYU7e2BWL207XIV5D3I3gxJZtQrCZ0rNJC
	 PKp7DCvXW7Cg8G4Q7zWxju5wHP3OcmbUeGmLboik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 092/192] selftests: openvswitch: Use bash as interpreter
Date: Tue, 25 Jun 2024 11:32:44 +0200
Message-ID: <20240625085540.708770680@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

From: Simon Horman <horms@kernel.org>

[ Upstream commit e2b447c9a1bba718f9c07513a1e8958209e862a1 ]

openvswitch.sh makes use of substitutions of the form ${ns:0:1}, to
obtain the first character of $ns. Empirically, this is works with bash
but not dash. When run with dash these evaluate to an empty string and
printing an error to stdout.

 # dash -c 'ns=client; echo "${ns:0:1}"' 2>error
 # cat error
 dash: 1: Bad substitution
 # bash -c 'ns=client; echo "${ns:0:1}"' 2>error
 c
 # cat error

This leads to tests that neither pass nor fail.
F.e.

 TEST: arp_ping                                                      [START]
 adding sandbox 'test_arp_ping'
 Adding DP/Bridge IF: sbx:test_arp_ping dp:arpping {, , }
 create namespaces
 ./openvswitch.sh: 282: eval: Bad substitution
 TEST: ct_connect_v4                                                 [START]
 adding sandbox 'test_ct_connect_v4'
 Adding DP/Bridge IF: sbx:test_ct_connect_v4 dp:ct4 {, , }
 ./openvswitch.sh: 322: eval: Bad substitution
 create namespaces

Resolve this by making openvswitch.sh a bash script.

Fixes: 918423fda910 ("selftests: openvswitch: add an initial flow programming case")
Signed-off-by: Simon Horman <horms@kernel.org>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Link: https://lore.kernel.org/r/20240617-ovs-selftest-bash-v1-1-7ae6ccd3617b@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/openvswitch/openvswitch.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/openvswitch/openvswitch.sh b/tools/testing/selftests/net/openvswitch/openvswitch.sh
index 36e40256ab92a..bab7436c68348 100755
--- a/tools/testing/selftests/net/openvswitch/openvswitch.sh
+++ b/tools/testing/selftests/net/openvswitch/openvswitch.sh
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 #
 # OVS kernel module self tests
-- 
2.43.0



