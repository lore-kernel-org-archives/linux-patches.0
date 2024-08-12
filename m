Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01F151EA8D;
	Mon, 12 Aug 2024 16:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479099; cv=none; b=OzrUToCy8uQ5YLpFcV3puE7/L9UOvFYSQzIFLImxNvpUSSS+orFwVIq0lUO9kaYMzaulYKzCvRqQWB3iX/DguQDZtrMI/Gp+QenxNEk+2ekjO0UuDGRJCdIkVuri+xeRZVz/6w/9CRo+e8idenDUepTBbuP7qCJIBQESfLhOu+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479099; c=relaxed/simple;
	bh=5et3lvq2qn9mmMtMcg6NzHzED7gRKvkraHKGsT5p9H0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lcselUUBqww4ewWZzOjDScMbgQr7LQOr1ZW4yoVSh8faB+ON/sFHTdS2vSCksRX83K490TtmGIIX5nEVeohvcpSQRYr4mDKOvaAJcU9Nkkh4qneVTnFgwngFV/qRuZD4AplByg0+LOSefiN2nyOQs2lja/g5c5QZe/B6bYQwSoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LblySNrB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LblySNrB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B2B6C32782;
	Mon, 12 Aug 2024 16:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479098;
	bh=5et3lvq2qn9mmMtMcg6NzHzED7gRKvkraHKGsT5p9H0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LblySNrBIdo2pYWQWr2KOTYozmRSxW1d8jv3inUlhCWsNxYsrlUX8SLnSDlAws1WG
	 eDE0/XtWnl/dDFZiKONsB7LwN2h1J/Hhw0UkSb8wKjs+GbmMoVJ9whnXVF6D+VG1Dj
	 i9o1owsD4Sij3iUnJ06VU/rVgU27j8p07jOBnRLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.1 133/150] selftests: mptcp: join: check backup support in signal endp
Date: Mon, 12 Aug 2024 18:03:34 +0200
Message-ID: <20240812160130.301430254@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
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

commit f833470c27832136d4416d8fc55d658082af0989 upstream.

Before the previous commit, 'signal' endpoints with the 'backup' flag
were ignored when sending the MP_JOIN.

The MPTCP Join selftest has then been modified to validate this case:
the "single address, backup" test, is now validating the MP_JOIN with a
backup flag as it is what we expect it to do with such name. The
previous version has been kept, but renamed to "single address, switch
to backup" to avoid confusions.

The "single address with port, backup" test is also now validating the
MPJ with a backup flag, which makes more sense than checking the switch
to backup with an MP_PRIO.

The "mpc backup both sides" test is now validating that the backup flag
is also set in MP_JOIN from and to the addresses used in the initial
subflow, using the special ID 0.

The 'Fixes' tag here below is the same as the one from the previous
commit: this patch here is not fixing anything wrong in the selftests,
but it validates the previous fix for an issue introduced by this commit
ID.

Fixes: 4596a2c1b7f5 ("mptcp: allow creating non-backup subflows")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
[ Conflicts in mptcp_join.sh because 'run_tests' helper has been
  modified in multiple commits that are not in this version, e.g. commit
  e571fb09c893 ("selftests: mptcp: add speed env var"). Adaptations
  have been made to use the old way, similar to what is done around. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |   33 +++++++++++++++++++-----
 1 file changed, 27 insertions(+), 6 deletions(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -2666,6 +2666,18 @@ backup_tests()
 	if reset "single address, backup" &&
 	   continue_if mptcp_lib_kallsyms_has "subflow_rebuild_header$"; then
 		pm_nl_set_limits $ns1 0 1
+		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal,backup
+		pm_nl_set_limits $ns2 1 1
+		run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow nobackup
+		chk_join_nr 1 1 1
+		chk_add_nr 1 1
+		chk_prio_nr 1 0 0 1
+	fi
+
+	# single address, switch to backup
+	if reset "single address, switch to backup" &&
+	   continue_if mptcp_lib_kallsyms_has "subflow_rebuild_header$"; then
+		pm_nl_set_limits $ns1 0 1
 		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
 		pm_nl_set_limits $ns2 1 1
 		run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow backup
@@ -2678,12 +2690,12 @@ backup_tests()
 	if reset "single address with port, backup" &&
 	   continue_if mptcp_lib_kallsyms_has "subflow_rebuild_header$"; then
 		pm_nl_set_limits $ns1 0 1
-		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal port 10100
+		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal,backup port 10100
 		pm_nl_set_limits $ns2 1 1
-		run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow backup
+		run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow nobackup
 		chk_join_nr 1 1 1
 		chk_add_nr 1 1
-		chk_prio_nr 1 1 0 0
+		chk_prio_nr 1 0 0 1
 	fi
 
 	if reset "mpc backup" &&
@@ -2696,11 +2708,20 @@ backup_tests()
 
 	if reset "mpc backup both sides" &&
 	   continue_if mptcp_lib_kallsyms_doesnt_have "T mptcp_subflow_send_ack$"; then
-		pm_nl_add_endpoint $ns1 10.0.1.1 flags subflow,backup
+		pm_nl_set_limits $ns1 0 2
+		pm_nl_set_limits $ns2 1 2
+		pm_nl_add_endpoint $ns1 10.0.1.1 flags signal,backup
 		pm_nl_add_endpoint $ns2 10.0.1.2 flags subflow,backup
+
+		# 10.0.2.2 (non-backup) -> 10.0.1.1 (backup)
+		pm_nl_add_endpoint $ns2 10.0.2.2 flags subflow
+		# 10.0.1.2 (backup) -> 10.0.2.1 (non-backup)
+		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
+		ip -net "$ns2" route add 10.0.2.1 via 10.0.1.1 dev ns2eth1 # force this path
+
 		run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow
-		chk_join_nr 0 0 0
-		chk_prio_nr 1 1 0 0
+		chk_join_nr 2 2 2
+		chk_prio_nr 1 1 1 1
 	fi
 
 	if reset "mpc switch to backup" &&


