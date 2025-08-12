Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 964A42FFDD6;
	Tue, 12 Aug 2025 18:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024125; cv=none; b=ii9f/Trs66jVIYKEUIOI8J0KCM/Rz0Dog6QB4yHe4461v6IbtKjjv+3icpDF5ZoQqzR0aWXQ7kIn7TEVxMmbNhjOuLAbnMYGomr83EoUYq9PD5KWcuD002EUQo4hWJlBV1wyoa2WNme0Wc+RZ0nSXT/jwMVBYzB2302cWEERSt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024125; c=relaxed/simple;
	bh=Zl+1hCJi6MrGr9VIX+xKyuS3FfhvEZDS+WteyX8HMaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PbZ07QG+dhH8ksXZIG1IkWy/MTEM4FC5olnAqqbhhoB25jWMbwG/SLqlPEOmBB/ps41l/nPZaF2u+oAR7YC/OV/6IfDqtFOHdA0HhTTClxMB9PNY2iV0ztKvnh2ShlMrYQaQw23hFLR84D4Q8corj8pZ080wUVCHTdq9zjAIFK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2eqvQszh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2eqvQszh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 045E9C4CEF0;
	Tue, 12 Aug 2025 18:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024125;
	bh=Zl+1hCJi6MrGr9VIX+xKyuS3FfhvEZDS+WteyX8HMaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2eqvQszhH01FHuKThENs6Wkl3Byt9fa65YQoONq0DKSNCx+tnFDZnkbZEv1Tl98aH
	 uzmzPoTa5ILU44HyaqOkiC7zcgemZS6w2PDtoi64YyxzUHt2kEFBgWqNGl0Tdvj4Y8
	 FQD1efM+yHjTBlM/r52YmjXwB4cT02RCHTOjQLHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 274/627] selftests: netfilter: Ignore tainted kernels in interface stress test
Date: Tue, 12 Aug 2025 19:29:29 +0200
Message-ID: <20250812173429.736544907@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Phil Sutter <phil@nwl.cc>

[ Upstream commit 8d1c91850d064944ab214b2fbfffb7fc08a11d65 ]

Complain about kernel taint value only if it wasn't set at start
already.

Fixes: 73db1b5dab6f ("selftests: netfilter: Torture nftables netdev hooks")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/net/netfilter/nft_interface_stress.sh  | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/netfilter/nft_interface_stress.sh b/tools/testing/selftests/net/netfilter/nft_interface_stress.sh
index 5ff7be9daeee..c0fffaa6dbd9 100755
--- a/tools/testing/selftests/net/netfilter/nft_interface_stress.sh
+++ b/tools/testing/selftests/net/netfilter/nft_interface_stress.sh
@@ -10,6 +10,8 @@ source lib.sh
 checktool "nft --version" "run test without nft tool"
 checktool "iperf3 --version" "run test without iperf3 tool"
 
+read kernel_tainted < /proc/sys/kernel/tainted
+
 # how many seconds to torture the kernel?
 # default to 80% of max run time but don't exceed 48s
 TEST_RUNTIME=$((${kselftest_timeout:-60} * 8 / 10))
@@ -135,7 +137,8 @@ else
 	wait
 fi
 
-[[ $(</proc/sys/kernel/tainted) -eq 0 ]] || {
+
+[[ $kernel_tainted -eq 0 && $(</proc/sys/kernel/tainted) -ne 0 ]] && {
 	echo "FAIL: Kernel is tainted!"
 	exit $ksft_fail
 }
-- 
2.39.5



