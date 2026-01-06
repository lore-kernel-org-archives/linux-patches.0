Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEE3C33B6CA;
	Tue,  6 Jan 2026 17:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720983; cv=none; b=etMaqGup0hOg7vDlbL2/TpT/1dGJbofMxRkE2ZBKBISpnTf11ogcvBwwwdXQOZnuMeP8xMMY/URidprerCe/OzP5Cq6nCtJEQnNMfR7/5REiNKyqa2juE3zOBFpqslNjTF750y8m6+LZUgKlvgxqb4PGrW0vzfv1c8TG5GeMqmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720983; c=relaxed/simple;
	bh=KpnTsvFefhuSKBC4iqDTNJfGG97NXZ6LSd8eWHFlKwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AW1EngH2jNuee27Nj6EnsUEGkBVSpGx9AOJPitjvByR+nmT21+LlMWWAMBNVghV8Yez2mPsY9d1Lh8bsp+qGxnoTUprIU1f3wb/XwoCI4mBVvbTWVKi+m8HBgfyyO2WiTX6jzF1MFNnth26J9RnqDGEuAl2KYnDdLsFng3b2Y5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EUFngG8c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EUFngG8c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38177C16AAE;
	Tue,  6 Jan 2026 17:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720982;
	bh=KpnTsvFefhuSKBC4iqDTNJfGG97NXZ6LSd8eWHFlKwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EUFngG8cKF7xnJ6xvUSEf07lBbk6r7vIzYMpzzT8ousbluaimUg1M1Q9XI3YXhUR4
	 TyNnIbKvrmQnaNgpomVW9wHQefAixN4EYk0M5ddzyXcvT69hpTC+NHNVo4lV1rZSxN
	 7uE2qmXj5JMWt0HlKuZhbAWP83nYrAQen3fGcaAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ren=C3=A9=20Rebe?= <rene@exactco.de>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.12 401/567] fbdev: tcx.c fix mem_map to correct smem_start offset
Date: Tue,  6 Jan 2026 18:03:03 +0100
Message-ID: <20260106170506.175841148@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: René Rebe <rene@exactco.de>

commit 35fa2b4bf96415b88d7edaa5cf8af5185d9ce76e upstream.

403ae52ac047 ("sparc: fix drivers/video/tcx.c warning") changed the
physbase initializing breaking the user-space mmap, e.g. for Xorg
entirely.

Fix fbdev mmap table so the sbus mmap helper work correctly, and
not try to map vastly (physbase) offset memory.

Fixes: 403ae52ac047 ("sparc: fix drivers/video/tcx.c warning")
Cc: <stable@vger.kernel.org>
Signed-off-by: René Rebe <rene@exactco.de>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/tcx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/video/fbdev/tcx.c
+++ b/drivers/video/fbdev/tcx.c
@@ -428,7 +428,7 @@ static int tcx_probe(struct platform_dev
 			j = i;
 			break;
 		}
-		par->mmap_map[i].poff = op->resource[j].start;
+		par->mmap_map[i].poff = op->resource[j].start - info->fix.smem_start;
 	}
 
 	info->fbops = &tcx_ops;


