Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0995439890A;
	Mon, 23 Mar 2026 14:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275182; cv=none; b=B/GI0l1dnZ2C554FN9AMIeYByYVSYqKj2w1ByunpiWvRHX4gb6imWzamzPyF5we6QoE6BGq65uMKQjPDaybquWKQLilsTEDLQC1tAWLlTFGCNyagldmjoZNVnQ5m9JoOvx1OgURBu53bG36RJkOyYLuRD9qUj/to6DWQnYagSdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275182; c=relaxed/simple;
	bh=RZwuk4o9SncI1tYyXlQ2f0kkAgdTtbl6Md+u40B4CaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o32iVbiO/34xJu+a2uZYm8+jw6RrjxbRWWTG0V9Swnu2g0NdhbsAqcvrq/VQaSJPlhiHEiaXOOcAfR2WYLxA/8Jy8tr9dJKPVypJ06Po6DNQDxM6/OWZy71afit1gJIoyq1tVJ4lJNqpZ/auD6f3tARhuOdFAWuRWohN2uJkKXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pGkj1Bvy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pGkj1Bvy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84CA1C4CEF7;
	Mon, 23 Mar 2026 14:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275181;
	bh=RZwuk4o9SncI1tYyXlQ2f0kkAgdTtbl6Md+u40B4CaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pGkj1BvyKgzh4DjwtdOhANzy7m/O3xhLpo1F15KpQzO2SfikqcWV4jTPFhk5/xV2u
	 BQnCyIx7fJ7jstLSl1E+55w+yByBuhQFuegRqE5Kz3+MCTQjbjt7JS5g0GtI0sLBE2
	 FMatAXTtPrbgALLmeuHaExxxp0vyoag7maRxyYs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 010/481] ALSA: usb-audio: Cap the packet size pre-calculations
Date: Mon, 23 Mar 2026 14:39:52 +0100
Message-ID: <20260323134525.505618300@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 7fe8dec3f628e9779f1631576f8e693370050348 ]

We calculate the possible packet sizes beforehand for adaptive and
synchronous endpoints, but we didn't take care of the max frame size
for those pre-calculated values.  When a device or a bus limits the
packet size, a high sample rate or a high number of channels may lead
to the packet sizes that are larger than the given limit, which
results in an error from the USB core at submitting URBs.

As a simple workaround, just add the sanity checks of pre-calculated
packet sizes to have the upper boundary of ep->maxframesize.

Fixes: f0bd62b64016 ("ALSA: usb-audio: Improve frames size computation")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=221076
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260225085233.316306-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/endpoint.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/usb/endpoint.c b/sound/usb/endpoint.c
index 86a8624e8781e..8f486c5c938f2 100644
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -1392,6 +1392,9 @@ int snd_usb_endpoint_set_params(struct snd_usb_audio *chip,
 		goto unlock;
 	}
 
+	ep->packsize[0] = min(ep->packsize[0], ep->maxframesize);
+	ep->packsize[1] = min(ep->packsize[1], ep->maxframesize);
+
 	/* calculate the frequency in 16.16 format */
 	ep->freqm = ep->freqn;
 	ep->freqshift = INT_MIN;
-- 
2.51.0



