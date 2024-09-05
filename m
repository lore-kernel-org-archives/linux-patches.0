Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FBB91494DB;
	Thu,  5 Sep 2024 10:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530564; cv=none; b=sEGGsIGCOWpuqu02G1zyH2nQ3/Tc+C/dkHznTHvILZOtzLnqxLgSA9I4Ema1a8LefiXCJLnUTDVR0f8KrjkmikHZcy6joI1GGVGcICDzwCNkLGYKkeWpYUpVQtPrl7r85khgz6MT/ruFklNHhFKTo6FnjkZH0l0seZurvihBjBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530564; c=relaxed/simple;
	bh=Ujr/9ReO63LiX+XZr43C70g4GGGEfbV6rOJVTOKlSC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Afc/qWtDoiIQHtx7PX/7DKbqZT6tNN6A7DbmXbUoYoDS41QA85ZKExKERPb1Psf/2gZib+l/sr+IpIp0WVnA8P5b/jAl3bDlbTToi8gUdxsFGH8tXH7WG7q+64ic8+Ku3iK1HijKinmq/Y9aQpaEO8E7AOFMPKx/V736oG5XmFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s+v4uhCi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s+v4uhCi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0B65C4CEC3;
	Thu,  5 Sep 2024 10:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530564;
	bh=Ujr/9ReO63LiX+XZr43C70g4GGGEfbV6rOJVTOKlSC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s+v4uhCiKEBvEmNbGE4IktMorlPB/d7jJa4QOQi2UgGaxV0+vLj1XnowiaEKMqfd3
	 qHwju9Mcnc3nwzvOZMaTHaaXSoRbr9CiMvjz2ne9s95ULf4z4jYLQqq0fhd8BmhYw7
	 plau6FnCSYV18jX4nfoZ7Bb1W39gcAVQPs8QSYRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.1 022/101] selftests: mptcp: join: check re-adding init endp with != id
Date: Thu,  5 Sep 2024 11:40:54 +0200
Message-ID: <20240905093716.984562308@linuxfoundation.org>
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

commit 1c2326fcae4f0c5de8ad0d734ced43a8e5f17dac upstream.

The initial subflow has a special local ID: 0. It is specific per
connection.

When a global endpoint is deleted and re-added later, it can have a
different ID, but the kernel should still use the ID 0 if it corresponds
to the initial address.

This test validates this behaviour: the endpoint linked to the initial
subflow is removed, and re-added with a different ID.

Note that removing the initial subflow will not decrement the 'subflows'
counters, which corresponds to the *additional* subflows. On the other
hand, when the same endpoint is re-added, it will increment this
counter, as it will be seen as an additional subflow this time.

The 'Fixes' tag here below is the same as the one from the previous
commit: this patch here is not fixing anything wrong in the selftests,
but it validates the previous fix for an issue introduced by this commit
ID.

Fixes: 3ad14f54bd74 ("mptcp: more accurate MPC endpoint tracking")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
[ Conflicts in mptcp_join.sh, because the helpers are different in this
  version:
  - run_tests has been modified a few times to reduce the number of
    positional parameters
  - no chk_mptcp_info helper
  - chk_subflow_nr taking an extra parameter
  - kill_tests_wait instead of mptcp_lib_kill_wait ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -3243,11 +3243,12 @@ userspace_tests()
 	# remove and re-add
 	if reset "delete re-add signal" &&
 	   mptcp_lib_kallsyms_has "subflow_rebuild_header$"; then
-		pm_nl_set_limits $ns1 0 2
-		pm_nl_set_limits $ns2 2 2
+		pm_nl_set_limits $ns1 0 3
+		pm_nl_set_limits $ns2 3 3
 		pm_nl_add_endpoint $ns1 10.0.2.1 id 1 flags signal
 		# broadcast IP: no packet for this address will be received on ns1
 		pm_nl_add_endpoint $ns1 224.0.0.1 id 2 flags signal
+		pm_nl_add_endpoint $ns1 10.0.1.1 id 42 flags signal
 		run_tests $ns1 $ns2 10.0.1.1 4 0 0 speed_20 2>/dev/null &
 		local tests_pid=$!
 
@@ -3263,11 +3264,19 @@ userspace_tests()
 		pm_nl_add_endpoint $ns1 10.0.3.1 id 2 flags signal
 		wait_mpj $ns2
 		chk_subflow_nr "" "after re-add" 3
+
+		pm_nl_del_endpoint $ns1 42 10.0.1.1
+		sleep 0.5
+		chk_subflow_nr "" "after delete ID 0" 2
+
+		pm_nl_add_endpoint $ns1 10.0.1.1 id 99 flags signal
+		wait_mpj $ns2
+		chk_subflow_nr "" "after re-add" 3
 		kill_tests_wait
 
-		chk_join_nr 3 3 3
-		chk_add_nr 4 4
-		chk_rm_nr 2 1 invert
+		chk_join_nr 4 4 4
+		chk_add_nr 5 5
+		chk_rm_nr 3 2 invert
 	fi
 
 	# flush and re-add


