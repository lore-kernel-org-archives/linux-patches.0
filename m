Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5494323B604;
	Mon,  9 Feb 2026 14:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647422; cv=none; b=igwdmWGnq9nnDiCommNiB/7ClRWtpLlgsUSZUsTQcBnsGMh5Q6+dKwkJeuN+Oy+nqtzDl80QJ0Q/OkuVI5UDcTY4m5ebhzZGNZSJn604yhL4M9T0rysYq+ezIkk1/Iy27lgerlthDsuWO8kxhR2xMucnK+DLNJgw5i6s602Yt8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647422; c=relaxed/simple;
	bh=3P0RuQSWcTdJzF5vSGYHOpy69VZPIyhOgPm3cfVFHMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fGxwWGNP25s2u6nXTqAUU5T1lRk4Ppe0fo5DsFfHozFpsL4yjGuA8SX/qUNSxpVnljWvI7uvCUr7v1DKgAXjCZHuTj2ax1jQLibTCqFu2RcIz+NLwemWymMLW1FIaM6Ls9A46zMUPZDZBrRFCNGzTzb4Qjkfag9dqk1V5MND8Sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wCduCSUI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wCduCSUI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A690C116C6;
	Mon,  9 Feb 2026 14:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647422;
	bh=3P0RuQSWcTdJzF5vSGYHOpy69VZPIyhOgPm3cfVFHMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wCduCSUItZBvU5OjM/UknGawRVeqj0q+k+mGCjJjTKpAkqk9/Id0JwqD3w5jZnG/A
	 60CR13kCpYJg2IEavxX2pL2bS+cbyF+rdruruJvNeBq2eHLkPGql2+EgGjN4vsfKNO
	 +NwevbOTEfrs6qcTFdZ2TNtag3l5phaDzT9frDXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaushlendra Kumar <kaushlendra.kumar@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 096/175] regmap: maple: free entry on mas_store_gfp() failure
Date: Mon,  9 Feb 2026 15:22:49 +0100
Message-ID: <20260209142323.878289471@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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
index 2319c30283a6d..9cf0384ce7b95 100644
--- a/drivers/base/regmap/regcache-maple.c
+++ b/drivers/base/regmap/regcache-maple.c
@@ -95,12 +95,13 @@ static int regcache_maple_write(struct regmap *map, unsigned int reg,
 
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



