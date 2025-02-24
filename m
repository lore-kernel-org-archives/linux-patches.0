Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9580184A35;
	Mon, 24 Feb 2025 14:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408788; cv=none; b=bLDot7hjtkFAYks6K+OJTmvIha2ujmHxcVYbFZC8FUCQmuE1Ner2cYSjzFq72E6XupntoShW8hxX/HbWDRV9cK0d7XQpnLhmmTj7AxfojNxBYAI1Q7ikHhsU93nYbEz03+mHS3iXIvD9iVx0V0IR+TcyFJZ5bfW7yStQVrsmfRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408788; c=relaxed/simple;
	bh=0z6VxbS0mlhuDucpew3hf4h6a9FdWq5R5sUEjELWdro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pFYNPXdQ665WdOEMwyL5Z2SWZLEG0PruJLS29IdaGz8mrkLnh5nPvUY8UduFCv74+QCNwRzbjRToUgx0+OM7297juFyCBuSiMjn4KK/KBQyySqAwT5oYrVTlS4NMfx7NDVCDWwqSQoZb2LAlt96l4HpZEZPMJU/O4NkB2bgo2E4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HTFxWd4P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HTFxWd4P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F4DEC4CED6;
	Mon, 24 Feb 2025 14:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408788;
	bh=0z6VxbS0mlhuDucpew3hf4h6a9FdWq5R5sUEjELWdro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HTFxWd4P5v+tyda+91HlXZG7/iNBGAs/Tpfj3fxWQWYRQ9bo+u6Vgaimgot9Ukvzf
	 JCTHtImSJss58hTx7dCr51vrXhsUMr2BC/uQNjYHUmnWABfXNM5Mn11bTTBTv65xII
	 JYbpW/lsL/cub+Jh5j8F47hfFg0HdEGIVRenUnY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 131/154] ALSA: hda: Add error check for snd_ctl_rename_id() in snd_hda_create_dig_out_ctls()
Date: Mon, 24 Feb 2025 15:35:30 +0100
Message-ID: <20250224142612.176264583@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit 822b7ec657e99b44b874e052d8540d8b54fe8569 upstream.

Check the return value of snd_ctl_rename_id() in
snd_hda_create_dig_out_ctls(). Ensure that failures
are properly handled.

[ Note: the error cannot happen practically because the only error
  condition in snd_ctl_rename_id() is the missing ID, but this is a
  rename, hence it must be present.  But for the code consistency,
  it's safer to have always the proper return check -- tiwai ]

Fixes: 5c219a340850 ("ALSA: hda: Fix kctl->id initialization")
Cc: stable@vger.kernel.org # 6.4+
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20250213074543.1620-1-vulab@iscas.ac.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/hda_codec.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -2470,7 +2470,9 @@ int snd_hda_create_dig_out_ctls(struct h
 				break;
 			id = kctl->id;
 			id.index = spdif_index;
-			snd_ctl_rename_id(codec->card, &kctl->id, &id);
+			err = snd_ctl_rename_id(codec->card, &kctl->id, &id);
+			if (err < 0)
+				return err;
 		}
 		bus->primary_dig_out_type = HDA_PCM_TYPE_HDMI;
 	}


