Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B80BF846C
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:30:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C6E7C433EF;
	Fri, 10 Mar 2023 14:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678458635;
	bh=s45eB0R8juTjlWTD+m+madG1BptmyRT70x9JDqDwhck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZNWpL6wtJ4KiaKWlVupuSoojRwUIJ6k0RfiTbb8YUSEJ0BAst2po8P570ff59XBFq
	 5ZrZZNrSa6mZcj97ErGb+nq7El82VCGiSrR7/jaA6g2KwWiuSDE4gaBUcOESBNBJrQ
	 /iy/7j4GuePBaFNTsE9uX74Ypb7Mxc48xeRq7JGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Sitnicki <jakub@cloudflare.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 094/357] selftests/net: Interpret UDP_GRO cmsg data as an int value
Date: Fri, 10 Mar 2023 14:36:23 +0100
Message-Id: <20230310133738.144172649@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jakub Sitnicki <jakub@cloudflare.com>

[ Upstream commit 436864095a95fcc611c20c44a111985fa9848730 ]

Data passed to user-space with a (SOL_UDP, UDP_GRO) cmsg carries an
int (see udp_cmsg_recv), not a u16 value, as strace confirms:

  recvmsg(8, {msg_name=...,
              msg_iov=[{iov_base="\0\0..."..., iov_len=96000}],
              msg_iovlen=1,
              msg_control=[{cmsg_len=20,         <-- sizeof(cmsghdr) + 4
                            cmsg_level=SOL_UDP,
                            cmsg_type=0x68}],    <-- UDP_GRO
                            msg_controllen=24,
                            msg_flags=0}, 0) = 11200

Interpreting the data as an u16 value won't work on big-endian platforms.
Since it is too late to back out of this API decision [1], fix the test.

[1]: https://lore.kernel.org/netdev/20230131174601.203127-1-jakub@cloudflare.com/

Fixes: 3327a9c46352 ("selftests: add functionals test for UDP GRO")
Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/udpgso_bench_rx.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/net/udpgso_bench_rx.c b/tools/testing/selftests/net/udpgso_bench_rx.c
index 4058c7451e70d..f35a924d4a303 100644
--- a/tools/testing/selftests/net/udpgso_bench_rx.c
+++ b/tools/testing/selftests/net/udpgso_bench_rx.c
@@ -214,11 +214,10 @@ static void do_verify_udp(const char *data, int len)
 
 static int recv_msg(int fd, char *buf, int len, int *gso_size)
 {
-	char control[CMSG_SPACE(sizeof(uint16_t))] = {0};
+	char control[CMSG_SPACE(sizeof(int))] = {0};
 	struct msghdr msg = {0};
 	struct iovec iov = {0};
 	struct cmsghdr *cmsg;
-	uint16_t *gsosizeptr;
 	int ret;
 
 	iov.iov_base = buf;
@@ -237,8 +236,7 @@ static int recv_msg(int fd, char *buf, int len, int *gso_size)
 		     cmsg = CMSG_NXTHDR(&msg, cmsg)) {
 			if (cmsg->cmsg_level == SOL_UDP
 			    && cmsg->cmsg_type == UDP_GRO) {
-				gsosizeptr = (uint16_t *) CMSG_DATA(cmsg);
-				*gso_size = *gsosizeptr;
+				*gso_size = *(int *)CMSG_DATA(cmsg);
 				break;
 			}
 		}
-- 
2.39.2



