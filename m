Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60FF23502A8;
	Wed, 30 Sep 2026 19:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795038; cv=none; b=qt4qczpb+WfTnZcpifzPsH4bRmCm4Q9Lp3V7vYclLcaBu/GVKlDn/N/LazTMzBJT6f3E8nfnzEnD88RdHhPfnMYelyHHOTum20eenf/WyWAcxbiw5r6tjDNEnUKUl0YVHRbCV+iMQc2tVlnJjLDsniBaSZCI2Srooa0JUc2hQEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795038; c=relaxed/simple;
	bh=youebiGsB6WqzvTnwtrWoAWM/3unJZ/KFpFWuMc7Irk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ISJOJG2lCqDC5O+t/2W6iYIc+GDmfuXL5An6uEL4na/UrAO3jL2wAZP2/1ewx0FOdgB+NHRqOV2oFtP2Ddc5lzQq4VZO6LluEE3PfCq3wI1M87+9qq0oA/wZiSjT3FmBQ9V29EQ3WAVIg5+bEEEHAAEHCkXUu8JFAm5yfXO5oYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YDmTOv+a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YDmTOv+a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBF861F000FF;
	Wed, 30 Sep 2026 19:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795037;
	bh=o8SxvaPR3Hf4HFatV/JhMEyNEARBm7GdHXED1Y+2NSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YDmTOv+a5PPbdSRS8G5ktyeQ2noWq+78zLnajfBBsphOLgKN1c4kY5tewlJEPcxsV
	 p/biSl60tjjGH1rMPD7i4XdJD5OIEKjhyrhhOihgs0dKEXB2xifYwrJcS7tMP1A2Sf
	 WNF6YGJ17ugZpz3baHm8wvusxJ8iLswiqANmbEv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jad Keskes <inasj268@gmail.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0376/1193] EDAC/device_sysfs: Use kstrtouint() for poll_msec to prevent truncation
Date: Wed, 30 Sep 2026 17:17:40 +0200
Message-ID: <20260930152442.532187930@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
index 010c26be58464..c10f0094b5b86 100644
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



