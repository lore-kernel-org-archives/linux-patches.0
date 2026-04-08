Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 252BC2F39C2;
	Wed,  8 Apr 2026 18:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674629; cv=none; b=AF8AH+zE5t6t8/m5+AJ5zaVHQX9PPcQ50gS+NkHWpSRcmDYPI1x7G5hR5Eusp1W5a2wDE1ubWZpCX77EF2ky+5Hoq4ZEe5vfaCW+I43bztVcf4biaV3mgr+7Y4MWhDE3d5HrIBU4nGGzhqwci937X4TVFvdVhA7CUmM1pWu3wAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674629; c=relaxed/simple;
	bh=eQkBce7aDlPN8yKmzw762A8o5zXliHjK9D1Rg3nTMrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FwCSqSGNX/fpNyBKZCNdldKMiNLWQcnfjEesxNsx87jBs5KbH5h5UYRd8ttPs9jRPwUjCi9iPPtnFiqZ3iXaimqiqkjDb+UmBBYQw+qLkQVDU6xPZNRSJ7hsZRPgB/TBss7Ygf/pv+Sodc4ky1N6R8HUHLP2/+vOyEYTL14q9K8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iJn8pmkq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iJn8pmkq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ACC0C19421;
	Wed,  8 Apr 2026 18:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674628;
	bh=eQkBce7aDlPN8yKmzw762A8o5zXliHjK9D1Rg3nTMrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iJn8pmkq9LXyme6T/4jAVjJGJGT8yTfA9Rh1rbhSzTTdzuXuNdSBSjzCZGbq3wMn0
	 LWqSGfULdjqrkTs46QRhHgBd8sBDHy26pz+Hb+NRG96Nj3adm120EMm6flLkwHMyOc
	 RJM3mzmvg10lfEy6KvsKlKgR4XHlF7KS4yKsAN6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Berk Cem Goksel <berkcgoksel@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.19 170/311] ALSA: caiaq: fix stack out-of-bounds read in init_card
Date: Wed,  8 Apr 2026 20:02:50 +0200
Message-ID: <20260408175945.752387522@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
 


