Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A982197A77;
	Thu,  5 Sep 2024 09:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529455; cv=none; b=iVpe9IlSoizfpZhj/MmByc5bvWDE58XmDWMc6zZboBQgaAQK3J5QsnE6vnUTM5PfrSLPh76z0BlNtn5FLYXipMGARUd6ITY/bjLr52SGbqXRpeM8mZXBAvvdRuxfPTU9HqcDJSMRzTPi6HYU1qaxNsfuWaQyrh6+R8gd5iKbrzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529455; c=relaxed/simple;
	bh=Ho6TRf3bAJNdmqY4PShiZDvcDdmCPaplCFl1JHtY5Do=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gf1bBl8yhvr1RAJsKhBgWcVyyTkqBkL3MBr8Iecnmx49Xy/EWXufPKcYcLGoDvbZISKD2Mklvmp09zHOSsAKY4NBqRw9KwKnkZxBojPSPPglXtbqG5Vz5HYv8xpCgzVBNbImNuMqUhmHbaxIKxE2S9QyyoGL/8uSKjSGtnBQzXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y224dx24; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y224dx24"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DEFAC4CEC3;
	Thu,  5 Sep 2024 09:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529455;
	bh=Ho6TRf3bAJNdmqY4PShiZDvcDdmCPaplCFl1JHtY5Do=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y224dx24M6H435tSgr9whIXh9vxhL/i/nvcq3pb2xYOR6rJYbVvjeZcq1QJr7OGYg
	 Z06WanshRGOHFr3HKwwQtnxnBCTuawiiWaJZS4vS3vSgKAZDIAzXDrsuXYxdm4j2DQ
	 7rKRJI+zXE0Fv4O/SM5/hKg44J9isQCSWkvAN3ZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.10 039/184] selftests: mptcp: join: test for flush/re-add endpoints
Date: Thu,  5 Sep 2024 11:39:12 +0200
Message-ID: <20240905093733.775036193@linuxfoundation.org>
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

commit e06959e9eebdfea4654390f53b65cff57691872e upstream.

After having flushed endpoints that didn't cause the creation of new
subflows, it is important to check endpoints can be re-created, re-using
previously used IDs.

Before the previous commit, the client would not have been able to
re-create the subflow that was previously rejected.

The 'Fixes' tag here below is the same as the one from the previous
commit: this patch here is not fixing anything wrong in the selftests,
but it validates the previous fix for an issue introduced by this commit
ID.

Fixes: 06faa2271034 ("mptcp: remove multi addresses and subflows in PM")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20240819-net-mptcp-pm-reusing-id-v1-6-38035d40de5b@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |   30 ++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -3752,6 +3752,36 @@ endpoint_tests()
 		chk_rm_nr 4 3 invert
 	fi
 
+	# flush and re-add
+	if reset_with_tcp_filter "flush re-add" ns2 10.0.3.2 REJECT OUTPUT &&
+	   mptcp_lib_kallsyms_has "subflow_rebuild_header$"; then
+		pm_nl_set_limits $ns1 0 2
+		pm_nl_set_limits $ns2 1 2
+		# broadcast IP: no packet for this address will be received on ns1
+		pm_nl_add_endpoint $ns1 224.0.0.1 id 2 flags signal
+		pm_nl_add_endpoint $ns2 10.0.3.2 id 3 flags subflow
+		test_linkfail=4 speed=20 \
+			run_tests $ns1 $ns2 10.0.1.1 &
+		local tests_pid=$!
+
+		wait_attempt_fail $ns2
+		chk_subflow_nr "before flush" 1
+		chk_mptcp_info subflows 0 subflows 0
+
+		pm_nl_flush_endpoint $ns2
+		pm_nl_flush_endpoint $ns1
+		wait_rm_addr $ns2 0
+		ip netns exec "${ns2}" ${iptables} -D OUTPUT -s "10.0.3.2" -p tcp -j REJECT
+		pm_nl_add_endpoint $ns2 10.0.3.2 id 3 flags subflow
+		wait_mpj $ns2
+		pm_nl_add_endpoint $ns1 10.0.3.1 id 2 flags signal
+		wait_mpj $ns2
+		mptcp_lib_kill_wait $tests_pid
+
+		chk_join_nr 2 2 2
+		chk_add_nr 2 2
+		chk_rm_nr 1 0 invert
+	fi
 }
 
 # [$1: error message]


