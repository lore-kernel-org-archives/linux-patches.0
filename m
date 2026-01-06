Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C07F934D4E4;
	Tue,  6 Jan 2026 17:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722217; cv=none; b=g80t4w2TYQ1aMcLfdc7ZqyInBgSZlkPt3ZKbjQVmtCOsvZdC3XaNJEP2riDQPVrqhQ5MbTJh/u7A28HJi3vodX9NyORzMWDf/OLBCLQzciOw6YdpvUIwAFzOG35QIS7yb0KOxuqFHnoJbQkn4GPQxSbnxywW9GQcfUEwNbyX920=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722217; c=relaxed/simple;
	bh=sp85bRDzhYYWzn/l+zVQ/dojH7DZ569LH9GhmnwvWBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A3CJb+dSRP8poibniiNhocL4wcL75uayLUlTuQYeBAkI2e4viEBrVh0tNn/Bxq7GvRYs9u2K6WjwCGsHTSvkNU211sNYdwPEHm1P2/jhbg9n+4wq4/EthxlWMQJayrbUo7i8jDAOrdouw9OWDVSZNDG0Y1HTdFeFVfOVzW/7Z7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TvWWpE+T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TvWWpE+T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F4183C116C6;
	Tue,  6 Jan 2026 17:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722217;
	bh=sp85bRDzhYYWzn/l+zVQ/dojH7DZ569LH9GhmnwvWBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TvWWpE+TVZmz7OwdPUjEADmoNd5wmZk5XAL6HvPXWQcE03704ca50dzTQ/TUwz5Ch
	 iUh/X+xu38g7KwFH3doR0mcTswxw2m4Tcq92MpyMkr5xkWR39DMkQYamH/AurizOE/
	 cyQkqbcL/jadAaDc8RPE6gUL0NEbS8e7K5ewZIGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Abramov <i.abramov@mt-integration.ru>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 165/312] media: adv7842: Avoid possible out-of-bounds array accesses in adv7842_cp_log_status()
Date: Tue,  6 Jan 2026 18:03:59 +0100
Message-ID: <20260106170553.803684814@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

From: Ivan Abramov <i.abramov@mt-integration.ru>

commit 8163419e3e05d71dcfa8fb49c8fdf8d76908fe51 upstream.

It's possible for cp_read() and hdmi_read() to return -EIO. Those
values are further used as indexes for accessing arrays.

Fix that by checking return values where it's needed.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: a89bcd4c6c20 ("[media] adv7842: add new video decoder driver")
Cc: stable@vger.kernel.org
Signed-off-by: Ivan Abramov <i.abramov@mt-integration.ru>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/adv7842.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -2699,6 +2699,7 @@ static int adv7842_cp_log_status(struct
 	/* CP block */
 	struct adv7842_state *state = to_state(sd);
 	struct v4l2_dv_timings timings;
+	int temp;
 	u8 reg_io_0x02 = io_read(sd, 0x02);
 	u8 reg_io_0x21 = io_read(sd, 0x21);
 	u8 reg_rep_0x77 = rep_read(sd, 0x77);
@@ -2821,8 +2822,9 @@ static int adv7842_cp_log_status(struct
 		  (((reg_io_0x02 >> 2) & 0x01) ^ (reg_io_0x02 & 0x01)) ?
 			"(16-235)" : "(0-255)",
 		  (reg_io_0x02 & 0x08) ? "enabled" : "disabled");
+	temp = cp_read(sd, 0xf4) >> 4;
 	v4l2_info(sd, "Color space conversion: %s\n",
-		  csc_coeff_sel_rb[cp_read(sd, 0xf4) >> 4]);
+		  temp < 0 ? "" : csc_coeff_sel_rb[temp]);
 
 	if (!is_digital_input(sd))
 		return 0;
@@ -2852,8 +2854,9 @@ static int adv7842_cp_log_status(struct
 			hdmi_read(sd, 0x5f));
 	v4l2_info(sd, "AV Mute: %s\n",
 			(hdmi_read(sd, 0x04) & 0x40) ? "on" : "off");
+	temp = hdmi_read(sd, 0x0b) >> 6;
 	v4l2_info(sd, "Deep color mode: %s\n",
-			deep_color_mode_txt[hdmi_read(sd, 0x0b) >> 6]);
+			temp < 0 ? "" : deep_color_mode_txt[temp]);
 
 	adv7842_log_infoframes(sd);
 


