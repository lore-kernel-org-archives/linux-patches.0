Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB2E33C09EB;
	Tue, 12 May 2026 17:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608337; cv=none; b=MOhbEs9tPHbJZU/VDSMeT29mveWyVt+CKZrH+veBcxcM/AK60IqkZMpUkP2EAXw7bPP0cWqgw5Ah/RrkLYMa10Nx06964S3r6GFtyMLRlo1aIblg3v6bPUxQaOM/Xemyovewa0ssdhl/pssjAri/FFMUH0IvhHlAt7CxxV4SqM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608337; c=relaxed/simple;
	bh=HGro0a5lHzTYJlTATbjnpTkNRpfyI/WVvZbUm0878QQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g2zARzyeI6nFNDuVKHM9sNmRMHjIY0dEupHgA6cXRhPxtwxV3JGD6yV+3d8qA/soBWSkmWqeNhUb0MbupzlejZ30n81D3YdI9R02X2bfH3D3FLp0yTEkLGGkBw1VNfmhbqR80uhh+iY3RsEriZQJeKXM+s6Aw9iebdM6j1hT3J0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oHIEBGOQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oHIEBGOQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 425C6C2BCC7;
	Tue, 12 May 2026 17:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608337;
	bh=HGro0a5lHzTYJlTATbjnpTkNRpfyI/WVvZbUm0878QQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oHIEBGOQM8/aySN+rd3l+SvoyktDpuPgoOn6+oc/monvTVbxzfOB+st92UYGK4aWb
	 g61pg/0ISUVY6OmJkx2IFc9wrBQQPDve51Ff+hT3C7kCHSDzOg+1ha5zKMIti3Qt6m
	 dJ22eSmHc4HNt1k7r6mNXSDhx53tNZ9cdT0pmkw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 041/270] ALSA: usb-audio: Avoid potential endless loop in convert_chmap_v3()
Date: Tue, 12 May 2026 19:37:22 +0200
Message-ID: <20260512173939.319090072@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

commit 6e7247d8f5fefeceb0bb9cc80a5388a636b219cd upstream.

The convert_chmap_v3() has a loop with its increment size of
cs_desc->wLength, but we forgot to validate cs_desc->wLength itself,
which may lead to potential endless loop by a malformed descriptor.

Add a proper size check to abort the loop for plugging the hole.

Fixes: ecfd41166b72 ("ALSA: usb-audio: Validate UAC3 cluster segment descriptors")
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20260427152224.15276-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/stream.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/usb/stream.c
+++ b/sound/usb/stream.c
@@ -352,6 +352,8 @@ snd_pcm_chmap_elem *convert_chmap_v3(str
 		if (len < sizeof(*cs_desc))
 			break;
 		cs_len = le16_to_cpu(cs_desc->wLength);
+		if (cs_len < sizeof(*cs_desc))
+			break;
 		if (len < cs_len)
 			break;
 		cs_type = cs_desc->bSegmentType;


