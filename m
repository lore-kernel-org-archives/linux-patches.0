Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6491285073;
	Mon,  9 Feb 2026 14:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648481; cv=none; b=WGFMhEv/8x06FAH5NQu5Lc9dREZl6KMtc22hlWZHtC90bL7k4AQQ47d1vVjwB6Mx42NIIZHQpmQ26r131beCwaO8QbyPwxhrsER3x+Yg9IQh9oMxS2ejyh1uBe05XMbzzyWjJBlh8Xq9gxuAKcuki87Q07Xq8zDkCuxvWAhrOMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648481; c=relaxed/simple;
	bh=P6N9AuBPWZnTfQBCmtGOgOiPo+vrD/AZ7cH6YyCXUO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZgKnpoSDJxzp+cqP5fr4q2tefo/MbzsBQ2FLzoYpf3ACd7QpFCdKlfz5Nc2OGZwvcJLhdpvkCKnKUUO93IukqaiyuD04Ab7GAXwkVq5o6Cs79VT2I61gjFpdWjEzNfsUGdMxtwSLTF5PE4koFg2s4gjj7M1pz9mwTNMd6Zp/3Ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TEhY/EVA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TEhY/EVA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DABABC19422;
	Mon,  9 Feb 2026 14:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648481;
	bh=P6N9AuBPWZnTfQBCmtGOgOiPo+vrD/AZ7cH6YyCXUO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TEhY/EVA+QMFjq0+ovFofwsSGsM1bINisQdntmwsv7qH4RW71T3WZVH/9q/AZhR1f
	 e9B5i5gt7rgF4cWRSnietH+K+mdtMhVMKBuevxmuurvciwTkXzQI7eksZsxGR4/Orj
	 GUAx5LAQLh2TVEAStAJH5CHFqWnPvJleh2L4ps08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaushlendra Kumar <kaushlendra.kumar@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 49/86] regmap: maple: free entry on mas_store_gfp() failure
Date: Mon,  9 Feb 2026 15:24:12 +0100
Message-ID: <20260209142306.546010997@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142304.770150175@linuxfoundation.org>
References: <20260209142304.770150175@linuxfoundation.org>
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
index fb5761a5ef6ee..86de71ce2c191 100644
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



