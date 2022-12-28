Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDCF21863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:21:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7276FC433D2;
	Wed, 28 Dec 2022 15:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672240908;
	bh=2Xm07eXL0JB3MV9MymMDGxCYhaoEiXUc0TxK5crAAJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=06CfuOvMBCwiMnHFpJw3C1xwQHEPjnyVaeIGmLAi8kUxsZT+Dmvqqj57e7B5sSoz8
	 vtL90+UyhiUacg6s/OhHcFhW8cjP/ql3LnkhfuBeaVjpm3kLQSdjRkuxWOj6oiw0T1
	 i+KB8D4onuedbIc4dCIybAgrDpZeQ/x/oixBzmeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerhard Engleder <gerhard@engleder-embedded.com>,
	Song Liu <song@kernel.org>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0218/1073] samples/bpf: Fix map iteration in xdp1_user
Date: Wed, 28 Dec 2022 15:30:06 +0100
Message-Id: <20221228144333.936132595@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gerhard Engleder <gerhard@engleder-embedded.com>

[ Upstream commit 05ee658c654bacda03f7fecef367e62aaf8e1cfe ]

BPF map iteration in xdp1_user results in endless loop without any
output, because the return value of bpf_map_get_next_key() is checked
against the wrong value.

Other call locations of bpf_map_get_next_key() check for equal 0 for
continuing the iteration. xdp1_user checks against unequal -1. This is
wrong for a function which can return arbitrary negative errno values,
because a return value of e.g. -2 results in an endless loop.

With this fix xdp1_user is printing statistics again:
proto 0:          1 pkt/s
proto 0:          1 pkt/s
proto 17:     107383 pkt/s
proto 17:     881655 pkt/s
proto 17:     882083 pkt/s
proto 17:     881758 pkt/s

Fixes: bd054102a8c7 ("libbpf: enforce strict libbpf 1.0 behaviors")
Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
Acked-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20221013200922.17167-1-gerhard@engleder-embedded.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/bpf/xdp1_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/bpf/xdp1_user.c b/samples/bpf/xdp1_user.c
index ac370e638fa3..281dc964de8d 100644
--- a/samples/bpf/xdp1_user.c
+++ b/samples/bpf/xdp1_user.c
@@ -51,7 +51,7 @@ static void poll_stats(int map_fd, int interval)
 
 		sleep(interval);
 
-		while (bpf_map_get_next_key(map_fd, &key, &key) != -1) {
+		while (bpf_map_get_next_key(map_fd, &key, &key) == 0) {
 			__u64 sum = 0;
 
 			assert(bpf_map_lookup_elem(map_fd, &key, values) == 0);
-- 
2.35.1



