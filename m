Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFC7E168DE
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:38:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 459D8C433D2;
	Mon,  8 May 2023 11:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683545902;
	bh=RucaJblMQZjtfRZG4Zh8aHv1I8qZDV+jfsCu5aFdBwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c7TknohgIBrtSzIZsJaYag3QlYsW+QBHsP4MAIgb8AzOZpF1D3P5mbxvsNqo9NpcF
	 uqjIDdGMohRMNYs7swE2YfUs7LWQphYwPDZpbB5QhPfDKcSwI44mH4P9c4IGIV+QQA
	 8lwKkknJBbgw5lcI3q5fqBeW1wGamaRR2oQoqSuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Yonghong Song <yhs@fb.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 161/371] selftests/bpf: Fix a fd leak in an error path in network_helpers.c
Date: Mon,  8 May 2023 11:46:02 +0200
Message-Id: <20230508094818.495053531@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094811.912279944@linuxfoundation.org>
References: <20230508094811.912279944@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Martin KaFai Lau <martin.lau@kernel.org>

[ Upstream commit 226efec2b0efad60d4a6c4b2c3a8710dafc4dc21 ]

In __start_server, it leaks a fd when setsockopt(SO_REUSEPORT) fails.
This patch fixes it.

Fixes: eed92afdd14c ("bpf: selftest: Test batching and bpf_(get|set)sockopt in bpf tcp iter")
Reported-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Yonghong Song <yhs@fb.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/bpf/20230316000726.1016773-2-martin.lau@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/network_helpers.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/network_helpers.c b/tools/testing/selftests/bpf/network_helpers.c
index 6db1af8fdee78..c57e1e47e52f2 100644
--- a/tools/testing/selftests/bpf/network_helpers.c
+++ b/tools/testing/selftests/bpf/network_helpers.c
@@ -84,7 +84,7 @@ static int __start_server(int type, const struct sockaddr *addr,
 	if (reuseport &&
 	    setsockopt(fd, SOL_SOCKET, SO_REUSEPORT, &on, sizeof(on))) {
 		log_err("Failed to set SO_REUSEPORT");
-		return -1;
+		goto error_close;
 	}
 
 	if (bind(fd, addr, addrlen) < 0) {
-- 
2.39.2



