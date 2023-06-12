Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B3BD11C88
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:42:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97349C433EF;
	Mon, 12 Jun 2023 10:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566577;
	bh=7tn9c3uczJEzF1wb2c0HSFy1Db2QSUYWKlCw9RKcMQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s5HDVR+/GyNcIrbvY8dE9GUbK5/Q/FDoJ/2kRFK+kNaWbARfSEJzORpP6IX9PLMS1
	 BzMfpIklQlDYK6TUkBnPV9XTWv4nzbR6n50FQSRJROuzY+cd2e0/O0FriOlZ67cDaq
	 9K64ez1KjIjejoMKVJiJsEvOmaGO+92nyld6ra+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	Geliang Tang <geliang.tang@suse.com>,
	Mat Martineau <martineau@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.1 084/132] selftests: mptcp: update userspace pm addr tests
Date: Mon, 12 Jun 2023 12:26:58 +0200
Message-ID: <20230612101714.091588278@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101710.279705932@linuxfoundation.org>
References: <20230612101710.279705932@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Geliang Tang <geliang.tang@suse.com>

commit 48d73f609dcceeb563b0d960e59bf0362581e39c upstream.

This patch is linked to the previous commit ("mptcp: only send RM_ADDR in
nl_cmd_remove").

To align with what is done by the in-kernel PM, update userspace pm addr
selftests, by sending a remove_subflows command together after the
remove_addrs command.

Fixes: d9a4594edabf ("mptcp: netlink: Add MPTCP_PM_CMD_REMOVE")
Fixes: 97040cf9806e ("selftests: mptcp: userspace pm address tests")
Cc: stable@vger.kernel.org
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -851,7 +851,15 @@ do_transfer()
 				tk=$(sed -n 's/.*\(token:\)\([[:digit:]]*\).*$/\2/p;q' "$evts_ns1")
 				ip netns exec ${listener_ns} ./pm_nl_ctl ann $addr token $tk id $id
 				sleep 1
+				sp=$(grep "type:10" "$evts_ns1" |
+				     sed -n 's/.*\(sport:\)\([[:digit:]]*\).*$/\2/p;q')
+				da=$(grep "type:10" "$evts_ns1" |
+				     sed -n 's/.*\(daddr6:\)\([0-9a-f:.]*\).*$/\2/p;q')
+				dp=$(grep "type:10" "$evts_ns1" |
+				     sed -n 's/.*\(dport:\)\([[:digit:]]*\).*$/\2/p;q')
 				ip netns exec ${listener_ns} ./pm_nl_ctl rem token $tk id $id
+				ip netns exec ${listener_ns} ./pm_nl_ctl dsf lip "::ffff:$addr" \
+							lport $sp rip $da rport $dp token $tk
 			fi
 
 			counter=$((counter + 1))


