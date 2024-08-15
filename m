Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B2319F470;
	Thu, 15 Aug 2024 13:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729178; cv=none; b=nh7hAfhHgc4N+tmq7MHy1/wX35lTFjvV1qCJ74u4EBRDPdw9QYc+GYuJjouCBZVqauqSKd56ShPJXx3ko9ZYl55V+HxnRx+NxoxEoAGhNndXrru8VKMxFHrP9gM7AMuxz/uIL8f0M4GkdAT0ytd0N46lhL+hVvLishmS1QbLfRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729178; c=relaxed/simple;
	bh=4Mrkx/LT9dcyMWmNL6cZKnC87AvRDPNglrDGsXmg/yw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LMl7IkLpeYRIjAUnBesZLJ97HpjPUZWBzXflAdWcsmSoxGHcpTBlfEx3xq2ZVew097C9AdsXris9zJw6KsyJb+M9yTph55lzCVbl6Ho96tepWvf6pIkV0ZTFcgZjOxew5aPW0Sy/lEsX0DuHA6t0WtkW4aPvX/uWOhU+MV4igOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wCfPBgMz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wCfPBgMz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 454D4C32786;
	Thu, 15 Aug 2024 13:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729178;
	bh=4Mrkx/LT9dcyMWmNL6cZKnC87AvRDPNglrDGsXmg/yw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wCfPBgMzLaMymhWoJoKaABfldD3MIezUVQSkTRMtZLdErZFMRc1RN1dUJjJRJus2Y
	 RtO5W9Wx9CHgC+YrclwtcTD/ZrcGt/tiBuFaRddfxL6tqDqbz6M8B8iTWAGM4YJtxt
	 WrJeQXnD9z0/mDU1sz4BVLe0eSUUQSup0OmQ5WR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 016/484] hwmon: (max6697) Fix underflow when writing limit attributes
Date: Thu, 15 Aug 2024 15:17:54 +0200
Message-ID: <20240815131941.898065690@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



