Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12DAC38DD8;
	Mon, 24 Feb 2025 14:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740409171; cv=none; b=drSu38m5mJn2Sdts8LEn/YONwmDGmAjYQQ8MscEVaxdpEScXp/6eNR8DmEHhLeYZ29BKpXGDAgvKKHq1lZyaC4RpW8eNSmK8JZ3Pu8NYzIrlGsNlC29NN04QyAkeYSiAk0djiSfrfiwGELcfVfiEUk+o0WdylWNUzd/O250UY6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740409171; c=relaxed/simple;
	bh=eO/36/dFk4EBe0xo0hCxzQvACHBFr6w64Z1jAFFpqY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p2K6MOuS0gxElxjBDLisQiLx+NkTE3oMEpC/4Q4mhj70biezjNxcrj6SBO3RgjnmHRgzVPt9IDOAPIEX3kUszVdZsUtnT6DpG4xFIe44m2lRNgNwM4K3VfFfT2mWhNix4B8FH4z0cUIjHnO2aDkJKjcA6YhSOWyAbOwpzEGGe7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2P6wNXtk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2P6wNXtk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 764C5C4CED6;
	Mon, 24 Feb 2025 14:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740409170;
	bh=eO/36/dFk4EBe0xo0hCxzQvACHBFr6w64Z1jAFFpqY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2P6wNXtkSiMon66Ssuu5r7VCCs2ECo1oI0hjboLhBM+M5Q/k++d8r6+520YU5K1OE
	 NcjbNZWo4UtYy6EdF3bHvUkM1MKcm4wxbH0xx414l4hP+Z0/V9O/wEnuloSs/XHbAX
	 TSPjc0V23d4gsa548PRVb5FWn2Q8yKc0dM9O68sg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.13 117/138] ALSA: hda: Add error check for snd_ctl_rename_id() in snd_hda_create_dig_out_ctls()
Date: Mon, 24 Feb 2025 15:35:47 +0100
Message-ID: <20250224142609.073241449@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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


