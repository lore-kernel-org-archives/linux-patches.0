Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A19AF168CF
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:14:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EDC2C433EF;
	Mon,  8 May 2023 11:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544458;
	bh=2kx7MVjhaRT5DWsntRHvbdauuKO2SqnfFD1dnrB9eYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sXBfc2eFnuBiu2vdeeCi/EE6RBxUhgssyaGHWCKFn9xvHvEj45JG/7MvB6zebnjX1
	 e7a7K0bJEgsGm8K7U5VQSTPO20LuAjZhJBkGJYe18B6ckiksk4DDSXCEFr9W8RLpOv
	 LhK4+4IhERsVUFg6efA2lOCb0IdV6LvLieyDjjZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kal Conley <kal.conley@dectris.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 387/694] selftests: xsk: Disable IPv6 on VETH1
Date: Mon,  8 May 2023 11:43:42 +0200
Message-Id: <20230508094445.556592885@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kal Conley <kal.conley@dectris.com>

[ Upstream commit f2b50f17268390567bc0e95642170d88f336c8f4 ]

This change fixes flakiness in the BIDIRECTIONAL test:

    # [is_pkt_valid] expected length [60], got length [90]
    not ok 1 FAIL: SKB BUSY-POLL BIDIRECTIONAL

When IPv6 is enabled, the interface will periodically send MLDv1 and
MLDv2 packets. These packets can cause the BIDIRECTIONAL test to fail
since it uses VETH0 for RX.

For other tests, this was not a problem since they only receive on VETH1
and IPv6 was already disabled on VETH0.

Fixes: a89052572ebb ("selftests/bpf: Xsk selftests framework")
Signed-off-by: Kal Conley <kal.conley@dectris.com>
Link: https://lore.kernel.org/r/20230405082905.6303-1-kal.conley@dectris.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_xsk.sh | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/test_xsk.sh b/tools/testing/selftests/bpf/test_xsk.sh
index b077cf58f8258..377fb157a57c5 100755
--- a/tools/testing/selftests/bpf/test_xsk.sh
+++ b/tools/testing/selftests/bpf/test_xsk.sh
@@ -116,6 +116,7 @@ setup_vethPairs() {
 	ip link add ${VETH0} numtxqueues 4 numrxqueues 4 type veth peer name ${VETH1} numtxqueues 4 numrxqueues 4
 	if [ -f /proc/net/if_inet6 ]; then
 		echo 1 > /proc/sys/net/ipv6/conf/${VETH0}/disable_ipv6
+		echo 1 > /proc/sys/net/ipv6/conf/${VETH1}/disable_ipv6
 	fi
 	if [[ $verbose -eq 1 ]]; then
 	        echo "setting up ${VETH1}"
-- 
2.39.2



