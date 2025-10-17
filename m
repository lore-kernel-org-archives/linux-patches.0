Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 064AB2F12D2;
	Fri, 17 Oct 2025 15:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713957; cv=none; b=SU1se9LUvvWIyLXj6RVDXxV0cFCabjnBKSg67nJYFL89J6BHAQTdZwVIVJ7+rBoIIDVNjRgfkeVvlvFckoDAazebt4qA52u4gR+j5AVqNwFnbWzd9f4cmNiRpsllb1RfnLHr4UaqET8Tk8nePbpqqBgdWG26xpxZPCtYxj8BeMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713957; c=relaxed/simple;
	bh=HYdtQ/JOG9cRZTJ/ScftzHCtv/uoXtjyL7LHm4DEqmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GMWKY/ai3X2VXgpRXNfwz6BMI39LGE89pVsRJqwwE1Hjejo3WcAan7sg5+mCRl2eGn+/xxqCd3aZqyR+4kYQQME93mavBp9T4wUIBK8CQo7+LIwmF8LBVsqqshhoffgr7bqbaGY1qdpzg5Z4VMYtiIBMgoCAfk04OEwsJ3DIPWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z6bglqga; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z6bglqga"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F40CC4CEE7;
	Fri, 17 Oct 2025 15:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713956;
	bh=HYdtQ/JOG9cRZTJ/ScftzHCtv/uoXtjyL7LHm4DEqmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z6bglqgavR0WMKyRZzsNS7/Dgioz9IfRyR7jYDsuQwillRmyJRR6xU72zuVOIPIHJ
	 6mXOeOkTKdGE7FfNt6gWen1XlS9XmE+Cz1NM18VPUoRxdNG9fBNWRslGvF5GGrDHrt
	 s3lk/0gHRQQMKzvCiysmyMCsRx9emCnxImPM1cxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 178/201] ACPI: battery: allocate driver data through devm_ APIs
Date: Fri, 17 Oct 2025 16:53:59 +0200
Message-ID: <20251017145141.292919823@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit 909dfc60692331e1599d5e28a8f08a611f353aef ]

Simplify the cleanup logic a bit.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Link: https://patch.msgid.link/20240904-acpi-battery-cleanups-v1-2-a3bf74f22d40@weissschuh.net
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 399dbcadc01e ("ACPI: battery: Add synchronization between interface updates")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/battery.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -1203,7 +1203,7 @@ static int acpi_battery_add(struct acpi_
 	if (device->dep_unmet)
 		return -EPROBE_DEFER;
 
-	battery = kzalloc(sizeof(struct acpi_battery), GFP_KERNEL);
+	battery = devm_kzalloc(&device->dev, sizeof(*battery), GFP_KERNEL);
 	if (!battery)
 		return -ENOMEM;
 	battery->device = device;
@@ -1241,7 +1241,6 @@ fail:
 	sysfs_remove_battery(battery);
 	mutex_destroy(&battery->lock);
 	mutex_destroy(&battery->sysfs_lock);
-	kfree(battery);
 
 	return result;
 }
@@ -1264,7 +1263,6 @@ static void acpi_battery_remove(struct a
 
 	mutex_destroy(&battery->lock);
 	mutex_destroy(&battery->sysfs_lock);
-	kfree(battery);
 }
 
 #ifdef CONFIG_PM_SLEEP


