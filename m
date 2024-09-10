Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1FCD18FDC5;
	Tue, 10 Sep 2024 10:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963743; cv=none; b=LeVDnvoxLkYyaNIZcPOWi3L/av8KAPk5rJxOHM0oALkG6R84hvBGub0cAGtEU7YUds2pfa/7b/aptu4rmUPTYlc2+1kI9cvBj9HX6k7h3iJDRlci57L+kj7i7tn9S/0Wg9nn7VeGDVM55odPs3XRelWhbvqfvxD+pjn8ZASzleg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963743; c=relaxed/simple;
	bh=K1Rcf/5YyQiCuWM9/vdPCkRzR7Bm6S8DS3Ckel3Wcr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h6+hryv2DgOhTDu9+jGVKSKB6nxluRNWf37dcfMveA14sFQMp3plJ3Bdm+ByLDqdtKZ79czyj6i4l9XmCKvCjXN/1Ce9phlwIZfzPfIeTYAF9FaV89I9zjlgy4Jf57mVmerdWKJnNnH9NKdbxG++5WU7KmMUX/gfiJGGZLX3Ths=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fGnzb53U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fGnzb53U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A396C4CEC3;
	Tue, 10 Sep 2024 10:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963743;
	bh=K1Rcf/5YyQiCuWM9/vdPCkRzR7Bm6S8DS3Ckel3Wcr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fGnzb53UBYcX7O4Ac7IdZtSA/iJdWAVPnKRLPwBL0jvFMPMPWfjfg5tdDvHq2oLoY
	 kiJ4qIk97baaud3UZAaJTXKbtpnh+fpAzC6kqMJDPWYqFQ/m+2WNIVOL2dUQd0uups
	 RdUKpj2kZ6CEyWf9gqDXo5ME2ys+p7ERWoKa7KY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 144/214] hwmon: (nct6775-core) Fix underflows seen when writing limit attributes
Date: Tue, 10 Sep 2024 11:32:46 +0200
Message-ID: <20240910092604.639393987@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

[ Upstream commit 0403e10bf0824bf0ec2bb135d4cf1c0cc3bf4bf0 ]

DIV_ROUND_CLOSEST() after kstrtol() results in an underflow if a large
negative number such as -9223372036854775808 is provided by the user.
Fix it by reordering clamp_val() and DIV_ROUND_CLOSEST() operations.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/nct6775.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/nct6775.c b/drivers/hwmon/nct6775.c
index 5bd15622a85f..3645a19cdaf4 100644
--- a/drivers/hwmon/nct6775.c
+++ b/drivers/hwmon/nct6775.c
@@ -2374,7 +2374,7 @@ store_temp_offset(struct device *dev, struct device_attribute *attr,
 	if (err < 0)
 		return err;
 
-	val = clamp_val(DIV_ROUND_CLOSEST(val, 1000), -128, 127);
+	val = DIV_ROUND_CLOSEST(clamp_val(val, -128000, 127000), 1000);
 
 	mutex_lock(&data->update_lock);
 	data->temp_offset[nr] = val;
-- 
2.43.0



