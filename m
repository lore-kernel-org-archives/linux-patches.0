Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F2E251C58;
	Mon, 11 Dec 2023 18:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hKASbFua"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AECFC433C7;
	Mon, 11 Dec 2023 18:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320599;
	bh=o0gJcD1UfuR21Uku3y79FLVeGR3+1bdV7l6mndAQ4v4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hKASbFuaeHOxxtMTou0mLHh+z7S9sLgfoMHbqNWi1gGmI0NX5gwH8N/EPTAoZOX7L
	 qtpRBcMhOngYf0y82NnDKP29RJbIUVjtswi+Y4An4xQKulNvMYVelDt7SdqmWS/5xh
	 lv6b+wFfzOLksZj8muqHkJUWE9KvJU3zLvW6dNcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Reichl <hias@horus.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 121/194] regmap: fix bogus error on regcache_sync success
Date: Mon, 11 Dec 2023 19:21:51 +0100
Message-ID: <20231211182041.922481542@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182036.606660304@linuxfoundation.org>
References: <20231211182036.606660304@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthias Reichl <hias@horus.com>

commit fea88064445a59584460f7f67d102b6e5fc1ca1d upstream.

Since commit 0ec7731655de ("regmap: Ensure range selector registers
are updated after cache sync") opening pcm512x based soundcards fail
with EINVAL and dmesg shows sync cache and pm_runtime_get errors:

[  228.794676] pcm512x 1-004c: Failed to sync cache: -22
[  228.794740] pcm512x 1-004c: ASoC: error at snd_soc_pcm_component_pm_runtime_get on pcm512x.1-004c: -22

This is caused by the cache check result leaking out into the
regcache_sync return value.

Fix this by making the check local-only, as the comment above the
regcache_read call states a non-zero return value means there's
nothing to do so the return value should not be altered.

Fixes: 0ec7731655de ("regmap: Ensure range selector registers are updated after cache sync")
Cc: stable@vger.kernel.org
Signed-off-by: Matthias Reichl <hias@horus.com>
Link: https://lore.kernel.org/r/20231203222216.96547-1-hias@horus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/regmap/regcache.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -410,8 +410,7 @@ out:
 			rb_entry(node, struct regmap_range_node, node);
 
 		/* If there's nothing in the cache there's nothing to sync */
-		ret = regcache_read(map, this->selector_reg, &i);
-		if (ret != 0)
+		if (regcache_read(map, this->selector_reg, &i) != 0)
 			continue;
 
 		ret = _regmap_write(map, this->selector_reg, i);


