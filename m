Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E5E34751B;
	Tue, 16 Jun 2026 19:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636679; cv=none; b=GYQYv5Hb2ypinRfjZQmvIg8xscpvTQVxQfEV1X03jIoVvVU9s6bfwKMScZ12GEGKAPESIeC/Bav7EMdqB3Uy4H0laFyiftK7YLcellk6bUAMwsbuNcUx4dgdMeXr1fsEeQl1OJ0l8lx8GuKKz8n0ag/P4yiM+WZXNMV1rAZQkh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636679; c=relaxed/simple;
	bh=Aih/q2F8SXGZHhuMQ5Cbltt4GGokppseyc8/30WffdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RRs1FT/MQmc9ZmhM9i4fq8J7r+B892SBlj90KIqw0RARWVY0a9PnjPWpgk3gy4Kt3T73CPs2KuQNSe95K47VXCPa/J0ckZo7YhRp3YpOqt8++8of81ZI4vH6PHrUR45Nesv+AhCdmUJzmSR5q1f3l5Rth324f7C7aVpb9FEqkFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ffrc0BNP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ffrc0BNP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 829261F000E9;
	Tue, 16 Jun 2026 19:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636678;
	bh=8V8lytNe0mJmZy2VDnrY0YFC1sCiVM6OCg/Nh5+QNBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ffrc0BNPrEbWVTGVrI+doa0KYvVuD3gTpSipyjvl1Wu0Qy4lSzYQiTict6vAueo5q
	 cDl3ARVYTOcoaN7v70Ok+bwpKyaN4PNBqy6RXaB+mWIehDGQVsBES3y9MZM4Mm/WRy
	 b3uR917jeIc928jnJ9Phpd3dTF06mOzUexNiaAx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 252/342] ACPI: scan: Use acpi_dev_put() in object add error paths
Date: Tue, 16 Jun 2026 20:29:08 +0530
Message-ID: <20260616145059.982440074@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit 9c0acc169ac71535477caedea8315f7041c5f07c ]

After acpi_init_device_object(), the lifetime of struct acpi_device is
managed by the driver core through reference counting.

Both acpi_add_power_resource() and acpi_add_single_object() call
acpi_init_device_object() and then invoke acpi_device_add(). If that
fails, their error paths call the release callback directly instead of
dropping the device reference through acpi_dev_put().

This bypasses the normal device lifetime rules and frees the object
without releasing the reference acquired by device_initialize(), which
may lead to a refcount leak.

The issue was identified by a static analysis tool I developed and
confirmed by manual review.

Fix both error paths by using acpi_dev_put() and let the release
callback handle the final cleanup.

Fixes: 781d737c7466 ("ACPI: Drop power resources driver")
Fixes: 718fb0de8ff88 ("ACPI: fix NULL bug for HID/UID string")
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Link: https://patch.msgid.link/20260413135343.2884481-1-lgs201920130244@gmail.com
Signed-off-by: Rafael J. Wysocki <rjw@rjwysocki.net>
[ preserved 5.10's `return result;` instead of upstream's `return NULL;` since the function returns int ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/power.c |    2 +-
 drivers/acpi/scan.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/acpi/power.c
+++ b/drivers/acpi/power.c
@@ -977,7 +977,7 @@ int acpi_add_power_resource(acpi_handle
 	return 0;
 
  err:
-	acpi_release_power_resource(&device->dev);
+	acpi_dev_put(device);
 	return result;
 }
 
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -1679,7 +1679,7 @@ static int acpi_add_single_object(struct
 
 	result = acpi_device_add(device, acpi_device_release);
 	if (result) {
-		acpi_device_release(&device->dev);
+		acpi_dev_put(device);
 		return result;
 	}
 


