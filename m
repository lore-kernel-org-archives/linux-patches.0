Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AEE379DD;
	Sat, 30 Dec 2023 12:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ACwguz7D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C757BC433C8;
	Sat, 30 Dec 2023 12:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703938280;
	bh=5EAqNRWruzVVU81F9hGZ04oiiyuPre7+HCfZJL2eLl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ACwguz7DJGMrBtRAWYzJwebfjUd4nqK4rvXEYkeQeB9a0j1I/HFMabXvNHuEic+lr
	 5KEaBoxoXRNH2eCLK9MzWKYgnsNG6AeyIKLhIUrMal5VXsfTteovkWMBlcMoUn/Fcl
	 eKKr/+sblu+vcP4LDXxXZuHEOzTCT4batlLnHXaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang.tang@linux.dev>,
	Mat Martineau <martineau@kernel.org>,
	Matthieu Baerts <matttbe@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 095/112] selftests: mptcp: join: fix subflow_send_ack lookup
Date: Sat, 30 Dec 2023 12:00:08 +0000
Message-ID: <20231230115809.855103870@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115806.714618407@linuxfoundation.org>
References: <20231230115806.714618407@linuxfoundation.org>
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

From: Geliang Tang <geliang.tang@linux.dev>

[ Upstream commit c8f021eec5817601dbd25ab7e3ad5c720965c688 ]

MPC backups tests will skip unexpected sometimes (For example, when
compiling kernel with an older version of gcc, such as gcc-8), since
static functions like mptcp_subflow_send_ack also be listed in
/proc/kallsyms, with a 't' in front of it, not 'T' ('T' is for a global
function):

 > grep "mptcp_subflow_send_ack" /proc/kallsyms

 0000000000000000 T __pfx___mptcp_subflow_send_ack
 0000000000000000 T __mptcp_subflow_send_ack
 0000000000000000 t __pfx_mptcp_subflow_send_ack
 0000000000000000 t mptcp_subflow_send_ack

In this case, mptcp_lib_kallsyms_doesnt_have "mptcp_subflow_send_ack$"
will be false, MPC backups tests will skip. This is not what we expected.

The correct logic here should be: if mptcp_subflow_send_ack is not a
global function in /proc/kallsyms, do these MPC backups tests. So a 'T'
must be added in front of mptcp_subflow_send_ack.

Fixes: 632978f0a961 ("selftests: mptcp: join: skip MPC backups tests if not supported")
Cc: stable@vger.kernel.org
Signed-off-by: Geliang Tang <geliang.tang@linux.dev>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts <matttbe@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index ea6fc59e9f62f..e52d513009fb0 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -2652,7 +2652,7 @@ backup_tests()
 	fi
 
 	if reset "mpc backup" &&
-	   continue_if mptcp_lib_kallsyms_doesnt_have "mptcp_subflow_send_ack$"; then
+	   continue_if mptcp_lib_kallsyms_doesnt_have "T mptcp_subflow_send_ack$"; then
 		pm_nl_add_endpoint $ns2 10.0.1.2 flags subflow,backup
 		run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow
 		chk_join_nr 0 0 0
@@ -2660,7 +2660,7 @@ backup_tests()
 	fi
 
 	if reset "mpc backup both sides" &&
-	   continue_if mptcp_lib_kallsyms_doesnt_have "mptcp_subflow_send_ack$"; then
+	   continue_if mptcp_lib_kallsyms_doesnt_have "T mptcp_subflow_send_ack$"; then
 		pm_nl_add_endpoint $ns1 10.0.1.1 flags subflow,backup
 		pm_nl_add_endpoint $ns2 10.0.1.2 flags subflow,backup
 		run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow
@@ -2669,7 +2669,7 @@ backup_tests()
 	fi
 
 	if reset "mpc switch to backup" &&
-	   continue_if mptcp_lib_kallsyms_doesnt_have "mptcp_subflow_send_ack$"; then
+	   continue_if mptcp_lib_kallsyms_doesnt_have "T mptcp_subflow_send_ack$"; then
 		pm_nl_add_endpoint $ns2 10.0.1.2 flags subflow
 		run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow backup
 		chk_join_nr 0 0 0
@@ -2677,7 +2677,7 @@ backup_tests()
 	fi
 
 	if reset "mpc switch to backup both sides" &&
-	   continue_if mptcp_lib_kallsyms_doesnt_have "mptcp_subflow_send_ack$"; then
+	   continue_if mptcp_lib_kallsyms_doesnt_have "T mptcp_subflow_send_ack$"; then
 		pm_nl_add_endpoint $ns1 10.0.1.1 flags subflow
 		pm_nl_add_endpoint $ns2 10.0.1.2 flags subflow
 		run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow backup
-- 
2.43.0



