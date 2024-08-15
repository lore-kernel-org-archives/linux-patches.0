Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBC061A2570;
	Thu, 15 Aug 2024 14:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731066; cv=none; b=ae4JCYYypQz9mnDE7LVzrWJsDXt0cViczIijZe0a54T2f4peMsHRZvz69cN1eMnK/vtnVZBxR19AqCERKSkF0FNDpHbj8RWFLqoyaVXMk/iNzqbCHekAfaCJIVNmMQxVnEazhbiyVa4RbinpP0/cGLudzDGM1s0RIFUigqIisCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731066; c=relaxed/simple;
	bh=E8rJfzpLrgBtMxz+h9kz+pMH3Hb3cc/XbVn9QrucjqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bEtRou8P86l8HGoC0g9nRckZDGqix6o9Zb8MtLx35gyp7KEomYoH1YshNZk0GksvV2aeEMmODtiPusLtTGRYVKJxnlahVa49kRgsNSSYrLWmZJwajIIGy+8YhQgTtNdEH7cK/+PBtYkVuCqNyWFOd2vwBlheyvhCD722WeCAm14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ERa/nqQT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ERa/nqQT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E709C32786;
	Thu, 15 Aug 2024 14:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731066;
	bh=E8rJfzpLrgBtMxz+h9kz+pMH3Hb3cc/XbVn9QrucjqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ERa/nqQTKfgsJ65LpTgrJudNGvOQzd3Oon1IA65fga4oy9/KaaDGGbhc5xS4OugKG
	 w9NaeJ1QLRdznGg+VJpWUGo/NQXpyuddzVbSKDvLiaO4l8y5TP/h+yA294faokeKrg
	 YSOiEaSuJiUTmwNZhB+iILhwBU4IKbe0m/PbmgSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 013/259] hwmon: (max6697) Fix underflow when writing limit attributes
Date: Thu, 15 Aug 2024 15:22:26 +0200
Message-ID: <20240815131903.305713500@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit cbf7467828cd4ec7ceac7a8b5b5ddb2f69f07b0e ]

Using DIV_ROUND_CLOSEST() on an unbound value can result in underflows.
Indeed, module test scripts report:

temp1_max: Suspected underflow: [min=0, read 255000, written -9223372036854775808]
temp1_crit: Suspected underflow: [min=0, read 255000, written -9223372036854775808]

Fix by introducing an extra set of clamping.

Fixes: 5372d2d71c46 ("hwmon: Driver for Maxim MAX6697 and compatibles")
Reviewed-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/max6697.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hwmon/max6697.c b/drivers/hwmon/max6697.c
index 64122eb38060d..cfd5815e60dfa 100644
--- a/drivers/hwmon/max6697.c
+++ b/drivers/hwmon/max6697.c
@@ -305,6 +305,7 @@ static ssize_t temp_store(struct device *dev,
 		return ret;
 
 	mutex_lock(&data->update_lock);
+	temp = clamp_val(temp, -1000000, 1000000);	/* prevent underflow */
 	temp = DIV_ROUND_CLOSEST(temp, 1000) + data->temp_offset;
 	temp = clamp_val(temp, 0, data->type == max6581 ? 255 : 127);
 	data->temp[nr][index] = temp;
-- 
2.43.0



