Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71392523781;
	Wed,  9 Sep 2026 13:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961620; cv=none; b=I25vdnf2IA4aNZmX5N5lBsVg6UgtXHSAdBHOYbyskFLRQJYejEMFXMBGKQVZKSZtj3OZ36KVktKDEvJJKjeptKOePLYydIcnCpkcQ+9KqAq4l91U9jlKz6I2yasKZOk2weZno1oe9bgU0U470X8snxKWz6GYxyCyryOkd6CtWq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961620; c=relaxed/simple;
	bh=1zvxXTdwq8xtUDbGM2F8Llt8al4BQS6FHhYpRjCQwzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DyR5lGMdY4xVPJUqqD/Bhh6OAddDFfoKITfbhcxDJQZoA+8yAb3MpF0O68SDE2g2yD3Tp+G0ajIPld1Zy1GGVhAdzf51y55oVc/P846rLB1S0U83msa37J1bGrfGM2nQPJPnfaGrOCfL9kaXEQ+NB/a3hZPUv/oAVW75WmaEuYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZiR0hf+U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZiR0hf+U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88CE11F00A3A;
	Wed,  9 Sep 2026 13:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961619;
	bh=2VHZSUwRW55zf4Be6vqu9mreFjp3oCYMWNW0cqchWTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZiR0hf+UwsysGtE8juG6LhthelyhurzjzX8/qCQ/GsWZiwfZS8BvQpXtShcai+8Up
	 IaCUfeHDAdPFDLNH8ZXL+hsKVAbfa5lpOoGR8ec79KrIfunnf0JTjSFfY2vd4iiRdc
	 yEeFYgjZf82yBVkNBpWBrcjxh5zE3z3CrldoV8lc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avraham Hollander <anhollander516@gmail.com>,
	Rong Zhang <i@rong.moe>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 012/556] ACPI: battery: Use kstrtoul() over sscanf("%lu\n")
Date: Wed,  9 Sep 2026 15:34:52 +0200
Message-ID: <20260909134230.903751054@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rong Zhang <i@rong.moe>

[ Upstream commit 57346c4d78d38b357dbe9ef16d3f63bf4610c039 ]

It is more preferred to use kstrto*() to parse a single number. The
function family properly returns an errno on error and is the correct
mechanism to parse data from sysfs.

The number base is set to 10 in order not to break the ABI.

Tested-by: Avraham Hollander <anhollander516@gmail.com>
Signed-off-by: Rong Zhang <i@rong.moe>
Link: https://patch.msgid.link/20260718-b4-acpi-battery-notification-v4-2-599c8ed1072f@rong.moe
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 9e409f1dff78 ("ACPI: battery: Protect all properties with a separated mutex")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/battery.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -668,9 +668,13 @@ static ssize_t acpi_battery_alarm_store(
 {
 	unsigned long x;
 	struct acpi_battery *battery = to_acpi_battery(dev_get_drvdata(dev));
+	int err;
 
-	if (sscanf(buf, "%lu\n", &x) == 1)
-		battery->alarm = x/1000;
+	err = kstrtoul(buf, 10, &x);
+	if (err)
+		return err;
+
+	battery->alarm = x / 1000;
 	if (acpi_battery_present(battery))
 		acpi_battery_set_alarm(battery);
 	return count;


