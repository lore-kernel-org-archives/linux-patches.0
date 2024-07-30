Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED12529A2;
	Tue, 30 Jul 2024 15:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722354869; cv=none; b=TAsYG1LYX1BgAEU70LO9a+AYygGQFFlLxyYpyiWDg24svXJKWwIDfcapl0i91ZpnF7iCCFK30mypdsPp7SIAGSHylJYbN1cD+PMb8mSc2hZtIGz/Sew3rvdaIYOU/yoLExQLiVqZRYKzI5yBrknWgMqV7Q2nqFA2+87lJmltQls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722354869; c=relaxed/simple;
	bh=Eo+rDmCr3o65Nr9ruVHzRh8SeDasVxAjza04Zwe1AjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WZqE7kiwJZB3Ub3gQ42lZwgKGKIOSTVjrbhwVrhYszKPB+OQgMZbvOGgRBPd6uL0pwUO0crNUIKQUwVbfZjd12L04NNYaQHuCkupfTIXDjMRz+MZFp068We3taeXyvk7HthTJ26dbrzoTVYnINCKhMMyx0M4YaipewckRzodvtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xZHx/5GB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xZHx/5GB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A846C4AF0A;
	Tue, 30 Jul 2024 15:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722354868;
	bh=Eo+rDmCr3o65Nr9ruVHzRh8SeDasVxAjza04Zwe1AjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xZHx/5GB02YX+pWtlD0tfFrikCj4rwFu1dgH5fX4gtaqhi+phljNBaYlIVuc3TlIW
	 CTn7XxLrxRai9E+vEU0pO5Gh634nC0UAptOvuPX2wrii8avzoARBS5oRBT0bt9LtC8
	 8mpXVHu2kC1ObeV04oUKJzf06TcRPhcyKVW7VLVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 029/440] hwmon: (max6697) Fix underflow when writing limit attributes
Date: Tue, 30 Jul 2024 17:44:22 +0200
Message-ID: <20240730151616.903000725@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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
index 2895cea541934..563e73f071d07 100644
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



