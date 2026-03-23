Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B4613BD65D;
	Mon, 23 Mar 2026 16:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282432; cv=none; b=ajx/SaJ7KvlTHsrjq9wjmb5ln11BuoM0kE4tKgRdx2eZDBEAqvL8nliuPS/M/41BRWlL2qh/O4W2esNuY+NNdT1OMTe62l1RJzxD9exsk46AOQTe9ytEjmdIOQdkvOfsr+v0yUzVzlT/4uoUs81+cIQTYnVNaVgPIK5dlJqxWXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282432; c=relaxed/simple;
	bh=1adOG7br39IHaPsiDBrdwcrlEFvkuRzqcHaTlEBggZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hYNsPjDDbuMriwtvW6/QS/f1QKnAKPK5LjMcgm5bgQigKJAQ8ilfs5eqScmHekBHcP7NncMgn/MPG159zfzJdb3+PslOWp8mVDs9XJY9g49Z2cDZtdqMD1W+yJW1ICu/skhk7ZAL/34zN2tZNdKmd2wy0Mt81g85C97qXhFzQS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wem+MtEz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wem+MtEz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47DF0C4CEF7;
	Mon, 23 Mar 2026 16:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282431;
	bh=1adOG7br39IHaPsiDBrdwcrlEFvkuRzqcHaTlEBggZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wem+MtEz7IH1jpGoIAATgIYEohoqnUkZEQd7dyqd+YIBccqPAbhBmqna2Lnl8Absz
	 mpCnUbuodTrBwrzS/132RwN/Gnq1SCRs6Lagak3SPy+rAXI1BT11tXoCTNjb6lB4xB
	 b6lPcnC6xafA9sXoA+bAL9h4zLYJLUgWnpj8+GLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 155/481] ALSA: usb-audio: Check max frame size for implicit feedback mode, too
Date: Mon, 23 Mar 2026 14:42:17 +0100
Message-ID: <20260323134529.016357097@linuxfoundation.org>
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

[ Upstream commit 7cb2a5422f5bbdf1cf32eae0eda41000485b9346 ]

When the packet sizes are taken from the capture stream in the
implicit feedback mode, the sizes might be larger than the upper
boundary defined by the descriptor.  As already done for other
transfer modes, we have to cap the sizes accordingly at sending,
otherwise this would lead to an error in USB core at submission of
URBs.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=221076
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260225085233.316306-3-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/endpoint.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/usb/endpoint.c b/sound/usb/endpoint.c
index b5af8dc1e48de..0f86319f62598 100644
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -224,6 +224,7 @@ int snd_usb_endpoint_next_packet_size(struct snd_usb_endpoint *ep,
 
 	packet = ctx->packet_size[idx];
 	if (packet) {
+		packet = min(packet, ep->maxframesize);
 		if (avail && packet >= avail)
 			return -EAGAIN;
 		return packet;
-- 
2.51.0



