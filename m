Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A42D3DC857;
	Mon, 17 Aug 2026 14:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975545; cv=none; b=a6Id5YGnclyKrgQZNeFjgqZ5brZvxUhXXm/PRiu9AGV4ZDybL36JaIwzSdb9x+j9PO7dGwOy68BT0JwI+XqqN3F2+zSJUvTEYTljXP2I3ISNqal34Zl53DQ6xufMTZYVksCr4UjreOFjyf6NOOU/yLSsU/bmodr8AewEWqq+j4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975545; c=relaxed/simple;
	bh=H/aZFHNINPhBock0tnQRXwerZYB6SnKA9RrLfqIZqi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n9Q+xqftNe2ocg05hhfP4I6Yfa+910Ifbfvq0efhaI89oosKW9unenZhhYbGwS6nGUEvY5tuiQ2fvyhiISE4r+KKeE+76wuqdD+gRDJNR8JVoKfwHxIkN/xldDdJ3uEFDmbEjl8MqZvbMB/4wkdlBhaMzmbm9bK1P2SyGIwtAAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=17WgMo8Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="17WgMo8Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D108B1F00A3A;
	Mon, 17 Aug 2026 14:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975544;
	bh=u7nCnuI8zpOpdwj0wcM388rQPQg0lDQZXrxHJgimNWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=17WgMo8YDFGfq0GdRGZhO0+tTH+3u4PN/+tQD4T2JH6zHIF7xBdH6L/yiccN7glWq
	 QKsv4uvPVVJxyTiSUNwRWGfPu8XQW+MDGv+x908kFrp8uqvG84sdK+U9eaMLW7h+S5
	 2Zl++9+LCFxBSF26EvlFlTYBK3qLI2P895I01jDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 062/389] hwmon: (corsair-cpro) Stop device IO before calling hid_hw_stop
Date: Mon, 17 Aug 2026 15:28:21 +0200
Message-ID: <20260817132541.509634995@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 94c87871b051d7ad758828a805215a2ec194512a ]

Calling hid_hw_stop() does not stop the device IO.
This results in a race condition between hid_input_report() and the point
immediately following the execution of hid_device_io_start() within
the driver probe function. If the probe operation fails after "io start"
has been initiated, this race condition will result in a UAF vulnerability.

Fix the problem by calling hid_device_io_stop() before calling
hid_hw_stop().

Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: 40c3a44542257 ("hwmon: add Corsair Commander Pro driver")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/corsair-cpro.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hwmon/corsair-cpro.c b/drivers/hwmon/corsair-cpro.c
index 074f812332e89b..f117479096ef87 100644
--- a/drivers/hwmon/corsair-cpro.c
+++ b/drivers/hwmon/corsair-cpro.c
@@ -557,6 +557,7 @@ static int ccp_probe(struct hid_device *hdev, const struct hid_device_id *id)
 
 out_hw_close:
 	hid_hw_close(hdev);
+	hid_device_io_stop(hdev);
 out_hw_stop:
 	hid_hw_stop(hdev);
 	return ret;
-- 
2.53.0



