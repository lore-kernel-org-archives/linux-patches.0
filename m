Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3948FBA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:20:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 892F8C433A0;
	Tue,  7 Mar 2023 17:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209626;
	bh=pqBOIN0vjKr0hvji9yvYaio+5//deXvS3cThIIRruyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=id5alzokm4/yDGxXROZ/jUtS0vxsCybRUTQlP++f3fqdscheWDCQuTlp1QbOsZNpz
	 Xrvgn3Lae63J+PS9OotPH9+xN6ZqLDhCVZqn+LDHwEYQdKww3pgyWSN3HVGQFMMtN4
	 GAww9WLNLOvWU0KDHd4Xfnuv8bsEp3RuMM7cs5dc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Pietro Borrello <borrello@diag.uniroma1.it>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0279/1001] rds: rds_rm_zerocopy_callback() correct order for list_add_tail()
Date: Tue,  7 Mar 2023 17:50:51 +0100
Message-Id: <20230307170033.761610811@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pietro Borrello <borrello@diag.uniroma1.it>

[ Upstream commit 68762148d1b011d47bc2ceed7321739b5aea1e63 ]

rds_rm_zerocopy_callback() uses list_add_tail() with swapped
arguments. This links the list head with the new entry, losing
the references to the remaining part of the list.

Fixes: 9426bbc6de99 ("rds: use list structure to track information for zerocopy completion notification")
Suggested-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Pietro Borrello <borrello@diag.uniroma1.it>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/message.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rds/message.c b/net/rds/message.c
index c19c935612278..7af59d2443e5d 100644
--- a/net/rds/message.c
+++ b/net/rds/message.c
@@ -118,7 +118,7 @@ static void rds_rm_zerocopy_callback(struct rds_sock *rs,
 	ck = &info->zcookies;
 	memset(ck, 0, sizeof(*ck));
 	WARN_ON(!rds_zcookie_add(info, cookie));
-	list_add_tail(&q->zcookie_head, &info->rs_zcookie_next);
+	list_add_tail(&info->rs_zcookie_next, &q->zcookie_head);
 
 	spin_unlock_irqrestore(&q->lock, flags);
 	/* caller invokes rds_wake_sk_sleep() */
-- 
2.39.2



