Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 485C63A542B;
	Sat, 17 Oct 2026 17:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259231; cv=none; b=Di09llF8XSsyZ5A3XjaYVw8TGEVhu/b8Po1Bm5VRL1qZ5sx8VpISM2G2FAnJ6jgE5T5uQvWeVPPtmRLMzdJ5kMPYTOJ4Z5NaM0iHTv0xYJJuNWfqZD5TWPBaP12DaAQmtz474Q4rtxaOHzuvj20iqBUdQBL9wYPctCGpwSX9VDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259231; c=relaxed/simple;
	bh=BpgAHIVEGJRtMClDtKSyRjKRlEc/xQ7bGZmDhPUW59g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r+3KnSiS9vbXz4xzVfzZ881uKnO3bH66qSbfNMFARN8x66NOYSMHc0SMB13r7AYDRWkdHoKdhHErCLwpZBOXekFz+Qr25fy1m8QaZaJpL+PfYFUsCH+ILg4VDMcj/SCFbLJs1Tgt8n5tDoZNSair25X+LMKOGAgNwUwfbyulAF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=os46M6vc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="os46M6vc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A143B1F000C4;
	Sat, 17 Oct 2026 17:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259230;
	bh=TZ57N8FgPfr1dTDb+kfwISPm/tVmO04gc+CL+B68gAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=os46M6vc0elDXpxc+Buh06eIby/kiZtcPOcgEHcDeeg1KHXmgJr+1ck0+ZPFHZMjS
	 VcZtgilMJWKvLMMkoefZbdZ/3SrIEAKD1y9cIkICX+KMKRfKfj94rVDAl+gTCj+r7V
	 tDSYBg4/HOs2vr3j1WgrOn7I26aLnJpjl/1KQQ24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1143/1674] md/raid10: fix writes_pending and barrier reference leaks on discard failures
Date: Sat, 17 Oct 2026 17:56:55 +0200
Message-ID: <20261017160500.494645973@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>

[ Upstream commit 393d687131d8aa8c7e4de2cb494438e145d20fc2 ]

raid10_make_request() acquires a writes_pending reference with
md_write_start() before calling raid10_handle_discard(). Several failure
paths in raid10_handle_discard() complete the bio and return without
releasing the corresponding reference, causing md_write_end() to be
skipped.

Call md_write_end() before returning from these failure paths to keep
writes_pending accounting balanced.

Additionally, discard split allocation failures can occur after
wait_barrier() succeeds. Those paths return without calling
allow_barrier(), leaking the associated barrier reference.

Release the barrier before returning from those paths.

Fixes: c9aa889b035f ("md: raid10 add nowait support")
Fixes: 4cf58d952909 ("md/raid10: Handle bio_split() errors")
Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Link: https://patch.msgid.link/20260613182810.1317258-4-abd.masalkhi@gmail.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid10.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 08f59c1ad2751..d055365f91302 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1655,6 +1655,7 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 
 	if (!wait_barrier(conf, bio->bi_opf & REQ_NOWAIT)) {
 		bio_wouldblock_error(bio);
+		md_write_end(mddev);
 		return 0;
 	}
 
-- 
2.53.0



