Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BE7828FD;
	Tue, 26 Aug 2025 13:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214390; cv=none; b=r4a375+wRVLnxJPT0FEbK7WHJUzc4bEho3X2Zyg5NJxRV7HMeuA0HrmHwFHwWGj8NnWsw5juYAeaPnD6B3WxbF4YMfPg8pzBslS7UuNo00wDqT+7oMp5YjIq/HjtHAOeNcjvkRe/o6VyEUSFXU7UiKLS23/gkMpeMEXu/V0Y8QA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214390; c=relaxed/simple;
	bh=zLivDoERfX4JA+yfMKxnR0IXoQkYO/k5B6vW82HXzi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oVVAascohclYY69zg+mhsS2Ifo/KcOlsvUMpIapLwv6tlIXykemAyqoZizqotvI1ByajaRu6fI8VbhlNxNlA+d58kl/q0CCNDBQCZ+iTHJtBN6dYHD4/mPW9joZz9XQYKsjiuv1lIuQbup/3jHjQZ6MgDLkt99Ji21OdD2w+1rI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UgGxvAZ6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UgGxvAZ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EB84C4CEF1;
	Tue, 26 Aug 2025 13:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214390;
	bh=zLivDoERfX4JA+yfMKxnR0IXoQkYO/k5B6vW82HXzi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UgGxvAZ6wH31nhd18Pbmow2jblmGUgu1L+wH9Rj5EpjqvIOjEUm/5+qlY4tFn+69i
	 llK8nfXQRzlnQyxS94ncYUPuwQaSDKaQaKtmk3Ln3O937COIK27KHyActNTMIriEB2
	 vKvzwqv7aFESrk1PzY1ObZrzYJUoPjyYiaunUu4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hsin-Te Yuan <yuanhsinte@chromium.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 088/482] thermal: sysfs: Return ENODATA instead of EAGAIN for reads
Date: Tue, 26 Aug 2025 13:05:41 +0200
Message-ID: <20250826110933.003689035@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index bd7596125461..7ee89e99acbf 100644
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



