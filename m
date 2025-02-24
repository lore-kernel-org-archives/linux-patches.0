Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21427155308;
	Mon, 24 Feb 2025 14:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408167; cv=none; b=MonaQU4hfCM23Lk+CQc064AwcAqmupr5Euxv+FdUK02iGO3YBOdMRJGnZq8OirlwoqM4gPsO35qn5MA1whv7LMERWaslVooZDC685/MLF7vRmm5pPOmus4RU0YsLQNhb2uWYNfskmoYzA6PcqR1q+8D+0zLyD00anwVuRMpjUco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408167; c=relaxed/simple;
	bh=LKkzmXCqXaOHvTGoa2wHHl/62stn6ZZkzYmoyA23Y/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kge3OQho/9wdS1Sha8jQhVZB8TIiRk5xoVHi5cPXq4lb2OBfjT0KmSoio/B40aMbRsq5cMVZtrPYn28KDyuzjYKgIAxQL8NaOd5PHG1FqC7AEDJqXH9MjyK5+sAZKYINVVz+9T8fYUtuSiD3a995vQiNUcm0PKS09eZhgX+hsD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gys84mgS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gys84mgS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 842BAC4CED6;
	Mon, 24 Feb 2025 14:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408167;
	bh=LKkzmXCqXaOHvTGoa2wHHl/62stn6ZZkzYmoyA23Y/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gys84mgS8x8oBf59hMPjGbaC90DaEN/scWC4cJMc2HXHrvDuHOFV2655FMNv71Cjm
	 LFJAicPO/s3exhz48rIFuhmG6cs1Q95s3mFnqKdhC/Kmd2ArKhGQ+Q+AAJJiPMuQec
	 dElLSjCy6V5LyYNRc9EOjxRMbIaK0UHBIGzTwBMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 119/140] ALSA: hda: Add error check for snd_ctl_rename_id() in snd_hda_create_dig_out_ctls()
Date: Mon, 24 Feb 2025 15:35:18 +0100
Message-ID: <20250224142607.693361759@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2463,7 +2463,9 @@ int snd_hda_create_dig_out_ctls(struct h
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


