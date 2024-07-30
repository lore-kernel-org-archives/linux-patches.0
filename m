Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AB4C21C198;
	Tue, 30 Jul 2024 16:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355307; cv=none; b=rbGWU2DRlxWLwM+t3prI86Nq/d5fEvT/CZFhmHHrGZnh/01U3CM8wEOwJkK6e7r1BQRVpVu0ejTMV4X1h+RVFXrDezu4/K9gWJUlu5iNCmgGSW5hbCvKgCJ2FakB6CU4bcrd4/Gqou0J6xGotXV7qUdwp1ewxIeo4HZfpMmqMo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355307; c=relaxed/simple;
	bh=51DdB8l2g4LKLlL/hnx7KIv7XuRKnDv5975XwoRq598=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ciaMugdq7p6CoEijXxz6l2pkx863DPv4VeOv0hvnI0eUPxdCzdl/Bxaw5M8ijxArOa8SdxBt7ZZQLmWfNZFoBgmHA3J16pP0r+lQzMT36ezbrSkcrqA5Ul9hVgi4O3IjUbc18s7gEUUkp1mlGX0uGGVYBrmwBN2Cvh+Spl1Qu8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eOrz6csj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eOrz6csj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1968C32782;
	Tue, 30 Jul 2024 16:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355307;
	bh=51DdB8l2g4LKLlL/hnx7KIv7XuRKnDv5975XwoRq598=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eOrz6csjwEPnqpveePJC8DXmcHtCuVUWuYpvsOLdt0EgrsYNP+VHLBbyY4rHqXz4K
	 WfnINJ0/C5VGJnHEByYgG7epSIvRIjNUQV4ZTz3m0gmKx8MDxke1WkYjRGYCxiHHxF
	 ib+boTeUs7oAw7Ax8oFq6GlPtaWIZo7xOUTc3H4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 039/809] hwmon: (max6697) Fix underflow when writing limit attributes
Date: Tue, 30 Jul 2024 17:38:35 +0200
Message-ID: <20240730151726.194097109@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index d161ba0e7813c..978476b632752 100644
--- a/drivers/hwmon/max6697.c
+++ b/drivers/hwmon/max6697.c
@@ -311,6 +311,7 @@ static ssize_t temp_store(struct device *dev,
 		return ret;
 
 	mutex_lock(&data->update_lock);
+	temp = clamp_val(temp, -1000000, 1000000);	/* prevent underflow */
 	temp = DIV_ROUND_CLOSEST(temp, 1000) + data->temp_offset;
 	temp = clamp_val(temp, 0, data->type == max6581 ? 255 : 127);
 	data->temp[nr][index] = temp;
-- 
2.43.0



