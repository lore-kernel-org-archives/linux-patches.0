Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25887350D52;
	Tue, 26 Aug 2025 13:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216179; cv=none; b=VGGNZDzvxqizoHyrFk/ih1ovkR2EhXwO1TAQgodoyk9G4wBVJO0LWB1Tke0cHdFCV8rqgb+zav9tQRcDarKbHgvyDCuaNrtDkIzt+7JPUFJEfoURF9x4dbEhFEGQBVZhOmqnrpZx+pSNOxLg09R0vVndm4qvX+vnUPGub50qh1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216179; c=relaxed/simple;
	bh=nyjnx5EdbYfXuOZkozfU+Fv/EFhHkQBG2a0d7aPu2dM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c8H3//S8EwROfx9VmKgkqb90012yuLStv7ldfI9T4dPfSjG94Ha+ruOi+F3/4qwXfGCkv81qRfr/4OGtifewn2WKGlklr/1wE56jaO/ZuyNUbv3Kv3HCwHw1F9tmj90xbbVmYyTIXOdBfXfhkfWlWDlQRjY7k7zhwXlKRLpUn2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n5PcS9Ay; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n5PcS9Ay"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB04CC4CEF1;
	Tue, 26 Aug 2025 13:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216179;
	bh=nyjnx5EdbYfXuOZkozfU+Fv/EFhHkQBG2a0d7aPu2dM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n5PcS9Ayfq4U9NPyWVbtSkAgFIRntd+95UT93sNZAfmXOJXGb9dSy9nqFD4XYJqdI
	 pJIKN3sVIoII50ov3652fi6DH9AyM3BXGLJmjI3oVHiOiredfP8MpaQjJCnr1tQEET
	 B6jr8E3wCSkkA+YWrQYO1bWNdrNsPLn2WknyrVeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hsin-Te Yuan <yuanhsinte@chromium.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 315/644] thermal: sysfs: Return ENODATA instead of EAGAIN for reads
Date: Tue, 26 Aug 2025 13:06:46 +0200
Message-ID: <20250826110954.191246847@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index de7cdec3db90..a21af02f6347 100644
--- a/drivers/thermal/thermal_sysfs.c
+++ b/drivers/thermal/thermal_sysfs.c
@@ -39,10 +39,13 @@ temp_show(struct device *dev, struct device_attribute *attr, char *buf)
 
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



