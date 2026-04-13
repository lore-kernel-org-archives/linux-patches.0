Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80C9126B971;
	Mon, 13 Apr 2026 16:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098233; cv=none; b=FBhPfKfSUObHMKFuDiForDg6cceGpkiIb1sDQ55YEfDWnkUBZmbruBy+WKtiqCwG6KpZ063oEOGLgO2cfvyYd6qb8S7vDJFe6JeYunmkUi5x4yxkYPe6kr3j/l1AxjUMOdU3RgN1g1UFnLISSQHvCSFhenIM7vItP7lbXhHUc0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098233; c=relaxed/simple;
	bh=bxQ4RrwIKxtYSt6kiD8pj59FIdRDNKpEv0POt+q0MQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iz2rzUeMZQIQB4nGwM1L1/pKRfLpOdD7VjBRLmRUMfZCXxiNdRKyt4lTVfK8rerqVhGkz/bRLGpAVWpeKWoUUR+1ycnd8pFYPphiJYf8n1aIpdbvcjoFqHvALjkf3Yop82gelALDJpGOWGxwi0R/M13lptG58MxkxkuEmFOskTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fBCNB3Ze; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fBCNB3Ze"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18AA7C2BCAF;
	Mon, 13 Apr 2026 16:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098233;
	bh=bxQ4RrwIKxtYSt6kiD8pj59FIdRDNKpEv0POt+q0MQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fBCNB3ZeH1qbTp7b0ad/hHaBpVplR3KiXwPHL4FRQ/+321Ffjk5QYN4eHoaPDASup
	 D+a0Us+V8eC0LRcCK5hvKiq7uwiXW/HrBl4Ex7NtNmU+NeTSg8cT+8nsUa6OeUXS2u
	 0J069JeCPtJ0IlvCOhUBxiFC1hSeoIFa+S1QWRlg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Berk Cem Goksel <berkcgoksel@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 446/570] ALSA: caiaq: fix stack out-of-bounds read in init_card
Date: Mon, 13 Apr 2026 17:59:37 +0200
Message-ID: <20260413155847.177631035@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Berk Cem Goksel <berkcgoksel@gmail.com>

commit 45424e871abf2a152e247a9cff78359f18dd95c0 upstream.

The loop creates a whitespace-stripped copy of the card shortname
where `len < sizeof(card->id)` is used for the bounds check. Since
sizeof(card->id) is 16 and the local id buffer is also 16 bytes,
writing 16 non-space characters fills the entire buffer,
overwriting the terminating nullbyte.

When this non-null-terminated string is later passed to
snd_card_set_id() -> copy_valid_id_string(), the function scans
forward with `while (*nid && ...)` and reads past the end of the
stack buffer, reading the contents of the stack.

A USB device with a product name containing many non-ASCII, non-space
characters (e.g. multibyte UTF-8) will reliably trigger this as follows:

  BUG: KASAN: stack-out-of-bounds in copy_valid_id_string
       sound/core/init.c:696 [inline]
  BUG: KASAN: stack-out-of-bounds in snd_card_set_id_no_lock+0x698/0x74c
       sound/core/init.c:718

The off-by-one has been present since commit bafeee5b1f8d ("ALSA:
snd_usb_caiaq: give better shortname") from June 2009 (v2.6.31-rc1),
which first introduced this whitespace-stripping loop. The original
code never accounted for the null terminator when bounding the copy.

Fix this by changing the loop bound to `sizeof(card->id) - 1`,
ensuring at least one byte remains as the null terminator.

Fixes: bafeee5b1f8d ("ALSA: snd_usb_caiaq: give better shortname")
Cc: stable@vger.kernel.org
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Reported-by: Berk Cem Goksel <berkcgoksel@gmail.com>
Signed-off-by: Berk Cem Goksel <berkcgoksel@gmail.com>
Link: https://patch.msgid.link/20260329133825.581585-1-berkcgoksel@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/caiaq/device.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/usb/caiaq/device.c
+++ b/sound/usb/caiaq/device.c
@@ -488,7 +488,7 @@ static int init_card(struct snd_usb_caia
 		memset(id, 0, sizeof(id));
 
 		for (c = card->shortname, len = 0;
-			*c && len < sizeof(card->id); c++)
+			*c && len < sizeof(card->id) - 1; c++)
 			if (*c != ' ')
 				id[len++] = *c;
 


