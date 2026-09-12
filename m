Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 396853DB313;
	Sat, 12 Sep 2026 10:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208809; cv=none; b=YtJA55DJLr4OQKyCjhuYV6/R7qcPCEnhhYq5igbLsePQXnmWjOmsm6zsoXM28LUCHAvaa2FTkwENXyuSXbUNNF52FydEzBepy0CmVqrbMHSIQBuSQY5luWBdWvd94Q0e4I6cLKlZqN0/V3DzJVqmGzqBEUAPe54MebUobgJ+Yd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208809; c=relaxed/simple;
	bh=BjH1d7fOGkXn4h1L5VkawOViP29lRpeh1WlMpAYkyjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NTtoKbcWICTPB8oWQgMtPvkUfLkmW7tQObvx7PCr9Wrik9RNOI8olipluvn2a1x/2yL6KQQjBKhJYfTBa9ZRtdOfinNSN+UnA/wNeP4nfNqmiBKK78LT/pBDaISyZhbdn3dsNmQVRBpFqAYOFn0xRa5kaZ3a1/Pdu32fHiKqkSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y9m6OIng; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y9m6OIng"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E49951F000FF;
	Sat, 12 Sep 2026 10:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208808;
	bh=xgFu0/hf5bpPjJ//1BrakloscieqL3BET+ZIiZXOE2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y9m6OIngXY80OMIGH5Yd+PuwrnzVEquZrMFGClEDakWsqxBLEuDP1kJfG7QJcCywm
	 fDMnBjmopMFcF9blcj2gj27kxENwEeXuTpQWm9ezXcoZRZsS6eqw/pBA4XAxGMlvtd
	 Mf2Yh5unyv4d7sapYSufJXWzZeM43vogLDKY4geA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Sajal Gupta <sajal2005gupta@gmail.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0651/1518] md/raid5-ppl: fix use-after-free in ppl_do_flush()
Date: Sat, 12 Sep 2026 08:47:00 +0200
Message-ID: <20260912065638.156967944@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sajal Gupta <sajal2005gupta@gmail.com>

[ Upstream commit 371f7a1b392edc8b7cf449cc7713179b588f2d0e ]

The loop in ppl_do_flush() continues iterating after calling
ppl_io_unit_finished(), touching io->pending_flushes and leading to a
use-after-free.

Add a break statement to stop the loop once io is freed.

Fixes: 1532d9e87e8b ("raid5-ppl: PPL support for disks with write-back cache enabled")
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/all/ajJF2wKYWRk4GGCK@stanley.mountain/
Signed-off-by: Sajal Gupta <sajal2005gupta@gmail.com>
Reviewed-by: Yu Kuai <yukuai@fygo.io>
Link: https://patch.msgid.link/20260622142146.56637-1-sajal2005gupta@gmail.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid5-ppl.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid5-ppl.c b/drivers/md/raid5-ppl.c
index 56b234683ee6b..2678e82bfa52d 100644
--- a/drivers/md/raid5-ppl.c
+++ b/drivers/md/raid5-ppl.c
@@ -643,8 +643,10 @@ static void ppl_do_flush(struct ppl_io_unit *io)
 	log->disk_flush_bitmap = 0;
 
 	for (i = flushed_disks ; i < raid_disks; i++) {
-		if (atomic_dec_and_test(&io->pending_flushes))
+		if (atomic_dec_and_test(&io->pending_flushes)) {
 			ppl_io_unit_finished(io);
+			break;
+		}
 	}
 }
 
-- 
2.53.0



