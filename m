Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70C22482DC;
	Thu, 30 Nov 2023 16:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U4k7SArn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F22F4C433C7;
	Thu, 30 Nov 2023 16:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361918;
	bh=6v1OuM7Neg8oBMI83rKWJnbg4elFNE/svaxLoaDO+Is=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U4k7SArnZ1Wg1ZmC0awDUEGK1ad/ZXLMPIdp4ZkXuaV2fSCZ2VZD90vIYs7XjaxcI
	 wn3If72wok2pKaYjGZbfkpyqtN/sFMsHA3ppwQgIHOzh66DNT2DUFjkFPn+7SIgBio
	 F0hffEuGMI/o2xeaEhw933sSkEvOjQq4Nym9sO/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"D. Wythe" <alibuda@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 15/69] net/smc: avoid data corruption caused by decline
Date: Thu, 30 Nov 2023 16:22:12 +0000
Message-ID: <20231130162133.585896957@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162133.035359406@linuxfoundation.org>
References: <20231130162133.035359406@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: D. Wythe <alibuda@linux.alibaba.com>

[ Upstream commit e6d71b437abc2f249e3b6a1ae1a7228e09c6e563 ]

We found a data corruption issue during testing of SMC-R on Redis
applications.

The benchmark has a low probability of reporting a strange error as
shown below.

"Error: Protocol error, got "\xe2" as reply type byte"

Finally, we found that the retrieved error data was as follows:

0xE2 0xD4 0xC3 0xD9 0x04 0x00 0x2C 0x20 0xA6 0x56 0x00 0x16 0x3E 0x0C
0xCB 0x04 0x02 0x01 0x00 0x00 0x20 0x00 0x00 0x00 0x00 0x00 0x00 0x00
0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0xE2

It is quite obvious that this is a SMC DECLINE message, which means that
the applications received SMC protocol message.
We found that this was caused by the following situations:

client                  server
        ¦  clc proposal
        ------------->
        ¦  clc accept
        <-------------
        ¦  clc confirm
        ------------->
wait llc confirm
			send llc confirm
        ¦failed llc confirm
        ¦   x------
(after 2s)timeout
                        wait llc confirm rsp

wait decline

(after 1s) timeout
                        (after 2s) timeout
        ¦   decline
        -------------->
        ¦   decline
        <--------------

As a result, a decline message was sent in the implementation, and this
message was read from TCP by the already-fallback connection.

This patch double the client timeout as 2x of the server value,
With this simple change, the Decline messages should never cross or
collide (during Confirm link timeout).

This issue requires an immediate solution, since the protocol updates
involve a more long-term solution.

Fixes: 0fb0b02bd6fd ("net/smc: adapt SMC client code to use the LLC flow")
Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
Reviewed-by: Wen Gu <guwen@linux.alibaba.com>
Reviewed-by: Wenjia Zhang <wenjia@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/af_smc.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 49cf523a783a2..8c11eb70c0f69 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -398,8 +398,12 @@ static int smcr_clnt_conf_first_link(struct smc_sock *smc)
 	struct smc_llc_qentry *qentry;
 	int rc;
 
-	/* receive CONFIRM LINK request from server over RoCE fabric */
-	qentry = smc_llc_wait(link->lgr, NULL, SMC_LLC_WAIT_TIME,
+	/* Receive CONFIRM LINK request from server over RoCE fabric.
+	 * Increasing the client's timeout by twice as much as the server's
+	 * timeout by default can temporarily avoid decline messages of
+	 * both sides crossing or colliding
+	 */
+	qentry = smc_llc_wait(link->lgr, NULL, 2 * SMC_LLC_WAIT_TIME,
 			      SMC_LLC_CONFIRM_LINK);
 	if (!qentry) {
 		struct smc_clc_msg_decline dclc;
-- 
2.42.0



