Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F4C403E98;
	Wed, 20 May 2026 18:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302531; cv=none; b=j4ihk0bwb8+HeCoE+yJMJHlXv6A+5BPoVLK4yENVSDe3z9rl6XocGhs6Rd+CP7bdqjheqB1vZ1IezgQpe9zhFhh2zwzLgpc9/q7TqAGl2DEDuoVZ6LctojGGMbNINhBTRMKYFzgaUKFaUoZsb8WX9KRfFUHDr9LUc94+nOX639Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302531; c=relaxed/simple;
	bh=mEM5kq3J2UWIKxYvbZkaU9Oba105qBRIXjWsR5nYkeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PBogVI3Xp0Dio6mKTCJ0GuZGMSmlkazv2sziNWUF3cYlHWME8D4GPBBMwkW1cZf1Qnw35xaypMsyh0s7ccPZcUWAUFITzgh8f6PFgZ1SjT3N29JZHUBRckexBKQZhJYlMwSGKY7yA/K4jmbLD1EIDW7TT4JGzVbskhdOZQhkob8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JuRwdWU3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JuRwdWU3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C98F21F000E9;
	Wed, 20 May 2026 18:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302530;
	bh=E/xMauHoY74qThbtbss7RmP5nZBeJbas4h0I2W9Doe0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JuRwdWU3nvu/0GzLs9l4g+kRhQRdcDuz8KPHF2JY7ow5JpnBAdwLYkJjX53aD9T7z
	 veIP3ZZfEiUBq4WtpO3mAZ8UAx3gMlH3AQ/q/0oUDU8EXeC9gIqPFRrWYmaoFCth+E
	 0SFneRnDpW7KK2CWLjqc4+goIm9IQ+KDDv/BIy/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nuno Sa <nuno.sa@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 260/508] dev_printk: add new dev_err_probe() helpers
Date: Wed, 20 May 2026 18:21:23 +0200
Message-ID: <20260520162104.279433370@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nuno Sa <nuno.sa@analog.com>

[ Upstream commit dbbe7eaf0e4795bf003ac06872aaf52b6b6b1310 ]

This is similar to dev_err_probe() but for cases where an ERR_PTR() or
ERR_CAST() is to be returned simplifying patterns like:

	dev_err_probe(dev, ret, ...);
	return ERR_PTR(ret)
or
	dev_err_probe(dev, PTR_ERR(ptr), ...);
	return ERR_CAST(ptr)

Signed-off-by: Nuno Sa <nuno.sa@analog.com>
Link: https://patch.msgid.link/20240606-dev-add_dev_errp_probe-v3-1-51bb229edd79@analog.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: 797cc011ae02 ("backlight: sky81452-backlight: Check return value of devm_gpiod_get_optional() in sky81452_bl_parse_dt()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/dev_printk.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/linux/dev_printk.h b/include/linux/dev_printk.h
index ae80a303c216b..ca32b5bb28eb5 100644
--- a/include/linux/dev_printk.h
+++ b/include/linux/dev_printk.h
@@ -277,4 +277,12 @@ do {									\
 
 __printf(3, 4) int dev_err_probe(const struct device *dev, int err, const char *fmt, ...);
 
+/* Simple helper for dev_err_probe() when ERR_PTR() is to be returned. */
+#define dev_err_ptr_probe(dev, ___err, fmt, ...) \
+	ERR_PTR(dev_err_probe(dev, ___err, fmt, ##__VA_ARGS__))
+
+/* Simple helper for dev_err_probe() when ERR_CAST() is to be returned. */
+#define dev_err_cast_probe(dev, ___err_ptr, fmt, ...) \
+	ERR_PTR(dev_err_probe(dev, PTR_ERR(___err_ptr), fmt, ##__VA_ARGS__))
+
 #endif /* _DEVICE_PRINTK_H_ */
-- 
2.53.0



