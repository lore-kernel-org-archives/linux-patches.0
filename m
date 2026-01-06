Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 163015695;
	Tue,  6 Jan 2026 17:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720713; cv=none; b=iIi598OPQqjyuYUrLTvX9tQ6HBh2Riy8KmdpUhka49dLtNGQmtVChjkpI6zkXR+durPqWJrCMLWPGwj7K96dnZdG5aFIW4/KUsm/jNzG6SeNDwNcHqwUqgTah+9Y023qWqyhTM803cBd50rdv9iiqug4xo2A6+T8XdLPmKxmOcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720713; c=relaxed/simple;
	bh=XeveiZBsCGxIL8S3/B/fezq4PUv8CGn7k69DBt7YUsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kl3Rgf6hqhdQbrAigF/JGzc7/96CqIR3sdyopD3wU+R+mkOBtV3bR+9+j9up5tG7rF7ou2Ti+bQoDJw7ribhSHJ9Fk1UMOZ5Bg8sa9McGl+fS370fs6tGMpsD3XkvX0HeJb9M3VAeS5wvHYi5mwv0CViPPyK1BpSH9d9shc5riY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mlh/BB1J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mlh/BB1J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4582BC116C6;
	Tue,  6 Jan 2026 17:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720712;
	bh=XeveiZBsCGxIL8S3/B/fezq4PUv8CGn7k69DBt7YUsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mlh/BB1J2P8ztKWYsvCFtQi0mR8pAezJ/x/MHbqRZndAYT2+kwSltYipVhsJDuZov
	 bWpU5daE4YV8ehe8ufR/Z40tbCXwrNP4UZovQbCD5DwpmJbPXa6s46BvpVeyvOavLQ
	 msrP0xZWpOa3zkpCIf+uqMA2ZDBe6CCW+T8O+gG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gui-Dong Han <hanguidong02@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.12 286/567] hwmon: (max16065) Use local variable to avoid TOCTOU
Date: Tue,  6 Jan 2026 18:01:08 +0100
Message-ID: <20260106170501.912385994@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Gui-Dong Han <hanguidong02@gmail.com>

commit b8d5acdcf525f44e521ca4ef51dce4dac403dab4 upstream.

In max16065_current_show, data->curr_sense is read twice: once for the
error check and again for the calculation. Since
i2c_smbus_read_byte_data returns negative error codes on failure, if the
data changes to an error code between the check and the use, ADC_TO_CURR
results in an incorrect calculation.

Read data->curr_sense into a local variable to ensure consistency. Note
that data->curr_gain is constant and safe to access directly.

This aligns max16065_current_show with max16065_input_show, which
already uses a local variable for the same reason.

Link: https://lore.kernel.org/all/CALbr=LYJ_ehtp53HXEVkSpYoub+XYSTU8Rg=o1xxMJ8=5z8B-g@mail.gmail.com/
Fixes: f5bae2642e3d ("hwmon: Driver for MAX16065 System Manager and compatibles")
Cc: stable@vger.kernel.org
Signed-off-by: Gui-Dong Han <hanguidong02@gmail.com>
Link: https://lore.kernel.org/r/20251128124709.3876-1-hanguidong02@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/max16065.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/hwmon/max16065.c
+++ b/drivers/hwmon/max16065.c
@@ -216,12 +216,13 @@ static ssize_t max16065_current_show(str
 				     struct device_attribute *da, char *buf)
 {
 	struct max16065_data *data = max16065_update_device(dev);
+	int curr_sense = data->curr_sense;
 
-	if (unlikely(data->curr_sense < 0))
-		return data->curr_sense;
+	if (unlikely(curr_sense < 0))
+		return curr_sense;
 
 	return sysfs_emit(buf, "%d\n",
-			  ADC_TO_CURR(data->curr_sense, data->curr_gain));
+			  ADC_TO_CURR(curr_sense, data->curr_gain));
 }
 
 static ssize_t max16065_limit_store(struct device *dev,


