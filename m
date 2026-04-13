Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C0430EF6B;
	Mon, 13 Apr 2026 16:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098141; cv=none; b=aZItf5gaF/YLdR1EbDScxbFl4D6G+a+B8Ud92aS35+OnD1DXgn5pOIBWiBEf1/+FrPtUJFysXKbyjDlfD8uPe4BCCtBxvuXdmtxIeTx14GS/V/aqFRX/LdMNumKP8W6Z7u0gf27zH91nrV19yKmtKO3x+2QNEGs/5g5/RsikVbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098141; c=relaxed/simple;
	bh=AgA9ctiQpqUdRdz16LAKaDStF8aNeNVcr6K2xIN3My0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EhH9sNYbAeKNSsfSWp0P5BNtn8vf01r3BnE02WL9QY7eYZEcK1KKm5frjUVIPoKHf/se36ILY9LNup9zBVQKA8N1S+GxaKP4PsyQI8uDCSiL2zBqo2khrjOBDT6KfoWylRbFGwPA8OQC6x42sPDeM8adCnMRFLCh7BFw5eMd+QI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PnCeGMei; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PnCeGMei"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51683C2BCAF;
	Mon, 13 Apr 2026 16:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098140;
	bh=AgA9ctiQpqUdRdz16LAKaDStF8aNeNVcr6K2xIN3My0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PnCeGMei4eWTRFneaoAvDkuqjLGm4Rcg5OoFf2XpXSTE12HD1LX9Hc2YcyLt6oZu2
	 Xk4lZ9mtJlq/WQtnJU0UxIdRyXGJIgkDr1cizjdnX1ogcAZWyBh4txJC1nxqk5PnM1
	 0J7bCXOpS1mYlzdYGtdq+B89G10JdwYQ7hzk/PV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 402/570] HID: multitouch: Check to ensure report responses match the request
Date: Mon, 13 Apr 2026 17:58:53 +0200
Message-ID: <20260413155845.528734014@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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
index 30769b37aabe7..7a092a2a1bf00 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -472,12 +472,19 @@ static void mt_get_feature(struct hid_device *hdev, struct hid_report *report)
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



