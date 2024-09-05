Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC383154BFF;
	Thu,  5 Sep 2024 09:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530127; cv=none; b=qwLv728D6cu/cPT+7gmZt/QJ3lpKea6DTw//HetIXduccnnneE5BzzJQHaqVCL2atbAZt4rg+jQtqblMV4M4DFRsYZz6DDwN0VqNfh34XBChO4hEiDeqYJdHDVM+u1nKNmtQj0L8qOcZEzFnECfqFAuuVH6KBmAVfNX/w4cP+BM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530127; c=relaxed/simple;
	bh=M3AOghXr3wmUFi3EZG7zXOdDKSzG9OQFvuE4WtftPto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C0FzY8AW17WT0p8T84wxP3ypgN20qPY9vWs7fM9/ivVZcE1nO1hGYmmSPIXBJcFIj+u8evk1uP1vn44gpsGUlTxj0xWwRIDHrcoIoV2mIuuOOhCCz9fJ17jFdjJlpG/zIwanBkwNbELJxKwEG6PGneMRRUEdlbK9XDY2DYc19kQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zMdPbOO8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zMdPbOO8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30D01C4CEC4;
	Thu,  5 Sep 2024 09:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530126;
	bh=M3AOghXr3wmUFi3EZG7zXOdDKSzG9OQFvuE4WtftPto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zMdPbOO8B//JZewLC+E32sNKazmqiAspGO5j8EVZ6oakO7loYuZL1U/0DOTT5CnmG
	 I+yFwArMf8A/SNbvcPuu4Yfd+6SMO6w4MA9WrZNRF4BKfC/z5NkvFkQXo5wRM222t6
	 QeB2cYO5LqIWZmE9KZUyMbjrJIaYgiadMQq8rkmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 031/132] selftests: mptcp: join: check re-adding init endp with != id
Date: Thu,  5 Sep 2024 11:40:18 +0200
Message-ID: <20240905093723.447299888@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
References: <20240905093722.230767298@linuxfoundation.org>
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

[ Upstream commit 1c2326fcae4f0c5de8ad0d734ced43a8e5f17dac ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/net/mptcp/mptcp_join.sh | 21 ++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index 67675ce3b9a38..0ff60b3744c06 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -3738,11 +3738,12 @@ endpoint_tests()
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
 		test_linkfail=4 speed=20 \
 			run_tests $ns1 $ns2 10.0.1.1 &
 		local tests_pid=$!
@@ -3764,11 +3765,21 @@ endpoint_tests()
 		wait_mpj $ns2
 		chk_subflow_nr "after re-add" 3
 		chk_mptcp_info subflows 2 subflows 2
+
+		pm_nl_del_endpoint $ns1 42 10.0.1.1
+		sleep 0.5
+		chk_subflow_nr "after delete ID 0" 2
+		chk_mptcp_info subflows 2 subflows 2
+
+		pm_nl_add_endpoint $ns1 10.0.1.1 id 99 flags signal
+		wait_mpj $ns2
+		chk_subflow_nr "after re-add" 3
+		chk_mptcp_info subflows 3 subflows 3
 		mptcp_lib_kill_wait $tests_pid
 
-		chk_join_nr 3 3 3
-		chk_add_nr 4 4
-		chk_rm_nr 2 1 invert
+		chk_join_nr 4 4 4
+		chk_add_nr 5 5
+		chk_rm_nr 3 2 invert
 	fi
 
 }
-- 
2.43.0



