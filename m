Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD9CF1EB5FD;
	Sat, 12 Sep 2026 08:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200310; cv=none; b=PeBURwiDGA/6bGWteQZ8ITeEwTGt53bYGA1T34Nl/5LTA2bo5RPNun/ClZBoRhHmSEk6kwYXnUZi2giQdtlCUBBsJ2eF2wR+HDKAiov0xEpdN6YUb/lkGjeupnvnIZDlFQYJIkXD5EMisasyJSaVj6ZkahUXdj3eUPPUQIQMcYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200310; c=relaxed/simple;
	bh=OHy4ehhvSIu+v/m6xZ4B3bDFCffdleEfAxKgvcbAQIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ESVYgK6e2477lCy+oAXcSkFKkfX4mOeCnPpPYaGHAGu5ilEN2WrEPqDBT0ZAEwoDfvsCMQgB9pnDzYJg+p1CFdLxHo+EmQshRIehrtZ0QP9lO9o0pU02T6oIKQDRQT0UZZMpneGfP9LJMCMKObX9fxuheJrSxJcOg6tW1BiAC0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uyJRrQmT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uyJRrQmT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD71C1F000FF;
	Sat, 12 Sep 2026 08:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200309;
	bh=7bHfunoSfCGlmpA7mHyW/AQ+dAb07Lt58NVxlD60bPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uyJRrQmTYxTvEdxcSNLB2+vhQOH3WtyCX4lKuJ79pGAmoW8n8uAaytVyVDgmBvLR1
	 d3LFz5iCQAJOZ23/b8534BFcYBW4WbTg9EyGkwcgYgz7c2TRnnx4sWUPK76DS3F/Fq
	 FWf9QsCrXXENPSTi83pynpcEFb8ojVe1KnoiBqQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Sajal Gupta <sajal2005gupta@gmail.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0763/1815] md/raid5-ppl: fix use-after-free in ppl_do_flush()
Date: Sat, 12 Sep 2026 08:41:53 +0200
Message-ID: <20260912065706.820437108@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 7be1648c4e4f0..7f8a9d3fd578d 100644
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



