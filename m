Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD4293D0A1;
	Wed, 21 Feb 2024 14:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525528; cv=none; b=lHW7IMmUB3ejgxXui/fxjaGlCz4LggrrZ3OzE3oqaEB63qBaHfu8p0ZEi1fcsEbBX6iU1iAouJYuLyeMUYVidIpVJWc2MJv8YfYcYxOscauAjQOSMpdlC7VMRN0PmYHxz7ybwGCzPIU/GKBO0ml0FAWG04MV4vx/tf4LXunBvx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525528; c=relaxed/simple;
	bh=0a6TuoKdfS4f/djxn2eo0fhW0Vovc7bSsDDgAp/KDs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ICGS2pgcgS4/hm68oY9972txf6hsfJKnxU/8CHsbRBNKuik9vt9Q23lUlQozzBvE/wcX859ZYfKZHdyIIAW2F6DxhEWhoytsyHsFWxsF84JuyO8SEe993eDHzSQng0kZleVAX5RXMBw1o5yuvDsVHPm33jpNlg1pxU6fg3RJuVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=THW2QrX8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="THW2QrX8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6E70C433C7;
	Wed, 21 Feb 2024 14:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525528;
	bh=0a6TuoKdfS4f/djxn2eo0fhW0Vovc7bSsDDgAp/KDs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=THW2QrX8bMao3rD4mUF+bkf2TrClDpi3tdLD/uJib/kNzGJKv4Q58YLEn7XrK5XM5
	 cTeVWS5EOaEE4xXDVjRh/yfCI2mcbBxztVtIIw31Ddtfv7i4mceUaLGSophB0//JWJ
	 K3UEs8nJeMei0ZZ5i1LpFM3R9OrnOafq01SVTgu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhipeng Lu <alexious@zju.edu.cn>,
	Jiri Pirko <jiri@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 183/267] atm: idt77252: fix a memleak in open_card_ubr0
Date: Wed, 21 Feb 2024 14:08:44 +0100
Message-ID: <20240221125945.870534780@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index c60611196786..605e992d25df 100644
--- a/drivers/atm/idt77252.c
+++ b/drivers/atm/idt77252.c
@@ -2935,6 +2935,8 @@ open_card_ubr0(struct idt77252_dev *card)
 	vc->scq = alloc_scq(card, vc->class);
 	if (!vc->scq) {
 		printk("%s: can't get SCQ.\n", card->name);
+		kfree(card->vcs[0]);
+		card->vcs[0] = NULL;
 		return -ENOMEM;
 	}
 
-- 
2.43.0



