Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52C1F3570DC;
	Wed,  3 Dec 2025 16:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779752; cv=none; b=FV1WIWtyOzX1yCES9WllEGsuPEygthXfJqRbPza8QGu5jLcXmouW3gSgRMQtPjNT++n2qSQp//QnvZuDfK9fpyiwD1wjA83wi0PdgSpl95G5IZew98ZFzXXlYc9lQTQTdLP/eyfGHiVWKOx/Bn4qaSbY7BMrfH2vFJvVG/kZolA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779752; c=relaxed/simple;
	bh=lPFgs6eLo6bTO4Sq1WeeS+TQjV2nAOoGb5MiYLrzR38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p3osM4bR0qf6QDmDppWveuyzxmwozu4Ukd4N8/bUlpw0BTDWpy+v02EYBsY4z8BYq+2YtGWEjxYbUVjhq3LMrWD1ynqrM4apV39tzbcfgGL2muN6McrkDkoL/qMAhhyElxGLLHlkNepf8X64BaEPLLwgXheHfjBZbq5Gzw8ipr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z7knAPUt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z7knAPUt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8733C4CEF5;
	Wed,  3 Dec 2025 16:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779752;
	bh=lPFgs6eLo6bTO4Sq1WeeS+TQjV2nAOoGb5MiYLrzR38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z7knAPUtzk4a2jVJ88tWGccWdIwgFyd7+zRf//QBasiyKqRzdF6os6HNghLTF36Jo
	 UPppj3TYVbmOh/lR1gHgX9h5A2dfsLX5huBWi4e4pIXuWiD8n2TkxSUzPI6gp6+oyW
	 3As18vji7GGfsLIvr4yMpY3dEKAwkHipx3akpelk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 349/568] selftests: net: local_termination: Wait for interfaces to come up
Date: Wed,  3 Dec 2025 16:25:51 +0100
Message-ID: <20251203152453.487194056@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



