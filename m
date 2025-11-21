Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC8D03396E5;
	Fri, 21 Nov 2025 13:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731494; cv=none; b=G6aSxJYsnvK6+7Pw19+YedUZ4Yq/xYFfXhAOukTBKQZUUJwRA93td+X3E9cCgXYRqKandpTdpS0FNRdYd77rPZVQm9ZPJEwnGdGdsioZTW+4sPN3P96oz//XVj/VaoeCwO4YOiB1K7U4T8VODLIIVuVuwpLrGLwMCkZpTz/V9cI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731494; c=relaxed/simple;
	bh=WLm56B2LvgXRijHQnap7bpzSXv+WenEj36b9/DEbQbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ES2i3FqYWPGEsIAwZXN+tR/yMyVT1wVJmi1rq+EN1Nkx33rHKSNzDfcmj3pFRVNwpMYGdVFDaQ6MHT/Rx2r9M3OvQ7rq7XZzx5ZL6/llk8mUebmJm7gmXDz7jMQhp2kHA+QXwPKTy5UTlKO1/Rz/DKgF2NdOikbjgPDngu675Nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ti5s3wZH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ti5s3wZH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02E9BC4CEF1;
	Fri, 21 Nov 2025 13:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731494;
	bh=WLm56B2LvgXRijHQnap7bpzSXv+WenEj36b9/DEbQbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ti5s3wZHLEB1caG/KIKzx/1ttbjwO0PJJVj2x++p2Tol7KxytgCOKDRmX8cyANNlQ
	 GVfoc+gc5apN0zhIpc6pUr1WO+WuUNyuIZw+coFnFlMG7/cdon+/lpYWwq0ocUlBVf
	 /1O3xRVfcw5J4Z/QU373wZS9m9NiyRx5e1tQuKrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.17 193/247] ALSA: hda/hdmi: Fix breakage at probing nvhdmi-mcp driver
Date: Fri, 21 Nov 2025 14:12:20 +0100
Message-ID: <20251121130201.650261037@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 82420bd4e17bdaba8453fbf9e10c58c9ed0c9727 upstream.

After restructuring and splitting the HDMI codec driver code, each
HDMI codec driver contains the own build_controls and build_pcms ops.
A copy-n-paste error put the wrong entries for nvhdmi-mcp driver; both
build_controls and build_pcms are swapped.  Unfortunately both
callbacks have the very same form, and the compiler didn't complain
it, either.  This resulted in a NULL dereference because the PCM
instance hasn't been initialized at calling the build_controls
callback.

Fix it by passing the proper entries.

Fixes: ad781b550f9a ("ALSA: hda/hdmi: Rewrite to new probe method")
Cc: <stable@vger.kernel.org>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=220743
Link: https://patch.msgid.link/20251106104647.25805-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/codecs/hdmi/nvhdmi-mcp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/hda/codecs/hdmi/nvhdmi-mcp.c
+++ b/sound/hda/codecs/hdmi/nvhdmi-mcp.c
@@ -351,8 +351,8 @@ static int nvhdmi_mcp_probe(struct hda_c
 static const struct hda_codec_ops nvhdmi_mcp_codec_ops = {
 	.probe = nvhdmi_mcp_probe,
 	.remove = snd_hda_hdmi_simple_remove,
-	.build_controls = nvhdmi_mcp_build_pcms,
-	.build_pcms = nvhdmi_mcp_build_controls,
+	.build_pcms = nvhdmi_mcp_build_pcms,
+	.build_controls = nvhdmi_mcp_build_controls,
 	.init = nvhdmi_mcp_init,
 	.unsol_event = snd_hda_hdmi_simple_unsol_event,
 };


