Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0505207670;
	Fri,  6 Dec 2024 15:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498588; cv=none; b=Ht7YVfUQ1mismqXqo5MeHMeR2J75kbuyhLRgwppYpcH5BfcSiBq3ZhXPiAlu8THv48Arj6ylhPWQr/sVilrS74ss3lB7/eHCI4cAyEajXNOr6iJZ71PuWmdNswmxpjtzXn9A/O0n2bE26ovnGN1pGz0QgT65hFonmv6EI1Kumkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498588; c=relaxed/simple;
	bh=fN3Iggj0AFHdqxZpns4WczRBcv1dwQ8N1DTwos/9hiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JfbxXomOaPYqkZkmHoU8HlszgCHc5cP/cD7vpDioTfF+Rs/3Ozl/Nglo9f0/rLSoBdXDpJHpdmgGAi5Fh7FY0m6e2z/kYuJAcoyTrCDZFsfGp+cfvo6SecvXp4DHAphxB/y0KlgA/cz+T5AwWW3ytNe53qlNqYxn7qoo/HA45TY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eUK3G8fw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eUK3G8fw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C9FCC4CED1;
	Fri,  6 Dec 2024 15:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498588;
	bh=fN3Iggj0AFHdqxZpns4WczRBcv1dwQ8N1DTwos/9hiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eUK3G8fwrszjdhaFoeADJbjXZ17KzEAH7zbfT3YdMXKe4FqAqPf3yLr+8Dww0CHha
	 HS5iEcTITjEPVkR2pSN9JwS0/Wp1O1h8m0QKOJcFF+8Z/0H8a9mVwYrVy0CMQbIebp
	 ziLUKbMn6kUOKWQYhHYV+EncRwRK1VBNcB8XU6sc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Shin Kawamura <kawasin@google.com>,
	Brian Geffon <bgeffon@google.com>,
	Minchan Kim <minchan@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 630/676] zram: clear IDLE flag after recompression
Date: Fri,  6 Dec 2024 15:37:29 +0100
Message-ID: <20241206143717.975207918@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Senozhatsky <senozhatsky@chromium.org>

commit f85219096648b251a81e9fe24a1974590cfc417d upstream.

Patch series "zram: IDLE flag handling fixes", v2.

zram can wrongly preserve ZRAM_IDLE flag on its entries which can result
in premature post-processing (writeback and recompression) of such
entries.

This patch (of 2)

Recompression should clear ZRAM_IDLE flag on the entries it has accessed,
because otherwise some entries, specifically those for which recompression
has failed, become immediate candidate entries for another post-processing
(e.g.  writeback).

Consider the following case:
- recompression marks entries IDLE every 4 hours and attempts
  to recompress them
- some entries are incompressible, so we keep them intact and
  hence preserve IDLE flag
- writeback marks entries IDLE every 8 hours and writebacks
  IDLE entries, however we have IDLE entries left from
  recompression, so writeback prematurely writebacks those
  entries.

The bug was reported by Shin Kawamura.

Link: https://lkml.kernel.org/r/20241028153629.1479791-1-senozhatsky@chromium.org
Link: https://lkml.kernel.org/r/20241028153629.1479791-2-senozhatsky@chromium.org
Fixes: 84b33bf78889 ("zram: introduce recompress sysfs knob")
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reported-by: Shin Kawamura <kawasin@google.com>
Acked-by: Brian Geffon <bgeffon@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/zram/zram_drv.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1600,6 +1600,13 @@ static int zram_recompress(struct zram *
 	if (ret)
 		return ret;
 
+	/*
+	 * We touched this entry so mark it as non-IDLE. This makes sure that
+	 * we don't preserve IDLE flag and don't incorrectly pick this entry
+	 * for different post-processing type (e.g. writeback).
+	 */
+	zram_clear_flag(zram, index, ZRAM_IDLE);
+
 	class_index_old = zs_lookup_class_index(zram->mem_pool, comp_len_old);
 	/*
 	 * Iterate the secondary comp algorithms list (in order of priority)


