Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36858267F4F;
	Tue,  8 Apr 2025 11:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111615; cv=none; b=Jq2v0Bax7otWm1Ut/D2GsmS08UFmcZy6qRgU4GTQO9yy+D7EY/HSI18PgErFq7DxqwpIxHJJrVtdGTIKg2QyhPwZbevjvKZt9xyAcmhH7HWKXbFG9KOpoPTVQizPHNOMB0KUyleqFP8mZ9oYnECE8c4V4cHi5/AQWGeV/QeCeco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111615; c=relaxed/simple;
	bh=MqVNFkfQDCi3Ew2Dy+P1n6bGUqxs5fy7tT+8zGKnFwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hYivPBckJEF4lrZ3uI5OtNqBhXU7oTx0rNOProzdCZjFUpxa00e6QwDcdFNkq2I1s1ctWysgqY2E4KIvb8S1QkNUyowGrYqp1k0yRsejDq0t2aHW00knUCxUdDO5hmPvqMsZ9oIT/AJqfDulPbw6veHGxhFc9rslWptqul+cuUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VGqaYtsU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VGqaYtsU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61F4BC4CEE5;
	Tue,  8 Apr 2025 11:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111614;
	bh=MqVNFkfQDCi3Ew2Dy+P1n6bGUqxs5fy7tT+8zGKnFwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VGqaYtsUAcqKBIQEsEks9wsFkS44lStcdvXTkr9xYPpD0FEfAzwf13NuB9o8OVhPG
	 ljw7xmQwmbR1tZgxcUdJ0vk/LAMTsk5s9J7skueHYToqc8FUd40Fj7mRGWUZHFk2rE
	 Nn/Lt9icqxvrCMpLwARg9579kQSKp+wiejBBh58A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 494/731] iio: adc: ad7173: Fix comparison of channel configs
Date: Tue,  8 Apr 2025 12:46:31 +0200
Message-ID: <20250408104925.765294085@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@baylibre.com>

[ Upstream commit 7b6033ed5a9e1a369a9cf58018388ae4c5f17e41 ]

Checking the binary representation of two structs (of the same type)
for equality doesn't have the same semantic as comparing all members for
equality. The former might find a difference where the latter doesn't in
the presence of padding or when ambiguous types like float or bool are
involved. (Floats typically have different representations for single
values, like -0.0 vs +0.0, or 0.5 * 2² vs 0.25 * 2³. The type bool has
at least 8 bits and the raw values 1 and 2 (probably) both evaluate to
true, but memcmp finds a difference.)

When searching for a channel that already has the configuration we need,
the comparison by member is the one that is needed.

Convert the comparison accordingly to compare the members one after
another. Also add a static_assert guard to (somewhat) ensure that when
struct ad7173_channel_config::config_props is expanded, the comparison
is adapted, too.

This issue is somewhat theoretic, but using memcmp() on a struct is a
bad pattern that is worth fixing.

Fixes: 76a1e6a42802 ("iio: adc: ad7173: add AD7173 driver")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Link: https://patch.msgid.link/20250303114659.1672695-14-u.kleine-koenig@baylibre.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad7173.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/iio/adc/ad7173.c b/drivers/iio/adc/ad7173.c
index 6645a811764fd..4f8810e35a8d1 100644
--- a/drivers/iio/adc/ad7173.c
+++ b/drivers/iio/adc/ad7173.c
@@ -189,7 +189,11 @@ struct ad7173_channel_config {
 	u8 cfg_slot;
 	bool live;
 
-	/* Following fields are used to compare equality. */
+	/*
+	 * Following fields are used to compare equality. If you
+	 * make adaptations in it, you most likely also have to adapt
+	 * ad7173_find_live_config(), too.
+	 */
 	struct_group(config_props,
 		bool bipolar;
 		bool input_buf;
@@ -717,15 +721,28 @@ static struct ad7173_channel_config *
 ad7173_find_live_config(struct ad7173_state *st, struct ad7173_channel_config *cfg)
 {
 	struct ad7173_channel_config *cfg_aux;
-	ptrdiff_t cmp_size;
 	int i;
 
-	cmp_size = sizeof_field(struct ad7173_channel_config, config_props);
+	/*
+	 * This is just to make sure that the comparison is adapted after
+	 * struct ad7173_channel_config was changed.
+	 */
+	static_assert(sizeof_field(struct ad7173_channel_config, config_props) ==
+		      sizeof(struct {
+				     bool bipolar;
+				     bool input_buf;
+				     u8 odr;
+				     u8 ref_sel;
+			     }));
+
 	for (i = 0; i < st->num_channels; i++) {
 		cfg_aux = &st->channels[i].cfg;
 
 		if (cfg_aux->live &&
-		    !memcmp(&cfg->config_props, &cfg_aux->config_props, cmp_size))
+		    cfg->bipolar == cfg_aux->bipolar &&
+		    cfg->input_buf == cfg_aux->input_buf &&
+		    cfg->odr == cfg_aux->odr &&
+		    cfg->ref_sel == cfg_aux->ref_sel)
 			return cfg_aux;
 	}
 	return NULL;
-- 
2.39.5



