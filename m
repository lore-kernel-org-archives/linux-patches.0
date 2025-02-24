Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B2C423373D;
	Mon, 24 Feb 2025 14:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408070; cv=none; b=Zhr6BtmgIIvDyl/36e7/FMA1V3a3U7oSnCVKoZTrd5jHbslQl6DkVDnxjX2tdvVyPts2R9vAITjDvy864/DUsGzcluOun9CY40H3DMaQIMavE8qDNMwNzQfLgHNlcGO5/O6IrEJEv7otlq3M8tI+EF4syPh0zGGsTqbJ4/rRkqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408070; c=relaxed/simple;
	bh=NVx+bldAiOtVgFwnRI6FvAgbDYH6VCYtV7SCtvJHiW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mMUfoCTi5KoPUJ2l+/J/XIkuPL7jANKDJuSy3fHh+wrWF+/j+ICQtPzmQv6YkxYaarezCKxt+QPiFH/j7visAwEcfo0Q2TJcbM0dPFx+AacwTcAprdCJbok4MtP2TSaDeCMLDOTbJNs7DulZOlDhlcHXv/jsUALs9hT1lnsmWgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wsGfmXaq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wsGfmXaq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD6A7C4CED6;
	Mon, 24 Feb 2025 14:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408070;
	bh=NVx+bldAiOtVgFwnRI6FvAgbDYH6VCYtV7SCtvJHiW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wsGfmXaqKP0a9RMhdgz4woxSt9dEAE/Qas42OMu7UdIM0PwXvkpfDmJRCK94q8FbK
	 2K++tdGgsWFhbJBZzUrihxPMXW/J7PC3cjhtQJJMEmvbD5iIeHg0ObWD4dLh7fH9mf
	 bQyg8jIg/6ku9AkaSU04RFpJ4prhXZ2CWCVLhZ60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jill Donahue <jilliandonahue58@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 064/140] USB: gadget: f_midi: f_midi_complete to call queue_work
Date: Mon, 24 Feb 2025 15:34:23 +0100
Message-ID: <20250224142605.529123307@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
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

From: Jill Donahue <jilliandonahue58@gmail.com>

[ Upstream commit 4ab37fcb42832cdd3e9d5e50653285ca84d6686f ]

When using USB MIDI, a lock is attempted to be acquired twice through a
re-entrant call to f_midi_transmit, causing a deadlock.

Fix it by using queue_work() to schedule the inner f_midi_transmit() via
a high priority work queue from the completion handler.

Link: https://lore.kernel.org/all/CAArt=LjxU0fUZOj06X+5tkeGT+6RbXzpWg1h4t4Fwa_KGVAX6g@mail.gmail.com/
Fixes: d5daf49b58661 ("USB: gadget: midi: add midi function driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Jill Donahue <jilliandonahue58@gmail.com>
Link: https://lore.kernel.org/r/20250211174805.1369265-1-jdonahue@fender.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_midi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/function/f_midi.c b/drivers/usb/gadget/function/f_midi.c
index 49946af11a905..6d91d7d7a23f8 100644
--- a/drivers/usb/gadget/function/f_midi.c
+++ b/drivers/usb/gadget/function/f_midi.c
@@ -282,7 +282,7 @@ f_midi_complete(struct usb_ep *ep, struct usb_request *req)
 			/* Our transmit completed. See if there's more to go.
 			 * f_midi_transmit eats req, don't queue it again. */
 			req->length = 0;
-			f_midi_transmit(midi);
+			queue_work(system_highpri_wq, &midi->work);
 			return;
 		}
 		break;
-- 
2.39.5



