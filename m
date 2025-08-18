Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E457527B330;
	Mon, 18 Aug 2025 12:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521806; cv=none; b=Wu1c0gBmwoUeZW8SJmUlBFJfWTUR65FQzztBZ7DjfsCSlZKMnghxTOgf7g/X8Tp08+OZETCQa8+OFwqo2+XvJ1OZuuKcFvJgCnYUCLaaXeaP3dcIvF8kzdQ/hIsJ+8Km1tteTDp2v7ITEDLbbnEzIu7yrSHN8Sb1ITAgAVWFoi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521806; c=relaxed/simple;
	bh=W6S3cnjR7+lbT97ZY96Ag3UVByX+3aIaDJ2LKpiGt0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nB3ZRiZOgQcpBYjHyLtWKbLjp8C9DU6DUN8souw6+n5wtApRTyTDs1dh7O3zVntiCemTWO/oocvBLF28xDQaFfZoQkzOvOR/mUHMxa19wQRDCHiCaLUZBklIApE7ZKc70vmSesDXmnZkWGoVMGETc18EYWh8URlkohONit21cAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q8qJWCC4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q8qJWCC4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AA64C4CEF1;
	Mon, 18 Aug 2025 12:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755521805;
	bh=W6S3cnjR7+lbT97ZY96Ag3UVByX+3aIaDJ2LKpiGt0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q8qJWCC4jCItGq9A02ZFshvFqEgTznDU6WcpeWgYpR2eZYXP3h4cymxPU34LNxZlI
	 IatDRP3J1YSCoA5OHKIi9qHHcHxo4EnpKYN194SSUy00q5i58Rx/jBd3zrPeDNCnle
	 +aLcZ+hcCbo5vQXx4Rpr3rTy1pWf47CHM3HFYTL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hsin-Te Yuan <yuanhsinte@chromium.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 128/444] thermal: sysfs: Return ENODATA instead of EAGAIN for reads
Date: Mon, 18 Aug 2025 14:42:34 +0200
Message-ID: <20250818124453.718108285@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 1838aa729bb5..c58c53d4ecc6 100644
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



