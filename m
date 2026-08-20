Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A33037F8B3;
	Thu, 20 Aug 2026 15:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238823; cv=none; b=pecPxA072EdjtiNgDFB8fEj10cQpKAKjnJ3w3cGgzYQyRVmYpg+8kJSMdcgyAvWCam+zUPHJO46ZQmSKE2ckjkIiNzrIpY42WCiKFw8mhUO+v0vGjqiMP9QjDN97YLLwjghf/CAEE79YCj8ZA4RCEiupcH5a16IJxEQVDTKI7j4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238823; c=relaxed/simple;
	bh=KFzR8fi8VFN5XHc3n7pnGNnqtcSpQ2R+GcV9UqPnCvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ah9g3Dxzuhmn5na6MkAEoGAiDg+dhqm7n4ViUefXMKOe0CKyjkAu+nmZDFeEAgyJ9Fi5XLGVzENnTau0fS7wWNhYynpvXQ/DoppvGuOH8TUyxclxaMUA+zkWA44voqDjwdrgM3CFVqSfK53Ft/p1Aq+KVDe9O6wat7j/gJHwg3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lPow8TvH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lPow8TvH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 662881F00A3A;
	Thu, 20 Aug 2026 15:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238821;
	bh=04/nWy0Unz9vMGHzB2e3AQHjWLbxeVod7D5Z3jkL8Zg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lPow8TvHr4BuzpHdylnAq0vIy/gtmuLCAF4KQV8o70ZIg6hdIM90AvM/un4gMNTeL
	 miMLvv5PxMA3b+m63mTvhTKETraglVc2qFaxmlXcemqzT3ozopClX//Wsmhuc+rGTF
	 ojXFRFXOCMEPUMaP/WoeqS4+pDgUDW6YoYUoutl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Davies <richard@arachsys.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.18 036/217] Input: focaltech - fix array out-of-bounds in focaltech_process_rel_packet
Date: Thu, 20 Aug 2026 16:53:24 +0200
Message-ID: <20260820145238.703784425@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

From: Richard Davies <richard@arachsys.com>

commit 296736076b3fd078742651c719555a488624023a upstream.

Make finger2 (and also finger1) unsigned, so that if the finger index in
the packet is 0 then subtracting 1 creates an array index which overflows
above the existing check for FOC_MAX_FINGERS, as the existing comment says
it should, instead of writing to state->fingers[-1].

Fixes: 05be1d079ec0 ("Input: psmouse - support for the FocalTech PS/2 protocol extensions")
Signed-off-by: Richard Davies <richard@arachsys.com>
Link: https://patch.msgid.link/20260701190932.14960-1-richard@arachsys.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/mouse/focaltech.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/mouse/focaltech.c
+++ b/drivers/input/mouse/focaltech.c
@@ -197,7 +197,7 @@ static void focaltech_process_rel_packet
 {
 	struct focaltech_data *priv = psmouse->private;
 	struct focaltech_hw_state *state = &priv->state;
-	int finger1, finger2;
+	unsigned int finger1, finger2;
 
 	state->pressed = packet[0] >> 7;
 	finger1 = ((packet[0] >> 4) & 0x7) - 1;


