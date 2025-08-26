Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD74352FDB;
	Tue, 26 Aug 2025 14:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219380; cv=none; b=IgV2IPkmy8NAkh/CQ4hK3QhxaO+HAezYlLXtya3yUVkH8+RXVaTX/OcpEwDxRSgShcclG8/k/x2HJkBaDu6ynBeYyX7ZhAzz545SJT1/Up/oL/uH5c/wgSw70Z86Ws7/q7JjaDXh5pPKIVJ4jgbpdNZ+PIz54qQPf7pqxgvNFmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219380; c=relaxed/simple;
	bh=13qFPfiizwk9UdmEXZR9Vg1zhh8J3tnEbu2ngnKDNSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DBchz/KI4rUIO+Xe0Ap9MLt0FRrk0Yp5HGDQmX8VyyVVcMPweeayr1inNqHbzQNrwlOQyphTSwkSaL23OVR+mL0qHV5vO0RLUyA2Vs8NeteiHFxmgsBCsVSzO0Hfk94nrJ16q7CvaiA7upVbMZYxXX8YtbM9/64LBIuazEr/TJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0rndpkoB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0rndpkoB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9D0FC4CEF1;
	Tue, 26 Aug 2025 14:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219380;
	bh=13qFPfiizwk9UdmEXZR9Vg1zhh8J3tnEbu2ngnKDNSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0rndpkoBe1A+Ck3O1+uAL+siJBfA+uVQtehwJdVvY0aGWdoJV7YZollUlx1RJEER+
	 eHdhvXY5moB6W9M7xp9ABp7LpS21tRy/CyEQqDJpXsufaeJHr9gw9WfVRkgyxnQXjq
	 3belR6KTdpOI+b1D4gwc6jbkr1cNz8jLpjopP3Xw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 352/403] USB: cdc-acm: do not log successful probe on later errors
Date: Tue, 26 Aug 2025 13:11:18 +0200
Message-ID: <20250826110916.601147813@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 79579411826647fd573dbe301c4d933bc90e4be7 ]

Do not log the successful-probe message until the tty device has been
registered.

Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20210322155318.9837-9-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 64690a90cd7c ("cdc-acm: fix race between initial clearing halt and open")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-acm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1520,8 +1520,6 @@ skip_countries:
 	acm->nb_index = 0;
 	acm->nb_size = 0;
 
-	dev_info(&intf->dev, "ttyACM%d: USB ACM device\n", minor);
-
 	acm->line.dwDTERate = cpu_to_le32(9600);
 	acm->line.bDataBits = 8;
 	acm_set_line(acm, &acm->line);
@@ -1541,6 +1539,8 @@ skip_countries:
 		usb_clear_halt(usb_dev, acm->out);
 	}
 
+	dev_info(&intf->dev, "ttyACM%d: USB ACM device\n", minor);
+
 	return 0;
 alloc_fail6:
 	if (!acm->combined_interfaces) {


