Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84C5019F49C;
	Thu, 15 Aug 2024 13:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728490; cv=none; b=gShM9wl+ajB2rXWfosFblb/s53d1yMqk9+0yAe+bU0TuJCwEzaHomtinMpVeDi+CTALxp+VRYUEvB8sBa/59Hi6+Z2Nw0miz5WPxJl9n8bJLL1yol8R4KIvUeGP8QbkaxX10FSgjVHqwJ4llQkrN7+SQKbjpNLO95ail8yagZ8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728490; c=relaxed/simple;
	bh=36+Ld6l1CqKyI4o5hjbb604YL057ctXwX10jXu2ic8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uTXwCRclGgymXribRvbs75cmkWecGEz+4wDcbqhAW39Y9D4st1WdDH76hYbz+I5mxc1wRitzWx304/Bh8M5pvyDbXwab35IJzDCOfKkip2gQMZqqObC0P1fHIR3gQ8HWxiO08bJKAZ3a7g1hcS2bfIWB+xQ0tqvWWfcfopw2DrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rJiTLMlb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rJiTLMlb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B798C32786;
	Thu, 15 Aug 2024 13:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728490;
	bh=36+Ld6l1CqKyI4o5hjbb604YL057ctXwX10jXu2ic8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rJiTLMlbFWYEgLgmnocbMQgMxM1WLdIZvwN8cJkcGXR8TIBVG5Ud9WHpYPihG5AEr
	 TSqrRFKSqyFz3Il8qDTyLBlU0ueF19v4RSMZeX3ByoVHmZRoeeSK6/i4iY+jWKB3Lw
	 cOLG9E0y6WWGLUBn+erF3hHGwBkDb8MuXVHBvp9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 009/196] hwmon: (max6697) Fix underflow when writing limit attributes
Date: Thu, 15 Aug 2024 15:22:06 +0200
Message-ID: <20240815131852.429364184@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 6df28fe0577da..7e7f59c68ce6e 100644
--- a/drivers/hwmon/max6697.c
+++ b/drivers/hwmon/max6697.c
@@ -314,6 +314,7 @@ static ssize_t set_temp(struct device *dev,
 		return ret;
 
 	mutex_lock(&data->update_lock);
+	temp = clamp_val(temp, -1000000, 1000000);	/* prevent underflow */
 	temp = DIV_ROUND_CLOSEST(temp, 1000) + data->temp_offset;
 	temp = clamp_val(temp, 0, data->type == max6581 ? 255 : 127);
 	data->temp[nr][index] = temp;
-- 
2.43.0



