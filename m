Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050450;
	b=P5WXQPKRKteG2fynt9H4P5jaPzClauy8Y8GP7tHVCPC4/d0u6Mmj40+I3cUCcNZg7usv
	 P0nrr6yDv9fUXo8Lv3b4m2fH32LZ2QruDD1jKWC64q0jH78AqtLFmk/GUL1StlKI3S4gw
	 UwqKPmcCNYMCki+n8XCT1NWAM4PQ0RkBuft5jy6N0pCc+4PAMt6aCZeppxoDEseTCgTCq
	 w2MRNXGs46rQV2w9Gev92hjxfs9uf3DZUpgKx25j48m71wQVbavTyTRIZZvHynH3+CA/7
	 PEqUGrMvAD6XnioCf2Aiz0X0yHDzRjSnCyDh7FPlOuyEoGw1PONEBARNlLITSpnKGQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050450;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8flGor2NafqeTguYkBDGw3xoPcgVh69Q9p6pF81FYAo=;
	b=CT1WeG0+V5uHbb9Ly6FYrlVk98k9V9gd1TzS0VMU1RuhH96+9MdL8ZhXSxIoJJilPVss
	 SPbSYdb+k8G8q/xRR74ao7CJXOqh0O4RLs5otGyhktFpAVrILSzv16z7fe+IlNldoGdPP
	 wcOgBc6Xze0EvCVAGPUSYfKxJiy02aP4etGLYoqxVieIYnTD/fD9DI6OVkoePypEO1/TR
	 4CtPLNHpg50+aAv4se+54POXMJwD7WoWelqg1ncJqkAta8OlEuQi/Pf0tQR9RFN4eGCwr
	 5LP17UPYVoC/Yy9XXOscVfPzOfG07HRf3DRl3liZIbGC5I0y4A28SiclrbqS87c8OGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aZP2E+6G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5DC0606A325;
	Thu, 19 Nov 2026 01:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aZP2E+6G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30FB31F000C4;
	Thu, 19 Nov 2026 01:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050450;
	bh=8flGor2NafqeTguYkBDGw3xoPcgVh69Q9p6pF81FYAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aZP2E+6Gqn9typUpMFRboAo3fjaA9zxGSvrQDkfKByKEaUUm3P6ZAkivY7tqptuav
	 slS+BM56cuTTzaFEYEO7+YAX1l2pwvYwvbl3vHjTIru/vUgInPhG74p4yn9r5YAyS2
	 eT0+ioYqa09n5vudjPWqK+H5KFqanDDbEXyFLUoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anil Kaushik <anilkaushikwireless@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2672/2857] gtp: hold RCU for the device lookup when adding a PDP context
Date: Wed, 18 Nov 2026 16:01:46 +0100
Message-ID: <20261118150337.783380628@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anil Kaushik <anilkaushikwireless@gmail.com>

[ Upstream commit fe3e1a42fb7eb18d8c55d714b50a3d51f8cd6ffe ]

gtp_genl_new_pdp() calls gtp_find_dev(), which looks the device up with
dev_get_by_index_rcu(). Since commit e2d1baca2b33 ("gtp: remove useless
rcu_read_lock()"), this only runs under the rtnl lock, and kernels with
CONFIG_PROVE_RCU_LIST warn:

  WARNING: suspicious RCU usage
  net/core/dev.c:1047 RCU-list traversed in non-reader section!!
  ...
   dev_get_by_index_rcu
   gtp_find_dev
   gtp_genl_new_pdp

Hold the RCU read lock around the lookup only: gtp_pdp_add() allocates
with GFP_KERNEL, and the rtnl lock keeps the device alive afterwards.

Found with the gtp selftest on a debug kernel.

Fixes: e2d1baca2b33 ("gtp: remove useless rcu_read_lock()")
Signed-off-by: Anil Kaushik <anilkaushikwireless@gmail.com>
Link: https://patch.msgid.link/20261016093225.1036375-3-anilkaushikwireless@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/gtp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index ea5d1cb255f33..0303f24815a1b 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -1496,7 +1496,10 @@ static int gtp_genl_new_pdp(struct sk_buff *skb, struct genl_info *info)
 
 	rtnl_lock();
 
+	/* the rtnl lock keeps the device alive once found */
+	rcu_read_lock();
 	gtp = gtp_find_dev(sock_net(skb->sk), info->attrs);
+	rcu_read_unlock();
 	if (!gtp) {
 		err = -ENODEV;
 		goto out_unlock;
-- 
2.53.0



