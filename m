Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B448D3BB29
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F9t7Tldd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60B09C433C8;
	Wed, 15 Nov 2023 19:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077925;
	bh=HMOoEQp/YQbCeiRkl7PkSPsmVfzpz+BiFzIxzN+rrI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F9t7TlddpOHjATmECEKO7ZRf38FgtDOcDyp7iU16SeXRL+D4eZrH++YsXk4r1gPmb
	 Rx70rabmS+2QADTLSTfHhhmLQ1WO1WUH+gi596MepwhtBh407Xy5ZbwMI0u4fJX8gQ
	 NIVMQqsgxD86nZ/KrMoOxCyUBJOyPwJiQY3JNXpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthieu Baerts <matttbe@kernel.org>,
	Geliang Tang <geliang.tang@suse.com>,
	Mat Martineau <martineau@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 597/603] selftests: mptcp: fix wait_rm_addr/sf parameters
Date: Wed, 15 Nov 2023 14:19:02 -0500
Message-ID: <20231115191652.416583936@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geliang Tang <geliang.tang@suse.com>

commit 9168ea02b898d3dde98b51e4bd3fb082bd438dab upstream.

The second input parameter of 'wait_rm_addr/sf $1 1' is misused. If it's
1, wait_rm_addr/sf will never break, and will loop ten times, then
'wait_rm_addr/sf' equals to 'sleep 1'. This delay time is too long,
which can sometimes make the tests fail.

A better way to use wait_rm_addr/sf is to use rm_addr/sf_count to obtain
the current value, and then pass into wait_rm_addr/sf.

Fixes: 4369c198e599 ("selftests: mptcp: test userspace pm out of transfer")
Cc: stable@vger.kernel.org
Suggested-by: Matthieu Baerts <matttbe@kernel.org>
Reviewed-by: Matthieu Baerts <matttbe@kernel.org>
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <martineau@kernel.org>
Link: https://lore.kernel.org/r/20231025-send-net-next-20231025-v1-2-db8f25f798eb@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -3289,6 +3289,7 @@ userspace_pm_rm_sf_addr_ns1()
 	local addr=$1
 	local id=$2
 	local tk sp da dp
+	local cnt_addr cnt_sf
 
 	tk=$(grep "type:1," "$evts_ns1" |
 	     sed -n 's/.*\(token:\)\([[:digit:]]*\).*$/\2/p;q')
@@ -3298,11 +3299,13 @@ userspace_pm_rm_sf_addr_ns1()
 	     sed -n 's/.*\(daddr6:\)\([0-9a-f:.]*\).*$/\2/p;q')
 	dp=$(grep "type:10" "$evts_ns1" |
 	     sed -n 's/.*\(dport:\)\([[:digit:]]*\).*$/\2/p;q')
+	cnt_addr=$(rm_addr_count ${ns1})
+	cnt_sf=$(rm_sf_count ${ns1})
 	ip netns exec $ns1 ./pm_nl_ctl rem token $tk id $id
 	ip netns exec $ns1 ./pm_nl_ctl dsf lip "::ffff:$addr" \
 				lport $sp rip $da rport $dp token $tk
-	wait_rm_addr $ns1 1
-	wait_rm_sf $ns1 1
+	wait_rm_addr $ns1 "${cnt_addr}"
+	wait_rm_sf $ns1 "${cnt_sf}"
 }
 
 userspace_pm_add_sf()
@@ -3324,17 +3327,20 @@ userspace_pm_rm_sf_addr_ns2()
 	local addr=$1
 	local id=$2
 	local tk da dp sp
+	local cnt_addr cnt_sf
 
 	tk=$(sed -n 's/.*\(token:\)\([[:digit:]]*\).*$/\2/p;q' "$evts_ns2")
 	da=$(sed -n 's/.*\(daddr4:\)\([0-9.]*\).*$/\2/p;q' "$evts_ns2")
 	dp=$(sed -n 's/.*\(dport:\)\([[:digit:]]*\).*$/\2/p;q' "$evts_ns2")
 	sp=$(grep "type:10" "$evts_ns2" |
 	     sed -n 's/.*\(sport:\)\([[:digit:]]*\).*$/\2/p;q')
+	cnt_addr=$(rm_addr_count ${ns2})
+	cnt_sf=$(rm_sf_count ${ns2})
 	ip netns exec $ns2 ./pm_nl_ctl rem token $tk id $id
 	ip netns exec $ns2 ./pm_nl_ctl dsf lip $addr lport $sp \
 				rip $da rport $dp token $tk
-	wait_rm_addr $ns2 1
-	wait_rm_sf $ns2 1
+	wait_rm_addr $ns2 "${cnt_addr}"
+	wait_rm_sf $ns2 "${cnt_sf}"
 }
 
 userspace_tests()


