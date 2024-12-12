Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C462288CB;
	Thu, 12 Dec 2024 17:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022804; cv=none; b=KQAogU4r9Izy+8InOKpECQUwnr76Cemp+GTFaXIUWCMZy7O1D7VZK6yxmyB2yTayofRkM9k+4ID5cKbvQfE1tIJ2M6MkBhcM71h8pGkQ+uSsyOFhVSmZI2ZQUQXdcvNKtRfg8oT2hwZUrcaueYBtFuCT9364RmOguu1wHndif1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022804; c=relaxed/simple;
	bh=48jXB4LhZlHkLD993/Qf5AGCtfa0mGuZPFn/W6XExRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AOC33KomuF+L+2+7/3a6b1Kkl51nZu2f4lDRtI14dtrN7BAbE5umsEx28eqwxfzIqhDkuUhqZhbDHtZvYcDdbUN9SRKCEj8Se9udwu3NjfBvsCg+NvsVgEUw8zj4mutZ3BBBP7fWvBs5zOw2UkSkrlAWqOHBQX/Z5Gtx0/CvL/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bTGCAyTd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bTGCAyTd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC32BC4CECE;
	Thu, 12 Dec 2024 17:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022803;
	bh=48jXB4LhZlHkLD993/Qf5AGCtfa0mGuZPFn/W6XExRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bTGCAyTdd6sNnYITq/r3QMOcR+q+KcPxOUfaf42nOwqFKiXG5n4UDryAwpoJcaf+d
	 0v+ghyjd/oSZRaC0wdEvEbkIxbUaeRXRhXXhcL6pqtfZlf/ELsUyi2bGFI7ylTLfQQ
	 DTQWN69YfKPLia0+Atx6DyXwnFkTU/5b7TPm2euk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gerecke <jason.gerecke@wacom.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 5.15 339/565] HID: wacom: Interpret tilt data from Intuos Pro BT as signed values
Date: Thu, 12 Dec 2024 15:58:54 +0100
Message-ID: <20241212144324.995477673@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gerecke <jason.gerecke@wacom.com>

commit 49a397ad24ee5e2c53a59dada2780d7e71bd3f77 upstream.

The tilt data contained in the Bluetooth packets of an Intuos Pro are
supposed to be interpreted as signed values. Simply casting the values
to type `char` is not guaranteed to work since it is implementation-
defined whether it is signed or unsigned. At least one user has noticed
the data being reported incorrectly on their system. To ensure that the
data is interpreted properly, we specifically cast to `signed char`
instead.

Link: https://github.com/linuxwacom/input-wacom/issues/445
Fixes: 4922cd26f03c ("HID: wacom: Support 2nd-gen Intuos Pro's Bluetooth classic interface")
CC: stable@vger.kernel.org # 4.11+
Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/wacom_wac.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -1401,9 +1401,9 @@ static void wacom_intuos_pro2_bt_pen(str
 					rotation -= 1800;
 
 				input_report_abs(pen_input, ABS_TILT_X,
-						 (char)frame[7]);
+						 (signed char)frame[7]);
 				input_report_abs(pen_input, ABS_TILT_Y,
-						 (char)frame[8]);
+						 (signed char)frame[8]);
 				input_report_abs(pen_input, ABS_Z, rotation);
 				input_report_abs(pen_input, ABS_WHEEL,
 						 get_unaligned_le16(&frame[11]));


