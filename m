Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA473183CB0;
	Tue, 10 Sep 2024 09:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962063; cv=none; b=k5ojbOwsZlTKudWpZuPiaWXGlNm8SErRCvtzs1/28ofmHzc8dyT/ZDl6mEmnpMYEKYwMTD2P9JqywBLUoh2mt5Y4ToupPyLJ+pdyLC6ioyU2Dw1Ae+9z7ADGmhaC/uZZ8YEweNF0bW6LgeFqgNA0fARhzWET0PezS54AkbsG4ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962063; c=relaxed/simple;
	bh=0A4kUenrHGzfankqwgsVV9OgAzBOuSUoIIJtMqT+TVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rpiVpz2drqk01JVZ30W6sjeqwFBk90CzhEt5j00L7UeIg5RpMzAliuc9QXtKx2KRo+kbvPZWi+uriVTTmTE7PeGZJ+r0m2rR144cEXoNfEemmD2tFat+CXoCOTV+d0LaZotncOQb5DHpwbXM3TW+AFhN8LvUS5irTKhDTBb4Ngo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WaEn4sWF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WaEn4sWF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5194CC4CEC3;
	Tue, 10 Sep 2024 09:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962063;
	bh=0A4kUenrHGzfankqwgsVV9OgAzBOuSUoIIJtMqT+TVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WaEn4sWFO1XmUyxFCZZWT4i18BMweeTzgpYpiQNn9a+HAwb9zyEASm6Die0Ply5mI
	 kEt8nqH5zxi4+QYD2f7evOO3EjxjHpAvkvHV7W+iIUCV3wvOfTHTT3WlVEl/ozfg/B
	 e57cUWu+coe8ZHrLMRH24ph8iod1eCQGwDMlD2PU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 255/375] regmap: maple: work around gcc-14.1 false-positive warning
Date: Tue, 10 Sep 2024 11:30:52 +0200
Message-ID: <20240910092631.117337013@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 542440fd7b30983cae23e32bd22f69a076ec7ef4 ]

With gcc-14.1, there is a false-postive -Wuninitialized warning in
regcache_maple_drop:

drivers/base/regmap/regcache-maple.c: In function 'regcache_maple_drop':
drivers/base/regmap/regcache-maple.c:113:23: error: 'lower_index' is used uninitialized [-Werror=uninitialized]
  113 |         unsigned long lower_index, lower_last;
      |                       ^~~~~~~~~~~
drivers/base/regmap/regcache-maple.c:113:36: error: 'lower_last' is used uninitialized [-Werror=uninitialized]
  113 |         unsigned long lower_index, lower_last;
      |                                    ^~~~~~~~~~

I've created a reduced test case to see if this needs to be reported
as a gcc, but it appears that the gcc-14.x branch already has a change
that turns this into a more sensible -Wmaybe-uninitialized warning, so
I ended up not reporting it so far.

The reduced test case also produces a warning for gcc-13 and gcc-12
but I don't see that with the version in the kernel.

Link: https://godbolt.org/z/oKbohKqd3
Link: https://lore.kernel.org/all/CAMuHMdWj=FLmkazPbYKPevDrcym2_HDb_U7Mb9YE9ovrP0jJfA@mail.gmail.com/
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://patch.msgid.link/20240719104030.1382465-1-arnd@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/regmap/regcache-maple.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/base/regmap/regcache-maple.c b/drivers/base/regmap/regcache-maple.c
index e42433404854..4c034c813126 100644
--- a/drivers/base/regmap/regcache-maple.c
+++ b/drivers/base/regmap/regcache-maple.c
@@ -110,7 +110,8 @@ static int regcache_maple_drop(struct regmap *map, unsigned int min,
 	struct maple_tree *mt = map->cache;
 	MA_STATE(mas, mt, min, max);
 	unsigned long *entry, *lower, *upper;
-	unsigned long lower_index, lower_last;
+	/* initialized to work around false-positive -Wuninitialized warning */
+	unsigned long lower_index = 0, lower_last = 0;
 	unsigned long upper_index, upper_last;
 	int ret = 0;
 
-- 
2.43.0



