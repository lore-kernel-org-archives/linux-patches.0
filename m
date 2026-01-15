Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0DA43C00AA;
	Thu, 15 Jan 2026 17:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499692; cv=none; b=b0IHr93drD6g9zGIcsDlRgZU7Z8NslAyFbH/05YXDOwG4jVa1KjhxWlh30PI9CGZ7lpxKiN/C78VsA9g3ZzaHsldceTOC2LXvFmEmmUW9Dv5UPDag0qyWWZEvTwF/QRakEwmVll9M8kGQu/ym9KnikANYYOvTc/PZ90TJQh1sQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499692; c=relaxed/simple;
	bh=nf18jLEYGqjo9p8SI90o/A0pbQb66QGHekcam4KKLi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jNQe2HSsYPV3ho3RQPhihLTE65ll1eOFqk/vfUYLUC02lJ/oNJfA4gYj5Io8LiRUIw8Ts4MMHeJtn+Cx9Bs6NeHODp78u9ubUwoZmFVTfv11R7dB/0fJZ5XZq1xdzdyoSNGw0MqQ4aL+IuwOpC/hUviNkbF1FMtKHqwnbnUyN9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Il3l4aql; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Il3l4aql"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B07AC116D0;
	Thu, 15 Jan 2026 17:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499692;
	bh=nf18jLEYGqjo9p8SI90o/A0pbQb66QGHekcam4KKLi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Il3l4aqlqbpqmBICbD8ZPyPSpDoO2qrKLPUkPCq1GfKqUcDs0++VL8PQWNU9byJzt
	 0om+UHHcSKqp+vixxA5sEqKgRk1sPSaILOCiY33ebAgKu1fpikOdIgntY4m+uPoIn+
	 UoA3wuko2rZhf7DkfIh9FfxZAX3RMXztq6rP+9pQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Abramov <i.abramov@mt-integration.ru>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.10 317/451] media: adv7842: Avoid possible out-of-bounds array accesses in adv7842_cp_log_status()
Date: Thu, 15 Jan 2026 17:48:38 +0100
Message-ID: <20260115164242.368641079@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2671,6 +2671,7 @@ static int adv7842_cp_log_status(struct
 	/* CP block */
 	struct adv7842_state *state = to_state(sd);
 	struct v4l2_dv_timings timings;
+	int temp;
 	u8 reg_io_0x02 = io_read(sd, 0x02);
 	u8 reg_io_0x21 = io_read(sd, 0x21);
 	u8 reg_rep_0x77 = rep_read(sd, 0x77);
@@ -2793,8 +2794,9 @@ static int adv7842_cp_log_status(struct
 		  (((reg_io_0x02 >> 2) & 0x01) ^ (reg_io_0x02 & 0x01)) ?
 			"(16-235)" : "(0-255)",
 		  (reg_io_0x02 & 0x08) ? "enabled" : "disabled");
+	temp = cp_read(sd, 0xf4) >> 4;
 	v4l2_info(sd, "Color space conversion: %s\n",
-		  csc_coeff_sel_rb[cp_read(sd, 0xf4) >> 4]);
+		  temp < 0 ? "" : csc_coeff_sel_rb[temp]);
 
 	if (!is_digital_input(sd))
 		return 0;
@@ -2824,8 +2826,9 @@ static int adv7842_cp_log_status(struct
 			hdmi_read(sd, 0x5f));
 	v4l2_info(sd, "AV Mute: %s\n",
 			(hdmi_read(sd, 0x04) & 0x40) ? "on" : "off");
+	temp = hdmi_read(sd, 0x0b) >> 6;
 	v4l2_info(sd, "Deep color mode: %s\n",
-			deep_color_mode_txt[hdmi_read(sd, 0x0b) >> 6]);
+			temp < 0 ? "" : deep_color_mode_txt[temp]);
 
 	adv7842_log_infoframes(sd);
 


