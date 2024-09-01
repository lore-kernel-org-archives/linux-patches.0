Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2EBB143C6E;
	Sun,  1 Sep 2024 16:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207931; cv=none; b=TPjimLJcwDsw6pxgO8Tb6vgcRTkhUnnO3YhJVxJlFkYZ9Gh3z81dHJXT/4teAbFSK4jlCX3BjVl5OcEUuhC57RYgLFPJdW/jUpfxSHhFWizQHPJrcBg7dI2gteGfGerSeJMYcYdtGd5w6MaJ1yZT0Wa+OIAXAbs+Ryb1YxfYOEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207931; c=relaxed/simple;
	bh=MNbxKstlr0o7CmhBA6NhWp8hRr4a0eLwsABiKWdyj0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i2xGv4E8TQO0pHoUPiy3wPzlk29IMy8dKW1yncw4FS3lbp9Zpr9uHeILu/36+utWYhtShMj42OX0dcuZ+zVFDPTjpdYeAEIj/Pg1FVekRv1pA3mr8AJnTW8j7WqyaW4DI2ZEjMlqMAXX502TzWVxfgQwZktAumUnWkwIJpqO0BI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VmbKAm3u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VmbKAm3u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 407BEC4CEC3;
	Sun,  1 Sep 2024 16:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207931;
	bh=MNbxKstlr0o7CmhBA6NhWp8hRr4a0eLwsABiKWdyj0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VmbKAm3uNdgxbZeW2F5/QgBzs1ZkuzGEpdyr39OOfG0AZjX/evfOkKJaaYo23kuKC
	 IA9l5AV2yCvFX4XWzxT3G3m2sb5eSogqcq4KIDd8Rd8ni6HVgw3v/u+ySfwz/EPgMZ
	 GCKH46MBx5hbTEtgJgoS2DtHrc7VV8qudy8gg2HU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 21/93] selftests: mptcp: join: check removing ID 0 endpoint
Date: Sun,  1 Sep 2024 18:16:08 +0200
Message-ID: <20240901160808.158105680@linuxfoundation.org>
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

commit 5f94b08c001290acda94d9d8868075590931c198 upstream.

Removing the endpoint linked to the initial subflow should trigger a
RM_ADDR for the right ID, and the removal of the subflow. That's what is
now being verified in the "delete and re-add" test.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |   25 +++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -3578,8 +3578,9 @@ endpoint_tests()
 
 	if reset_with_tcp_filter "delete and re-add" ns2 10.0.3.2 REJECT OUTPUT &&
 	   mptcp_lib_kallsyms_has "subflow_rebuild_header$"; then
-		pm_nl_set_limits $ns1 0 2
-		pm_nl_set_limits $ns2 0 2
+		pm_nl_set_limits $ns1 0 3
+		pm_nl_set_limits $ns2 0 3
+		pm_nl_add_endpoint $ns2 10.0.1.2 id 1 dev ns2eth1 flags subflow
 		pm_nl_add_endpoint $ns2 10.0.2.2 id 2 dev ns2eth2 flags subflow
 		test_linkfail=4 speed=20 \
 			run_tests $ns1 $ns2 10.0.1.1 &
@@ -3588,17 +3589,17 @@ endpoint_tests()
 		wait_mpj $ns2
 		pm_nl_check_endpoint "creation" \
 			$ns2 10.0.2.2 id 2 flags subflow dev ns2eth2
-		chk_subflow_nr "before delete" 2
+		chk_subflow_nr "before delete id 2" 2
 		chk_mptcp_info subflows 1 subflows 1
 
 		pm_nl_del_endpoint $ns2 2 10.0.2.2
 		sleep 0.5
-		chk_subflow_nr "after delete" 1
+		chk_subflow_nr "after delete id 2" 1
 		chk_mptcp_info subflows 0 subflows 0
 
 		pm_nl_add_endpoint $ns2 10.0.2.2 id 2 dev ns2eth2 flags subflow
 		wait_mpj $ns2
-		chk_subflow_nr "after re-add" 2
+		chk_subflow_nr "after re-add id 2" 2
 		chk_mptcp_info subflows 1 subflows 1
 
 		pm_nl_add_endpoint $ns2 10.0.3.2 id 3 flags subflow
@@ -3613,10 +3614,20 @@ endpoint_tests()
 		chk_subflow_nr "after no reject" 3
 		chk_mptcp_info subflows 2 subflows 2
 
+		pm_nl_del_endpoint $ns2 1 10.0.1.2
+		sleep 0.5
+		chk_subflow_nr "after delete id 0" 2
+		chk_mptcp_info subflows 2 subflows 2 # only decr for additional sf
+
+		pm_nl_add_endpoint $ns2 10.0.1.2 id 1 dev ns2eth1 flags subflow
+		wait_mpj $ns2
+		chk_subflow_nr "after re-add id 0" 3
+		chk_mptcp_info subflows 3 subflows 3
+
 		mptcp_lib_kill_wait $tests_pid
 
-		chk_join_nr 3 3 3
-		chk_rm_nr 1 1
+		chk_join_nr 4 4 4
+		chk_rm_nr 2 2
 	fi
 }
 


