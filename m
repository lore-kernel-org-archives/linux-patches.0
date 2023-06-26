Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A019512B9C
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:28:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E990C433C8;
	Mon, 26 Jun 2023 18:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687804080;
	bh=xfe7n/CuJ6Vusd9L6zDgyic7yjmrIHBWVSrOq2mjl2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hpwjJh+BhFbJB9gIbkWDlqbyE0AoIJlVSdiBEMyiybIVTNKA6r6K1U0ZLNtbvSGxL
	 rdJkBBojhybSyOEmtI8jG053NPZoNGEq3HBPgJuL1ZN6i7YuL0numew7GDTSv6IIQV
	 T5ufNrAdfLN+Fk3TN2BHv+s7smrbnwweNh/FHzH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 017/170] selftests: mptcp: connect: skip transp tests if not supported
Date: Mon, 26 Jun 2023 20:09:46 +0200
Message-ID: <20230626180801.327355265@linuxfoundation.org>
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

commit 07bf49401909264a38fa3427c3cce43e8304436a upstream.

Selftests are supposed to run on any kernels, including the old ones not
supporting all MPTCP features.

One of them is the support of IP(V6)_TRANSPARENT socket option with
MPTCP connections introduced by commit c9406a23c116 ("mptcp: sockopt:
add SOL_IP freebind & transparent options").

It is possible to look for "__ip_sock_set_tos" in kallsyms because
IP(V6)_TRANSPARENT socket option support has been added after TOS
support which came with the required infrastructure in MPTCP sockopt
code. To support TOS, the following function has been exported (T). Not
great but better than checking for a specific kernel version.

Link: https://github.com/multipath-tcp/mptcp_net-next/issues/368
Fixes: 5fb62e9cd3ad ("selftests: mptcp: add tproxy test case")
Cc: stable@vger.kernel.org
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_connect.sh |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/tools/testing/selftests/net/mptcp/mptcp_connect.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
@@ -144,6 +144,7 @@ cleanup()
 }
 
 mptcp_lib_check_mptcp
+mptcp_lib_check_kallsyms
 
 ip -Version > /dev/null 2>&1
 if [ $? -ne 0 ];then
@@ -696,6 +697,15 @@ run_test_transparent()
 		return 0
 	fi
 
+	# IP(V6)_TRANSPARENT has been added after TOS support which came with
+	# the required infrastructure in MPTCP sockopt code. To support TOS, the
+	# following function has been exported (T). Not great but better than
+	# checking for a specific kernel version.
+	if ! mptcp_lib_kallsyms_has "T __ip_sock_set_tos$"; then
+		echo "INFO: ${msg} not supported by the kernel: SKIP"
+		return
+	fi
+
 ip netns exec "$listener_ns" nft -f /dev/stdin <<"EOF"
 flush ruleset
 table inet mangle {


