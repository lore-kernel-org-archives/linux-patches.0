Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F8391E5706;
	Mon, 21 Oct 2024 10:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506519; cv=none; b=tR80BvIZrpNM8A2c46UyB5V4OaAfLS2zmzX4m4/ABACxwFLORHUfLxlXyEITk2V2tas0Jo3IHP8xDgyqHrOGwGQ6v41WCEMn0uF6ceVoJFi9wAyeV1npAFQxAlznKtynlqVmdEaW8AlIlGLMqOd4U1FXahFw/mxFDwLfhHzgnE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506519; c=relaxed/simple;
	bh=iq52OMUi5LoSgqCHz8s1NjaX9/xPkX50ulR7Yg4l36Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jHLq05znlV+Z156AqijXCxZRuT4vgVNHHQgymgnXmR/KWKNCx7KRQgYoPHG7StbVfxYjFkcgPtgLa/e7CV63ZnumXRjtj7Tv1dI6elkz/8PUqAZ8qTThjH1v0CZznxoSu19+XpI58JJSc5kZlEnahzVw1letBs2VRr9ifKDK3gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AzZdeFgH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AzZdeFgH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 743AEC4CEE5;
	Mon, 21 Oct 2024 10:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506518;
	bh=iq52OMUi5LoSgqCHz8s1NjaX9/xPkX50ulR7Yg4l36Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AzZdeFgHaAk3BttOHYDKwXLpbiKRer9U8TSA5BMsk5o+jSHUXcbnquiGuhiqMnT7r
	 Wv+xvYorPU/75daFyGVKeGqOgYdZTJl7M6T073/0cqAuWTnUoPm5lcYGoyC57XKpbg
	 di1o3EFnWPfVa6dBdotPd4CaX2UHd9/w860p6ICk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Jun <zhujun2@cmss.chinamobile.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.11 004/135] ALSA: scarlett2: Add error check after retrieving PEQ filter values
Date: Mon, 21 Oct 2024 12:22:40 +0200
Message-ID: <20241021102259.505644929@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>
References: <20241021102259.324175287@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhu Jun <zhujun2@cmss.chinamobile.com>

commit fd5f14c126a65f27ada3f192b982c6797cc302c7 upstream.

Add error check after retrieving PEQ filter values in
scarlett2_update_filter_values that ensure function returns error if
PEQ filter value retrieval fails.

Fixes: b64678eb4e70 ("ALSA: scarlett2: Add DSP controls")
Signed-off-by: Zhu Jun <zhujun2@cmss.chinamobile.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20241009092305.8570-1-zhujun2@cmss.chinamobile.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/mixer_scarlett2.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/usb/mixer_scarlett2.c b/sound/usb/mixer_scarlett2.c
index 1150cf104985..4cddf84db631 100644
--- a/sound/usb/mixer_scarlett2.c
+++ b/sound/usb/mixer_scarlett2.c
@@ -5613,6 +5613,8 @@ static int scarlett2_update_filter_values(struct usb_mixer_interface *mixer)
 			info->peq_flt_total_count *
 			SCARLETT2_BIQUAD_COEFFS,
 		peq_flt_values);
+	if (err < 0)
+		return err;
 
 	for (i = 0, dst_idx = 0; i < info->dsp_input_count; i++) {
 		src_idx = i *
-- 
2.47.0



