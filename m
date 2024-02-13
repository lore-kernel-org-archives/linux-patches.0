Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 884805FBB5;
	Tue, 13 Feb 2024 17:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845013; cv=none; b=TBoqDb49mzhoCBvRuoA4Oklf0sJb5RHlHJH8CW+ug4CoaqFm7A/leX7ndBAuKdqsNM4aE25C23PT+3vt1UolmRz4SwXtjsI6Q9N0y+t3aT8SYr1hDuzOxfX9PvKJbb0HkTBry6VHrJUWU/L0fg1aam79FupIr6U5Je0Vl0abJCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845013; c=relaxed/simple;
	bh=LS8XPzuqW+p3dYTHcaYV7E8WL1FYgP9zJwR/gI5o5ZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ax/Ib989xj+3bfYxIxOGR8OQFWW/nkxkg/5BbNJMjJ2y9Tps26Qr1Q5oAZauRGd8qDSOPmtVqzhttjLCsw1uoqqmREtzqztsf3CoJq80gJMCLfdy949jntESYasaPVWgo3cIMCU5N/oTZKQJcnYoAvKHerJE293II4zpCSzTnnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bOCyXBW8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bOCyXBW8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0B9FC433F1;
	Tue, 13 Feb 2024 17:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845013;
	bh=LS8XPzuqW+p3dYTHcaYV7E8WL1FYgP9zJwR/gI5o5ZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bOCyXBW8laMQh/9Cx6Jae1KPVl8bFNwq0RszVKkCs+kvwKfZF3Gn3tGjQCc37miAM
	 eUmgAIR1KmLUIduJp0Z8UGsrbnkbM0550O6qLYrKrTopD0Vyh4lq/ybUKdVTEpOjZO
	 C6EW7TzSGdQZGA+HBFmfoyXWJSLnKOhJ4MtqU6Ns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhipeng Lu <alexious@zju.edu.cn>,
	Jiri Pirko <jiri@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 20/64] atm: idt77252: fix a memleak in open_card_ubr0
Date: Tue, 13 Feb 2024 18:21:06 +0100
Message-ID: <20240213171845.368667967@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171844.702064831@linuxfoundation.org>
References: <20240213171844.702064831@linuxfoundation.org>
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

From: Zhipeng Lu <alexious@zju.edu.cn>

[ Upstream commit f3616173bf9be9bf39d131b120d6eea4e6324cb5 ]

When alloc_scq fails, card->vcs[0] (i.e. vc) should be freed. Otherwise,
in the following call chain:

idt77252_init_one
  |-> idt77252_dev_open
        |-> open_card_ubr0
              |-> alloc_scq [failed]
  |-> deinit_card
        |-> vfree(card->vcs);

card->vcs is freed and card->vcs[0] is leaked.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Zhipeng Lu <alexious@zju.edu.cn>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/atm/idt77252.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/atm/idt77252.c b/drivers/atm/idt77252.c
index 49cb4537344a..2daf50d4cd47 100644
--- a/drivers/atm/idt77252.c
+++ b/drivers/atm/idt77252.c
@@ -2930,6 +2930,8 @@ open_card_ubr0(struct idt77252_dev *card)
 	vc->scq = alloc_scq(card, vc->class);
 	if (!vc->scq) {
 		printk("%s: can't get SCQ.\n", card->name);
+		kfree(card->vcs[0]);
+		card->vcs[0] = NULL;
 		return -ENOMEM;
 	}
 
-- 
2.43.0



