Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC6DC3793BF;
	Mon,  9 Feb 2026 14:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648001; cv=none; b=eVtHZHsyxY+8+zI0Uj7PGiB+w/rbpxgJevB9lXx0d8BNSCnMmyGkUdFF4PRX7C1vb6+sU1Jz8rvIXqQFPuO2SGGpHcp2bUjPlPC6g6DSSfYztIPCtnqOeOh9/oS9XCr5H925BKsgw7nqFScSb6PhbgOyxIN51SNWNSRgSgTNDWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648001; c=relaxed/simple;
	bh=QpzElN1eHR+h3KtQKuH3oPiH78zWSgUAQXckbjODYVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jwEcN2sZD9GxTJe2MBsYM2yXTlj9uJCB/DaIayjzsgJHzeA7e9D/vxjcBwl0bk94yg/gkIUoiidUjs4aYLALeTnOiqhSz+E/iQxGpW6M7IKgjgMOF3qMcm0756MlgrHpMpQfZ/bWC2mBVZtMQa8kRqgWlc8SrbviZge5qf8QX10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EJLvdKAT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EJLvdKAT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B55D2C116C6;
	Mon,  9 Feb 2026 14:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648001;
	bh=QpzElN1eHR+h3KtQKuH3oPiH78zWSgUAQXckbjODYVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EJLvdKATrUm/41pBeSjQJO1B3UIbNV4+So/QnrM0V7PZUikynXB3sgsXkisHQOhec
	 z2bt8mxw18p9qdpTHdgVCX9cJ1JVsLjwrQxyTNuF0B8pTsEn5BGhlZOHjh/kdvvjWu
	 pwOgvtYB2uHwkl0M2V458EhCjZqWBK6wHiEMJ1fc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaushlendra Kumar <kaushlendra.kumar@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 064/113] regmap: maple: free entry on mas_store_gfp() failure
Date: Mon,  9 Feb 2026 15:23:33 +0100
Message-ID: <20260209142312.495204881@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142310.204833231@linuxfoundation.org>
References: <20260209142310.204833231@linuxfoundation.org>
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

From: Kaushlendra Kumar <kaushlendra.kumar@intel.com>

[ Upstream commit f3f380ce6b3d5c9805c7e0b3d5bc28d9ec41e2e8 ]

regcache_maple_write() allocates a new block ('entry') to merge
adjacent ranges and then stores it with mas_store_gfp().
When mas_store_gfp() fails, the new 'entry' remains allocated and
is never freed, leaking memory.

Free 'entry' on the failure path; on success continue freeing the
replaced neighbor blocks ('lower', 'upper').

Signed-off-by: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
Link: https://patch.msgid.link/20260105031820.260119-1-kaushlendra.kumar@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/regmap/regcache-maple.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/base/regmap/regcache-maple.c b/drivers/base/regmap/regcache-maple.c
index 23da7b31d7153..34440e188f925 100644
--- a/drivers/base/regmap/regcache-maple.c
+++ b/drivers/base/regmap/regcache-maple.c
@@ -96,12 +96,13 @@ static int regcache_maple_write(struct regmap *map, unsigned int reg,
 
 	mas_unlock(&mas);
 
-	if (ret == 0) {
-		kfree(lower);
-		kfree(upper);
+	if (ret) {
+		kfree(entry);
+		return ret;
 	}
-	
-	return ret;
+	kfree(lower);
+	kfree(upper);
+	return 0;
 }
 
 static int regcache_maple_drop(struct regmap *map, unsigned int min,
-- 
2.51.0



