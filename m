Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B3D434E2F;
	Tue, 21 Jul 2026 22:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672147; cv=none; b=rL558WKyZ+UiGY13GZ05ZcPhaPUYJ8+PnPLXNxctx4WXsAm0QHbE4amAnpE7U9YOppDkLy7i3kqcIFC8iCvyKoNeiMDQ/mrYZCIFiR4sV7IzlyUgUKcK6kNSB5WEdNvn/QPHhdRC3bCNkRQ5Ylb50bu1W58KZM3UTCaB8ZbSMiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672147; c=relaxed/simple;
	bh=upPRJorYKHVC0zvQiV+uBp+cXe9cr4LaAt6quujEItk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SQ1KRJsjG/omldJjB9CCf7zx1USGDDoTiGL8n7/gX3zx14y3lLNWhi7K13bjwcLjoCaXa09PawWwJOEO8IkW2z+rLGMdoI/x6NZ3bz2b+Ak2Js7WtQyYsYIE1t6vaZfLiLB0vVmAtEa3ZrlU3bXvsDvJRZkMap2WPOATq3n0Po0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xOipbgOt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xOipbgOt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 745BE1F000E9;
	Tue, 21 Jul 2026 22:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672145;
	bh=+zxQBgd97Yhk0iu3eThhpbZRfgM6U53XStrM4ogm4q0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xOipbgOtcK53LYjETnKJy1qNgbd1lus/NtIArpE+kjg9Mbe8B+0Dk/W8WfIv6gtUu
	 Vk+T80bG3OFqAe0zO+hVOneTmjAeUweJG2Whuj9iY/OXmiqLIcG04IW6ulbQmqMeGQ
	 TYi4zrACJZMfLotcZ/KUbmBDDrMSvX4WXMXbqbXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgiy Osokin <g.osokin@auroraos.dev>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 514/843] HID: picolcd: prevent NULL pointer dereference in picolcd_send_and_wait()
Date: Tue, 21 Jul 2026 17:22:29 +0200
Message-ID: <20260721152417.594900733@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

From: Georgiy Osokin <g.osokin@auroraos.dev>

[ Upstream commit 0021eb09041f021c079be1022934a280f7f176c0 ]

In picolcd_send_and_wait(), an integer overflow of the signed loop counter
'k' can theoretically lead to a NULL pointer dereference of 'raw_data'.
If the loop executes more than INT_MAX times, 'k' becomes negative,
making the condition 'k < size' true even when 'size' is 0.

Change the type of 'k' to 'unsigned int' to prevent the overflow and
eliminate the out-of-bounds access.

Found by Linux Verification Center (linuxtesting.org) with the Svace static
analysis tool.

[jkosina@suse.com: extended hash length]
Fixes: fabdbf2fd22fa17 ("HID: picoLCD: split driver code")
Signed-off-by: Georgiy Osokin <g.osokin@auroraos.dev>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-picolcd_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-picolcd_core.c b/drivers/hid/hid-picolcd_core.c
index bbda231a7ce303..ee0977a8e42e0d 100644
--- a/drivers/hid/hid-picolcd_core.c
+++ b/drivers/hid/hid-picolcd_core.c
@@ -72,7 +72,8 @@ struct picolcd_pending *picolcd_send_and_wait(struct hid_device *hdev,
 	struct picolcd_pending *work;
 	struct hid_report *report = picolcd_out_report(report_id, hdev);
 	unsigned long flags;
-	int i, j, k;
+	int i, j;
+	unsigned int k;
 
 	if (!report || !data)
 		return NULL;
-- 
2.53.0



