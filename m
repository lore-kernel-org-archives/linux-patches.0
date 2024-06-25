Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B95A51465A8;
	Tue, 25 Jun 2024 09:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308515; cv=none; b=AhURJIAD4SGKNUAs6W+9e8Qglx4c74Z+wQx7CfaP0xpCC2XpLkEstI0o4xgbC2pqZl5aweOv6X9KjMjtCiqhIo/VIYWjK4qWoCT9+RVXAAuxDVxyqj16NkDgpuqv3+8HiJ1HDVnrBpWVwwu5riO/mJ7hBFrVTT3Vns1jsfboYeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308515; c=relaxed/simple;
	bh=yTXsoMFUZgyTWtzmpaAc9et7xK3y0dGnx44wndMkZeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NiPa1UodFg5Z3pxuUCUYGth5ncHzfezA2OUnRUHKBfHFLL9zgZNuX3UQbnLB4oMbNYJlnxdhjG1Q9oxOm+e7OtOEZlf48lAni6pYlKMTXBDlB76MCh4B947IUeeuZO7sNKLdUxuZ0i1Q1f0MvLrjiyAg2gvmzSR0SOGHB1OptIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bs/DJl43; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bs/DJl43"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EA08C32781;
	Tue, 25 Jun 2024 09:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308515;
	bh=yTXsoMFUZgyTWtzmpaAc9et7xK3y0dGnx44wndMkZeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bs/DJl43PccxadHeQipMPa9FW2gaXKD6hheLlOS7fs8Do9V9rV5F0HW9m7C0kTmBu
	 u8pJSX46lw4AwGuPc2iSAWUpF6rpeC31Vyp+nxa1R+sGWzr9EjWKAxLh1vI9k3Xynh
	 a8x0wgXzk6C8K02od4O3vn/G+qHN5WqAmGKGyck0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 130/250] selftests: openvswitch: Use bash as interpreter
Date: Tue, 25 Jun 2024 11:31:28 +0200
Message-ID: <20240625085553.055216366@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 5cae535438491..15bca07087179 100755
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



