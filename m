Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3652C471252;
	Tue, 21 Jul 2026 19:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660794; cv=none; b=D5jKDpdz1V3xrYeJUk8uoN5/LEGZLd6eDTBktMeerzB9IWui3MNv5zPi/0/DqXLRc9/s4cdeEUxycrYRqIqZdMG0QLUyS/nkzJHF7lZRLMglzHrr5OUpgw/1GXKbikgwpybR+6LniWvQBtMwfmCvy/lBdt5+OL50r1xmGcKc0Hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660794; c=relaxed/simple;
	bh=bDaNfKKE5nBC156D1O2SII15zFr7xHU4AplOPCjfp/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MnYekuNa88kH29m/J9DinRoHmRKoFcCetWX6erSpnr4mLeQLy+4/oB5Js7evnJWqTS4dQab1mzC8BpNrnuH4SX9qaTD+AQwD+K8pfRZD/4y/AvieSXcDkoFDlZJyod0CjQH+5+EUEzF2C5+h/Zta3vwT3RAJKU0Mg5KuzVp0pM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fZUgJy7C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fZUgJy7C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DAD71F000E9;
	Tue, 21 Jul 2026 19:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660793;
	bh=gzYfaHSMuh3Ily74wLm/eITPQ3GI+8qdQuIfDLXlmIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fZUgJy7CxORe55XArolyyeWcdoaqtEg5bEMjWn4CFHVdAYzMFBniwe5uK2RDdim9K
	 TniG/4ogu8NCQIbFrwBVdtLYrbsKOkETO+s9kcYAA/DPh2/bbrGw293YRj76d0SFwM
	 cWDj807IB3Q56gNzK3AVhQ1bGAws/xVOHAZYrr0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1115/2077] ALSA: usb-audio: qcom: reject stream disable with no active interface
Date: Tue, 21 Jul 2026 17:13:08 +0200
Message-ID: <20260721152619.120335864@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

[ Upstream commit bdb640be82e645e2828731648f485224d0c2587b ]

handle_uaudio_stream_req() resolves an interface index with
info_idx_from_ifnum(), which returns -EINVAL when no interface matches.
The enable branch and the response: cleanup label both guard against a
negative index, but the disable branch does not: it forms
info = &uadev[pcm_card_num].info[info_idx] and dereferences it.

uadev[].info is a pointer allocated only when a stream is first enabled,
so a negative info_idx on the disable path is unsafe in two ways:

 - If the card was never enabled, .info is NULL and &info[-EINVAL] is a
   wild pointer; reading info->data_ep_pipe faults (kernel oops).

 - If the card was enabled at least once (.info allocated) and the
   disable names an interface that does not match, &info[-EINVAL] points
   before the allocation; info->data_ep_pipe / info->sync_ep_pipe are an
   out-of-bounds slab read and, when non-zero, an out-of-bounds 4-byte
   write (both pipe fields are cleared to 0). That is memory corruption,
   not just a NULL dereference.

The request is reachable from unprivileged local userspace over
AF_QIPCRTR. Reject a disable request with no resolved interface, matching
the guard the enable path already has.

Fixes: 326bbc348298a ("ALSA: usb-audio: qcom: Introduce QC USB SND offloading support")
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Link: https://patch.msgid.link/20260618025126.1862954-2-michael.bommarito@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/qcom/qc_audio_offload.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/sound/usb/qcom/qc_audio_offload.c b/sound/usb/qcom/qc_audio_offload.c
index ccb5ffd73a66cf..621dca3587f853 100644
--- a/sound/usb/qcom/qc_audio_offload.c
+++ b/sound/usb/qcom/qc_audio_offload.c
@@ -1647,6 +1647,11 @@ static void handle_uaudio_stream_req(struct qmi_handle *handle,
 			subs->opened = 0;
 		}
 	} else {
+		if (info_idx < 0) {
+			ret = -EINVAL;
+			goto response;
+		}
+
 		info = &uadev[pcm_card_num].info[info_idx];
 		if (info->data_ep_pipe) {
 			ep = usb_pipe_endpoint(uadev[pcm_card_num].udev,
-- 
2.53.0



