Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F5681C680;
	Mon,  4 Mar 2024 21:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587964; cv=none; b=UxUd4dT09tfAVOE3kPROgtJng9EB96dTg14yUUfFrm/FrbuBpO68acLhGAepX8msyF+OhM9V7YrIupEmGxWvrr2n8wq1KEtl/yTOeGrSXdGPYAVdU2YDO8NyllAHxbaY3db+SYJOWRKYc1WVgP/tNlbwMLrzpU/95hhgvRYtxI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587964; c=relaxed/simple;
	bh=x3hip2GW89ubS0opHHrv/ysdeI4IWXWZh3BH6Cv+QhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jH1y0ig8VhxiNafbzWlJSlvJbL10fVEtTg6+uABfXSoVFOPh/1NFX+QA54mxk38NhKc7UtWcymfGQQp9jSiiFh22v1aRIQH2nHz+aNIRJol2dtPueICHnw5y9J/p4zAfcfmWnJ1RWT4Seguflob6vcWdrmuAuOhxkJ5/3dcK/zQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wuk7+57m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wuk7+57m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BF1DC433F1;
	Mon,  4 Mar 2024 21:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587964;
	bh=x3hip2GW89ubS0opHHrv/ysdeI4IWXWZh3BH6Cv+QhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wuk7+57mj6SPRYrbFL5A7q15XvjhPUjuSL+bG76eiZ8w0RT2akjxoa6YnV3hjPpoT
	 i/Q8Q5sY1popZjojs2QYzXz/BMMoVV/bWfNW+BspbAGGjYqzMqyFdITeXyDugQ//U0
	 ptEUloJnMPe+VvnVz77585ATDg/UsAWxNyumi8qM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthieu Baerts <matttbe@kernel.org>,
	Geliang Tang <geliang.tang@suse.com>,
	Mat Martineau <martineau@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.7 158/162] selftests: mptcp: add chk_subflows_total helper
Date: Mon,  4 Mar 2024 21:23:43 +0000
Message-ID: <20240304211556.717533429@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geliang Tang <geliang.tang@suse.com>

commit 80775412882e273b8ef62124fae861cde8e6fb3d upstream.

This patch adds a new helper chk_subflows_total(), in it use the newly
added counter mptcpi_subflows_total to get the "correct" amount of
subflows, including the initial one.

To be compatible with old 'ss' or kernel versions not supporting this
counter, get the total subflows by listing TCP connections that are
MPTCP subflows:

    ss -ti state state established state syn-sent state syn-recv |
        grep -c tcp-ulp-mptcp.

Reviewed-by: Matthieu Baerts <matttbe@kernel.org>
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <martineau@kernel.org>
Link: https://lore.kernel.org/r/20231128-send-net-next-2023107-v4-3-8d6b94150f6b@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |   42 +++++++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -1843,7 +1843,7 @@ chk_mptcp_info()
 	local cnt2
 	local dump_stats
 
-	print_check "mptcp_info ${info1:0:8}=$exp1:$exp2"
+	print_check "mptcp_info ${info1:0:15}=$exp1:$exp2"
 
 	cnt1=$(ss -N $ns1 -inmHM | mptcp_lib_get_info_value "$info1" "$info1")
 	cnt2=$(ss -N $ns2 -inmHM | mptcp_lib_get_info_value "$info2" "$info2")
@@ -1864,6 +1864,42 @@ chk_mptcp_info()
 	fi
 }
 
+# $1: subflows in ns1 ; $2: subflows in ns2
+# number of all subflows, including the initial subflow.
+chk_subflows_total()
+{
+	local cnt1
+	local cnt2
+	local info="subflows_total"
+	local dump_stats
+
+	# if subflows_total counter is supported, use it:
+	if [ -n "$(ss -N $ns1 -inmHM | mptcp_lib_get_info_value $info $info)" ]; then
+		chk_mptcp_info $info $1 $info $2
+		return
+	fi
+
+	print_check "$info $1:$2"
+
+	# if not, count the TCP connections that are in fact MPTCP subflows
+	cnt1=$(ss -N $ns1 -ti state established state syn-sent state syn-recv |
+	       grep -c tcp-ulp-mptcp)
+	cnt2=$(ss -N $ns2 -ti state established state syn-sent state syn-recv |
+	       grep -c tcp-ulp-mptcp)
+
+	if [ "$1" != "$cnt1" ] || [ "$2" != "$cnt2" ]; then
+		fail_test "got subflows $cnt1:$cnt2 expected $1:$2"
+		dump_stats=1
+	else
+		print_ok
+	fi
+
+	if [ "$dump_stats" = 1 ]; then
+		ss -N $ns1 -ti
+		ss -N $ns2 -ti
+	fi
+}
+
 chk_link_usage()
 {
 	local ns=$1
@@ -3407,10 +3443,12 @@ userspace_tests()
 		chk_join_nr 1 1 1
 		chk_add_nr 1 1
 		chk_mptcp_info subflows 1 subflows 1
+		chk_subflows_total 2 2
 		chk_mptcp_info add_addr_signal 1 add_addr_accepted 1
 		userspace_pm_rm_sf_addr_ns1 10.0.2.1 10
 		chk_rm_nr 1 1 invert
 		chk_mptcp_info subflows 0 subflows 0
+		chk_subflows_total 1 1
 		kill_events_pids
 		mptcp_lib_kill_wait $tests_pid
 	fi
@@ -3427,9 +3465,11 @@ userspace_tests()
 		userspace_pm_add_sf 10.0.3.2 20
 		chk_join_nr 1 1 1
 		chk_mptcp_info subflows 1 subflows 1
+		chk_subflows_total 2 2
 		userspace_pm_rm_sf_addr_ns2 10.0.3.2 20
 		chk_rm_nr 1 1
 		chk_mptcp_info subflows 0 subflows 0
+		chk_subflows_total 1 1
 		kill_events_pids
 		mptcp_lib_kill_wait $tests_pid
 	fi


