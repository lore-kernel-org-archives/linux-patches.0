Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C2852FE56A;
	Mon, 20 Apr 2026 15:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700718; cv=none; b=qxgp265P17bME0v539pcrVGtpdgH1kehgfRLgPabT4gohLJ69VWzQFAET/UgHr9iWHTCCH3B68grAdHLG9Yg5J6FEIDvn5GflFqaejdriNaaQ5l6/+3LmWPWWWeLuZHJMStdAHERzEWusexS26ywk9bMq/ydt9Z6pZpzRtthmQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700718; c=relaxed/simple;
	bh=CS4Ohuy5IkwBOUCV7+TUZJCTtIoovF2MLYSeX0ST5Zw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EPGm55Yuo2gSox08+x9rkthb4TXc2XLjMaqZwCRB7XHv6aSUBtw7mqeGYSum+VVqAE0/+xHUMQH0Cw5u6B/dMTT3laQArjpYtrmNjv9pISroW05Rn1ZZy1zDB+VCsLNW4ILEL1k35mf3V5v4JMPiv0+iyUhCcWMrw9E7ko0PMFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kgHlCoBC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kgHlCoBC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22EDBC2BCB6;
	Mon, 20 Apr 2026 15:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700718;
	bh=CS4Ohuy5IkwBOUCV7+TUZJCTtIoovF2MLYSeX0ST5Zw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kgHlCoBCmOcI6WIArGtugFhJ4xa1u5ztDI/lPpFldU1/44bSe0hUU7yv8wUuN/sS9
	 n6/iFptBY7T+NTDDXYcXJXjup18Zu0Gv9Awsoqp8W5+5TJgGTsJNZw0rrN3xJ90Hxd
	 gtZ2uGEr23qK+S2maVobb29wybL45mfvID8V5KQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Casey Croy <ccroy@bugzilla.kernel.org>,
	Maximilian Pezzullo <maximilianpezzullo@gmail.com>,
	Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 060/198] HID: amd_sfh: dont log error when device discovery fails with -EOPNOTSUPP
Date: Mon, 20 Apr 2026 17:40:39 +0200
Message-ID: <20260420153937.775155522@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 1d9f955573aa4..4b81cebdc3359 100644
--- a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
@@ -413,7 +413,8 @@ static void sfh_init_work(struct work_struct *work)
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



