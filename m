Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 781F017551;
	Sat,  3 Feb 2024 04:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933937; cv=none; b=tBMLmweVnUg1PmLckmoZYb5bkFe+ST3Hmmuuofw/qvI3mniwYTsLYyvZLqM9DkDWSV6ba+eKNndTwLJJFSR/fZPIrZecHvJnWWzP7AhSRePWOV7D8WMaalaCwvWvmqUi0C5JB5O1LbgIvoyH6FSkUcTaNLjAx6X5BP0IteGJYGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933937; c=relaxed/simple;
	bh=L0NnWtO9xGqe6yA4tMTGa9IE4N1ctB3SlDDEgQpbNwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V87rv2Y2RspSRsZCfzYSHlosN8mJHteGiPQfP6Sid0liQvOZ/m3lqoqttx7KIGjsh+WWFa1WchF6r0z/0g6GvBjpyXsBrT1G/kkRsqw67MyVfyWBu7cTS5H8ihHyzFSkLyZ7VtSwFPoSyFr/jJN2CU9xWEsCc2ETsPyPRLGxlsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CL/RrDWf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CL/RrDWf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35C49C433C7;
	Sat,  3 Feb 2024 04:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933937;
	bh=L0NnWtO9xGqe6yA4tMTGa9IE4N1ctB3SlDDEgQpbNwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CL/RrDWf5KgkwSyC1hjQ/9OTH3RFyG64H4oVeq9eF9Ns/7WgN+qIfzSQ3g2MbnSfY
	 9MrIQNiuxMYLVWHZMWGu89kHPyY+OJT1zHENN8x/QAG7ec+8v+//ZeNb0JJC/oIZY3
	 lXoLZYde50h09Too2CSRnwD/qOBpAwIcmEYfTRxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 299/353] selftests: net: explicitly wait for listener ready
Date: Fri,  2 Feb 2024 20:06:57 -0800
Message-ID: <20240203035413.295962811@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 4acffb66630a0e4800880baa61a54ef18047ccd3 ]

The UDP GRO forwarding test still hard-code an arbitrary pause
to wait for the UDP listener becoming ready in background.

That causes sporadic failures depending on the host load.

Replace the sleep with the existing helper waiting for the desired
port being exposed.

Fixes: a062260a9d5f ("selftests: net: add UDP GRO forwarding self-tests")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://lore.kernel.org/r/4d58900fb09cef42749cfcf2ad7f4b91a97d225c.1706131762.git.pabeni@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/udpgro_fwd.sh | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/udpgro_fwd.sh b/tools/testing/selftests/net/udpgro_fwd.sh
index 5fa8659ab13d..d6b9c759043c 100755
--- a/tools/testing/selftests/net/udpgro_fwd.sh
+++ b/tools/testing/selftests/net/udpgro_fwd.sh
@@ -1,6 +1,8 @@
 #!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 
+source net_helper.sh
+
 BPF_FILE="xdp_dummy.o"
 readonly BASE="ns-$(mktemp -u XXXXXX)"
 readonly SRC=2
@@ -119,7 +121,7 @@ run_test() {
 	ip netns exec $NS_DST $ipt -A INPUT -p udp --dport 8000
 	ip netns exec $NS_DST ./udpgso_bench_rx -C 1000 -R 10 -n 10 -l 1300 $rx_args &
 	local spid=$!
-	sleep 0.1
+	wait_local_port_listen "$NS_DST" 8000 udp
 	ip netns exec $NS_SRC ./udpgso_bench_tx $family -M 1 -s 13000 -S 1300 -D $dst
 	local retc=$?
 	wait $spid
@@ -168,7 +170,7 @@ run_bench() {
 	ip netns exec $NS_DST bash -c "echo 2 > /sys/class/net/veth$DST/queues/rx-0/rps_cpus"
 	ip netns exec $NS_DST taskset 0x2 ./udpgso_bench_rx -C 1000 -R 10  &
 	local spid=$!
-	sleep 0.1
+	wait_local_port_listen "$NS_DST" 8000 udp
 	ip netns exec $NS_SRC taskset 0x1 ./udpgso_bench_tx $family -l 3 -S 1300 -D $dst
 	local retc=$?
 	wait $spid
-- 
2.43.0



