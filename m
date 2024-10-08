Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05EBA1C9B61;
	Tue,  8 Oct 2024 12:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391881; cv=none; b=ec77jvHMQoapGK07wLBUoRE5IZ8hn1TvTmviMcjFdqB7Exoz880K4/mgPH7mtYgRbq6fF2xBa2PcXXWLE4xT0CfjVrWGrkqWQO5WAYqQkq0Vym6Ci3ip5HSanBjt8VpePSxi/u4jrdq/7ICqypo8IShNWxXJ2j6vSxpAkYZkvxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391881; c=relaxed/simple;
	bh=YxbZie0chxyktcIEThLfFKrHt9w3KFHW9N/ljtjRv4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VwHmQ7DR+H8CZPzwpVnBEzy/hXPH1aAAlSOqT/IWUYyN0TLmq6PJNgSvcqE6//h0hxx6d3A/608Wt5GiSize2pET/o+ap8N8bq81PJwvwktdpEWeHaF/9ChMMXdwlQ4WCKU02yaKPYr+VMKQqVjhdy4Zo8KVmPNLr+Ya7K3emjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GZs+EW1U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GZs+EW1U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69832C4CEC7;
	Tue,  8 Oct 2024 12:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391880;
	bh=YxbZie0chxyktcIEThLfFKrHt9w3KFHW9N/ljtjRv4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GZs+EW1UXyjTN39O1N8ap3V6OrSqdQm3FlRK7nG+EgMwjWHGoLQETljnYZXl3HHS+
	 TlDfTYb0iA6SRB8pZKdrE7ukokh5aM3s40kpSEkKzjrIj5jPXVfZe7i9HfDWw8SEDu
	 K20vedech514E/85wjK71RACeP8xgR+o3rwlUVe4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yannick Fertre <yannick.fertre@foss.st.com>,
	Raphael Gallais-Pou <raphael.gallais-pou@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 251/558] drm/stm: ltdc: reset plane transparency after plane disable
Date: Tue,  8 Oct 2024 14:04:41 +0200
Message-ID: <20241008115712.215115219@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yannick Fertre <yannick.fertre@foss.st.com>

[ Upstream commit 02fa62d41c8abff945bae5bfc3ddcf4721496aca ]

The plane's opacity should be reseted while the plane
is disabled. It prevents from seeing a possible global
or layer background color set earlier.

Signed-off-by: Yannick Fertre <yannick.fertre@foss.st.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240712131344.98113-1-yannick.fertre@foss.st.com
Signed-off-by: Raphael Gallais-Pou <raphael.gallais-pou@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/stm/ltdc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/stm/ltdc.c b/drivers/gpu/drm/stm/ltdc.c
index 056642d12265c..0832b749b66e7 100644
--- a/drivers/gpu/drm/stm/ltdc.c
+++ b/drivers/gpu/drm/stm/ltdc.c
@@ -1513,6 +1513,9 @@ static void ltdc_plane_atomic_disable(struct drm_plane *plane,
 	/* Disable layer */
 	regmap_write_bits(ldev->regmap, LTDC_L1CR + lofs, LXCR_LEN | LXCR_CLUTEN |  LXCR_HMEN, 0);
 
+	/* Reset the layer transparency to hide any related background color */
+	regmap_write_bits(ldev->regmap, LTDC_L1CACR + lofs, LXCACR_CONSTA, 0x00);
+
 	/* Commit shadow registers = update plane at next vblank */
 	if (ldev->caps.plane_reg_shadow)
 		regmap_write_bits(ldev->regmap, LTDC_L1RCR + lofs,
-- 
2.43.0



