Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B62C89446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:40:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBCDEC433C8;
	Sun, 13 Aug 2023 21:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962858;
	bh=vyrbWkL+w5yCnSv55T8mPMqORP3G3ad88emGkNyMm4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DK90rvUvKR2KB0nj5hMesYA0ZOFXlygmalukTqUsf5lI9rQVwEhvvM2edpNomkfuh
	 18yNvWHZKv/J733gnHbMUh9Nj2PPDPZQ9mRdQdyLtwxFQ28dBIl3tA4oMV9bAVm+K6
	 aBxytHuoGo3iAfwRlskFp7IHL4oiZ6Db0KWy/orE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 33/68] selftests: forwarding: Add a helper to skip test when using veth pairs
Date: Sun, 13 Aug 2023 23:19:34 +0200
Message-ID: <20230813211709.162643828@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211708.149630011@linuxfoundation.org>
References: <20230813211708.149630011@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ido Schimmel <idosch@nvidia.com>

commit 66e131861ab7bf754b50813216f5c6885cd32d63 upstream.

A handful of tests require physical loopbacks to be used instead of veth
pairs. Add a helper that these tests will invoke in order to be skipped
when executed with veth pairs.

Fixes: 64916b57c0b1 ("selftests: forwarding: Add speed and auto-negotiation test")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Tested-by: Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>
Reviewed-by: Hangbin Liu <liuhangbin@gmail.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://lore.kernel.org/r/20230808141503.4060661-7-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/forwarding/lib.sh |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -69,6 +69,17 @@ check_tc_action_hw_stats_support()
 	fi
 }
 
+skip_on_veth()
+{
+	local kind=$(ip -j -d link show dev ${NETIFS[p1]} |
+		jq -r '.[].linkinfo.info_kind')
+
+	if [[ $kind == veth ]]; then
+		echo "SKIP: Test cannot be run with veth pairs"
+		exit $ksft_skip
+	fi
+}
+
 if [[ "$(id -u)" -ne 0 ]]; then
 	echo "SKIP: need root privileges"
 	exit 0


