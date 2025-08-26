Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A7791662E7;
	Tue, 26 Aug 2025 14:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217769; cv=none; b=mO7xbSvDnwB0DT3ydWXc1OMfZxL0zf7SQq1ZAk/b8vw0CLjE3lqpuUhr3nh/YqVZisKEaKU++6g6vwO6Ef6JnGCNDYVm4o0czgjLyg+VOOxBDmYzRLryQ8PR5BecOE2WT6ODW3Em2Z68nUVMmDOz3QSWlrMKEjaz39D+gPYpSO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217769; c=relaxed/simple;
	bh=NX2B2GfkGEGOheeqKKcI353VmORoUXMUYKaTGq/08fg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fXr4F8vDCdOinihbh5wJFWLEtFcXA5nT4WjAZaY/DhCvJE93C9Md47aYwoPE4dnzcx4QLj9ps7KTW27T7MoBxaq7bn7+zlCQnlE/0b9yVJ5tQUvjEtQhh4jj6gcytPfbqnlmXcs4k0+cRjVJeEEhjuxl6S+YUabh/66GrZcZsFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OwfHCH46; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OwfHCH46"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD49CC4CEF1;
	Tue, 26 Aug 2025 14:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217769;
	bh=NX2B2GfkGEGOheeqKKcI353VmORoUXMUYKaTGq/08fg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OwfHCH462Sa4IK6tfOlZzcJt7ZHQieKJenua1z8VXg+diVbeaLU9ZE2xf71EJdSSs
	 piKxpqs5hZUduTWEsmVDEvxiIOjc2174OLQ3SGU3uJGQwklkzicACiOUc0AZ4Jv92K
	 gi75CeiX336CXvOQE55dCHDVKpTXK6oAAhBlNalc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hsin-Te Yuan <yuanhsinte@chromium.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 237/523] thermal: sysfs: Return ENODATA instead of EAGAIN for reads
Date: Tue, 26 Aug 2025 13:07:27 +0200
Message-ID: <20250826110930.292221146@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 05e9a3de80b5..d64af62abcc6 100644
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



