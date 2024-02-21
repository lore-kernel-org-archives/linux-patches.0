Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4A411E4B2;
	Wed, 21 Feb 2024 13:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522982; cv=none; b=fljHkU7ZXagUeD+UgL1Q4tAd2gLAC+5N+mrF/vReyoLfLrNi66zgyLxHVcAEA/mcMrnZPJiNA5RZoNzfCre4GXPiZSw9+XoYHl8TPgkx1IseNyiMXBCruhvy+HJ1o3UZv5L41hDqaPlwvyMk5JgHP0vY+TKdaDC5MmKvtV1/AFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522982; c=relaxed/simple;
	bh=N1LfYUaiTKMbqre2tVt2qR1xz3LH7j3upj65bSetUQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QFM66QSxEUZO0RalB+akxhWs7q8NZVqU+Dv+X7DsAyAcJzqKFmaGY2D4zUvnxHj4s3nCUA+/5kTSiVOp7pymCqwBUVCsMNeIeYZoEBJ2q69/YBNyr/g8V4NJL/lvdp4yAc+JwLMa4kye+8xHywgvBFNq5iMhzWsUlqwVkvUF9qY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EdlnZg7v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EdlnZg7v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AEC2C433F1;
	Wed, 21 Feb 2024 13:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522981;
	bh=N1LfYUaiTKMbqre2tVt2qR1xz3LH7j3upj65bSetUQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EdlnZg7vBa47bVTJvZViYeaG5QmsI9Vu/cppppVyFW+ONM+2M+rsmkYI6de8Ft26K
	 Y25zqh1tON4b/hovxNdkaGTN0QiyMTlj3iEGxyYmf+BHvrDhXBpj7kzW3yPibrQixY
	 PSqcWacxCVFudyRHthGAI9+pZ4w4J+lFzlZepKio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhipeng Lu <alexious@zju.edu.cn>,
	Jiri Pirko <jiri@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 308/476] atm: idt77252: fix a memleak in open_card_ubr0
Date: Wed, 21 Feb 2024 14:05:59 +0100
Message-ID: <20240221130019.406908214@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



