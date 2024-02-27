Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F6F813B293;
	Tue, 27 Feb 2024 13:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041113; cv=none; b=eXHyBmPqddk0N8luAKMi12iqY0zDXRjyODEfM3n8xgwCGT+kYEBhkBLkhv5sCQ/FyGo+Ylezw4fBVIofU2539jdcbq14l9XS/U8FBQsxX6QbCzwTaQnU+e9EOX83/l18lQmI4Da972t+vYGu8wQQyKLx2h21L8XPxGgJiYtcByY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041113; c=relaxed/simple;
	bh=83dOD4jDLxiZIFHQV1eqp7ilpTQxqgZLbqam7E3BV/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DiieIYqdiszCA184BnN/zxWy3ioA9sb/9qcSN/5ZtiB6uOEXTEZYlIJt4C5EIHOqWG4GR7lr/ZzV491rXjg5ursqknuxnElUiLbxEE2Mmb/5T6Ahp4kVzCYqHa8nXnSF+htIG6l4rHacxRar87YZK8uiyl7Y8rJmTliTthdxmTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ampc781v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ampc781v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3D3DC43390;
	Tue, 27 Feb 2024 13:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041113;
	bh=83dOD4jDLxiZIFHQV1eqp7ilpTQxqgZLbqam7E3BV/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ampc781v4qa4/KM5qWKvdKjTSm+Ol864vvKHAwq/sE7GmW2sBcptzLrDrM7ZkWx8M
	 d+cAgCahSQRblVp6xvj1bhmFNTVCViPXkj0uZysQbGMIN/fbClcX7cE5Bd83ERB4aN
	 rZdzgs/ViBQxP3hBw64DIfwm3x8ozJIlph75XTNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.7 225/334] selftests: mptcp: diag: unique in use subtest names
Date: Tue, 27 Feb 2024 14:21:23 +0100
Message-ID: <20240227131638.054673888@linuxfoundation.org>
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

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 645c1dc965ef6b5554e5e69737bb179c7a0f872f upstream.

It is important to have a unique (sub)test name in TAP, because some CI
environments drop tests with duplicated name.

Some 'in use' subtests from the diag selftest had the same names, e.g.:

    chk 0 msk in use after flush

Now the previous value is taken, to have different names, e.g.:

    chk 2->0 msk in use after flush

While at it, avoid repeating the full message, declare it once in the
helper.

Fixes: ce9902573652 ("selftests: mptcp: diag: format subtests results in TAP")
Cc: stable@vger.kernel.org
Reviewed-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/diag.sh |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

--- a/tools/testing/selftests/net/mptcp/diag.sh
+++ b/tools/testing/selftests/net/mptcp/diag.sh
@@ -166,9 +166,13 @@ chk_msk_listen()
 chk_msk_inuse()
 {
 	local expected=$1
-	local msg="$2"
+	local msg="....chk ${2:-${expected}} msk in use"
 	local listen_nr
 
+	if [ "${expected}" -eq 0 ]; then
+		msg+=" after flush"
+	fi
+
 	listen_nr=$(ss -N "${ns}" -Ml | grep -c LISTEN)
 	expected=$((expected + listen_nr))
 
@@ -179,7 +183,7 @@ chk_msk_inuse()
 		sleep 0.1
 	done
 
-	__chk_nr get_msk_inuse $expected "$msg" 0
+	__chk_nr get_msk_inuse $expected "${msg}" 0
 }
 
 # $1: ns, $2: port
@@ -244,11 +248,11 @@ wait_connected $ns 10000
 chk_msk_nr 2 "after MPC handshake "
 chk_msk_remote_key_nr 2 "....chk remote_key"
 chk_msk_fallback_nr 0 "....chk no fallback"
-chk_msk_inuse 2 "....chk 2 msk in use"
+chk_msk_inuse 2
 chk_msk_cestab 2
 flush_pids
 
-chk_msk_inuse 0 "....chk 0 msk in use after flush"
+chk_msk_inuse 0 "2->0"
 chk_msk_cestab 0
 
 echo "a" | \
@@ -264,11 +268,11 @@ echo "b" | \
 				127.0.0.1 >/dev/null &
 wait_connected $ns 10001
 chk_msk_fallback_nr 1 "check fallback"
-chk_msk_inuse 1 "....chk 1 msk in use"
+chk_msk_inuse 1
 chk_msk_cestab 1
 flush_pids
 
-chk_msk_inuse 0 "....chk 0 msk in use after flush"
+chk_msk_inuse 0 "1->0"
 chk_msk_cestab 0
 
 NR_CLIENTS=100
@@ -290,11 +294,11 @@ for I in `seq 1 $NR_CLIENTS`; do
 done
 
 wait_msk_nr $((NR_CLIENTS*2)) "many msk socket present"
-chk_msk_inuse $((NR_CLIENTS*2)) "....chk many msk in use"
+chk_msk_inuse $((NR_CLIENTS*2)) "many"
 chk_msk_cestab $((NR_CLIENTS*2))
 flush_pids
 
-chk_msk_inuse 0 "....chk 0 msk in use after flush"
+chk_msk_inuse 0 "many->0"
 chk_msk_cestab 0
 
 mptcp_lib_result_print_all_tap


