Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8ECB19FA99;
	Thu, 15 Aug 2024 14:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732029; cv=none; b=LRVpsHxkwhqfTFME/iwp/e0h1kkRMagInc9Fk2pSvGEDTpKrRX+cK247RuvLM7L5eZ+SwTt/gDx/e+myxqZk0WkcQqK+wPUYPeSuQ3baCycoS0eukTU50N3n1vSNs+iea/IKZYz0S5jrd091u4NhsYDLMWFRCSr8v/Ni+q2sOow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732029; c=relaxed/simple;
	bh=QFVYtbGibTRiFUB27ayrTzKv2QSN3at3oVWpZ0rV78Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UG303T+TWXHmzO8E0q9RS+7siiliYFn3atLULlDdoADzbuv+D8UpY5Phny8rqyDS73Y1lZro/Ujdv/nUd6RWMaWK01P3FN/gjbOmkGG1n+y/irNhpxIFsfgUEBRCaeFo/cQFgQL/LVQrm/b/WdhQ8VMIl9jXMiQCUkdS0QwVQFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uOPKZ1xG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uOPKZ1xG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C8C4C32786;
	Thu, 15 Aug 2024 14:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732028;
	bh=QFVYtbGibTRiFUB27ayrTzKv2QSN3at3oVWpZ0rV78Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uOPKZ1xGt0oGJ26Bkv5yCkInvv+cIhH8QcpLx445o5uaGB47lyDgoBqxYLK5RPQ5Z
	 4FnYLmgYNtCG3LY8VgvUIsZqqFHebzbQPiWeLly50G06rJc2iZRoUsXr60lZiN0TAw
	 81YMdqfRi1unpZ/nz6/1OZ1dMVvfUnm1500f7lFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 011/352] hwmon: (max6697) Fix underflow when writing limit attributes
Date: Thu, 15 Aug 2024 15:21:17 +0200
Message-ID: <20240815131919.647777006@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index fc3241101178d..3fa2a3b3c9954 100644
--- a/drivers/hwmon/max6697.c
+++ b/drivers/hwmon/max6697.c
@@ -312,6 +312,7 @@ static ssize_t temp_store(struct device *dev,
 		return ret;
 
 	mutex_lock(&data->update_lock);
+	temp = clamp_val(temp, -1000000, 1000000);	/* prevent underflow */
 	temp = DIV_ROUND_CLOSEST(temp, 1000) + data->temp_offset;
 	temp = clamp_val(temp, 0, data->type == max6581 ? 255 : 127);
 	data->temp[nr][index] = temp;
-- 
2.43.0



