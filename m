Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD900155308;
	Mon, 24 Feb 2025 14:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408381; cv=none; b=f8MKH91dRsAHLJmQy+LtRo0xPsifY5fXF6FdvcHa2xDCktbvk4vn3vKqJu7yOQcunXcAYsqDVKA1GmVvs3Y7wY9weZXzlRBTndFR3BgowpRnYef4PG1cdIiNT2lnofPbQmd7szvRaumfGysrp+Nr0vxSQ1MIHQALYcNKVmANZto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408381; c=relaxed/simple;
	bh=uTNrFEYYsFJBz6cPFM6D63sLMrL2ra9uunpp7SElrCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hjqIAskWOflRfdVcna5ODw/jxcW/FIztt+oBgOktg1aTTA1umnkaJ1DgERMgLGFXaigvhE+R7DcZxnaKQugTlkA49zPg94S+jJxKQKUxRg/dTsaKUw8b0EIURawfhBNS387ITpWPbZwZjKf1fbdHVdQ/aMCAEsyZuB/wjeC0j80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gnIabfC4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gnIabfC4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5260C4CEE8;
	Mon, 24 Feb 2025 14:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408381;
	bh=uTNrFEYYsFJBz6cPFM6D63sLMrL2ra9uunpp7SElrCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gnIabfC4B+SHoM6U/RGyGpUmgKWWDp6JQ/pTF/KPnWYjS8lUWzqL0Cp2MdmsYu2Nd
	 CbJbDqIRRJ1vl3b56VJMfgP83le2Jc16iELYoM3BCYC6D2JVor+fzTGet7RlTe8bS9
	 zGOnnEMNemcROSCOVVajvPU1cJMsZXlQgs7xLylo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jill Donahue <jilliandonahue58@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 041/154] USB: gadget: f_midi: f_midi_complete to call queue_work
Date: Mon, 24 Feb 2025 15:34:00 +0100
Message-ID: <20250224142608.702427836@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 4153643c67dce..1f18f15dba277 100644
--- a/drivers/usb/gadget/function/f_midi.c
+++ b/drivers/usb/gadget/function/f_midi.c
@@ -283,7 +283,7 @@ f_midi_complete(struct usb_ep *ep, struct usb_request *req)
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



