Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21BEA312811;
	Mon,  2 Feb 2026 21:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770068845; cv=none; b=jE6REGKE7oUKtW5q+yfVzFgLl8N5hoD4PnRMuFzE5jrcYlC7L6oVWLN0+xmT6ClAdw+dAvNei6aBJGhlnddhIzXMoNfteCP5PoGNKHmc9jHmGPkC/kYfjcSdqIu4+QRRRhJjsoyCO2Bs5z2w5+CfCiEHxfRIFx+5xgnJBjw3tqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770068845; c=relaxed/simple;
	bh=4WPF0RWd/+xw+ffbBSv0gvLKr2HM/4sbMFAx5UJIYNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DhDhOEP6lS7IRAu2XD4q1EsHcN3pUMEmaZt0HAmmuavXLWS1M9y7nTqsOIby5tMOsDM1jfzqwcgQ/fBZtQDDSlK4d3uk3YZhXPNmKB9+tMvxRENqrFcVxmqfjMIWfsh4gNOgOan53cc8HQP6zIO5eQkO8D6RIRKmZDA8VjJGHBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CJiIKqiG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CJiIKqiG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B7FEC116C6;
	Mon,  2 Feb 2026 21:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770068845;
	bh=4WPF0RWd/+xw+ffbBSv0gvLKr2HM/4sbMFAx5UJIYNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CJiIKqiGoKwZbPnU/3o/Kw7yvq6/SenmWMXkRNmIOXVn8tECpvUyo8LjExmRbyA8p
	 X8a9dJcQvODtrWv6GU/DnwF+nYQMeNnX72JvQkL2tcj0yqWpyHE/tVhlaZQzM8yguy
	 QWaO27jyxrCt4dsytPkho4mm4nOfr78cxx12hBrkiwQRck3lfVC4G6o1H7QINRaKDV
	 HbIrAfWqJfQULoPCijCesRKDWJbxaq8PsTfSSRi4b/Cc7S9dXIUOVpEco3VZvfhmTe
	 7iBuHfF340EIUgR+wTqz/DkJ+RwDn9V72onto1B10pH08Dh6T/YLfEr+r2DQJqHCzK
	 672CdCSr8oP9A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Kaushlendra Kumar <kaushlendra.kumar@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] regmap: maple: free entry on mas_store_gfp() failure
Date: Mon,  2 Feb 2026 16:46:15 -0500
Message-ID: <20260202214643.212290-20-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260202214643.212290-1-sashal@kernel.org>
References: <20260202214643.212290-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.8
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

### SUMMARY

**What the commit fixes:**
A memory leak in `regcache_maple_write()` where the allocated `entry`
block is not freed when `mas_store_gfp()` fails. This is a clear
resource leak bug.

**Why it matters to stable users:**
- Memory leaks affect system stability over time, especially on long-
  running embedded systems that commonly use regmap
- Under memory pressure scenarios, this leak compounds the problem
- regmap is core infrastructure used by many hardware drivers

**Stable kernel criteria assessment:**
1. ✅ **Obviously correct**: The fix follows standard kernel error
   handling patterns - allocate, try to use, free on failure
2. ✅ **Fixes a real bug**: Memory leak is a real, user-visible issue
3. ✅ **Important issue**: Memory leaks can lead to system
   instability/OOM
4. ✅ **Small and contained**: ~8 lines changed in a single file, single
   function
5. ✅ **No new features**: Pure bug fix
6. ✅ **Clean backport**: Self-contained fix with no dependencies

**Risk vs Benefit:**
- **Risk**: Very low - the change only affects the error path of
  `mas_store_gfp()` failure
- **Benefit**: Fixes a memory leak in widely-used infrastructure code
- The logic is straightforward and the fix is obviously correct

**Affected versions:**
- The regcache-maple.c file was introduced in v6.4
- Applicable to stable trees: 6.4.y, 6.6.y (LTS), and newer

**Concerns:**
- None - this is a textbook stable backport candidate

**YES**

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

