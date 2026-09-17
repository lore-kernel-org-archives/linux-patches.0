Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 165104DEC07;
	Thu, 17 Sep 2026 17:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665250; cv=none; b=K0D6r4YN/0Ca/FA5EwWZ3BwpRA53mS4g8pTwl5qKq0VcqYbNIQZBUPKDmPXGJ4KpmxDCwfBUBubiPuG+4tV52EsXv0cz67xGl5EaswR9zq/fAi1QzzFxG7gN/rpm3Q+oI5BHBsomx4+0AcxilcYnz6loyNlke9g0+eXz96UNjZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665250; c=relaxed/simple;
	bh=+BPwmDM3I6ehtGGbLWTaX9Qa6R3/0FVSlJF4eDJNuU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bbZGMJhve9h48jeOpzyntZUS/Zv6Xov4WGEzyr0UDvnfQRjXCJz0CIoz44G+mDAcZ3brrs9eaYwcTpHgo8CUNlaZPn4Nghaq2IuJ8iDUEAKNIlLW2ad9Jn2JDGDKhIIqD9rjITc1mZj0PPJ4RY0h0sOYMUBd39UUc2YJEYXzlRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2cQlVnXd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2cQlVnXd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E6251F000FF;
	Thu, 17 Sep 2026 17:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665248;
	bh=bJ6v0T5kB3JxyzNh2bHw4LM+TLleCY0I3W9pNSWfh8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2cQlVnXd3ZJvGLuvfL0rGNAnG0DYeJg46o5qqgyiL/tDAPP7IiCcxnnngUWUaIQq6
	 ysqJVxj2dOOIjJDWVSBJW9D1CFbVSoAgzVG+RzAwkD3jq2PASWmpmQd53xqup32SPa
	 sdxn4KmOv/8gOavN4Eb/9/KAhWn/T5M/yBodQi98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jad Keskes <inasj268@gmail.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0605/1250] EDAC/device_sysfs: Use kstrtouint() for poll_msec to prevent truncation
Date: Thu, 17 Sep 2026 16:06:40 +0100
Message-ID: <20260917151608.275374433@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jad Keskes <inasj268@gmail.com>

[ Upstream commit 66cc9dec919dd63d8e4b3d386f7aed3ae684e645 ]

The poll_msec sysfs store file uses simple_strtoul() which accepts an unsigned
long, but the target field (poll_msec) is unsigned int. On 64-bit systems,
a value > UINT_MAX is silently truncated when stored.

Fix the mismatch by using kstrtouint() instead. This rejects values larger
than UINT_MAX at parse time, making truncation impossible. Also add a check
for value < 1 to reject the 0-delay case, which would cause the poll work to
spin without delay and consume 100% CPU.

Fixes: e27e3dac6517 ("drivers/edac: add edac_device class")
Signed-off-by: Jad Keskes <inasj268@gmail.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://patch.msgid.link/20260730145549.148229-1-inasj268@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/edac_device_sysfs.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/edac/edac_device_sysfs.c b/drivers/edac/edac_device_sysfs.c
index fcebc4ffea26d..71940f43a0dd8 100644
--- a/drivers/edac/edac_device_sysfs.c
+++ b/drivers/edac/edac_device_sysfs.c
@@ -90,14 +90,21 @@ static ssize_t edac_device_ctl_poll_msec_store(struct edac_device_ctl_info
 					*ctl_info, const char *data,
 					size_t count)
 {
-	unsigned long value;
+	unsigned int value;
+	int ret;
 
 	/* get the value and enforce that it is non-zero, must be at least
 	 * one millisecond for the delay period, between scans
 	 * Then cancel last outstanding delay for the work request
 	 * and set a new one.
 	 */
-	value = simple_strtoul(data, NULL, 0);
+	ret = kstrtouint(data, 0, &value);
+	if (ret < 0)
+		return ret;
+
+	if (value < 1)
+		return -EINVAL;
+
 	edac_device_reset_delay_period(ctl_info, value);
 
 	return count;
-- 
2.53.0



