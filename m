Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0E852E7374;
	Thu, 25 Jun 2026 13:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782393131; cv=none; b=jsKPHqwOtlxYGfmrYehbf9vQsgZWzyrCRVprJjJjjQkfqAKfnlXqhXNd2vx9kKo5f8DImFsMj7Cz9dA9mFKWioxlCnWqCx+jihgCwUot8t6BMZtpbSJ/lc5NuEOB2iyX+ZLdxEAOSzjgB5SLFF4J5TSNvfGSUCR2+6Cn6xFkXNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782393131; c=relaxed/simple;
	bh=TWp+mgwzcDPVlGlBdP4CxEZF59slptHnq0+XaDhAmzw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HwoJIOy7zep+tyP7mADecClES33JHHgSv6JavNnlfywCHE1vhrA4EvdfKaCvgf2ZMitMaPf9GfKZX5HuHktl6V2MOwJXVFYWRqoR9VLsWEawU63e6YuZQ6pyD1FMZSBjBl7trNcrTknCrDjF3Vor0AsRBnjz/bc2MFNm58G6Z3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q0rB2n7Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q0rB2n7Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3B301F000E9;
	Thu, 25 Jun 2026 13:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782393130;
	bh=Kv8C/+GWlW1U7A/SjZfD4zBbikncud+1zV7bKDuLHoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q0rB2n7Y8hggE5xdXmDO1aE0mTYr464Tbr5ZA6g1d+QrR8rNsujrGkBN/wwIAOP6V
	 l/hQaYMaBHfOLDwN+rwWYXyrzWT2H4nu/wC1yZeCzhgEKIclfI/4QXo57/ouv7YHhS
	 JCPUF0nMZlfYWf1h1mBg3F1SuJjLyKTPkgBdEOB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Sam Daly <sam@samdaly.ie>,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 7.1 05/21] iio: light: veml6075: add bounds check to veml6075_it_ms index
Date: Thu, 25 Jun 2026 14:03:57 +0100
Message-ID: <20260625125613.974922260@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625125613.243729608@linuxfoundation.org>
References: <20260625125613.243729608@linuxfoundation.org>
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

From: Sam Daly <sam@samdaly.ie>

commit 307dc4240bd41852d9e0912921e298160db1c109 upstream.

veml6075_it_ms has 5 elements but VEML6075_CONF_IT can yield values 0-7.
If it returns a value >= 5, this causes an out-of-bounds array access.
Add a bounds check and return -EINVAL if the index is out of range.

The problem values are reserved so should never be read from the
register. Hence this is hardening against fault device, missprogramming
or bus corruption.

Assisted-by: gkh_clanker_2000
Cc: stable <stable@kernel.org>
Signed-off-by: Sam Daly <sam@samdaly.ie>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/veml6075.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/iio/light/veml6075.c
+++ b/drivers/iio/light/veml6075.c
@@ -100,7 +100,7 @@ static const struct iio_chan_spec veml60
 
 static int veml6075_request_measurement(struct veml6075_data *data)
 {
-	int ret, conf, int_time;
+	int ret, conf, int_time, int_index;
 
 	ret = regmap_read(data->regmap, VEML6075_CMD_CONF, &conf);
 	if (ret < 0)
@@ -117,7 +117,11 @@ static int veml6075_request_measurement(
 	 * time for all possible configurations. Using a 1.50 factor simplifies
 	 * operations and ensures reliability under all circumstances.
 	 */
-	int_time = veml6075_it_ms[FIELD_GET(VEML6075_CONF_IT, conf)];
+	int_index = FIELD_GET(VEML6075_CONF_IT, conf);
+	if (int_index >= ARRAY_SIZE(veml6075_it_ms))
+		return -EINVAL;
+
+	int_time = veml6075_it_ms[int_index];
 	msleep(int_time + (int_time / 2));
 
 	/* shutdown again, data registers are still accessible */


