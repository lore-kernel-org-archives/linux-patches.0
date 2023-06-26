Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3074134C7
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:15:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44706C433C0;
	Mon, 26 Jun 2023 18:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687803327;
	bh=YCvqiD7CfL+10n7nXCvN2LYigcQhTVgWb2YQLpXlhio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QFTxiOCVz/boTQisNEsR+22rdYIqEX5QNQjMNnGPTI/vOlM5O7xTDCg2nPdM69dMz
	 2FTrJEb7+JAtTZinYI8gOGB/GTBNhNJyb7Lj54zpZgBbRfGx3WHZt+LCAMMoefAqtE
	 4g+wJRpLfL5pxvYAWle1ttireoDbXH9uixvWpj9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.3 023/199] selftests: mptcp: connect: skip TFO tests if not supported
Date: Mon, 26 Jun 2023 20:08:49 +0200
Message-ID: <20230626180806.660609030@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180805.643662628@linuxfoundation.org>
References: <20230626180805.643662628@linuxfoundation.org>
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

commit 06b03083158e90d57866fa220de92c8dd8b9598b upstream.

Selftests are supposed to run on any kernels, including the old ones not
supporting all MPTCP features.

One of them is the support of TCP_FASTOPEN socket option with MPTCP
connections introduced by commit 4ffb0a02346c ("mptcp: add TCP_FASTOPEN
sock option").

It is possible to look for "mptcp_fastopen_" in kallsyms to know if the
feature is supported or not.

Link: https://github.com/multipath-tcp/mptcp_net-next/issues/368
Fixes: ca7ae8916043 ("selftests: mptcp: mptfo Initiator/Listener")
Cc: stable@vger.kernel.org
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_connect.sh |    5 +++++
 1 file changed, 5 insertions(+)

--- a/tools/testing/selftests/net/mptcp/mptcp_connect.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
@@ -777,6 +777,11 @@ run_tests_peekmode()
 
 run_tests_mptfo()
 {
+	if ! mptcp_lib_kallsyms_has "mptcp_fastopen_"; then
+		echo "INFO: TFO not supported by the kernel: SKIP"
+		return
+	fi
+
 	echo "INFO: with MPTFO start"
 	ip netns exec "$ns1" sysctl -q net.ipv4.tcp_fastopen=2
 	ip netns exec "$ns2" sysctl -q net.ipv4.tcp_fastopen=1


