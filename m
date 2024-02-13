Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C743E5F56B;
	Tue, 13 Feb 2024 17:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845804; cv=none; b=tdviCAupsFwHj4CUjtJdONq0fHF2CCuasrmooyYPVkHsddNsdPH3GhiOdzxPRKrTWNWqSqtvqyp8OzA70qec533MXnapmiQX4J94c1LB0jbx+IoMmLAeOUUrqgy4zZWaRnOTVjy5V6+YPtfbBro8PzXe1Rqs+rCH/RQ1U7PPimA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845804; c=relaxed/simple;
	bh=Jrg+Wu2wXsdf6fj3lADd4LXy3y0bjk/MOnCsn4wiTTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l5+qzWCT09NZIF17JyvzWefhY2815ZeUibw1Hy/nhnCEFBCopXoKcNt1tcLh62QDG+R9YuwujboVmxYAMg7Bcefx10fumViUGqkPmUacn40PExT7jeaf3ti7FtsJh/aE/nHRSvmkklad7TlOjPGxgrRPPmrlAQgJLwub53qXV/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H7dDeMkq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H7dDeMkq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33C07C433F1;
	Tue, 13 Feb 2024 17:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845804;
	bh=Jrg+Wu2wXsdf6fj3lADd4LXy3y0bjk/MOnCsn4wiTTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H7dDeMkq1Bg3NKlsOXwUXOs+/OZHkPidbZbqsNfAswdvgsYN+fyYm2olOwPehZt4T
	 VR4xmuGa+CV0AUl6T+M03wQWnfzkYFhj4gJpSAZk0rM25z2CLW0wcK7O7ZvO8TRDhJ
	 d7ZsTXs4bJbJacF/MHxjYC7qL3HIGtcpwznmfpCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	Xin Long <lucien.xin@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 053/124] selftests: net: let big_tcp test cope with slow env
Date: Tue, 13 Feb 2024 18:21:15 +0100
Message-ID: <20240213171855.289076798@linuxfoundation.org>
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

[ Upstream commit a19747c3b9bf6476cc36d0a3a5ef0ff92999169e ]

In very slow environments, most big TCP cases including
segmentation and reassembly of big TCP packets have a good
chance to fail: by default the TCP client uses write size
well below 64K. If the host is low enough autocorking is
unable to build real big TCP packets.

Address the issue using much larger write operations.

Note that is hard to observe the issue without an extremely
slow and/or overloaded environment; reduce the TCP transfer
time to allow for much easier/faster reproducibility.

Fixes: 6bb382bcf742 ("selftests: add a selftest for big tcp")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Acked-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/big_tcp.sh | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/big_tcp.sh b/tools/testing/selftests/net/big_tcp.sh
index cde9a91c4797..2db9d15cd45f 100755
--- a/tools/testing/selftests/net/big_tcp.sh
+++ b/tools/testing/selftests/net/big_tcp.sh
@@ -122,7 +122,9 @@ do_netperf() {
 	local netns=$1
 
 	[ "$NF" = "6" ] && serip=$SERVER_IP6
-	ip net exec $netns netperf -$NF -t TCP_STREAM -H $serip 2>&1 >/dev/null
+
+	# use large write to be sure to generate big tcp packets
+	ip net exec $netns netperf -$NF -t TCP_STREAM -l 1 -H $serip -- -m 262144 2>&1 >/dev/null
 }
 
 do_test() {
-- 
2.43.0



