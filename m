Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C99403DEAD3;
	Mon,  4 May 2026 14:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904800; cv=none; b=uB+/W5SvT3JTqNR8Wnf3WsOORBIJSxBi7xmO82R5W/PvlyWN8Igw8hDMOob1UexwwP1LAlGVkHTSoQp7JKrZ8CwqOADHOBSyxEAwTyHfNKD0zFG8mOO5E88a5yshoRlg7bwAynV2xSg69nLRt6Jv1tA/ZOfODDlmZozBFvqEg1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904800; c=relaxed/simple;
	bh=njH3KqaUP683uzXrU0WJnd5/sfsKPk5I7/6roHGMaRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F+mXeVJ/4cBFotn+UAq/wNwDgCywrZLIo+OcFfCiamDRkWJVUxzMoldJcVh9m2U6WRdb/SgrUzyvVKcBvhA75Dkp2FDlz41bGrO30dvtHHrwrYDHwqKKo4eMMcIVED3aI3GV657qrqP4iuLk2eFmDlFBqlvEfIIqopLSuJ1/ojg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zcj0VPiN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zcj0VPiN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5741DC2BCB8;
	Mon,  4 May 2026 14:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904800;
	bh=njH3KqaUP683uzXrU0WJnd5/sfsKPk5I7/6roHGMaRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zcj0VPiNsyQlYIZLwhdClVkODTsRFbv94xGMXFVYUMfUwCtIWeOo6dkOG0ciwwtUo
	 0j740lNvdxRPVdKdeMifSlhqNQ9Lq+t+16D58fqG4rdY4bpycqhsaT/SFToR6cvPLp
	 DKnCCHP0k9R82Gyhm4UOdgaSdJeZ9a+y4eUaGZls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 180/215] thermal: core: Fix thermal zone governor cleanup issues
Date: Mon,  4 May 2026 15:53:19 +0200
Message-ID: <20260504135136.787528202@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

[ Upstream commit 41ff66baf81c6541f4f985dd7eac4494d03d9440 ]

If thermal_zone_device_register_with_trips() fails after adding
a thermal governor to the thermal zone being registered, the
governor is not removed from it as appropriate which may lead to
a memory leak.

In turn, thermal_zone_device_unregister() calls thermal_set_governor()
without acquiring the thermal zone lock beforehand which may race with
a governor update via sysfs and may lead to a use-after-free in that
case.

Address these issues by adding two thermal_set_governor() calls, one to
thermal_release() to remove the governor from the given thermal zone,
and one to the thermal zone registration error path to cover failures
preceding the thermal zone device registration.

Fixes: e33df1d2f3a0 ("thermal: let governors have private data for each thermal zone")
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/5092923.31r3eYUQgx@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/thermal_core.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -917,6 +917,7 @@ static void thermal_release(struct devic
 		     sizeof("thermal_zone") - 1)) {
 		tz = to_thermal_zone(dev);
 		thermal_zone_destroy_device_groups(tz);
+		thermal_set_governor(tz, NULL);
 		mutex_destroy(&tz->lock);
 		complete(&tz->removal);
 	} else if (!strncmp(dev_name(dev), "cooling_device",
@@ -1483,8 +1484,10 @@ thermal_zone_device_register_with_trips(
 	/* sys I/F */
 	/* Add nodes that are always present via .groups */
 	result = thermal_zone_create_device_groups(tz);
-	if (result)
+	if (result) {
+		thermal_set_governor(tz, NULL);
 		goto remove_id;
+	}
 
 	/* A new thermal zone needs to be updated anyway. */
 	atomic_set(&tz->need_update, 1);
@@ -1630,8 +1633,6 @@ void thermal_zone_device_unregister(stru
 
 	cancel_delayed_work_sync(&tz->poll_queue);
 
-	thermal_set_governor(tz, NULL);
-
 	thermal_remove_hwmon_sysfs(tz);
 	ida_free(&thermal_tz_ida, tz->id);
 	ida_destroy(&tz->ida);


