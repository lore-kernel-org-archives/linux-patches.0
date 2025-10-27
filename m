Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6602B31B137;
	Mon, 27 Oct 2025 18:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590444; cv=none; b=mUU32ArcLbpYcvg40X6ysDtXgFrUwp13O/q9xG34jasbNeNmYj9DCUdyBrag9qZFO9a+Xh4GorbqFnHkgRiVky0SoCQPhTkYCBZwz1IrMdHPezUoSs40j5SIfMg8iLSSXsHatftESXgd1KZ/FUuQTDPlYJDvOZq0RwEL7+p+J5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590444; c=relaxed/simple;
	bh=C8jlbmabZFgew2UAaJ4hG/nnm2hkZIQNiJ79YnWyob0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iA1Rpzne7pErUyjHpNeMSBpPj3T/9ItKqHAN/tLYA4uwP6oFcLGBLGURw5sOev9P1cHUmM6zYuiImzp91Bt9Re4v9L0v3bW6zaqCQXtrZtcXkCYw2+BWusmSO3VefLLS6Y0baWN/o2ZX0WnBlXuj3IYalc+TZaT1oF4f2wZ+6Ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D1xFh35J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D1xFh35J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF8C5C4CEF1;
	Mon, 27 Oct 2025 18:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590444;
	bh=C8jlbmabZFgew2UAaJ4hG/nnm2hkZIQNiJ79YnWyob0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D1xFh35Jal1YXF4LEi+ayYikf6keE40tbzlM9sUpysgqWuTEblmiZH3/FXI4P/BzN
	 2z6ML8YnpNpBJtkm6ns0QvjDm/6+8i+2shAJmCP3gLxLGIdRw+GLvvEopxaC+BjVco
	 EbWGvKPif+J2eVKxh+BSMFaizIhnD88O+adTMVGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liam Beguin <liambeguin@gmail.com>,
	Andy Shevchenko <andy@kernel.org>,
	Hans de Goede <hansg@kernel.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 048/224] iio: consumers: Fix offset handling in iio_convert_raw_to_processed()
Date: Mon, 27 Oct 2025 19:33:14 +0100
Message-ID: <20251027183510.286054726@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hansg@kernel.org>

[ Upstream commit 33f5c69c4daff39c010b3ea6da8ebab285f4277b ]

Fix iio_convert_raw_to_processed() offset handling for channels without
a scale attribute.

The offset has been applied to the raw64 value not to the original raw
value. Use the raw64 value so that the offset is taken into account.

Fixes: 14b457fdde38 ("iio: inkern: apply consumer scale when no channel scale is available")
Cc: Liam Beguin <liambeguin@gmail.com>
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Signed-off-by: Hans de Goede <hansg@kernel.org>
Link: https://patch.msgid.link/20250831104825.15097-3-hansg@kernel.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/inkern.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/inkern.c b/drivers/iio/inkern.c
index 6374d50915557..6bdd175df021d 100644
--- a/drivers/iio/inkern.c
+++ b/drivers/iio/inkern.c
@@ -627,7 +627,7 @@ static int iio_convert_raw_to_processed_unlocked(struct iio_channel *chan,
 		 * If no channel scaling is available apply consumer scale to
 		 * raw value and return.
 		 */
-		*processed = raw * scale;
+		*processed = raw64 * scale;
 		return 0;
 	}
 
-- 
2.51.0



