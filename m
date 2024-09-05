Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F135195FCE;
	Thu,  5 Sep 2024 09:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529452; cv=none; b=kifTUZTb+8sh+VB+0hIQqmkeSBCP+l8JSRkoIp5WumvPMxbnO2E16CbPa6/nSQdQXwTdJczcAQr9+H+GEH/X/M5PGTRDdXbJTi+xbojdTHa0R/v5ZFsNGGfLxSSuxe86RMYeGsY1q5KYtZB+iF2F7JaOwpdBylc4w+yz8WeON/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529452; c=relaxed/simple;
	bh=KGmB07st3Jl/kNHhzprXo2N/VwhQftg0/qgntI4xweo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D6IG/qlYcZV7dAu302vXMoFHswIBuCIl3U3nnyLApJ47ygjbPZyMoz/UkCqWvRZG8urab8V5jxXiT2kmRrVcBPR5a/LmrNKoXL1t1MDI/vDBejHSPK0hrwnHn6WZH0zm4XRrUiVFsAcT0EnPW0pV01m1Z8ekzyyJrZPyx/CJyOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oBaWqsmC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oBaWqsmC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88F5FC4CEC3;
	Thu,  5 Sep 2024 09:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529451;
	bh=KGmB07st3Jl/kNHhzprXo2N/VwhQftg0/qgntI4xweo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oBaWqsmC0vpof/xioxhgVHQTie3FKzOo5fPzShrw5QWQ0v+qhLLd1mw5vgehaiQSm
	 xO4uhPm1qzXf8eXX4AU1LNTaZQ9cdfo19Wn6Lh+FgzWoj0Np04jfa/7ZQA+7b/aDrF
	 0RdxSC7hMCkBTjh9xhYjNEdwPsMg43OFfdPx5vw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 038/184] selftests: mptcp: join: check re-re-adding ID 0 signal
Date: Thu,  5 Sep 2024 11:39:11 +0200
Message-ID: <20240905093733.736507774@linuxfoundation.org>
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

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

[ Upstream commit f18fa2abf81099d822d842a107f8c9889c86043c ]

This test extends "delete re-add signal" to validate the previous
commit: when the 'signal' endpoint linked to the initial subflow (ID 0)
is re-added multiple times, it will re-send the ADD_ADDR with id 0. The
client should still be able to re-create this subflow, even if the
add_addr_accepted limit has been reached as this special address is not
considered as a new address.

The 'Fixes' tag here below is the same as the one from the previous
commit: this patch here is not fixing anything wrong in the selftests,
but it validates the previous fix for an issue introduced by this commit
ID.

Fixes: d0876b2284cf ("mptcp: add the incoming RM_ADDR support")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/net/mptcp/mptcp_join.sh | 32 ++++++++++++-------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index 73f9db065788e..3b65c462d6ddc 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -3688,7 +3688,7 @@ endpoint_tests()
 		# broadcast IP: no packet for this address will be received on ns1
 		pm_nl_add_endpoint $ns1 224.0.0.1 id 2 flags signal
 		pm_nl_add_endpoint $ns1 10.0.1.1 id 42 flags signal
-		test_linkfail=4 speed=20 \
+		test_linkfail=4 speed=5 \
 			run_tests $ns1 $ns2 10.0.1.1 &
 		local tests_pid=$!
 
@@ -3717,7 +3717,17 @@ endpoint_tests()
 
 		pm_nl_add_endpoint $ns1 10.0.1.1 id 99 flags signal
 		wait_mpj $ns2
-		chk_subflow_nr "after re-add" 3
+		chk_subflow_nr "after re-add ID 0" 3
+		chk_mptcp_info subflows 3 subflows 3
+
+		pm_nl_del_endpoint $ns1 99 10.0.1.1
+		sleep 0.5
+		chk_subflow_nr "after re-delete ID 0" 2
+		chk_mptcp_info subflows 2 subflows 2
+
+		pm_nl_add_endpoint $ns1 10.0.1.1 id 88 flags signal
+		wait_mpj $ns2
+		chk_subflow_nr "after re-re-add ID 0" 3
 		chk_mptcp_info subflows 3 subflows 3
 		mptcp_lib_kill_wait $tests_pid
 
@@ -3727,19 +3737,19 @@ endpoint_tests()
 		chk_evt_nr ns1 MPTCP_LIB_EVENT_ESTABLISHED 1
 		chk_evt_nr ns1 MPTCP_LIB_EVENT_ANNOUNCED 0
 		chk_evt_nr ns1 MPTCP_LIB_EVENT_REMOVED 0
-		chk_evt_nr ns1 MPTCP_LIB_EVENT_SUB_ESTABLISHED 4
-		chk_evt_nr ns1 MPTCP_LIB_EVENT_SUB_CLOSED 2
+		chk_evt_nr ns1 MPTCP_LIB_EVENT_SUB_ESTABLISHED 5
+		chk_evt_nr ns1 MPTCP_LIB_EVENT_SUB_CLOSED 3
 
 		chk_evt_nr ns2 MPTCP_LIB_EVENT_CREATED 1
 		chk_evt_nr ns2 MPTCP_LIB_EVENT_ESTABLISHED 1
-		chk_evt_nr ns2 MPTCP_LIB_EVENT_ANNOUNCED 5
-		chk_evt_nr ns2 MPTCP_LIB_EVENT_REMOVED 3
-		chk_evt_nr ns2 MPTCP_LIB_EVENT_SUB_ESTABLISHED 4
-		chk_evt_nr ns2 MPTCP_LIB_EVENT_SUB_CLOSED 2
+		chk_evt_nr ns2 MPTCP_LIB_EVENT_ANNOUNCED 6
+		chk_evt_nr ns2 MPTCP_LIB_EVENT_REMOVED 4
+		chk_evt_nr ns2 MPTCP_LIB_EVENT_SUB_ESTABLISHED 5
+		chk_evt_nr ns2 MPTCP_LIB_EVENT_SUB_CLOSED 3
 
-		chk_join_nr 4 4 4
-		chk_add_nr 5 5
-		chk_rm_nr 3 2 invert
+		chk_join_nr 5 5 5
+		chk_add_nr 6 6
+		chk_rm_nr 4 3 invert
 	fi
 
 }
-- 
2.43.0



