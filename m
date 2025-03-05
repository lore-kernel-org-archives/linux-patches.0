Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 399F2250BFB;
	Wed,  5 Mar 2025 17:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197105; cv=none; b=KrVtxn7g/lArzBHpKv3MonNK5iijTXRd1RwmTeL9fCoVLcq785SvOarCh8YgPBbfksJbWYDGV/r8c3fsgLbybGGZyY44nIzZWzCOPCc0v0LAR40+mE1mAj5Yo3OmCzolcyAP3g2BbKQqzrCDAYBCW6AgDNQiy8KG6uuNFV09CqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197105; c=relaxed/simple;
	bh=iPetLBpR5REr4FdTzFLXMQHyb2VC3yTvBqBrs1wUOSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eBgNlVZK8O0VGTLWfTkUfSzmd6ozBcSbDgUxYep2rxiYgGipgjSD40MVXA8de9n9inAl2kd9qzRUkaRIGWo+VCoCgeQWhscDN31DBDQpgJNDzgZSDk10j/NDOVqg/luXmI13z3xh5SJlfHwWWgS7hNqMTQ5gFMbmmMWfuE8/ZZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CLN1SUff; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CLN1SUff"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B73EC4CEE2;
	Wed,  5 Mar 2025 17:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197103;
	bh=iPetLBpR5REr4FdTzFLXMQHyb2VC3yTvBqBrs1wUOSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CLN1SUffbK0MPKZny5n9IBaapJLxe8a276EmNvjV6U49jna+A5G9Bhndrh655IIS3
	 1UOQOq4iSyEg2/FnN+gsZnxwwBk96q+nrDEk6XPBt30zs7d8qTs+8HpRyeICgLrgJt
	 xsjMAYxm3BRv202y/fKWhW1q1PttRrQbWhKsmyEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jill Donahue <jilliandonahue58@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 041/176] USB: gadget: f_midi: f_midi_complete to call queue_work
Date: Wed,  5 Mar 2025 18:46:50 +0100
Message-ID: <20250305174507.115481827@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 1d8521103b661..dd1cfeeffb671 100644
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



