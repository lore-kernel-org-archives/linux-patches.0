Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E803F4E36DC;
	Wed, 30 Sep 2026 16:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786703; cv=none; b=LCUCD0ecj+TOj8ez+sKd93eQ0JeNKZ34AQSOcJBW+w2G88Lbj5SvL33aLNW9FU+xKCTzhG/k4rYiq49P2mn0PRZA06lPR72BJwAKZc6DCpoS+gndL55UKaqkDp+PrzO5s64cGJR8MuKYBCcTThfadT+gjBOHn31JPIphs3fnflk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786703; c=relaxed/simple;
	bh=5W4LWjYqxyyxeHp1MOUNwk3JmN28X95GaeosN1d3KYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dTYuW9mCzE2UM9gdYWOfNWhk0ybJJ4plIvTGpOGMp/wiEem2P8auOWmEcNr9QAwxwpZpwgDfHIN8/khd95RxPV5u3coqz4Qt5AMihIwxmEsndeW3YA7SJ/JXeZbeHZx+B9z1zYIM5v+xdQcmPPHFxVcb+7G5gYVetbHYXSnOtS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BAZGHVkp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BAZGHVkp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C0021F000FF;
	Wed, 30 Sep 2026 16:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786701;
	bh=SAHaLaD3OYZFGwjMNyJA53MW/bTeuh3f54MvQsijjog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BAZGHVkpPAsUOb0aiYF6FsaCHagM6gVMgTE2tv+zE5xin2BLeXlR88oFy1H4ikCLT
	 cY7g7BjDzvzYytiXd2lrWJ/uGOiVUdbVO1gfmlHwh2Z/3S4BYBVZQHi2Xq1NTseT9I
	 xOigTCpzT21ocbgeWi7K3xJFGwqfph1rnzccFMno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Peng <benquike@gmail.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 928/982] fou: reject omitted FOU_ATTR_IPPROTO on FOU_ENCAP_DIRECT
Date: Wed, 30 Sep 2026 17:27:44 +0200
Message-ID: <20260930152436.674444443@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hui Peng <benquike@gmail.com>

commit d22609f3d13fc5baacd92c222731b03c593401db upstream.

Commit 7a9bc9e3f423 ("fou: Don't allow 0 for FOU_ATTR_IPPROTO.") added
NLA_POLICY_MIN(NLA_U8, 1) to fou_nl_policy[FOU_ATTR_IPPROTO], which
rejects an explicitly supplied FOU_ATTR_IPPROTO == 0 attribute with
-ERANGE.

However, FOU_ATTR_IPPROTO is an optional netlink attribute. When a user
sends FOU_CMD_ADD with FOU_ATTR_TYPE set to FOU_ENCAP_DIRECT and omits
FOU_ATTR_IPPROTO entirely, nla_policy validation succeeds and
parse_nl_config() leaves cfg->protocol as 0 (from memset(cfg, 0,
sizeof(*cfg))). fou_create() then creates a FOU_ENCAP_DIRECT socket with
fou->protocol == 0.

In fou_udp_recv(), returning -fou->protocol to udp_queue_rcv_one_skb()
triggers IP protocol resubmission when fou->protocol > 0, whereas
returning 0 tells the UDP tunnel layer that the skb was consumed without
freeing it. When fou->protocol == 0, every packet received on the socket
returns 0 from fou_udp_recv() and leaks the sk_buff.

Reject FOU_ENCAP_DIRECT when !cfg->protocol in fou_create() so that
creating a direct encapsulation port without FOU_ATTR_IPPROTO fails with
-EINVAL while leaving FOU_CMD_DEL and FOU_CMD_GET (which share
parse_nl_config()) unaffected.

Tested in QEMU against Linux 7.3.0-rc3 by sending a FOU_CMD_ADD Generic
Netlink request with FOU_ATTR_PORT = 5555 and FOU_ATTR_TYPE =
FOU_ENCAP_DIRECT while omitting FOU_ATTR_IPPROTO. On the unfixed kernel,
FOU_CMD_ADD succeeds (err = 0), FOU_CMD_GET reports fou->type = 1 and
fou->protocol = 0, and sending 4000 UDP packets to 127.0.0.1:5555 leaks
all 4000 sk_buffs (SUnreclaim in /proc/meminfo grows from 41456 kB to
59008 kB, +17552 kB); with this patch applied, FOU_CMD_ADD is rejected
with -EINVAL (-22).

Fixes: 23461551c006 ("fou: Support for foo-over-udp RX path")
Fixes: 7a9bc9e3f423 ("fou: Don't allow 0 for FOU_ATTR_IPPROTO.")
Cc: stable@vger.kernel.org
Signed-off-by: Hui Peng <benquike@gmail.com>
Reviewed-by: Hangbin Liu <liuhangbin@kylinos.cn>
Link: https://patch.msgid.link/20260921045920.1613098-1-benquike@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/fou_core.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/ipv4/fou_core.c
+++ b/net/ipv4/fou_core.c
@@ -607,6 +607,10 @@ static int fou_create(struct net *net, s
 	/* Initial for fou type */
 	switch (cfg->type) {
 	case FOU_ENCAP_DIRECT:
+		if (!cfg->protocol) {
+			err = -EINVAL;
+			goto error;
+		}
 		tunnel_cfg.encap_rcv = fou_udp_recv;
 		tunnel_cfg.gro_receive = fou_gro_receive;
 		tunnel_cfg.gro_complete = fou_gro_complete;


