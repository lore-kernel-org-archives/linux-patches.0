Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35586147C60;
	Wed, 19 Jun 2024 13:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803368; cv=none; b=eQ7VmBokWaSM+0RNIJoy93mHnGBne0O7/jsZEISa/tGWbwf0S81Wk/huxdOBzzGylmU1f4zf15Ll4dXvLaNkoEdSW3u6kqnvMYmJx91R1jeIjC2mmau5Hb8ZGX2rSKjCvWw9dk2BVX90Fhg3dSlYfWShwk3WJtCxiT1vTp4hb6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803368; c=relaxed/simple;
	bh=dG1urc/0FYVY0+Z46o4v0fnX/b8RT18naUMFqqkniXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TmQz1ciWdjuVQJFbZg6Fia/5TasQgdMsr5gd1hGJcDeSMmT4lY3CV9l5SVwzlpKnMcC0qVT+tZz6Ekz+wE/ozBS0s40/KB598sYX87DJI0FOk2Yilo9YK7GOhzWi88u621SdGMvoONO3mN1iE3JbtkC4LAHf2+Pkp5HPdJiIaqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RBGr2Nmc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RBGr2Nmc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF8FAC2BBFC;
	Wed, 19 Jun 2024 13:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803368;
	bh=dG1urc/0FYVY0+Z46o4v0fnX/b8RT18naUMFqqkniXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RBGr2NmcMmB9XScXd280uBeRnftkZMXfIQeSrNnuXyCCivX7vgPfJxOLIQODNdZIn
	 kPrSVBAGKO4hfXiOtv/guDQnUcSoRn+7eo2xUaNmUYAMc8P8smwCkoDJ+fO79meUSn
	 xMr+lHPoB2+f4HMFN/oizNR/13elp9hQGz8h5OT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Eric Wheeler <linux-integrity@lists.ewheeler.net>,
	Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 6.9 242/281] dm-integrity: set discard_granularity to logical block size
Date: Wed, 19 Jun 2024 14:56:41 +0200
Message-ID: <20240619125619.274437021@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 69381cf88a8dfa0ab27fb801b78be813e7e8fb80 upstream.

dm-integrity could set discard_granularity lower than the logical block
size. This could result in failures when sending discard requests to
dm-integrity.

This fix is needed for kernels prior to 6.10.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reported-by: Eric Wheeler <linux-integrity@lists.ewheeler.net>
Cc: stable@vger.kernel.org # <= 6.9
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-integrity.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 7f3dc8ee6ab8..417fddebe367 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -3492,6 +3492,7 @@ static void dm_integrity_io_hints(struct dm_target *ti, struct queue_limits *lim
 		limits->physical_block_size = ic->sectors_per_block << SECTOR_SHIFT;
 		blk_limits_io_min(limits, ic->sectors_per_block << SECTOR_SHIFT);
 		limits->dma_alignment = limits->logical_block_size - 1;
+		limits->discard_granularity = ic->sectors_per_block << SECTOR_SHIFT;
 	}
 	limits->max_integrity_segments = USHRT_MAX;
 }
-- 
2.45.2



