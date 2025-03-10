Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D341DE89C;
	Mon, 10 Mar 2025 18:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630764; cv=none; b=IvIhrq1gCCmECmMiK9jWwYlmvz6+6+r6zFtl3dyvM77tcsd7AJwaIA5nWYKTpqX0CHm8nN94KpyxpZt/fNxK/8QeAw5J/bhUNyWxXo8MFF2JdGwEJzKbmnYItiaFTCN65D7qo1/kzE91uiNZ0ctKP97d+XYE63nv13GWnmEq2zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630764; c=relaxed/simple;
	bh=tNO4ecaQZUd97GUOabi62i5gjc8e3wS1TlmmFzkR5CI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GYmPPIyAYETb5dqI/Me/U3wWwT+ajZJk3uYlXVNNmQBmcABlBPrEXogmAu0ugsA8Lh+Q4t4+CtPxy8EohtFsjBTu9Czq602Rq2NHq/6mZ2hmtEyCtoNXK1liiFiyQM3UxQom8lJNUC0/vQ7OrZEStQ1uSJSiyGmbUYsStL6id24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=epeBObHn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="epeBObHn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50555C4CEE5;
	Mon, 10 Mar 2025 18:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630763;
	bh=tNO4ecaQZUd97GUOabi62i5gjc8e3wS1TlmmFzkR5CI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=epeBObHnT8CNea2PLhb3kuXCkLR2kDIncXFTFc5joFpwxSTKnMFGpO94NWcaD/gGs
	 nBwy3c/Ex3sOfRGO4Meb6z159OPyfppbJub1bvZa4SRwMuXT9w6TLIFS3GxRa4q0xM
	 O7hEc5JWW2DtkqiMNt/UczYrpv1H5fwOBvfsdNXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	John Keeping <jkeeping@inmusicbrands.com>
Subject: [PATCH 5.15 494/620] ALSA: usb-audio: Avoid dropping MIDI events at closing multiple ports
Date: Mon, 10 Mar 2025 18:05:40 +0100
Message-ID: <20250310170605.070020512@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit a3bdd8f5c2217e1cb35db02c2eed36ea20fb50f5 ]

We fixed the UAF issue in USB MIDI code by canceling the pending work
at closing each MIDI output device in the commit below.  However, this
assumed that it's the only one that is tied with the endpoint, and it
resulted in unexpected data truncations when multiple devices are
assigned to a single endpoint and opened simultaneously.

For addressing the unexpected MIDI message drops, simply replace
cancel_work_sync() with flush_work().  The drain callback should have
been already invoked before the close callback, hence the port->active
flag must be already cleared.  So this just assures that the pending
work is finished before freeing the resources.

Fixes: 0125de38122f ("ALSA: usb-audio: Cancel pending work at closing a MIDI substream")
Reported-and-tested-by: John Keeping <jkeeping@inmusicbrands.com>
Closes: https://lore.kernel.org/20250217111647.3368132-1-jkeeping@inmusicbrands.com
Link: https://patch.msgid.link/20250218114024.23125-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/midi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/usb/midi.c b/sound/usb/midi.c
index 9a361b202a09d..a56c1a69b422a 100644
--- a/sound/usb/midi.c
+++ b/sound/usb/midi.c
@@ -1145,7 +1145,7 @@ static int snd_usbmidi_output_close(struct snd_rawmidi_substream *substream)
 {
 	struct usbmidi_out_port *port = substream->runtime->private_data;
 
-	cancel_work_sync(&port->ep->work);
+	flush_work(&port->ep->work);
 	return substream_open(substream, 0, 0);
 }
 
-- 
2.39.5



