Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88E1930DED3;
	Thu, 27 Nov 2025 14:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255404; cv=none; b=SPAEOdagcNz6bWlz8D0bFzMl7GYingdr6Hp+HH4UzKeWMtbsZFuyfho3jNCsTgeuRIaRQ6OYOflPEgppsubvzUzWh7Gp9OsdNimbY2FaEjp08uaIk16c0izhamDK0mGRpyu5M+B7/ywzrxmzkX9MrZxpNpIoGkdPI1Sc4TXyBIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255404; c=relaxed/simple;
	bh=CXXKUlfUJWPTiISEGGip9ob9MPUR8iAfYVm3xS8yVbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gFquwaHiinXnNgdRIXAC3vnt98QeNroqMg0WhkZbl8PAXnlfWqneYvBjg3UkbPJtGWF99G5zOcaiNvIt14N8Ei77Fd4zHkKIpt9BG/P79izhqLB1o+G5piA1fzT7nhgI3r6YnZQHwhxoOjZT31o33+hbryatCjCd85EWfvftS00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sL8iVyO9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sL8iVyO9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5AD2C4CEF8;
	Thu, 27 Nov 2025 14:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255404;
	bh=CXXKUlfUJWPTiISEGGip9ob9MPUR8iAfYVm3xS8yVbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sL8iVyO9TDCw7JRI1t4jAT7BYYMhCz7uAidKaI0kENTQQIIeMMcyactXuX4FANtc0
	 GrEwvb2qZA//pOHpCK+BKj9gSO9/ipcUkhrsHHE9K6ocRp8yy8EkKLhr/GC7ExlGdC
	 d4Jq4S3fyA2k/lTOkat+AG4v/ggqO0xrizrPPbP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Machek <pavel@denx.de>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 093/112] ALSA: usb-audio: Fix missing unlock at error path of maxpacksize check
Date: Thu, 27 Nov 2025 15:46:35 +0100
Message-ID: <20251127144036.245075625@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144032.705323598@linuxfoundation.org>
References: <20251127144032.705323598@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

The recent backport of the upstream commit 05a1fc5efdd8 ("ALSA:
usb-audio: Fix potential overflow of PCM transfer buffer") on the
older stable kernels like 6.12.y was broken since it doesn't consider
the mutex unlock, where the upstream code manages with guard().
In the older code, we still need an explicit unlock.

This is a fix that corrects the error path, applied only on old stable
trees.

Reported-by: Pavel Machek <pavel@denx.de>
Closes: https://lore.kernel.org/aSWtH0AZH5+aeb+a@duo.ucw.cz
Fixes: 98e9d5e33bda ("ALSA: usb-audio: Fix potential overflow of PCM transfer buffer")
Reviewed-by: Pavel Machek <pavel@denx.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/endpoint.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/usb/endpoint.c b/sound/usb/endpoint.c
index 7238f65cbcfff..aa201e4744bf6 100644
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -1389,7 +1389,8 @@ int snd_usb_endpoint_set_params(struct snd_usb_audio *chip,
 	if (ep->packsize[1] > ep->maxpacksize) {
 		usb_audio_dbg(chip, "Too small maxpacksize %u for rate %u / pps %u\n",
 			      ep->maxpacksize, ep->cur_rate, ep->pps);
-		return -EINVAL;
+		err = -EINVAL;
+		goto unlock;
 	}
 
 	/* calculate the frequency in 16.16 format */
-- 
2.51.0



