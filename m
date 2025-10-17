Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71C7F3208;
	Fri, 17 Oct 2025 15:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714831; cv=none; b=Wm7WtN1yZUJCvBljr3av118mRTQ6l5paW+BqaHcN7n/kgplYbK+V3261LhiSLaMS3Sc0jD2IKScn1x8MRghluBx/wXWW4t3KzbVk3iYapMKgyt+4kvAuwDf5Z5GdgVXsF+SK3wToGV7BICfsiaocvaOwMKbhnzXlusw/0jg+T+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714831; c=relaxed/simple;
	bh=GSqKQ/gWSsurPeqpO9Ac8k6ERh0PtJhbY0hQenA6AUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KEWs3E6AfGCOa91c/UEeUQxHTjauIqSb9PDvjrH2rRQAEbLbLCMbF0KGjMw338NAVvQ07pSwG4VTMqezaHYWQM6MdGoqZqkpYMY4VuCVcCtH/AiD79NWxyo7cxH0E3B+gY2Sylu88f6wbQC09K7vY9ICHuksQkID2tvVQ9KCNHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ai7CIZz2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ai7CIZz2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E3CDC4CEE7;
	Fri, 17 Oct 2025 15:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714830;
	bh=GSqKQ/gWSsurPeqpO9Ac8k6ERh0PtJhbY0hQenA6AUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ai7CIZz2jO/h1v2cecNhIK6ApzfCCjkxdk8svynjYHrTk2AZw/nIPN2rQC+4Map5e
	 YeHQSU+Jgbfda1g8UC0XVFY0+D+kqU9a2Hm2aYm7zMVe6aZM1p0vquUJMQKXPyE4UP
	 4VWJi/DRiLwFVMFSln/TkiJm9LifJinYyPtamMP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 248/277] ACPI: battery: allocate driver data through devm_ APIs
Date: Fri, 17 Oct 2025 16:54:15 +0200
Message-ID: <20251017145156.205564131@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1218,7 +1218,7 @@ static int acpi_battery_add(struct acpi_
 	if (device->dep_unmet)
 		return -EPROBE_DEFER;
 
-	battery = kzalloc(sizeof(struct acpi_battery), GFP_KERNEL);
+	battery = devm_kzalloc(&device->dev, sizeof(*battery), GFP_KERNEL);
 	if (!battery)
 		return -ENOMEM;
 	battery->device = device;
@@ -1256,7 +1256,6 @@ fail:
 	sysfs_remove_battery(battery);
 	mutex_destroy(&battery->lock);
 	mutex_destroy(&battery->sysfs_lock);
-	kfree(battery);
 
 	return result;
 }
@@ -1279,7 +1278,6 @@ static void acpi_battery_remove(struct a
 
 	mutex_destroy(&battery->lock);
 	mutex_destroy(&battery->sysfs_lock);
-	kfree(battery);
 }
 
 #ifdef CONFIG_PM_SLEEP


