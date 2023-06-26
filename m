Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C24F13AC4
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:28:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18B4FC433C0;
	Mon, 26 Jun 2023 18:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687804127;
	bh=lCzTTXsK9F3LiXP1DIfPcuSePbR6FNxIucFb5rRfXm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r8ZQflPVmpanzQcWeILkGd2URUQ25PN37RQ5iyUaBz0lAPywiv6GL2T2iQJCXYk9e
	 ZzAqm6aDmBLsSqlK5t6PfRelrta4SmUX+Y3uI7LEmIDm4WWcRULT25ml5jh8XeFfZ0
	 fxW6Ff2m4Fz/N94bHuGI2nv2+WzTFuUToyz+Z33U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 022/170] selftests: mptcp: sockopt: skip getsockopt checks if not supported
Date: Mon, 26 Jun 2023 20:09:51 +0200
Message-ID: <20230626180801.547524090@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180800.476539630@linuxfoundation.org>
References: <20230626180800.476539630@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Matthieu Baerts <matthieu.baerts@tessares.net>

commit c6f7eccc519837ebde1d099d9610c4f1d5bd975e upstream.

Selftests are supposed to run on any kernels, including the old ones not
supporting all MPTCP features.

One of them is the getsockopt(SOL_MPTCP) to get info about the MPTCP
connections introduced by commit 55c42fa7fa33 ("mptcp: add MPTCP_INFO
getsockopt") and the following ones.

It is possible to look for "mptcp_diag_fill_info" in kallsyms because
it is introduced by the mentioned feature. So we can know in advance if
the feature is supported and skip the sub-test if not.

Link: https://github.com/multipath-tcp/mptcp_net-next/issues/368
Fixes: ce9979129a0b ("selftests: mptcp: add mptcp getsockopt test cases")
Cc: stable@vger.kernel.org
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_sockopt.sh |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/tools/testing/selftests/net/mptcp/mptcp_sockopt.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_sockopt.sh
@@ -84,6 +84,7 @@ cleanup()
 }
 
 mptcp_lib_check_mptcp
+mptcp_lib_check_kallsyms
 
 ip -Version > /dev/null 2>&1
 if [ $? -ne 0 ];then
@@ -248,6 +249,11 @@ do_mptcp_sockopt_tests()
 {
 	local lret=0
 
+	if ! mptcp_lib_kallsyms_has "mptcp_diag_fill_info$"; then
+		echo "INFO: MPTCP sockopt not supported: SKIP"
+		return
+	fi
+
 	ip netns exec "$ns_sbox" ./mptcp_sockopt
 	lret=$?
 


