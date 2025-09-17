Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7231302774;
	Wed, 17 Sep 2025 12:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113136; cv=none; b=Tx69lOSbq6O09Aja9xBQ94WiTno4XDd3wKZFDs58g0kmyRnQIPxXebswrPXuZmeSSLNeQpvNoScYFUbDbBsJ27ueIPKXe8xy52vMcfTc5gJM/Pe6SG3pjiwAhnsetYB00Sb2DgoYUkZ+uJrYPEqdCB4DW6IS24dxobp0FF1z9ZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113136; c=relaxed/simple;
	bh=U0djiQMEdOFdSpkIbY/R/RGWskIzMC0xrCK754oc4N4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QHNxIJfIb9+zEc1cNnRpOIOyaRUsICq7i643UHfTJzP7QLgNNYkQiWVsP9F3BtGuqb9R5B4eqq9E1nNEVWiaXPO+ZjCuN1X27CHg3t/30oyiMd59PomtY+1/0651f4zjHX72dgQbxNiaJIzCz89DgDVLg9UMjpiUn5EtRWRzczc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CGb/TJ0h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CGb/TJ0h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5173DC4CEF0;
	Wed, 17 Sep 2025 12:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113136;
	bh=U0djiQMEdOFdSpkIbY/R/RGWskIzMC0xrCK754oc4N4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CGb/TJ0hlM7KguQTzZP6OxZFHtk8RTVylvNGTJ5LzDg/iHi5ID3ghYdjHHf0hVovx
	 vU01v2ayF2Yo7/PBgi2UwU1dwzKwu+3yv6mpp/FYZ9edYF78629iVuOUMt0F+Mpwj9
	 xn90LP1XxryGHuDaxftraF9sxw3JcFbu3lxnUxSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.16 182/189] usb: gadget: midi2: Fix missing UMP group attributes initialization
Date: Wed, 17 Sep 2025 14:34:52 +0200
Message-ID: <20250917123356.333975157@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 21d8525d2e061cde034277d518411b02eac764e2 upstream.

The gadget card driver forgot to call snd_ump_update_group_attrs()
after adding FBs, and this leaves the UMP group attributes
uninitialized.  As a result, -ENODEV error is returned at opening a
legacy rawmidi device as an inactive group.

This patch adds the missing call to address the behavior above.

Fixes: 8b645922b223 ("usb: gadget: Add support for USB MIDI 2.0 function driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20250904153932.13589-1-tiwai@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_midi2.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/gadget/function/f_midi2.c
+++ b/drivers/usb/gadget/function/f_midi2.c
@@ -1599,6 +1599,7 @@ static int f_midi2_create_card(struct f_
 			strscpy(fb->info.name, ump_fb_name(b),
 				sizeof(fb->info.name));
 		}
+		snd_ump_update_group_attrs(ump);
 	}
 
 	for (i = 0; i < midi2->num_eps; i++) {


