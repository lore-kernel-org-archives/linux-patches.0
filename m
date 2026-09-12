Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08AC95475F;
	Sat, 12 Sep 2026 14:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224150; cv=none; b=BkjSfD8IiTMiEV5HyStr7QIwIg1R4kzJOhfWzCL8rf/lSLIbvOHWPFIvBzZRRB5tIQWAqiYkejsEyXeE/ZDoUjYY02tXCkoQEVmcWhaWxMwr/RiwJ6cW0uxTtW2+3pkTMsWZCplgNqgghcKCpxKGZWc2ce6ObMjUk4SZ445ZcpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224150; c=relaxed/simple;
	bh=dkitCAqJUX5QJcyDoc+p5t64SEqTxzApjJiYr1BoCm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RuwvFpOi4/B6fRDmz10X04S9u3iRpsDe6m0Xar4Z3LeJ7aVRIp+Cec7F3Zhwbl4sUxgq6ECNj4S5hJUjXO2gNSLZgeBerbJIuY6/5IKz2QJrJGtGUU7lLzFuy/IOgut0G2EZe1zLpJA8BuQHpxCmm8M8EEk9mhDP7SUje/Kf4Uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ssK6r0oF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ssK6r0oF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C38CC1F000FF;
	Sat, 12 Sep 2026 14:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224148;
	bh=1kCjMV8DNUz3aXVFhR5Qu6cDNxLt1rcNd9QsWaAQ1rU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ssK6r0oF1ouf9MBTuGCuYuFTkLXpnqhIBSXUzvciPsQWqi1YS2QM3Sm1JKSNURk+x
	 RZa8xj2OrS2F5s9Y9CE+nVKBAxQi4d8oMRWjDncblqOQm+MK8ogvCOinUdTUc3ISd1
	 9H9RvuKvWgYTjBioImjPWigNkOiHy/Esx58WRItY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Sajal Gupta <sajal2005gupta@gmail.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0934/1424] md/raid5-ppl: fix use-after-free in ppl_do_flush()
Date: Sat, 12 Sep 2026 08:56:06 +0200
Message-ID: <20260912065628.238598625@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index eaea57aee602c..caea1c5ffee6c 100644
--- a/drivers/md/raid5-ppl.c
+++ b/drivers/md/raid5-ppl.c
@@ -645,8 +645,10 @@ static void ppl_do_flush(struct ppl_io_unit *io)
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



