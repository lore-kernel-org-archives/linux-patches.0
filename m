Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 181FD3D522C;
	Wed,  8 Apr 2026 18:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673666; cv=none; b=FZXQFPLCh87j4LUTqCQ2vJol76uC5nw+nWw8mgnjmgp7DRzxpG4S6tDvwwjmIRVqPKyDr2bjyd9A2ffcH2SimXcTJ21iylqNyainrygE4hVLlKMpjBUQnXc78idL0zjotQYUVzvBo955RyzWrvPtmGbCyPVOcXWUi/dKbsXik+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673666; c=relaxed/simple;
	bh=oakTcjRIs3mD+s1WEUSS5jq0bm/pP/ElhZW9kozhZEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kQm19BqGG1nWDd24NftJCKPsm08O9J4Y+u9DaKQJEbBHChPTQkVnmgmB1/ZYIF1egOFUmwOjtZEXcdp+SK+SBIRZl9CYN6DFie2/jXNkxVvyE2/e03qjRtpFKSif+2gPUnlGHFnd9TzupZzimBtdzCdzCmgQRdSADZtv+l+tPes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PKTc269e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PKTc269e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 597A8C19421;
	Wed,  8 Apr 2026 18:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673665;
	bh=oakTcjRIs3mD+s1WEUSS5jq0bm/pP/ElhZW9kozhZEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PKTc269ezwtLIkh2x75Vq36zBB0yCvkmJKkZqhLZJ0pzMZ+w+IXiHUvx6Gfu0rH/z
	 R/IWGgSuYxoG1ibRHIEcmwozgZvAwIRUP5BapyLHIq/rjjmzI5F8a9YlCYg5gx45Is
	 rjLwPvxWKzG8FdvAvp8QI+DJQ87nllXBRWH5Wois=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 035/242] HID: multitouch: Check to ensure report responses match the request
Date: Wed,  8 Apr 2026 20:01:15 +0200
Message-ID: <20260408175928.386742824@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

From: Lee Jones <lee@kernel.org>

[ Upstream commit e716edafedad4952fe3a4a273d2e039a84e8681a ]

It is possible for a malicious (or clumsy) device to respond to a
specific report's feature request using a completely different report
ID.  This can cause confusion in the HID core resulting in nasty
side-effects such as OOB writes.

Add a check to ensure that the report ID in the response, matches the
one that was requested.  If it doesn't, omit reporting the raw event and
return early.

Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-multitouch.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index eb148988484bf..fcf9a806f109a 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -493,12 +493,19 @@ static void mt_get_feature(struct hid_device *hdev, struct hid_report *report)
 		dev_warn(&hdev->dev, "failed to fetch feature %d\n",
 			 report->id);
 	} else {
+		/* The report ID in the request and the response should match */
+		if (report->id != buf[0]) {
+			hid_err(hdev, "Returned feature report did not match the request\n");
+			goto free;
+		}
+
 		ret = hid_report_raw_event(hdev, HID_FEATURE_REPORT, buf,
 					   size, 0);
 		if (ret)
 			dev_warn(&hdev->dev, "failed to report feature\n");
 	}
 
+free:
 	kfree(buf);
 }
 
-- 
2.53.0



