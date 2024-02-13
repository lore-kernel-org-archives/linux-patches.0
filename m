Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20F1A5FF07;
	Tue, 13 Feb 2024 17:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845712; cv=none; b=f30N8qqMega9JStO6n+mg1JuY7/+k1yPcf3KOtZN9f4xa4Fm2ZqHPc8vDbYmJXwYf2UM+Zq6QiIkuOEpcRcJq8tijTgjl/z9YjIN6Y+2LbnEcPJHNDECWAabLr2+MzVtdMi2rW1u10EXdiC3kxbZaWlVd+sGdxj5bJ+pcXPWa78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845712; c=relaxed/simple;
	bh=E/Cu5d+kOj4S2Nyl5CFtp4hKfK66MlwWRu85GImAdh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ko0okz+mCCliJSGjMzyAMNOjWXxyDq7+BAOJZUVFBa0YDbJ1HlNPo2n+2vg8LlR4YK2mF46A/8gfn4TeNd+ioksfDGlsWUqRapucTYXoAlwK/MsJg4shIcLXNnxC2nZqnWtvTFFeKDu7Fy2OfLpb0o/Y5CwbufpPmfKy3AISCdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gd/ys8PE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gd/ys8PE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78E8FC433F1;
	Tue, 13 Feb 2024 17:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845712;
	bh=E/Cu5d+kOj4S2Nyl5CFtp4hKfK66MlwWRu85GImAdh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gd/ys8PE2e9WJPOw20nWOX8gkKpoo8NZIyH+K0zOyWxIbDFc+jO71odulRq1WswB5
	 xwsqt103s8VMoSezD5mrFanK6lCgNGBSbqGO7Wv53MYTwgPl30mUP/D17GD3QGdTdb
	 H9ck2Xvlxy0I4n/r1VPC60GDT7LXnpHBJAk44jW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 037/124] selftests: net: fix tcp listener handling in pmtu.sh
Date: Tue, 13 Feb 2024 18:20:59 +0100
Message-ID: <20240213171854.815524681@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
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

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit e71e016ad0f6e641a7898b8cda5f62f8e2beb2f1 ]

The pmtu.sh test uses a few TCP listener in a problematic way:
It hard-codes a constant timeout to wait for the listener starting-up
in background. That introduces unneeded latency and on very slow and
busy host it can fail.

Additionally the test starts again the same listener in the same
namespace on the same port, just after the previous connection
completed. Fast host can attempt starting the new server before the
old one really closed the socket.

Address the issues using the wait_local_port_listen helper and
explicitly waiting for the background listener process exit.

Fixes: 136a1b434bbb ("selftests: net: test vxlan pmtu exceptions with tcp")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/f8e8f6d44427d8c45e9f6a71ee1a321047452087.1706812005.git.pabeni@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/pmtu.sh | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/pmtu.sh b/tools/testing/selftests/net/pmtu.sh
index 3f118e3f1c66..f0febc19baae 100755
--- a/tools/testing/selftests/net/pmtu.sh
+++ b/tools/testing/selftests/net/pmtu.sh
@@ -199,6 +199,7 @@
 #	Same as above but with IPv6
 
 source lib.sh
+source net_helper.sh
 
 PAUSE_ON_FAIL=no
 VERBOSE=0
@@ -1336,13 +1337,15 @@ test_pmtu_ipvX_over_bridged_vxlanY_or_geneveY_exception() {
 			TCPDST="TCP:[${dst}]:50000"
 		fi
 		${ns_b} socat -T 3 -u -6 TCP-LISTEN:50000 STDOUT > $tmpoutfile &
+		local socat_pid=$!
 
-		sleep 1
+		wait_local_port_listen ${NS_B} 50000 tcp
 
 		dd if=/dev/zero status=none bs=1M count=1 | ${target} socat -T 3 -u STDIN $TCPDST,connect-timeout=3
 
 		size=$(du -sb $tmpoutfile)
 		size=${size%%/tmp/*}
+		wait ${socat_pid}
 
 		[ $size -ne 1048576 ] && err "File size $size mismatches exepcted value in locally bridged vxlan test" && return 1
 	done
-- 
2.43.0



