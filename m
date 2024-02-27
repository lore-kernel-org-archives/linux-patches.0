Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A217C13B293;
	Tue, 27 Feb 2024 13:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041107; cv=none; b=kVl2D8Lmt286JXO53XAWJqmMWdbOv5mR1M0PTuka2wp5Ssmter03STZJSezXyyjT41hdTSHfzTBcfeeSBOOCzH+Cmk+nXM0YM0VaVVopE3IfQvAzqhpiezZwNZZ+WgsmongU4S3Khb9QSu4la6dU5DXKEixhZWCZ8u8u4o/Qfj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041107; c=relaxed/simple;
	bh=uhTJAWCB3Ky5zPzvdWhavVHe6QdpFLQSBvOsv5lZXuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r+8zOuzkQMYR2F+iqlW9WWH9RaTVh7K2woyHpiZYsFTZ9qjDplWuPCoYwyp9q08hsRcEc6Rybop8gihDU1mcpd4xZjhfWp9sZBuVE3rROQZeL7JHcFxAexdgFvZ0etBCOxjgdbrZ8ShfeHTvCLhjyz8zv2aDdRwZ9lvG5J1tRsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q0ASkMia; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q0ASkMia"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3494FC433F1;
	Tue, 27 Feb 2024 13:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041107;
	bh=uhTJAWCB3Ky5zPzvdWhavVHe6QdpFLQSBvOsv5lZXuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q0ASkMiafeH7UjoRHny3g3HtXDhz9jZkwcH6YVCQTCftlBxzzLm1QaUynYF4f+wBY
	 J3sCYK5PcxWRkk9LWEflkm2JTs+2ENZ+cSwg2U7NOvqdCdIxengolB0MEpqE8iuAuh
	 ALpnAMtpvKBL1EcdOZiy01q6j4An0dPiYcaTRAzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang.tang@linux.dev>,
	Matthieu Baerts <matttbe@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.7 223/334] selftests: mptcp: diag: check CURRESTAB counters
Date: Tue, 27 Feb 2024 14:21:21 +0100
Message-ID: <20240227131637.975728380@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

From: Geliang Tang <geliang.tang@linux.dev>

commit 81ab772819da408977ac79c0a17d8be57283379f upstream.

This patch adds a new helper chk_msk_cestab() to check the current
established connections counter MIB_CURRESTAB in diag.sh. Invoke it
to check the counter during the connection after every chk_msk_inuse().

Signed-off-by: Geliang Tang <geliang.tang@linux.dev>
Reviewed-by: Matthieu Baerts <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts <matttbe@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/diag.sh |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/net/mptcp/diag.sh
+++ b/tools/testing/selftests/net/mptcp/diag.sh
@@ -56,7 +56,7 @@ __chk_nr()
 	local command="$1"
 	local expected=$2
 	local msg="$3"
-	local skip="${4:-SKIP}"
+	local skip="${4-SKIP}"
 	local nr
 
 	nr=$(eval $command)
@@ -199,6 +199,15 @@ wait_local_port_listen()
 	done
 }
 
+# $1: cestab nr
+chk_msk_cestab()
+{
+	local cestab=$1
+
+	__chk_nr "mptcp_lib_get_counter ${ns} MPTcpExtMPCurrEstab" \
+		 "${cestab}" "....chk ${cestab} cestab" ""
+}
+
 wait_connected()
 {
 	local listener_ns="${1}"
@@ -236,9 +245,11 @@ chk_msk_nr 2 "after MPC handshake "
 chk_msk_remote_key_nr 2 "....chk remote_key"
 chk_msk_fallback_nr 0 "....chk no fallback"
 chk_msk_inuse 2 "....chk 2 msk in use"
+chk_msk_cestab 2
 flush_pids
 
 chk_msk_inuse 0 "....chk 0 msk in use after flush"
+chk_msk_cestab 0
 
 echo "a" | \
 	timeout ${timeout_test} \
@@ -254,9 +265,11 @@ echo "b" | \
 wait_connected $ns 10001
 chk_msk_fallback_nr 1 "check fallback"
 chk_msk_inuse 1 "....chk 1 msk in use"
+chk_msk_cestab 1
 flush_pids
 
 chk_msk_inuse 0 "....chk 0 msk in use after flush"
+chk_msk_cestab 0
 
 NR_CLIENTS=100
 for I in `seq 1 $NR_CLIENTS`; do
@@ -278,9 +291,11 @@ done
 
 wait_msk_nr $((NR_CLIENTS*2)) "many msk socket present"
 chk_msk_inuse $((NR_CLIENTS*2)) "....chk many msk in use"
+chk_msk_cestab $((NR_CLIENTS*2))
 flush_pids
 
 chk_msk_inuse 0 "....chk 0 msk in use after flush"
+chk_msk_cestab 0
 
 mptcp_lib_result_print_all_tap
 exit $ret


