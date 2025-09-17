Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6955330D27;
	Wed, 17 Sep 2025 12:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113914; cv=none; b=pgm7nuupvXxva6gSaBrHb+pGGGEq+cUqt1f1zod8XJxlTYBGl3LEqrAjV8FbCM1TGj+yJ+0Z52KrNejCGLGF6vobSBRvE4JYG0fPFBbOS+hqKehOYlf/nPTeD3RHvtv/074oHNKJ6sWPGJa8A/ExIlhLEqo9QfRgFpBwNtvVoHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113914; c=relaxed/simple;
	bh=8IgLQcWLvdEByU+ALFdAHB1n/9Ej57wkWUJBkQIEH9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VD6yf55wjPfmXrEHmMoDz5UuQjAjmE21X7GbV8fue7tuuOfSaP2LxLpPCrWmjhl2yoKllJXx9eKkftakNhrXNldsWjg0b0+Y+2ojC9rvEy84TJ8wlK1gPMoAow2k+xlrupdo8i4BmjJEDT4gRpUf5j7roV9zuX9C5ac8BpiRoeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wtFErkpi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wtFErkpi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5057AC4CEF0;
	Wed, 17 Sep 2025 12:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113914;
	bh=8IgLQcWLvdEByU+ALFdAHB1n/9Ej57wkWUJBkQIEH9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wtFErkpi2o93c1rGbF8X1ut3FVBnCrnsFX8OuZAJa9NikcRTU04VdiuLO8Z8ttalH
	 zDNzliU2i7dj8P0IEQMfdkgQA5XYKM0pKk7osVmwdom2hdAC6LribVFVA0yAX++Tz7
	 pPizy+4j1LZne8OqNAB2AaG/23np0CoifaIoUu50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 092/101] usb: gadget: midi2: Fix missing UMP group attributes initialization
Date: Wed, 17 Sep 2025 14:35:15 +0200
Message-ID: <20250917123339.065760564@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123336.863698492@linuxfoundation.org>
References: <20250917123336.863698492@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 21d8525d2e061cde034277d518411b02eac764e2 upstream.

The gadget card driver forgot to call snd_ump_update_group_attrs()
after adding FBs, and this leaves the UMP group attributes
uninitialized.  As a result, -ENODEV error is returned at opening a
legacy rawmidi device as an inactive group.

This patch adds the missing call to address the behavior above.

Fixes: 8b645922b223 ("usb: gadget: Add support for USB MIDI 2.0 function driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20250904153932.13589-1-tiwai@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_midi2.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/gadget/function/f_midi2.c
+++ b/drivers/usb/gadget/function/f_midi2.c
@@ -1601,6 +1601,7 @@ static int f_midi2_create_card(struct f_
 			strscpy(fb->info.name, ump_fb_name(b),
 				sizeof(fb->info.name));
 		}
+		snd_ump_update_group_attrs(ump);
 	}
 
 	for (i = 0; i < midi2->num_eps; i++) {


