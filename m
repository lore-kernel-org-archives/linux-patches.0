Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79D1927147D;
	Fri, 21 Nov 2025 13:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731072; cv=none; b=dVPEDHeZRhSFDnuaz+niNZBB5pfGtEbHPZQYSfElV0qrtAHufBOmBiH28hm/J6aLCGnQ3sJGBhUxfCspfOhtczPFnRfqiD5UQUTD44lP+wwDQD/IyYm0C6tZDtHwJQPsbBBc9OuGwOh55PT/nw6n2UJux8oc8ru+dAmIXPGoqnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731072; c=relaxed/simple;
	bh=UXfaQDcfuicS9/6dub/w2NJPtM1PtFYGCnIYMhSieJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gcplvoyJGvIh2193VAM6dRFVHYDIDDikaD2StVurNMg4okrzky+0g9dadsi6pcWv8wXHVf/avJjYLlXm2SEzFX5P1H8ZYg4po6UqQBWEdiKpFBHX3KaC020yjjKuiUs2yXuYhn7+ib5tDSh8SXwHjrYf0HcsjMuCJYyh0nFzYok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M6rKmtGs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M6rKmtGs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6247C4CEF1;
	Fri, 21 Nov 2025 13:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731072;
	bh=UXfaQDcfuicS9/6dub/w2NJPtM1PtFYGCnIYMhSieJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M6rKmtGsXliZLjOzKEchlXPtYxk9jiKYA/bsVbYIsAJ33TQjvHFeyVc+R5jJJsNI3
	 +n3j06XlSgO/F8TyubZ3VipxiYMKotj7DNQ4liUmqb+gdE894V9vaAnU/aRz1MZI9u
	 klgZU8hPjLp/tNI8PceQ18FvtbcmhCEAG/tF2KyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 048/247] selftests: net: local_termination: Wait for interfaces to come up
Date: Fri, 21 Nov 2025 14:09:55 +0100
Message-ID: <20251121130156.325916855@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Sverdlin <alexander.sverdlin@siemens.com>

[ Upstream commit 57531b3416448d1ced36a2a974a4085ec43d57b0 ]

It seems that most of the tests prepare the interfaces once before the test
run (setup_prepare()), rely on setup_wait() to wait for link and only then
run the test(s).

local_termination brings the physical interfaces down and up during test
run but never wait for them to come up. If the auto-negotiation takes
some seconds, first test packets are being lost, which leads to
false-negative test results.

Use setup_wait() in run_test() to make sure auto-negotiation has been
completed after all simple_if_init() calls on physical interfaces and test
packets will not be lost because of the race against link establishment.

Fixes: 90b9566aa5cd3f ("selftests: forwarding: add a test for local_termination.sh")
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@siemens.com>
Link: https://patch.msgid.link/20251106161213.459501-1-alexander.sverdlin@siemens.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/forwarding/local_termination.sh | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/local_termination.sh b/tools/testing/selftests/net/forwarding/local_termination.sh
index ecd34f364125c..892895659c7e4 100755
--- a/tools/testing/selftests/net/forwarding/local_termination.sh
+++ b/tools/testing/selftests/net/forwarding/local_termination.sh
@@ -176,6 +176,8 @@ run_test()
 	local rcv_dmac=$(mac_get $rcv_if_name)
 	local should_receive
 
+	setup_wait
+
 	tcpdump_start $rcv_if_name
 
 	mc_route_prepare $send_if_name
-- 
2.51.0



