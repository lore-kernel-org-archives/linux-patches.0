Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A1791EE00E;
	Tue,  3 Dec 2024 16:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242519; cv=none; b=orl6FfGbC5rhK6Z0tVVa2SxOU8w6GBT0mzkW58G6qdicC6KKBZ9em5brwM5BtBAbNs2ETrAr3AcxwVHXb44YDoeU9xOl6VZT0LvnEiadWuG63jrLKlVRzq2vdQNXo8wVf/tFK05R0szyJpWCToDDp/h1RA9+mqMCvJgxzgv+Mm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242519; c=relaxed/simple;
	bh=Mn2dxGaNygUyf+XqaNlzAjyz8AIEymncgyZ7sYBjouc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=avvkUM9fRvxtXJ5k9xcF81pXbAes5l5IDXLmIM7l3XEIYNUYq7agvTwTuDgurUZJtFv3cw2MXZrHYe1eAZkI1xI2Yj/DjSV2/N0gpi8pM9DsaCj8YWtzQ9s2vmY2xsLSXgGBxSLV+zoZRK4X5ZBSCjmKoRjKi9nXcNXPl7X+bEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LeuLEspP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LeuLEspP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D396C4CECF;
	Tue,  3 Dec 2024 16:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242519;
	bh=Mn2dxGaNygUyf+XqaNlzAjyz8AIEymncgyZ7sYBjouc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LeuLEspPj/nCtWPe3Y1ISJGuhyVTMUxPPMZ1ciMaTztVhxZX/5G93481piCb4QaDE
	 UVGU9M/ubPs9OFa47wDyI2wiO2J5WCUyM6skXiiiGe0pLWBam7E4KtCCIIIASetDAj
	 5J0Y9hY2Aq7GRQDwOf79MFoQe3hOPzNknQarrM4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gerecke <jason.gerecke@wacom.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.12 729/826] HID: wacom: Interpret tilt data from Intuos Pro BT as signed values
Date: Tue,  3 Dec 2024 15:47:36 +0100
Message-ID: <20241203144812.198535662@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1353,9 +1353,9 @@ static void wacom_intuos_pro2_bt_pen(str
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


