Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B2D8332604;
	Tue, 17 Mar 2026 17:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767111; cv=none; b=eOHG6sk9JDfpCOdECY77hFRzvnk3NcP06XIwwUKLGdNXpiewayIt3K1P5jNpZ5Df+8+AcA7Tc1/hWCLyLhPdWRhmyEhsmOHvU76P+qT//0Sl6/cgtNILjjyD3ELOOgM98m3s18uqykHCWaRAX2Y1skMTXFxN5qG3Qau1po7Ti2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767111; c=relaxed/simple;
	bh=5kh+FszlQ+1jfrJ5cbpyP8646LN5J9+pEEYEmXLylpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YGaGP15h7Q6ebH6JtGd+qck/upod64udT/ghfcX/e0ul0Vyqaw7xPzgZhHHPmRg6qTUCM5cbgMlNzuQCVUZtn+6PTwwcxYySQg/hkY3/6o1j4ukUNKj3RHH/QH21XMPrHYb4vbo5h7qvLHTvbJsMrNIfNVL1Zx71PkymqEIucdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qUK9erKq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qUK9erKq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4989C2BC86;
	Tue, 17 Mar 2026 17:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767111;
	bh=5kh+FszlQ+1jfrJ5cbpyP8646LN5J9+pEEYEmXLylpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qUK9erKqzaJh326Gx1E19WF+EofFJbJTqpDyYX8vsIVFnXzXBYCg07fodV+K+Inj/
	 GclOaTMdq3wXAfQLtOj9t8QxmpSwATUSU+uV6Y7T1wguGGmVY3fP7hNaEmZtk9fDd7
	 NSDvWZ1IpRZIslcR7uYuoQxqqw2Dm/6CI//tfoEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 017/333] ALSA: usb-audio: Check max frame size for implicit feedback mode, too
Date: Tue, 17 Mar 2026 17:30:46 +0100
Message-ID: <20260317162959.999271253@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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
index eff3329d86b7e..77c4330d52953 100644
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -221,6 +221,7 @@ int snd_usb_endpoint_next_packet_size(struct snd_usb_endpoint *ep,
 
 	packet = ctx->packet_size[idx];
 	if (packet) {
+		packet = min(packet, ep->maxframesize);
 		if (avail && packet >= avail)
 			return -EAGAIN;
 		return packet;
-- 
2.51.0



