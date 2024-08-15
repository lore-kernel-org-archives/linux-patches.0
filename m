Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E95A1A2C04;
	Thu, 15 Aug 2024 14:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730602; cv=none; b=oyIVdYA8n5xqYDDcb4MVhNcoN/zO5WiUVa0YGe1JdRSx+6tOj9zK6a7L8mPRB5S3iTc+q4BlMV+XHNJM+Bx5IPXNZWsxtz9SUdiz/UC7/v8l31PZX88qTJ0k+asKLnAYixv1KO06qKoBR3ud1eST4HZuJ1VvU/3OEl4xqJSAEVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730602; c=relaxed/simple;
	bh=VA/Ukhh0Ir+U/9WJ47WQO9JoGge/M7HKEfRIsgWET00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U+XWihYDQgY3o8bdOWi6KqQ4Va0OnlGfFW4RGVJCfZUTAGuW/nL6Yn627mQrljVAxdMPtgt5B4Z81Gz3TFGKyZUeePR1AULDvcP7TPEdgUJejOrWNfGtcHELpBQkxVy4T6/hJQm6TSf1vwuTJZ3M0/dfNOyYioNehgpVu0ycWrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=toMAH4mt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="toMAH4mt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A22C3C32786;
	Thu, 15 Aug 2024 14:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730602;
	bh=VA/Ukhh0Ir+U/9WJ47WQO9JoGge/M7HKEfRIsgWET00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=toMAH4mtWJQah8EFbnzsNwJx7WpWl5EVIONJO4ziziRKTJL7WE96GVAUc+GMEIcur
	 hVmSlUY1eoDMF719uZ1b9zDkn/o/cmeMA8sltmNhQCMcHz/wxPP1XdSm+RDLX/2PQ2
	 MnjXE+czu2EA14oL5PijVTQix0oV8jTrV7EXxnU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 459/484] selftests: mptcp: join: validate backup in MPJ
Date: Thu, 15 Aug 2024 15:25:17 +0200
Message-ID: <20240815131959.200537661@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

commit 935ff5bb8a1cfcdf8e60c8f5c794d0bbbc234437 upstream.

A peer can notify the other one that a subflow has to be treated as
"backup" by two different ways: either by sending a dedicated MP_PRIO
notification, or by setting the backup flag in the MP_JOIN handshake.

The selftests were previously monitoring the former, but not the latter.
This is what is now done here by looking at these new MIB counters when
validating the 'backup' cases:

  MPTcpExtMPJoinSynBackupRx
  MPTcpExtMPJoinSynAckBackupRx

The 'Fixes' tag here below is the same as the one from the previous
commit: this patch here is not fixing anything wrong in the selftests,
but it will help to validate a new fix for an issue introduced by this
commit ID.

Fixes: 4596a2c1b7f5 ("mptcp: allow creating non-backup subflows")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
[ Conflicts in mptcp_join.sh because the check are done has changed,
  e.g. in commit 03668c65d153 ("selftests: mptcp: join: rework detailed
  report"), or commit 985de45923e2 ("selftests: mptcp: centralize stats
  dumping"), etc. Adaptations have been made to use the old way, similar
  to what is done just above.
  Also, in this version, some subtests are missing. Only the two using
  chk_prio_nr() have been modified. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |   30 ++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -925,6 +925,8 @@ chk_prio_nr()
 {
 	local mp_prio_nr_tx=$1
 	local mp_prio_nr_rx=$2
+	local mpj_syn=$3
+	local mpj_syn_ack=$4
 	local count
 	local dump_stats
 
@@ -952,6 +954,30 @@ chk_prio_nr()
 		echo "[ ok ]"
 	fi
 
+	printf "%-39s %s" " " "bkp syn"
+	count=$(get_counter ${ns1} "MPTcpExtMPJoinSynBackupRx")
+	if [ -z "$count" ]; then
+		echo -n "[skip]"
+	elif [ "$count" != "$mpj_syn" ]; then
+		echo "[fail] got $count JOIN[s] syn with Backup expected $mpj_syn"
+		ret=1
+		dump_stats=1
+	else
+		echo -n "[ ok ]"
+	fi
+
+	echo -n " - synack   "
+	count=$(get_counter ${ns2} "MPTcpExtMPJoinSynAckBackupRx")
+	if [ -z "$count" ]; then
+		echo "[skip]"
+	elif [ "$count" != "$mpj_syn_ack" ]; then
+		echo "[fail] got $count JOIN[s] synack with Backup expected $mpj_syn_ack"
+		ret=1
+		dump_stats=1
+	else
+		echo "[ ok ]"
+	fi
+
 	if [ "${dump_stats}" = 1 ]; then
 		echo Server ns stats
 		ip netns exec $ns1 nstat -as | grep MPTcp
@@ -1557,7 +1583,7 @@ backup_tests()
 	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow,backup
 	run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow nobackup
 	chk_join_nr "single subflow, backup" 1 1 1
-	chk_prio_nr 0 1
+	chk_prio_nr 0 1 1 0
 
 	# single address, backup
 	reset
@@ -1567,7 +1593,7 @@ backup_tests()
 	run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow backup
 	chk_join_nr "single address, backup" 1 1 1
 	chk_add_nr 1 1
-	chk_prio_nr 1 0
+	chk_prio_nr 1 0 0 0
 }
 
 add_addr_ports_tests()


