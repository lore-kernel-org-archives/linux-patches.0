Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAEE3335BCD;
	Mon, 18 Aug 2025 13:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525259; cv=none; b=qT3/qEjtiweCkSjxRVmLdGR1OiMHbfOiQFlQD6wFqxS+cWRZ1zKKZ8CSAy1EevNKA3rJaRZ8NjfbL/d4VmVJqzRu5ZH6fC6PoX9iIeC6v37gr7mCxLM4U8G2wDexAZfuNU9RuS8ruDFUuSBerHAILn8v94SdmkwDv1glHRp9fm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525259; c=relaxed/simple;
	bh=Rilij5UYE76r8Mrz8szJRtJQA+SJPaBCRfiVh1wu4Ag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jl2aTjsAHfkpKul1Nvz3c6+P6ZTTn7jSyQZlw9DZW5gadGEbJ5HJn11ZY1u7qCPzosZqxG4Huqun3f14a6teVZ7H+Uu0e1RvaCMpePwTMmBndT2qqc0Y9gT7OFyzFmk+m0jyBlFjCfBF2xP5vO/iBXzHRnfot5DSYiD0Ljp79rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yuPdu2En; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yuPdu2En"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E186C4CEEB;
	Mon, 18 Aug 2025 13:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525258;
	bh=Rilij5UYE76r8Mrz8szJRtJQA+SJPaBCRfiVh1wu4Ag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yuPdu2EnRarsFNIGO+laYYyeDMSrmYIhLLN+E7xj+xj0OuAbECVGKGar7rG84DVM4
	 wVX8rUZhB4kge90PEEqLlBPFE15sI+uvK4pg8wMQSDicwld4Mk/oB3N4hKnicc/T2E
	 4yM1+YOIpX9hU/64TGvSSfqAeHG4oKKlwLLfRNVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hsin-Te Yuan <yuanhsinte@chromium.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 165/570] thermal: sysfs: Return ENODATA instead of EAGAIN for reads
Date: Mon, 18 Aug 2025 14:42:32 +0200
Message-ID: <20250818124512.162021124@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hsin-Te Yuan <yuanhsinte@chromium.org>

[ Upstream commit 1a4aabc27e95674837f2e25f4ef340c0469e6203 ]

According to POSIX spec, EAGAIN returned by read with O_NONBLOCK set
means the read would block. Hence, the common implementation in
nonblocking model will poll the file when the nonblocking read returns
EAGAIN. However, when the target file is thermal zone, this mechanism
will totally malfunction because thermal zone doesn't implement sysfs
notification and thus the poll will never return.

For example, the read in Golang implemnts such method and sometimes
hangs at reading some thermal zones via sysfs.

Change to return -ENODATA instead of -EAGAIN to userspace.

Signed-off-by: Hsin-Te Yuan <yuanhsinte@chromium.org>
Link: https://patch.msgid.link/20250620-temp-v3-1-6becc6aeb66c@chromium.org
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/thermal_sysfs.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/thermal/thermal_sysfs.c b/drivers/thermal/thermal_sysfs.c
index 24b9055a0b6c..d80612506a33 100644
--- a/drivers/thermal/thermal_sysfs.c
+++ b/drivers/thermal/thermal_sysfs.c
@@ -40,10 +40,13 @@ temp_show(struct device *dev, struct device_attribute *attr, char *buf)
 
 	ret = thermal_zone_get_temp(tz, &temperature);
 
-	if (ret)
-		return ret;
+	if (!ret)
+		return sprintf(buf, "%d\n", temperature);
 
-	return sprintf(buf, "%d\n", temperature);
+	if (ret == -EAGAIN)
+		return -ENODATA;
+
+	return ret;
 }
 
 static ssize_t
-- 
2.39.5



