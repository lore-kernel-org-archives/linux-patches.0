Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 514E613AC4
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:28:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2EAFC433C8;
	Mon, 26 Jun 2023 18:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687804104;
	bh=74WxVjDl3k9wjXHifVnu7oti0a2MKo6Bi+2zdzH9+II=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rc6rqLnZ9RetR4B9BNyFGrZPAT1IrLGSwLp/Xks6qSVTR2s3eQrL/EKZ6wOcLnb43
	 /shmMgKA6V+YYKI7TyC94IeZQAZBYM1zUzGEYmXE/Hyzo1GRNdZ3Lk6INJNIYqKwoc
	 UUhYCzLkvLRLSiak9I8vyrY4xOn9nipLVQVp90NU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: [PATCH 6.1 042/170] selftests: mptcp: join: fix "userspace pm add & remove address"
Date: Mon, 26 Jun 2023 20:10:11 +0200
Message-ID: <20230626180802.417459999@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180800.476539630@linuxfoundation.org>
References: <20230626180800.476539630@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Matthieu Baerts <matthieu.baerts@tessares.net>

It looks like this test was broken in v6.1 after the backport of commit
48d73f609dcc ("selftests: mptcp: update userspace pm addr tests").

It was not working because the commit ad3493746ebe ("selftests: mptcp:
add test-cases for mixed v4/v6 subflows") is not in v6.1. This commit
changes how the connections are being created in mptcp_join.sh selftest:
with IPv6 support always enabled. But then in v6.1, the server still
create IPv4 only connections, so without the v4-mapped-v6 format with
the "::ffff:" prefix like we have in v6.3.

The modification here adds a support for connections created in v4 as
well so it fixes the issue in v6.1. This patch is not needed for the
selftests in v6.3 because only IPv6 listening sockets are being created.

Fixes: 8f0ba8ec18f5 ("selftests: mptcp: update userspace pm addr tests")
Cc: stable@vger.kernel.org
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -946,11 +946,12 @@ do_transfer()
 				sp=$(grep "type:10" "$evts_ns1" |
 				     sed -n 's/.*\(sport:\)\([[:digit:]]*\).*$/\2/p;q')
 				da=$(grep "type:10" "$evts_ns1" |
-				     sed -n 's/.*\(daddr6:\)\([0-9a-f:.]*\).*$/\2/p;q')
+				     sed -n 's/.*\(daddr[46]:\)\([0-9a-f:.]*\).*$/\2/p;q')
+				echo "$da" | grep -q ":" && addr="::ffff:$addr"
 				dp=$(grep "type:10" "$evts_ns1" |
 				     sed -n 's/.*\(dport:\)\([[:digit:]]*\).*$/\2/p;q')
 				ip netns exec ${listener_ns} ./pm_nl_ctl rem token $tk id $id
-				ip netns exec ${listener_ns} ./pm_nl_ctl dsf lip "::ffff:$addr" \
+				ip netns exec ${listener_ns} ./pm_nl_ctl dsf lip "$addr" \
 							lport $sp rip $da rport $dp token $tk
 			fi
 


