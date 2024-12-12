Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23F3A21578E;
	Thu, 12 Dec 2024 15:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017715; cv=none; b=kJqyCAxey6DoZPInTf31qP7+TfoXDSeKwE3oO/frCDxsdXACbC+Jc7w7ty/yZbiamk7V9PVacOBOB/LoDaODSLzw/vtnJIcHaF0t0v1iW6ewgqMPytGBLG2yzI/s7f4dsNiwTMcLMpAEsIPB8RdAzc9LTg8ws7sYDnEP4kvKyvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017715; c=relaxed/simple;
	bh=9w4q49ul6SpU51qV3NW5u99YuFwHdcOdypTxmSB42j0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fxo8anWYE40zmLJ2DiWDqBL2k2f0dfK2rAhS7biHzLn+MFMeRCiS2v+QqsUAmvKZNc8lyZ8ekTMxae4nBaF4BPX89RdAwZSLtbq5b4sDwKzR/i+H+pSD120pLb1h1gcf6gOvr5hlP125bi3abcLr4tnVrOxa3eHtqXX6TK/s6vQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e1YORaaW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e1YORaaW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BC05C4CED4;
	Thu, 12 Dec 2024 15:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017713;
	bh=9w4q49ul6SpU51qV3NW5u99YuFwHdcOdypTxmSB42j0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e1YORaaWLod5r1ZbsSYOJEr/ATZKZjGidZwtrUVdq3Z7MiyMmtZQFGp3yVrPeWwTF
	 zcLd8R56SoSnQ79AgfIopRpFLjknrhFHSX+67tF992X+EdUQFbDwww+xDqlV0h2AGO
	 N9rt4iiDp6p9jqeZmhLt06ODM0IC5I6Hu200ItMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Shin Kawamura <kawasin@google.com>,
	Brian Geffon <bgeffon@google.com>,
	Minchan Kim <minchan@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 089/356] zram: clear IDLE flag in mark_idle()
Date: Thu, 12 Dec 2024 15:56:48 +0100
Message-ID: <20241212144248.134124194@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

[ Upstream commit d37da422edb0664a2037e6d7d42fe6d339aae78a ]

If entry does not fulfill current mark_idle() parameters, e.g.  cutoff
time, then we should clear its ZRAM_IDLE from previous mark_idle()
invocations.

Consider the following case:
- mark_idle() cutoff time 8h
- mark_idle() cutoff time 4h
- writeback() idle - will writeback entries with cutoff time 8h,
  while it should only pick entries with cutoff time 4h

The bug was reported by Shin Kawamura.

Link: https://lkml.kernel.org/r/20241028153629.1479791-3-senozhatsky@chromium.org
Fixes: 755804d16965 ("zram: introduce an aged idle interface")
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reported-by: Shin Kawamura <kawasin@google.com>
Acked-by: Brian Geffon <bgeffon@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/zram/zram_drv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index e05eace18cc47..27f9ae16a7282 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -319,6 +319,8 @@ static void mark_idle(struct zram *zram, ktime_t cutoff)
 #endif
 		if (is_idle)
 			zram_set_flag(zram, index, ZRAM_IDLE);
+		else
+			zram_clear_flag(zram, index, ZRAM_IDLE);
 		zram_slot_unlock(zram, index);
 	}
 }
-- 
2.43.0



