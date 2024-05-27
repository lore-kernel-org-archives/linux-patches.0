Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFF6C168C4;
	Mon, 27 May 2024 19:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837372; cv=none; b=kZSjHccBhaYqTkIaC954Ny8wTYn4beD219FPi9P4mYiwgwD6K06iDIl/ZoYCZT9gX5Vn2mOQFvPW5jzVdkmRbJisNvaRIRJRTG8r0vrAhm3tLfRfYuqC9LpLC7yRqJDiOoqOV2XsZ9eD9g7Lg3c4DBlnrMpiwJWfjr3A02UPUcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837372; c=relaxed/simple;
	bh=nFKaDEfmBS+KL0wf3k6080fPrP0vo2yhYVlO+tLYhzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b6W4sSpnO+T4hdSVApCXJJsrC5egYHiTbR0Z9aXMFfqC/BnQbsDt/VyLu15IBDiESrVFYIKWtgqoqmCHveWrFxDbkm7t/vdfabJJ+OKtAhWMWjVhr7EI2GNTohQIddA/5hSefkmwsk7Y4DLC+HIxWkONhmfHMRuNMXghnTTr4rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KItLkxdt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KItLkxdt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DE98C2BBFC;
	Mon, 27 May 2024 19:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837372;
	bh=nFKaDEfmBS+KL0wf3k6080fPrP0vo2yhYVlO+tLYhzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KItLkxdtKn2doZ6W7pe9h8Lls/VGg0xQ3ej3LOud7/p2CvrVyEIkIiw8UFjys3E58
	 Te6YsZ1Rv2HuLtZ18PHw0WDIwocXB4kf6hkEcpO52a7V4HkgEyQfUG+RqZ0m1BjnGN
	 9/jrkHK8CELGweEQxEcVN3klZIVJCzcVUm+Z03vE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 416/427] selftests/net/lib: no need to record ns name if it already exist
Date: Mon, 27 May 2024 20:57:43 +0200
Message-ID: <20240527185635.584092439@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 83e93942796db58652288f0391ac00072401816f ]

There is no need to add the name to ns_list again if the netns already
recoreded.

Fixes: 25ae948b4478 ("selftests/net: add lib.sh")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/lib.sh | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/lib.sh b/tools/testing/selftests/net/lib.sh
index f9fe182dfbd44..56a9454b7ba35 100644
--- a/tools/testing/selftests/net/lib.sh
+++ b/tools/testing/selftests/net/lib.sh
@@ -73,15 +73,17 @@ setup_ns()
 	local ns=""
 	local ns_name=""
 	local ns_list=""
+	local ns_exist=
 	for ns_name in "$@"; do
 		# Some test may setup/remove same netns multi times
 		if unset ${ns_name} 2> /dev/null; then
 			ns="${ns_name,,}-$(mktemp -u XXXXXX)"
 			eval readonly ${ns_name}="$ns"
+			ns_exist=false
 		else
 			eval ns='$'${ns_name}
 			cleanup_ns "$ns"
-
+			ns_exist=true
 		fi
 
 		if ! ip netns add "$ns"; then
@@ -90,7 +92,7 @@ setup_ns()
 			return $ksft_skip
 		fi
 		ip -n "$ns" link set lo up
-		ns_list="$ns_list $ns"
+		! $ns_exist && ns_list="$ns_list $ns"
 	done
 	NS_LIST="$NS_LIST $ns_list"
 }
-- 
2.43.0



