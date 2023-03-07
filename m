Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACEBABA46
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:10:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23EFDC433EF;
	Tue,  7 Mar 2023 18:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678212659;
	bh=s45eB0R8juTjlWTD+m+madG1BptmyRT70x9JDqDwhck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gpJdn9jibVfnaet1BRgK2LjwgflXC1xWNi/1SN9SyFP2rytNNFCt+5oywc/dsH+76
	 nzpXIdpOUiYMmRMvTHypqf9o5VpsXNJfJ1hzjnuEj6/0qtQavcSFKMHvJ4MtS0Iz0M
	 weXAvqZgCYd4wys3cDoRzexavgCcPSuhAH4n8fgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Sitnicki <jakub@cloudflare.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 256/885] selftests/net: Interpret UDP_GRO cmsg data as an int value
Date: Tue,  7 Mar 2023 17:53:10 +0100
Message-Id: <20230307170013.111781903@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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



