Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E282FD1DB;
	Fri, 21 Nov 2025 13:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733224; cv=none; b=ZmyY4llFYqOJ3oSyctcnNfuA4lxyqWKEG3pB98jS1AjSmtbcvhACRKbR+JLZZYVVV0bUyENfH129uwN2z+20xHVNURX5LFXAX63GVUuIx6ZIphGa1z94kL60WhdnaynABkSc2ZUs6oc+vbkzQL8kI4EQ2UA8L00JcQvM9F13hiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733224; c=relaxed/simple;
	bh=ObINufOHkzyAAC5e0YLQtgnwpmspvZYkO2dTc4AugtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L7dGzoVehURCoyoR/8vhspzjQAXsp60le+WxJK4Dv5zsGYkWW8vvJxzR6gA1ABQEdS6nL+7DnBBqWESzBm6ol8sEWEV+vND0wgrtIH/b1Zf3Vr5FVmdrfX36CchGTp8LxqZP/YaKX+1Y0UdaC9sZHD7YTeAR8zKJKKJNyo2og7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LIBO+3Au; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LIBO+3Au"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8707C4CEF1;
	Fri, 21 Nov 2025 13:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733224;
	bh=ObINufOHkzyAAC5e0YLQtgnwpmspvZYkO2dTc4AugtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LIBO+3Au43mG/G1UuGXIIM7hLv6pbuWm4sOXIm03EX6Y6V11+4qA+ombTLc4k6VnO
	 wLpEkJmutk4PiZh2nT5GaOZzscmwXRjds3GlExQlgbRgRBS2viIDwbgNTRHrldUh4r
	 MAsKGC9spYDtPYlW01noUS1+ZuoBnbW/SVscjpZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 395/529] selftests: net: local_termination: Wait for interfaces to come up
Date: Fri, 21 Nov 2025 14:11:34 +0100
Message-ID: <20251121130245.077160599@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9b5a63519b949..6cde61f10fd0e 100755
--- a/tools/testing/selftests/net/forwarding/local_termination.sh
+++ b/tools/testing/selftests/net/forwarding/local_termination.sh
@@ -108,6 +108,8 @@ run_test()
 	local smac=$(mac_get $h1)
 	local rcv_dmac=$(mac_get $rcv_if_name)
 
+	setup_wait
+
 	tcpdump_start $rcv_if_name
 
 	mc_route_prepare $h1
-- 
2.51.0



