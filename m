Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9DE9418349;
	Fri,  7 Aug 2026 14:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114058; cv=none; b=bfDw0evSsK9SmJvJMhuLr9SGQ0Bb/7qR2gcxv4J0nUakOGPNFSXCytTuny6urnq0bgxnEZY2SP4RgKjFIjQDV5JsmJqqjlBBFpgsnfGYpQ0t+aHOBfvcBoqj78TUZ20DtG5D5nlF2PT2LVB3ZnKlEYLZtctJTnjF+YvLYvKpDFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114058; c=relaxed/simple;
	bh=YST5LwNKCkG9iRZoXakr2+n3CUyLVm815MnCMmbRMfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XmE7piBbDAOQFZSsTA73wctAyy0JjKMDsyQ7myxg69CJacS3xnNbkJnVAWen/p5VOmfDDIOfinZcLMnL1ZH+g7UTYrcYlkl08LwGkru0PZukwqg45wJbc3yATwd9aQLANcL1gDhoCPhb8QeBP9Kk3w7GrhFkglLQUrJFAqkpO7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lFcIZ9wB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lFcIZ9wB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1C671F00A3D;
	Fri,  7 Aug 2026 14:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114054;
	bh=daxJF+hMCC7/BvrtqgYbsbXOWeygUqBAZ4F3CKX64i4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lFcIZ9wBu1nsIypyX95HoZ5p07H+4+deFvPOUCdvSoBrJnyZze29dI3HJY1q8oOpG
	 eV7zhPSJUVu1gvk1enpTAeB5c9xXqNaprY0gHcZqfmv7TdNTdVNgkdtE4s+bpUqhGV
	 tFMkTPeCNJQ2Fal7TY028xEOiNsxmi8lOeup/yHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Luiz Angelo Daros de Luca <luizluca@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 083/337] hwmon: (adt7470) Fix PWM auto temp state array and bounds check
Date: Fri,  7 Aug 2026 16:34:46 +0200
Message-ID: <20260807143420.312039038@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Angelo Daros de Luca <luizluca@gmail.com>

[ Upstream commit 92413f439d1ec5e55b73ede8d66a7b971cbd1ced ]

In pwm_auto_temp_store(), the parsed user input was missing bounds
checks, allowing values > 0xF to overflow into the adjacent channel's
bits. Furthermore, the value was being incorrectly written to the
pwm_automatic state array instead of pwm_auto_temp.

Fix this by rejecting values > 0xF with -EINVAL, and assigning the
value to the correct array only after a successful I2C write.

Reported-by: sashiko-bot@kernel.org
Closes: https://lore.kernel.org/all/20260727034932.0B7C41F000E9@smtp.kernel.org/#t
Fixes: 6f9703d0be16 ("hwmon: add support for adt7470")
Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
Link: https://lore.kernel.org/r/20260727-adt7470_fixes-v2-8-598e38a46ba6@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/adt7470.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/adt7470.c b/drivers/hwmon/adt7470.c
index 3a2d408a45be8..0fad4bfe53df6 100644
--- a/drivers/hwmon/adt7470.c
+++ b/drivers/hwmon/adt7470.c
@@ -1049,8 +1049,10 @@ static ssize_t pwm_auto_temp_store(struct device *dev,
 	if (temp < 0)
 		return temp;
 
+	if (temp > 0xF)
+		return -EINVAL;
+
 	mutex_lock(&data->lock);
-	data->pwm_automatic[attr->index] = temp;
 
 	if (!(attr->index % 2)) {
 		mask = 0xF0;
@@ -1061,6 +1063,9 @@ static ssize_t pwm_auto_temp_store(struct device *dev,
 	}
 
 	err = regmap_update_bits(data->regmap, pwm_auto_reg, mask, val);
+	if (!err)
+		data->pwm_auto_temp[attr->index] = temp;
+
 	mutex_unlock(&data->lock);
 
 	return err < 0 ? err : count;
-- 
2.53.0



