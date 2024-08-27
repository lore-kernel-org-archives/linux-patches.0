Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C201E520;
	Tue, 27 Aug 2024 15:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771178; cv=none; b=YE4P2fKadW5kZ8Vuw8o90pb6f+u9C0c3/iOW5bI2rWt897A5L6gze5mKFKLnIDtWjf7/f/D8SLwD4JSXbLkDHXX/bEmeUUPJEm2erOr225aaBpSzIV/hciyMnn6X9K4KD18TFsMbIfdnylOLXKk8w2mbJrfabvl4HPcSfdW3wVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771178; c=relaxed/simple;
	bh=hgAPDYDhq7N+i6ZV+m2P8iOOnfOh277+C3Ptuwby8LY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c98ykUr0xyHGcNHsfyi4c910t3Ae+0raaoqCr28GcosnXsyPdqqCmxAqXXzNqP1PUjLGTNT8wgWoOs/y3BCgcQWt6wHp5+UNObrWYAGNs8bkLppQqJQxl+ZLI7fResv5B2sMbO4F6q+UF4c5AEXA9NBcAKIsUBg1uVSHVh4862o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kQ/FQe/B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kQ/FQe/B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFD67C6107C;
	Tue, 27 Aug 2024 15:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771178;
	bh=hgAPDYDhq7N+i6ZV+m2P8iOOnfOh277+C3Ptuwby8LY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kQ/FQe/BiV80TDYAr5BRjIbTdn7u5YCm0je+6EEmMQEYuXZxRYtyA8YU+suBp3yfx
	 ilsD+UfSzHaH5ExcAx5AhM1JUhnMbhp6aAeLXKSUAIWS5Mx5DAjr/mohafErLCSbKp
	 Tf9KZSWPmSHVEIo2xt1XQQelhoLjCw2atvgIrrkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 111/273] selftests: net: lib: ignore possible errors
Date: Tue, 27 Aug 2024 16:37:15 +0200
Message-ID: <20240827143837.633250367@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

[ Upstream commit 7e0620bc6a5ec6b340a0be40054f294ca26c010f ]

No need to disable errexit temporary, simply ignore the only possible
and not handled error.

Reviewed-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://lore.kernel.org/r/20240607-upstream-net-next-20240607-selftests-mptcp-net-lib-v1-1-e36986faac94@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 7965a7f32a53 ("selftests: net: lib: kill PIDs before del netns")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/lib.sh | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/tools/testing/selftests/net/lib.sh b/tools/testing/selftests/net/lib.sh
index 9155c914c064f..b2572aff6286f 100644
--- a/tools/testing/selftests/net/lib.sh
+++ b/tools/testing/selftests/net/lib.sh
@@ -128,25 +128,17 @@ slowwait_for_counter()
 cleanup_ns()
 {
 	local ns=""
-	local errexit=0
 	local ret=0
 
-	# disable errexit temporary
-	if [[ $- =~ "e" ]]; then
-		errexit=1
-		set +e
-	fi
-
 	for ns in "$@"; do
 		[ -z "${ns}" ] && continue
-		ip netns delete "${ns}" &> /dev/null
+		ip netns delete "${ns}" &> /dev/null || true
 		if ! busywait $BUSYWAIT_TIMEOUT ip netns list \| grep -vq "^$ns$" &> /dev/null; then
 			echo "Warn: Failed to remove namespace $ns"
 			ret=1
 		fi
 	done
 
-	[ $errexit -eq 1 ] && set -e
 	return $ret
 }
 
-- 
2.43.0



