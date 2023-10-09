Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3B111A5A4
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oa51P5L5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 509C6C433C7;
	Mon,  9 Oct 2023 13:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857820;
	bh=WegpTihH3BhS88QABTC2mWfihMuEsGwhRqy1eo9kneM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Oa51P5L5Hot/YkpIijs3uHc0aHI/uL2JjIz8Jrd+k4/BDJ6bLLr6MdHWI3j4u4W+O
	 W/xNQyvlLhgmzI6X1U6+jYB66eCNPzvFiLkfmFcclnnJHSwyjxHrf0g+r2o+zVav5z
	 OVGIur1Te09etqvAiHSQpqwv3PcXNcUVVeBY8Obc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Long <lucien.xin@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 130/162] sctp: update hb timer immediately after users change hb_interval
Date: Mon,  9 Oct 2023 15:01:51 +0200
Message-ID: <20231009130126.506099253@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130122.946357448@linuxfoundation.org>
References: <20231009130122.946357448@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 1f4e803cd9c9166eb8b6c8b0b8e4124f7499fc07 ]

Currently, when hb_interval is changed by users, it won't take effect
until the next expiry of hb timer. As the default value is 30s, users
have to wait up to 30s to wait its hb_interval update to work.

This becomes pretty bad in containers where a much smaller value is
usually set on hb_interval. This patch improves it by resetting the
hb timer immediately once the value of hb_interval is updated by users.

Note that we don't address the already existing 'problem' when sending
a heartbeat 'on demand' if one hb has just been sent(from the timer)
mentioned in:

  https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg590224.html

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Link: https://lore.kernel.org/r/75465785f8ee5df2fb3acdca9b8fafdc18984098.1696172660.git.lucien.xin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/socket.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 32e3669adf146..e25dc17091311 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -2449,6 +2449,7 @@ static int sctp_apply_peer_addr_params(struct sctp_paddrparams *params,
 			if (trans) {
 				trans->hbinterval =
 				    msecs_to_jiffies(params->spp_hbinterval);
+				sctp_transport_reset_hb_timer(trans);
 			} else if (asoc) {
 				asoc->hbinterval =
 				    msecs_to_jiffies(params->spp_hbinterval);
-- 
2.40.1



