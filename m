Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C5C5FC08
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:42:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8813C433EF;
	Mon, 15 May 2023 17:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684172577;
	bh=iWbCCRy1Spjcf836iiuBVoDOigsexpBSKY30+3yNyjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=be8neLZF9AodVs4lDk6AIKtDtOJ5IPBvKdO4fPlac24AkLT+kjuHI9jMX2/7qkl6+
	 9sgdw/orW7CVWlLY2EiHoUyUrU+9ue8Ua0Uhbffjs7lwYmsSMqTmCtMDYkW2Df/XgY
	 xNNyMn9Ve86AlVbwWvfEz3/SbRTDXepscKqe0EUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Stanislav Fomichev <sdf@google.com>,
	YiFei Zhu <zhuyifei@google.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 160/381] selftests/bpf: Wait for receive in cg_storage_multi test
Date: Mon, 15 May 2023 18:26:51 +0200
Message-Id: <20230515161744.033983594@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161736.775969473@linuxfoundation.org>
References: <20230515161736.775969473@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: YiFei Zhu <zhuyifei@google.com>

[ Upstream commit 5af607a861d43ffff830fc1890033e579ec44799 ]

In some cases the loopback latency might be large enough, causing
the assertion on invocations to be run before ingress prog getting
executed. The assertion would fail and the test would flake.

This can be reliably reproduced by arbitrarily increasing the
loopback latency (thanks to [1]):
  tc qdisc add dev lo root handle 1: htb default 12
  tc class add dev lo parent 1:1 classid 1:12 htb rate 20kbps ceil 20kbps
  tc qdisc add dev lo parent 1:12 netem delay 100ms

Fix this by waiting on the receive end, instead of instantly
returning to the assert. The call to read() will wait for the
default SO_RCVTIMEO timeout of 3 seconds provided by
start_server().

[1] https://gist.github.com/kstevens715/4598301

Reported-by: Martin KaFai Lau <martin.lau@linux.dev>
Link: https://lore.kernel.org/bpf/9c5c8b7e-1d89-a3af-5400-14fde81f4429@linux.dev/
Fixes: 3573f384014f ("selftests/bpf: Test CGROUP_STORAGE behavior on shared egress + ingress")
Acked-by: Stanislav Fomichev <sdf@google.com>
Signed-off-by: YiFei Zhu <zhuyifei@google.com>
Link: https://lore.kernel.org/r/20230405193354.1956209-1-zhuyifei@google.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/cg_storage_multi.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/cg_storage_multi.c b/tools/testing/selftests/bpf/prog_tests/cg_storage_multi.c
index 643dfa35419c1..48dc5827daa7f 100644
--- a/tools/testing/selftests/bpf/prog_tests/cg_storage_multi.c
+++ b/tools/testing/selftests/bpf/prog_tests/cg_storage_multi.c
@@ -56,8 +56,9 @@ static bool assert_storage_noexist(struct bpf_map *map, const void *key)
 
 static bool connect_send(const char *cgroup_path)
 {
-	bool res = true;
 	int server_fd = -1, client_fd = -1;
+	char message[] = "message";
+	bool res = true;
 
 	if (join_cgroup(cgroup_path))
 		goto out_clean;
@@ -70,7 +71,10 @@ static bool connect_send(const char *cgroup_path)
 	if (client_fd < 0)
 		goto out_clean;
 
-	if (send(client_fd, "message", strlen("message"), 0) < 0)
+	if (send(client_fd, &message, sizeof(message), 0) < 0)
+		goto out_clean;
+
+	if (read(server_fd, &message, sizeof(message)) < 0)
 		goto out_clean;
 
 	res = false;
-- 
2.39.2



