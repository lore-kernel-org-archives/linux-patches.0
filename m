Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E1691F1522;
	Mon, 23 Jun 2025 13:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684443; cv=none; b=VLP+uXSbfysviDkrd0FDgQhdMvEuISYulAD2lKMRGL6iBGwU5VC3WXWS2tOSrIssIUDcdPnoID5rZIgBQH/hvI2pIFfklyJVQ7M+9VgPkgNSWs82WkK9X9Etq5EAV3Q29MiAq1cezVwvXNhquq0IGh2n7PX6mP6DTOqhFnZdJVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684443; c=relaxed/simple;
	bh=Lk1JhRUSlvlxyzsLtrsUNP9vwl0Qt8yaUHLV8cpeV18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l0C5KvgjjdJKLQbmAqTIgMFv9yoSkIH2lNJdGUX+0FrnLpeiu3KutjJUBce+E7KBbEQM8aeJtdcwYuW9YBQM9BD+3KPRK+0JVkvSwlK1NX43u7wAav+DZhRkLp8BJ91vXVhoPNcyb/GBWd+oK4zWta3SAXniIVjrhR3fC4miAkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=klgjWXJm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="klgjWXJm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C707FC4CEEA;
	Mon, 23 Jun 2025 13:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684443;
	bh=Lk1JhRUSlvlxyzsLtrsUNP9vwl0Qt8yaUHLV8cpeV18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=klgjWXJmcZo2FHz2GXKkCRmbz1jPlFkeo+0Byo4/l1SjLS65rTHyjvw7puDAgmCaV
	 M3irGlNgsYKdt7Czfjd4SKK2vgdYZHH6Mf/kvZDgDbLHI7k6dQQ+6HtH4o/am6LCat
	 5qp+n21KycWzoaMUh43Pu00cL9mn+PMSgT22W7x4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kieran Bingham <kieran.bingham@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.15 069/592] media: i2c: imx335: Fix frame size enumeration
Date: Mon, 23 Jun 2025 15:00:27 +0200
Message-ID: <20250623130701.903787617@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kieran Bingham <kieran.bingham@ideasonboard.com>

commit b240df2913d396638033b86af0f0ff76aa1aafc8 upstream.

In commit cfa49ff0558a ("media: i2c: imx335: Support 2592x1940 10-bit
mode") the IMX335 driver was extended to support multiple output
bitdepth modes.

This incorrectly extended the frame size enumeration to check against
the supported mbus_codes array instead of the supported mode/frame
array. This has the unwanted side effect of reporting the currently
supported frame size 2592x1944 three times.

Fix the check accordingly to report a frame size for each supported
size, which is presently only a single entry.

Fixes: cfa49ff0558a ("media: i2c: imx335: Support 2592x1940 10-bit mode")
Cc: stable@vger.kernel.org
Signed-off-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/imx335.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/media/i2c/imx335.c
+++ b/drivers/media/i2c/imx335.c
@@ -660,7 +660,8 @@ static int imx335_enum_frame_size(struct
 	struct imx335 *imx335 = to_imx335(sd);
 	u32 code;
 
-	if (fsize->index > ARRAY_SIZE(imx335_mbus_codes))
+	/* Only a single supported_mode available. */
+	if (fsize->index > 0)
 		return -EINVAL;
 
 	code = imx335_get_format_code(imx335, fsize->code);


