Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28671419A9;
	Tue, 27 Feb 2024 13:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042168; cv=none; b=dkHfDf4H1aTFKbrb+taxVkE7se9hcoR/acEk8fLDun+zESzcvRgFVGeZnTZES1IPO1MjB8SXXyzwhPxOq0Au4tV9BgoopAMa39pp5UX1zZbFfTFy3QpjZ0X7WDfI0+fKToB0xqZ1myv+JorsE5jowV7CppesR3bt36iRyuiIYNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042168; c=relaxed/simple;
	bh=8KMYKH90w8KW/W6/mbhstpeXzu1L8OxVo8Qt0LNKG1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ovH1NNek5QNq+HE863oU1buZoQtzzefHQcBs6b3l1kRvR/jNKBpfwDvSNrFy0eLmtgBU4N0sMMZ1AubvSkxKS8WXT8FJpOUFo0HJ6mZvEigdViAOOGKrXlZy/lBbAXLkzw7x+IdnEPUS7vx+1VU/caRX1y4byKdA9mi7Jm3vWJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pR6zIKYg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pR6zIKYg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 409A0C433F1;
	Tue, 27 Feb 2024 13:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042168;
	bh=8KMYKH90w8KW/W6/mbhstpeXzu1L8OxVo8Qt0LNKG1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pR6zIKYgulA68vSv4Vhgih1ARwtFWbJRpG370C/Vw7Tym7tSpFpzBpvZ/jmr0GlO6
	 JIrLd6+Jc+2crVeez2sShPhgJgmMzooCd0oPhNtyMRttbjyL37KBpYZmRv5riybIVk
	 0dZn8BpupH3AQroqDRcZVWVEi8FAUxlOY23BsqoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.6 203/299] selftests: mptcp: diag: unique in use subtest names
Date: Tue, 27 Feb 2024 14:25:14 +0100
Message-ID: <20240227131632.338081773@linuxfoundation.org>
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


