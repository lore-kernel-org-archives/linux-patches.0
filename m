Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3237D207DFA;
	Fri,  6 Dec 2024 15:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498658; cv=none; b=ZilR9x1knVY9vhIRrEuJKyyPZkK6aKe3KTMZnkoCYTTj6JVQFzU5sgfeldEnhzmZCyz7HuwaZl66MNUhZwt/6xLhUFHVKe4CKsVOrkWlqxOTujU0J65FmnVYipIgbya2oH/FiZ2Po1uZmYjxJpxbjDxeG4M5Dgr/gyZSI04pIoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498658; c=relaxed/simple;
	bh=rADzKthc1PO98oMPjc7MRLui2koB0vFx48M7rGoe0Ng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fDuE1+q1+RFURjGmhxH+eMpWARDTPuTaHBofEYZQWZg/V4ksQPSu5nRrklaKxaS/u2xT9waS1ZlVUzxRoTwkyEwanJ/zyLMo3Vrdl3XzZI7sZMoVuSgbdSlIVcSUS1yuerhwIBZ4KNNq8t94EV7ccxAOzgSRRPFIBSIOD+/ZwPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=feuOy910; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="feuOy910"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BC20C4CED1;
	Fri,  6 Dec 2024 15:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498658;
	bh=rADzKthc1PO98oMPjc7MRLui2koB0vFx48M7rGoe0Ng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=feuOy910C1aLgAvK7tWU1C+YIBeQDCc0wFOTylSCd29kvhXsCROzKFkMP5DWjFjFv
	 52gD9kmGl6EPbTR8QEGIj/aBKvq2+ISvTPFAF+GH/ZsBq7/aDRghga/boCGrQ1NJex
	 AsPJzonDmhiMTPkZQV5UOpK3Z48ekcH8tU+drOrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.6 622/676] media: gspca: ov534-ov772x: Fix off-by-one error in set_frame_rate()
Date: Fri,  6 Dec 2024 15:37:21 +0100
Message-ID: <20241206143717.662822616@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

commit d2842dec577900031826dc44e9bf0c66416d7173 upstream.

In set_frame_rate(), select a rate in rate_0 or rate_1 by checking
sd->frame_rate >= r->fps in a loop, but the loop condition terminates when
the index reaches zero, which fails to check the last elememt in rate_0 or
rate_1.

Check for >= 0 so that the last one in rate_0 or rate_1 is also checked.

Fixes: 189d92af707e ("V4L/DVB (13422): gspca - ov534: ov772x changes from Richard Kaswy.")
Cc: stable@vger.kernel.org
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/gspca/ov534.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/usb/gspca/ov534.c
+++ b/drivers/media/usb/gspca/ov534.c
@@ -847,7 +847,7 @@ static void set_frame_rate(struct gspca_
 		r = rate_1;
 		i = ARRAY_SIZE(rate_1);
 	}
-	while (--i > 0) {
+	while (--i >= 0) {
 		if (sd->frame_rate >= r->fps)
 			break;
 		r++;


