Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70D9413B2B4;
	Tue, 27 Feb 2024 13:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042160; cv=none; b=bXiiwyJ3qEW8KlI5VTjn5CYpX9IjQizZnqsc6d573FGXge7kkSorAYyxwykZxqPcfI8zGosprn5Hz4tDK7D5YhvnzebcuVGAqp69JtpejYf4xXhHcE3i5aQFWMMfcFBZ29Z98fjK6YgUuzwurWj0apbqbyBuWRFPnSFpWoI68bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042160; c=relaxed/simple;
	bh=DXCFCVB0RcsVIRF6o4lQqWjhRCUWl9AZSw3Nep74ZhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m+I14Nkfb75qmqjytr3sZ8u1V8vXiK/BRHXSWywVR7lUYKaX1xySseIbo6ew1kuBfncg0duCyXruphkEb5IqthgevDgXKxNo+FArMWGuTAZ0fy4Fk9jmHzz3cKezenULCnQF165xHZpqEH9g4rLNPcDQkmsbpKlZqDw3eSb1DNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N2EQW/Cr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N2EQW/Cr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F251CC433F1;
	Tue, 27 Feb 2024 13:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042160;
	bh=DXCFCVB0RcsVIRF6o4lQqWjhRCUWl9AZSw3Nep74ZhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N2EQW/Crhs13UmKNJ38+5GZHifVHqwJAuZkQAETtI9DkALEYNIpVfZyN5BbTFoDMI
	 eSwqVCzD6sJ8I5fVjHvPDy6remt7gvlRIfPdnbLjVe5WsGzKvlI5jJdROOwC0MdKKF
	 WH7AEqkl7w9gsMDCBWxwBpA2Rt887o6M3gGsyuMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang.tang@linux.dev>,
	Matthieu Baerts <matttbe@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.6 201/299] selftests: mptcp: diag: check CURRESTAB counters
Date: Tue, 27 Feb 2024 14:25:12 +0100
Message-ID: <20240227131632.277580088@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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


