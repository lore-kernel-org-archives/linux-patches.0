Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83D613C661A;
	Mon, 17 Aug 2026 14:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976718; cv=none; b=mnzRLJuH/1WYb6dBkTJ/9U1ewW8O8xSTQBsM3W2u1L1VYo0kIrpz8AGpUqMkUdckfw9608s2jIgiK9xkChIW9y7dTJcfClS5GFc2yeMkiJXob4z82v65dhqvomWEQXCU2vAtyEWrLdtVyR3vZrzbw28gVNnFy/+Lafe7gQZEF/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976718; c=relaxed/simple;
	bh=267doytQVmruddAlfRMZnQoEgg1q4gDSqKoZ6QGF6wE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d9cnJQAh8uTd1G5HOp1vWHaEOfyFGm7Pcpoxguo8NRVpC7aJhrmdFCa5B6ZXPMgenRSy8W80aXVPn4STX2ltSDhIqB8OpYOjcNcNz58GmD9JNNhby0rLs3pxrRKRPgM7zyDsT92VQairEL7w7YIszyVMSwGSX4GTbZV4n0DJNuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J1tt5ldT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J1tt5ldT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D48C31F000E9;
	Mon, 17 Aug 2026 14:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976717;
	bh=RcicH8LH/o1HXyMmUP+2KTdRQXsNxi4+yqr60HFyf7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J1tt5ldT7IWvULs3h+/H1B/+zrJRHwBeFuIQlR7uoRub6sqZ14hXGjrj+SD39MtAx
	 DNNS98WyQWqjb7iOQ+Sc1eVp3RKvv7jXSHs+0ctq6ulU/06yeX/odQQmnKkrSC0TFm
	 W/ZGsB+m44KJMtevMeMhXGrxYNm0K4zglRqOGv/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 080/456] hwmon: (corsair-cpro) Stop device IO before calling hid_hw_stop
Date: Mon, 17 Aug 2026 15:27:50 +0200
Message-ID: <20260817132543.229291731@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 18da3e013c20b7..62f9372f2d3551 100644
--- a/drivers/hwmon/corsair-cpro.c
+++ b/drivers/hwmon/corsair-cpro.c
@@ -558,6 +558,7 @@ static int ccp_probe(struct hid_device *hdev, const struct hid_device_id *id)
 
 out_hw_close:
 	hid_hw_close(hdev);
+	hid_device_io_stop(hdev);
 out_hw_stop:
 	hid_hw_stop(hdev);
 	return ret;
-- 
2.53.0



