Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88700194A60;
	Thu,  5 Sep 2024 09:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529440; cv=none; b=WD0uML4Nvf+dxevtxpUMIg14dAKAwdlFajfch8mN67AzdBtczVJlpUU93+Dk7tjdupIimkBm1UOaCKBazMfYetM9zetJvcEyhSHHFYb9F/NSoT6By3dgs8/FkPegfPEyqdfxqlTzvfqesXBB01sZP+iV/LEx9FloZEUe1/wClaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529440; c=relaxed/simple;
	bh=7oFF82MaUCXIDKWwI0wXfc97OvOk1ZUuecmP2OU5L8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HWLy6gfO72fkqbdV+1lrqMsiXU5YjJijlKma8qc+FYxrwo7jw+HtP1NT0tTn4PgppAR7NNhjj5fyMl8k5HKBJ1JipfzJTpJKhpVou9P5J2K8NnNUn4EhO6gsc68Pe3WvKUlx9xN7RVJjBezrqYXyFMVWiEwP+Rwuz8AQuNU/4Dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j65EX1+l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j65EX1+l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60FE6C4CEC6;
	Thu,  5 Sep 2024 09:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529440;
	bh=7oFF82MaUCXIDKWwI0wXfc97OvOk1ZUuecmP2OU5L8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j65EX1+lwRmpS1uIBv5omyMGSYaP/JYpzGIbuTyZyUMuRI5hPgnbFIMyouiwQ7fpp
	 95kNJCp4u+qhvySOWOGHHoiluY1bI7Ec9TfmOvn0W08JbuhPDO+5ABTh2HionzphEC
	 kfo4jgQBzI24Qj63RfqFP8aYX6JH6MF9sLLe//Yc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 034/184] selftests: mptcp: add explicit test case for remove/readd
Date: Thu,  5 Sep 2024 11:39:07 +0200
Message-ID: <20240905093733.579703966@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit b5e2fb832f48bc01d937a053e0550a1465a2f05d ]

Delete and re-create a signal endpoint and ensure that the PM
actually deletes and re-create the subflow.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 1c2326fcae4f ("selftests: mptcp: join: check re-adding init endp with != id")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/net/mptcp/mptcp_join.sh | 29 +++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index c0ba79a8ad6da..fb2d8326109ef 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -3626,6 +3626,35 @@ endpoint_tests()
 		chk_join_nr 6 6 6
 		chk_rm_nr 4 4
 	fi
+
+	# remove and re-add
+	if reset "delete re-add signal" &&
+	   mptcp_lib_kallsyms_has "subflow_rebuild_header$"; then
+		pm_nl_set_limits $ns1 1 1
+		pm_nl_set_limits $ns2 1 1
+		pm_nl_add_endpoint $ns1 10.0.2.1 id 1 flags signal
+		test_linkfail=4 speed=20 \
+			run_tests $ns1 $ns2 10.0.1.1 &
+		local tests_pid=$!
+
+		wait_mpj $ns2
+		pm_nl_check_endpoint "creation" \
+			$ns1 10.0.2.1 id 1 flags signal
+		chk_subflow_nr "before delete" 2
+		chk_mptcp_info subflows 1 subflows 1
+
+		pm_nl_del_endpoint $ns1 1 10.0.2.1
+		sleep 0.5
+		chk_subflow_nr "after delete" 1
+		chk_mptcp_info subflows 0 subflows 0
+
+		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
+		wait_mpj $ns2
+		chk_subflow_nr "after re-add" 2
+		chk_mptcp_info subflows 1 subflows 1
+		mptcp_lib_kill_wait $tests_pid
+	fi
+
 }
 
 # [$1: error message]
-- 
2.43.0



