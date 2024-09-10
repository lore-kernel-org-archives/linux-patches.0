Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0815519066D;
	Tue, 10 Sep 2024 10:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963001; cv=none; b=Q3VtJvtVCT80l+zP9HqGSbqeZ3uTzeTbObzBhgjuOrCDWMKz68Su0/+zO82I2SRvsIu7r9qbJznB6NAJU0lbvcA4J5iD5hWuar3Xjs3AAY8bcKAWKRPVB0zLJDoNXMrF7Y6swg9EOLs+MsrY0bz4TtXcNhNKQYQ6OLzoOQYPHDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963001; c=relaxed/simple;
	bh=8qFtgVPolKBnxIoRbAcYSzBdafvtVIojNKWqZE0h2B8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VUCsjrdCc4veVar4hgVp1XQELLTQMRT/WaAwErexiz6ihhXv+ZgJC5crUwrdfb4c9u6YXak1jZnfrZ+BEY2WFrjpjZRh2FlNOjjdAhLFEX4RLmZpHa4FqMEiaeykn9LjJMU80tn4A4DgxwIKwhmN9PSfp2lRAYlK0rLH9q2wRm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RNPsnCOt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RNPsnCOt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D42EC4CEC6;
	Tue, 10 Sep 2024 10:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963000;
	bh=8qFtgVPolKBnxIoRbAcYSzBdafvtVIojNKWqZE0h2B8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RNPsnCOtRCRNBDSPMfDxvJ8rglqOaA0xe6oNzLKdLOf87mFyNTa8SXxZKbAx+oEyr
	 tKC/vhTQrlxeO2y2VlLETkNev+n8hYPcq+ohdvIeEmfaOXD+TC1HQz4LTv6UaFq2jN
	 N3bJPW84/QHajWbbwKH7XbIB2k1u/eWhdvUZgTVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 101/192] hwmon: (w83627ehf) Fix underflows seen when writing limit attributes
Date: Tue, 10 Sep 2024 11:32:05 +0200
Message-ID: <20240910092602.172300246@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
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

[ Upstream commit 5c1de37969b7bc0abcb20b86e91e70caebbd4f89 ]

DIV_ROUND_CLOSEST() after kstrtol() results in an underflow if a large
negative number such as -9223372036854775808 is provided by the user.
Fix it by reordering clamp_val() and DIV_ROUND_CLOSEST() operations.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/w83627ehf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/w83627ehf.c b/drivers/hwmon/w83627ehf.c
index 939d4c35e713..66d71aba4171 100644
--- a/drivers/hwmon/w83627ehf.c
+++ b/drivers/hwmon/w83627ehf.c
@@ -895,7 +895,7 @@ store_target_temp(struct device *dev, struct device_attribute *attr,
 	if (err < 0)
 		return err;
 
-	val = clamp_val(DIV_ROUND_CLOSEST(val, 1000), 0, 127);
+	val = DIV_ROUND_CLOSEST(clamp_val(val, 0, 127000), 1000);
 
 	mutex_lock(&data->update_lock);
 	data->target_temp[nr] = val;
@@ -920,7 +920,7 @@ store_tolerance(struct device *dev, struct device_attribute *attr,
 		return err;
 
 	/* Limit the temp to 0C - 15C */
-	val = clamp_val(DIV_ROUND_CLOSEST(val, 1000), 0, 15);
+	val = DIV_ROUND_CLOSEST(clamp_val(val, 0, 15000), 1000);
 
 	mutex_lock(&data->update_lock);
 	reg = w83627ehf_read_value(data, W83627EHF_REG_TOLERANCE[nr]);
-- 
2.43.0



