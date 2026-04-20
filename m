Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F8C2C11C6;
	Mon, 20 Apr 2026 16:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701258; cv=none; b=nHi6/z7qxIzUFMMVAYjj50xfuACljJojKrxXI5gTaJD12aD57RGFPQ0vwsTV2lFiL6pgmpNa+BZtLJpC+fB2Q7biXqj72QEGvDuOaBP6tscYLY0LKh10OXL66Ss4OVQOSKmF7fCJ6sA6z5Dsz3MPQ4eXXaVonUYGo8nhrmVv5AA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701258; c=relaxed/simple;
	bh=TYE6qoXmbvLAyJgan1/ze0atXS4oVoGetdwJigy0Nak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UEPZGyaHM3/+H9+o52blStMJDTIzPvDbdwOG4bal2ICdbKJp/Rg/3vRCQzhPtRsWG+fE7EZGiG4qyegPCMqjDyg2xtu7EFMjwiv92+gtF2BH2cmr2CSk76OIr+gJoiXVZKJ54JDd31YweVML6iVrMMQVxdq2aMNYHhlqnQLWwcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y9N/gvk4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y9N/gvk4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A7EBC19425;
	Mon, 20 Apr 2026 16:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701258;
	bh=TYE6qoXmbvLAyJgan1/ze0atXS4oVoGetdwJigy0Nak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y9N/gvk4SJBD0hdqheDmy6X+hq6RRyOjE1om7Roc5uAz0r1coS+kwA1+utNuj8zFE
	 uo7FK5QGYB9+VZy+410xCdzNhHeuYLyPBcGGUWBc4t4ZeZNqpQyXYwKR0wviBrYuvi
	 HBrS+U+N+tBfoKVdKLwYcSc6FE2DNuBFrDHYvi4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Casey Croy <ccroy@bugzilla.kernel.org>,
	Maximilian Pezzullo <maximilianpezzullo@gmail.com>,
	Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 042/162] HID: amd_sfh: dont log error when device discovery fails with -EOPNOTSUPP
Date: Mon, 20 Apr 2026 17:41:14 +0200
Message-ID: <20260420153928.551957396@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153927.006696811@linuxfoundation.org>
References: <20260420153927.006696811@linuxfoundation.org>
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

From: Maximilian Pezzullo <maximilianpezzullo@gmail.com>

[ Upstream commit 743677a8cb30b09f16a7f167f497c2c927891b5a ]

When sensor discovery fails on systems without AMD SFH sensors, the
code already emits a warning via dev_warn() in amd_sfh_hid_client_init().
The subsequent dev_err() in sfh_init_work() for the same -EOPNOTSUPP
return value is redundant and causes unnecessary alarm.

Suppress the dev_err() for -EOPNOTSUPP to avoid confusing users who
have no AMD SFH sensors.

Fixes: 2105e8e00da4 ("HID: amd_sfh: Improve boot time when SFH is available")
Reported-by: Casey Croy <ccroy@bugzilla.kernel.org>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221099
Signed-off-by: Maximilian Pezzullo <maximilianpezzullo@gmail.com>
Acked-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/amd-sfh-hid/amd_sfh_pcie.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
index 9739f66e925c0..33ba9af1a249f 100644
--- a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
@@ -352,7 +352,8 @@ static void sfh_init_work(struct work_struct *work)
 	rc = amd_sfh_hid_client_init(mp2);
 	if (rc) {
 		amd_sfh_clear_intr(mp2);
-		dev_err(&pdev->dev, "amd_sfh_hid_client_init failed err %d\n", rc);
+		if (rc != -EOPNOTSUPP)
+			dev_err(&pdev->dev, "amd_sfh_hid_client_init failed err %d\n", rc);
 		return;
 	}
 
-- 
2.53.0



