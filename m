Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C32D728D8DF;
	Wed, 25 Feb 2026 01:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983770; cv=none; b=DTNrBNB/yTmrqWJaLDWAZMF0APVR3Jf0sjaC7JiDdOVbgxBaYQmc7fye5ZDzKp8CrEv8gLk2FOo/PrRfpmhL76NuuyPOW/S6DjGxgvzLAa5QggN3nz1Oj2aWTeqDWBfRRuPvKLmD+L+UwfLabeeHk2qOi3qxAHFtTTmO7nLVEH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983770; c=relaxed/simple;
	bh=hQZybT4PwKtWeHTZ53jjF6ZoqC9NS3IXde3Ih/5rucs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NSI2t7tva3V6U97cQpUt8l92ks9qCgWBr6w8MIQ8GZ/fz4nV7xZ8GJvv2bDBlbscl3qvWVp7iK4WXhyBVg0GxYf3N5u6LCGpTVigbmnzkeOnKKhyzhiIYkRtUwvgolsao3Ba5umheIyHBPufg5whupJnNqLdIQDT+BGpNdmz/Uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jo+SrJXN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jo+SrJXN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84732C116D0;
	Wed, 25 Feb 2026 01:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983770;
	bh=hQZybT4PwKtWeHTZ53jjF6ZoqC9NS3IXde3Ih/5rucs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jo+SrJXNgXbKG9KU3gc+mg8ZBJlXkS+J9bU7A3g4GGCvXYSt1p1X+viGK6YgX1e0s
	 8m/LGur5D8atfxlQVdZ8g5M/YTZQJ7Go3EQj2+LLuFKJDNA4iZZ1OugfJFvMIKceCw
	 6VadZYCz+ygMCqmk+T0Y9YnsMbIGMVaYrhUvEDDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 061/641] s390/cio: Fix device lifecycle handling in css_alloc_subchannel()
Date: Tue, 24 Feb 2026 17:16:27 -0800
Message-ID: <20260225012350.529694407@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Salah Triki <salah.triki@gmail.com>

[ Upstream commit f65c75b0b9b5a390bc3beadcde0a6fbc3ad118f7 ]

`css_alloc_subchannel()` calls `device_initialize()` before setting up
the DMA masks. If `dma_set_coherent_mask()` or `dma_set_mask()` fails,
the error path frees the subchannel structure directly, bypassing
the device model reference counting.

Once `device_initialize()` has been called, the embedded struct device
must be released via `put_device()`, allowing the release callback to
free the container structure.

Fix the error path by dropping the initial device reference with
`put_device()` instead of calling `kfree()` directly.

This ensures correct device lifetime handling and avoids potential
use-after-free or double-free issues.

Fixes: e5dcf0025d7af ("s390/css: move subchannel lock allocation")
Signed-off-by: Salah Triki <salah.triki@gmail.com>
Reviewed-by: Vineeth Vijayan <vneethv@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/cio/css.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/cio/css.c b/drivers/s390/cio/css.c
index be78a57f9bfde..8a70596a55447 100644
--- a/drivers/s390/cio/css.c
+++ b/drivers/s390/cio/css.c
@@ -236,7 +236,7 @@ struct subchannel *css_alloc_subchannel(struct subchannel_id schid,
 	return sch;
 
 err:
-	kfree(sch);
+	put_device(&sch->dev);
 	return ERR_PTR(ret);
 }
 
-- 
2.51.0



