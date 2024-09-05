Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 551171494DB;
	Thu,  5 Sep 2024 10:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530551; cv=none; b=H2fWRm4UJI+OriWYxtsTYUGZL+GWh67HYAj4rhEyM1t7w5+18DPTe05cb3gLqDZdqoXgw1Ir8CDbJeW9kS++Ts17+CKw9ksbDnvXwYthcknsR2EUPronltzDVgwOxPRQ6OjyeXBpxwGAEnSmaWgzgWMKoy3XW0GGbBKkO9qGzYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530551; c=relaxed/simple;
	bh=3iQ6U2hOclO3mvu+/n2STBmfK7Eo6bSxMmKj9skeg+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ajtVxcm3VXXYBdBmXVl7w+qIYMGHGJais5/Lz6GGl3WrXAgJkrdoNNJwA5jTMCdVcvXkj3RXGKjm9mM2q9TMtkYkdg1qltNMjlFa/8DZ8t/RCUZwOis45Q1Lg4OouaLrm/tFnrXmCbzpFqulaFB7d6oUSuQmSAe7uEV3GW7gUH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sVCgqTmG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sVCgqTmG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D408BC4CEC3;
	Thu,  5 Sep 2024 10:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530551;
	bh=3iQ6U2hOclO3mvu+/n2STBmfK7Eo6bSxMmKj9skeg+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sVCgqTmGds0OBIsh6hjUcyO7IEbsFzwoZyXqTOadAlzU75Unryl68fc1FK4m5cXtf
	 ZoG/Th8Zv+0Bop98Aj5JxK0IcWLSlnb0YpbNx9L8PutNQw+eNctOBF/UqBoNFawaHb
	 3Gl4UworNo8/ZNPIxv8XftzBfmbRvopI9VMVZStM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 028/101] selftests: mptcp: join: cannot rm sf if closed
Date: Thu,  5 Sep 2024 11:41:00 +0200
Message-ID: <20240905093717.228325628@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093716.075835938@linuxfoundation.org>
References: <20240905093716.075835938@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

commit e93681afcb96864ec26c3b2ce94008ce93577373 upstream.

Thanks to the previous commit, the MPTCP subflows are now closed on both
directions even when only the MPTCP path-manager of one peer asks for
their closure.

In the two tests modified here -- "userspace pm add & remove address"
and "userspace pm create destroy subflow" -- one peer is controlled by
the userspace PM, and the other one by the in-kernel PM. When the
userspace PM sends a RM_ADDR notification, the in-kernel PM will
automatically react by closing all subflows using this address. Now,
thanks to the previous commit, the subflows are properly closed on both
directions, the userspace PM can then no longer closes the same
subflows if they are already closed. Before, it was OK to do that,
because the subflows were still half-opened, still OK to send a RM_ADDR.

In other words, thanks to the previous commit closing the subflows, an
error will be returned to the userspace if it tries to close a subflow
that has already been closed. So no need to run this command, which mean
that the linked counters will then not be incremented.

These tests are then no longer sending both a RM_ADDR, then closing the
linked subflow just after. The test with the userspace PM on the server
side is now removing one subflow linked to one address, then sending
a RM_ADDR for another address. The test with the userspace PM on the
client side is now only removing the subflow that was previously
created.

Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20240826-net-mptcp-close-extra-sf-fin-v1-2-905199fe1172@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Fixes: 97040cf9806e ("selftests: mptcp: userspace pm address tests")
Fixes: 5e986ec46874 ("selftests: mptcp: userspace pm subflow tests")
[ It looks like this patch is needed for the same reasons as mentioned
  above, but the resolution is different: the subflows and addresses are
  removed elsewhere. The same type of adaptations have been applied
  here. The Fixes tag has been replaced by better appropriated ones. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -957,8 +957,6 @@ do_transfer()
 				dp=$(grep "type:10" "$evts_ns1" |
 				     sed -n 's/.*\(dport:\)\([[:digit:]]*\).*$/\2/p;q')
 				ip netns exec ${listener_ns} ./pm_nl_ctl rem token $tk id $id
-				ip netns exec ${listener_ns} ./pm_nl_ctl dsf lip "$addr" \
-							lport $sp rip $da rport $dp token $tk
 			fi
 
 			counter=$((counter + 1))
@@ -1024,7 +1022,6 @@ do_transfer()
 				sleep 1
 				sp=$(grep "type:10" "$evts_ns2" |
 				     sed -n 's/.*\(sport:\)\([[:digit:]]*\).*$/\2/p;q')
-				ip netns exec ${connector_ns} ./pm_nl_ctl rem token $tk id $id
 				ip netns exec ${connector_ns} ./pm_nl_ctl dsf lip $addr lport $sp \
 									rip $da rport $dp token $tk
 			fi
@@ -3227,7 +3224,7 @@ userspace_tests()
 		run_tests $ns1 $ns2 10.0.1.1 0 userspace_1 0 slow
 		chk_join_nr 1 1 1
 		chk_add_nr 1 1
-		chk_rm_nr 1 1 invert
+		chk_rm_nr 1 0 invert
 	fi
 
 	# userspace pm create destroy subflow
@@ -3237,7 +3234,7 @@ userspace_tests()
 		pm_nl_set_limits $ns1 0 1
 		run_tests $ns1 $ns2 10.0.1.1 0 0 userspace_1 slow
 		chk_join_nr 1 1 1
-		chk_rm_nr 1 1
+		chk_rm_nr 0 1
 	fi
 
 	# remove and re-add


