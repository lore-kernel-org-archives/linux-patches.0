Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80FF4411661;
	Tue, 21 Jul 2026 19:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660712; cv=none; b=rWG272wEMKEQ7/gCzev308KZTaxkYwdGaJS64hCPrksM8XQO8e9ijaB6ZiM9Isd6eDf5IslDxntk0YPWpstu0qQTXlarFFa8eoigfFeZkCK9T93hFMJ7ej/I9/8la92OanJUJP8KmkVhA+Cq9JM6xIK1q/rffOL5fGfLW3FMbfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660712; c=relaxed/simple;
	bh=Gllt48ojjZLkkd0JlOC9yEufmPNDEdiLOEZDWgsH5iU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RaTGCmzdo09+oEkVJnFHtnpVSxaDPdUuQzTH4c6I6aEgR1rTPpip3ZanfvCHCDt3daQ+vkSJzQBKwi5I+752AYDB9zuuMIcnKCI5NjlnghQLcEeBKTKoQinmITqMkFlO87+7FSLlgdtxSfnScIeY1gdG8jz71E+s0cL2liSGHJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AcpIJem0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AcpIJem0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6A4E1F000E9;
	Tue, 21 Jul 2026 19:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660711;
	bh=BPwdUnhpaTKSVa2APzQEJFkn3VvOC7FiQcD3Dea44K8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AcpIJem0c2IzXXwCY83+/cw17F0DZHpnMGWSVwfEfKGZjlLKRlSU2YJZ9aS3u43ln
	 +QghaSsw7YLrYuMsfLfJC8c+kV1+bk78I0De0rJq4qR6PbgHMX+yr3e5W+y/98OLgM
	 QVBrAUxtSh/93c3632FEOrjx6QhWafcMz+G/Ayuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Lavra <flavra@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1083/2077] regcache: Do not overwrite error code when finalizing cache after error
Date: Tue, 21 Jul 2026 17:12:36 +0200
Message-ID: <20260721152618.365976234@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Francesco Lavra <flavra@baylibre.com>

[ Upstream commit 9108f7fa493b4c88cbc09503e0c164244456bad5 ]

During regcache initialization, if an error occurs in the
cache_ops->populate callback, and if cache operations include an exit
callback, the error code from populate() is overwritten with the return
value from exit(). This hides the error condition from the caller of
regcache_init(), and can cause NULL pointer dereferences when the regcache
is later accessed.

Fixes: 94a3a95f0315 ("regcache: Add ->populate() callback to separate from ->init()")
Signed-off-by: Francesco Lavra <flavra@baylibre.com>
Link: https://patch.msgid.link/20260616114429.1852456-1-flavra@baylibre.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/regmap/regcache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index 27616b05111cc7..aa8f2efed7798d 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -245,7 +245,7 @@ int regcache_init(struct regmap *map, const struct regmap_config *config)
 	if (map->cache_ops->exit) {
 		dev_dbg(map->dev, "Destroying %s cache\n", map->cache_ops->name);
 		map->lock(map->lock_arg);
-		ret = map->cache_ops->exit(map);
+		map->cache_ops->exit(map);
 		map->unlock(map->lock_arg);
 	}
 err_free_reg_defaults:
-- 
2.53.0



