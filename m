Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 350CE341AA6;
	Tue, 26 Aug 2025 14:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218941; cv=none; b=sY+M5oFLqAOD9WBZzVW8TjVByJ7Go8sOGkVXQXYESTA+DWbcBwuRVqRy92WrYbmVnQ3H1sotLaNJF2Wq/BqjF1UHnMyqtAWef6jB6ns0ziVA5HboSwagMrz0C8M1sGReFivjEk1yDNRUXLyWOmAY6RjUAPB6HO4x5tGG40E3Qv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218941; c=relaxed/simple;
	bh=muiacT+Sxw0WrGlgz+0RZ8rvQdHtXAEtFJTg5+OymVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DCBr3oLBf+hClEWsTgcJ6zyzqp4YghDjcKOLOTIb1iO4/x7Vbjz05PP4Nvg2u39oT/MgaKFzNrODuUBZCL7pCTa9kwGgnerwkm//ysJGvoXbL5LhXu/Z39rR2UJITrMwjPE65A2HzWt4abxdw/ma53sGqWJLESPXJaBC1R2C2pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L+bnbPBj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L+bnbPBj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA628C19423;
	Tue, 26 Aug 2025 14:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218941;
	bh=muiacT+Sxw0WrGlgz+0RZ8rvQdHtXAEtFJTg5+OymVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L+bnbPBjvXs3HY7Gt/yArJpESyIe5xI7pQj7NQto8ezb89QAOdGL/R7AAUqvi89S9
	 ukQi9mWWzprrdomC+2Gv7rxbSjEnMiZiAO0cG4e1dCtsVWUUh2Phz9i0UHm379hADx
	 DKLQmiwjZgrd33IYR5ulsvHgl1dvfdvm56TDnBUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hsin-Te Yuan <yuanhsinte@chromium.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 193/403] thermal: sysfs: Return ENODATA instead of EAGAIN for reads
Date: Tue, 26 Aug 2025 13:08:39 +0200
Message-ID: <20250826110912.203007729@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 17b2361bc8f2..fc768b61f483 100644
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



