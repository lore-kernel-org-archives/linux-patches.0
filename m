Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D4447ACE9;
	Sat, 12 Sep 2026 12:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216461; cv=none; b=mlVHzSx1Har0UhN3OI1vclC7cVE1H8cazCLdHPV3CcDtxhsVquVrSCLBndCHDU5BqcrsBvj+ryCv/Z/Agk2/wXPRmTmifx3hMG1ytP/Ss7vr5Qlv9K42cvL0/o5RD5vvMJUEwr2Oag17oiF7FRph+gqOGXWhjjvutBgRvnxKMA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216461; c=relaxed/simple;
	bh=AtBcOLez8HsnKauDUm9qwIuzPlnxYpPJ8/h6+0GOVVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R8XXpbgCmCyH7FkOK3imwJL7SS5940ece1wfCVKvZiQc1+6hw4e4DOrWUdKrwq7sQcbiYnNJiCr8BNDHVFQ/0SJScQuLOrcOWvZVoOttUz3g83Wcw8zQw8eZaVVFkebFORO2QrJWqXQ+xM/QFgg1PmotlJVW/y94f+MhpLRYfsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qNZ8SJ1g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qNZ8SJ1g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08E8D1F000FF;
	Sat, 12 Sep 2026 12:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216460;
	bh=N3/FvBbZkrPDbShnt+D6T0v05TMvOOYEovr9cOhsHDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qNZ8SJ1gU4tKz8YWZ2lxbltJGMAypXPUC4L33w/9Qr6VQOY8TjQbqXdUqHiMz1DEJ
	 bQUlRS4hQgWD8xYCrLBax/L5Wk3q+DuTU51x1t+JIGq+TL+2lk3GtDn4tzEd3ddM+B
	 LM+xwVUXIUB778yTlv3JdPkLKcpFBFq5zzzMns9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Sajal Gupta <sajal2005gupta@gmail.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0739/1376] md/raid5-ppl: fix use-after-free in ppl_do_flush()
Date: Sat, 12 Sep 2026 08:52:45 +0200
Message-ID: <20260912065624.014693004@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a70cbec12ed01..c3cfdd66d8b0c 100644
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



