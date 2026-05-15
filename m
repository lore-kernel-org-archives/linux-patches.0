Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 355833FBB7D;
	Fri, 15 May 2026 16:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861099; cv=none; b=poDSV0P6wLz9fYuxAOmgjyekgjD9M4J5t/DltPX294sweDJfsBHBcF5XHCYwH75H/sa3H5jhUM3NnKqZYwRCZsxMlEIcxYQmeRmovjDL4DW2WBqnfIONvd0z58r+XnetxwbBIgAJdHD1Tn65Xcf4gGdJatHTV4lmsHGYyzyD/P0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861099; c=relaxed/simple;
	bh=Zk0tIE052poxCKUuocgJI1opceIbOuvkf8WoYZTxFdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Losc83Xfkdyw8nU7MJ5l9Wq2Vuqgg3CmYMbmp1UrblhmiC69UpF+VSri6TyXBEyRE0/OobMDm7QBHtmqgfymdhJTiJtb1zYIdZeSDsDE6bn6o7yhy+C8FqRi6qtzOAzyKiCPNJ2ay7CLR2z+1VunjGpb1h+JMtByLtTV51YYvIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QoDVk52+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QoDVk52+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86072C2BCB0;
	Fri, 15 May 2026 16:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861098;
	bh=Zk0tIE052poxCKUuocgJI1opceIbOuvkf8WoYZTxFdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QoDVk52+RnkC6KvMRjPv5hcKQP93CxACqIsXCNbOGRthqdVMwRd9hs7s2meOO4uGh
	 4cssao1kyqvVDGHBYRhfZEWO6+WIjEcrJ61a7dd7gLa2nhgAF/oxVFBYk1K5DjgZ+M
	 OLJK/cgTgVdcCQWLb48HJSXdDLJldg7sNPhZ9sYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 196/474] ALSA: usb-audio: Avoid potential endless loop in convert_chmap_v3()
Date: Fri, 15 May 2026 17:45:05 +0200
Message-ID: <20260515154719.260916401@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


