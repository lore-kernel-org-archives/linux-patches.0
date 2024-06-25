Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C8901465A8;
	Tue, 25 Jun 2024 09:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308833; cv=none; b=ogHqE1v8Ui1zVWQKf6N7fCV85FYD1dotHHE6v8G1mps/BsQIAv11sKQug3XrlFHfMxXMibWB7C4R9d+Q34aHgqhmBixhVii9MBNM3WvtyoFrDz+ihI5GQMv5QOhPROEha0TGN6cs8WAJ92wx3f+/hOde3pK8aCVbOFw3syhSjrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308833; c=relaxed/simple;
	bh=1paC+FbiDd/UV6er4lkDCrLJgJ09P7nnT0QZKILwxrY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lHv+5ezYCg/hAabm37NsX92sjz8BAb+8/LS0z/4NiN3fVwu5fpyt1ms58GyNN93vqfAEcMMdikuld7n9eWiNmkPVHQfZNqFz7n9PekwKdxnW48WNDrEYxmCuA2c7IJw1P6T1aaY8fetzh2LpOY1pce3TpqlHr4k6I0ViuQ3kfDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IHIFDOUg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IHIFDOUg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3C47C32781;
	Tue, 25 Jun 2024 09:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308833;
	bh=1paC+FbiDd/UV6er4lkDCrLJgJ09P7nnT0QZKILwxrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IHIFDOUgJEJI1oJWvf6PqAPPH/WJIPdwn/EYy0rustbi0uMp9dsLdaCA7jhu5hCdR
	 fu7nrHzQoF/f3WpYH9GYS6KY4RjKpssEYldT0lS6ksFKQ0zF4TPcIUw3DnZLER5q/G
	 nj3pRtviyXVjgZ03+PGuNTz1i0l6itGdl1hXrj+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	fhortner@yahoo.de,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.9 236/250] thermal: core: Change PM notifier priority to the minimum
Date: Tue, 25 Jun 2024 11:33:14 +0200
Message-ID: <20240625085557.113050590@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 494c7d055081da066424706b28faa9a4c719d852 upstream.

It is reported that commit 5a5efdaffda5 ("thermal: core: Resume thermal
zones asynchronously") causes battery data in sysfs on Thinkpad P1 Gen2
to become invalid after a resume from S3 (and it is necessary to reboot
the machine to restore correct battery data).  Some investigation into
the problem indicated that it happened because, after the commit in
question, the ACPI battery PM notifier ran in parallel with
thermal_zone_device_resume() for one of the thermal zones which
apparently confused the platform firmware on the affected system.

While the exact reason for the firmware confusion remains unclear, it
is arguably not particularly relevant, and the expected behavior of the
affected system can be restored by making the thermal PM notifier run
at the lowest priority which avoids interference between work items
spawned by it and the other PM notifiers (that will run before those
work items now).

Fixes: 5a5efdaffda5 ("thermal: core: Resume thermal zones asynchronously")
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218881
Reported-by: fhortner@yahoo.de
Tested-by: fhortner@yahoo.de
Cc: 6.8+ <stable@vger.kernel.org> # 6.8+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/thermal_core.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -1633,6 +1633,12 @@ static int thermal_pm_notify(struct noti
 
 static struct notifier_block thermal_pm_nb = {
 	.notifier_call = thermal_pm_notify,
+	/*
+	 * Run at the lowest priority to avoid interference between the thermal
+	 * zone resume work items spawned by thermal_pm_notify() and the other
+	 * PM notifiers.
+	 */
+	.priority = INT_MIN,
 };
 
 static int __init thermal_init(void)


