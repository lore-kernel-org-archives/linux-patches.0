Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 682CF36A025;
	Tue,  6 Jan 2026 17:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722114; cv=none; b=I3ShBatkJl8/FDAscAIoa/5NrDTO8DRjCt7z5l1KWStUnpePT1y6c79Wnyo/0JYunw0IRsL1TdCQvY8B6IASWtCvdyhQNRJmjNI+DNUf3a2RkYGatPXel6FUlw2T9xop1y9kZXWyTlD88gCdj00aIYHmhrihFJn9o0PoJOVe87I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722114; c=relaxed/simple;
	bh=uJu1CxsJiaU3YNXWrW41Zijrb19BUG4ClqJtRrrUus4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L0lFTZUaxd9SIcE9ElLQHpY4G6Y3VGMDVhSrgPIOYEF9iZYASGFvVXt1fv4JUlGq6xhW/ztNe/TYVA+yBBUPvAg/L6Jtl/eKkcb7UkLtvc/SRWow04TyXiJiFy/9C/gNpihIagzHpTkUEXX1EL0JPkS1d/65lxSKYVtoO2PZKSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W4r5+zXD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W4r5+zXD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCF8CC116C6;
	Tue,  6 Jan 2026 17:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722114;
	bh=uJu1CxsJiaU3YNXWrW41Zijrb19BUG4ClqJtRrrUus4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W4r5+zXDRh2kPi7iwstMViONd9b9uj5NohsHCtWM8y4YcH1I4oIxiRnbWl4IX3twP
	 uC66Arc407KWL2QCPkoOx05pEBja8kMDam7WxF72bh0e6Dy7vBLnBLgE7On7cOl3Cb
	 PzCOMSckaycMXuZx7GQGdj4kSwmCrnqEVpbxzAt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Chen <chenl311@chinatelecom.cn>,
	Dongsheng Yang <dongsheng.yang@linux.dev>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Zheng Gu <cengku@gmail.com>
Subject: [PATCH 6.18 170/312] dm pcache: fix segment info indexing
Date: Tue,  6 Jan 2026 18:04:04 +0100
Message-ID: <20260106170553.985992468@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

From: Li Chen <chenl311@chinatelecom.cn>

commit 13ea55ea20176736516b20b9ea2d8cf97dbe74f5 upstream.

Segment info indexing also used sizeof(struct) instead of the
4K metadata stride, so info_index could point between slots and
subsequent writes would advance incorrectly. Derive info_index
from the pointer returned by the segment meta search using
PCACHE_SEG_INFO_SIZE and advance to the next slot for future
updates.

Signed-off-by: Li Chen <chenl311@chinatelecom.cn>
Signed-off-by: Dongsheng Yang <dongsheng.yang@linux.dev>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: Zheng Gu <cengku@gmail.com>
Cc: stable@vger.kernel.org	# 6.18
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-pcache/cache_segment.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-pcache/cache_segment.c b/drivers/md/dm-pcache/cache_segment.c
index ae57cc261422..9d92e2b067ed 100644
--- a/drivers/md/dm-pcache/cache_segment.c
+++ b/drivers/md/dm-pcache/cache_segment.c
@@ -56,7 +56,10 @@ static int cache_seg_info_load(struct pcache_cache_segment *cache_seg)
 		ret = -EIO;
 		goto out;
 	}
-	cache_seg->info_index = cache_seg_info_addr - cache_seg_info_addr_base;
+
+	cache_seg->info_index =
+		((char *)cache_seg_info_addr - (char *)cache_seg_info_addr_base) /
+		PCACHE_SEG_INFO_SIZE;
 out:
 	mutex_unlock(&cache_seg->info_lock);
 
-- 
2.52.0



