Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19F23143894;
	Sun,  1 Sep 2024 16:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207938; cv=none; b=d5LSROTUAYhe1hsVv1khAZ20ZXj3yIMFeNGVFLMUMy5vANw3IJsHSZl8VXb7yoBxZ8WhAvV0Fex5/MeVkaHFF6qTcS3sO/j7/jGqCaX5+OVxUqnnyItFRx5/F/NZyoR6551w60x8qJpd/goeQFJdAkyuvlxhs4hAL2r2+CSi3NA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207938; c=relaxed/simple;
	bh=6FZUONix21cgDzxbMak0SeDXtuHYLAOwLQlahgWAF6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fR+tpP0v34VrNIHtQtjl8YmXqLlFsJrzfZBvLRNavZ+40cx1H08xpwttA0Qwmy3Iz6PN6vAqQSCto76ulWnKmVhGklSCJbu6aGPmiS74D/QSqEXG20tfHZ3mYq08BTip5WBJbxFcEm1HIm1NSm2dDiN47+9zVxopcetcFfwyLTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WbQMsGHQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WbQMsGHQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EC2CC4CEC3;
	Sun,  1 Sep 2024 16:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207938;
	bh=6FZUONix21cgDzxbMak0SeDXtuHYLAOwLQlahgWAF6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WbQMsGHQvjFeLMXxF0SBZGqH9V0wVyh3Z4clEC3hfCu+4HEP/Le5QsSUo+wlHhuWk
	 F3I6zjK2hvXrIc+1+9kbuTzULhWcnPfYK35DZmVf5+j98cjcIZJSerrK9AlYrh72zT
	 IAy0U3Dgujhko2Shop7hvlL2S/d2kWkIWiSlsOY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 23/93] selftests: mptcp: join: check re-re-adding ID 0 endp
Date: Sun,  1 Sep 2024 18:16:10 +0200
Message-ID: <20240901160808.231799469@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160807.346406833@linuxfoundation.org>
References: <20240901160807.346406833@linuxfoundation.org>
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

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit d397d7246c11ca36c33c932bc36d38e3a79e9aa0 upstream.

This test extends "delete and re-add" to validate the previous commit:
when the endpoint linked to the initial subflow (ID 0) is re-added
multiple times, it was no longer being used, because the internal linked
counters are not decremented for this special endpoint: it is not an
additional endpoint.

Here, the "del/add id 0" steps are done 3 times to unsure this case is
validated.

The 'Fixes' tag here below is the same as the one from the previous
commit: this patch here is not fixing anything wrong in the selftests,
but it validates the previous fix for an issue introduced by this commit
ID.

Fixes: 3ad14f54bd74 ("mptcp: more accurate MPC endpoint tracking")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |   27 +++++++++++++-----------
 1 file changed, 15 insertions(+), 12 deletions(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -3582,7 +3582,7 @@ endpoint_tests()
 		pm_nl_set_limits $ns2 0 3
 		pm_nl_add_endpoint $ns2 10.0.1.2 id 1 dev ns2eth1 flags subflow
 		pm_nl_add_endpoint $ns2 10.0.2.2 id 2 dev ns2eth2 flags subflow
-		test_linkfail=4 speed=20 \
+		test_linkfail=4 speed=5 \
 			run_tests $ns1 $ns2 10.0.1.1 &
 		local tests_pid=$!
 
@@ -3614,20 +3614,23 @@ endpoint_tests()
 		chk_subflow_nr "after no reject" 3
 		chk_mptcp_info subflows 2 subflows 2
 
-		pm_nl_del_endpoint $ns2 1 10.0.1.2
-		sleep 0.5
-		chk_subflow_nr "after delete id 0" 2
-		chk_mptcp_info subflows 2 subflows 2 # only decr for additional sf
-
-		pm_nl_add_endpoint $ns2 10.0.1.2 id 1 dev ns2eth1 flags subflow
-		wait_mpj $ns2
-		chk_subflow_nr "after re-add id 0" 3
-		chk_mptcp_info subflows 3 subflows 3
+		local i
+		for i in $(seq 3); do
+			pm_nl_del_endpoint $ns2 1 10.0.1.2
+			sleep 0.5
+			chk_subflow_nr "after delete id 0 ($i)" 2
+			chk_mptcp_info subflows 2 subflows 2 # only decr for additional sf
+
+			pm_nl_add_endpoint $ns2 10.0.1.2 id 1 dev ns2eth1 flags subflow
+			wait_mpj $ns2
+			chk_subflow_nr "after re-add id 0 ($i)" 3
+			chk_mptcp_info subflows 3 subflows 3
+		done
 
 		mptcp_lib_kill_wait $tests_pid
 
-		chk_join_nr 4 4 4
-		chk_rm_nr 2 2
+		chk_join_nr 6 6 6
+		chk_rm_nr 4 4
 	fi
 }
 


