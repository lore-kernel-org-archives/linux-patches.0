Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B85A52581;
	Tue, 23 Jan 2024 00:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969613; cv=none; b=Yauv3PX2C2hAz+l7p9CvpdLQ1A4XYw/gOOoRxnltGq332CWvEsigt+gUw5EEZ1aW+BfMEQs01LRlFunUPu+18qHmpdzbdH7IczS4BTzGhWt0cMPcCJUXZEUte/AePNuQYF7z+KqOXNtKj551tOczUfiUdoIi0KgSla9WpR5OJNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969613; c=relaxed/simple;
	bh=nn+iJnfPmuifaVa3I8sT0y1W/Cm+HF/1ME0qrcg/PcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t6zs9eSJKAbJ374HkOMToy/4ROsBbv5rDWpW8AOPJHP5iWVi/gAFXsyriw7RH3OoefTN8X65jO57YcX1w9LM+gDGzVOdLFQqN4c+BWjOBjaP6IHZtdrTHW14Ym6XuqJc9tsimXgLIX2GaznhzQ6CKgTYTux1KWIptxwOCEuOkwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NFKmj0rC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NFKmj0rC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 767E0C43390;
	Tue, 23 Jan 2024 00:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969613;
	bh=nn+iJnfPmuifaVa3I8sT0y1W/Cm+HF/1ME0qrcg/PcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NFKmj0rC8XKId6rYmPaQJZPB5ujF6oGwb5RsYizv3rvlSZR6SQ9CG/Ioj8TH3PUp7
	 dfigcbG2BBCY/HEdGnozNZ/kPdnuHMASDZOOUoF2YZcHpVyWFDDARtbHSRXuV/KKM7
	 9z7LyovuHHff8jjfBB+Y2VQ6ED4BEp8bHP8+t7UQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Geoffrey D. Bennett" <g@b4.vu>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 359/641] ALSA: scarlett2: Add missing error check to scarlett2_usb_set_config()
Date: Mon, 22 Jan 2024 15:54:23 -0800
Message-ID: <20240122235829.170974838@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geoffrey D. Bennett <g@b4.vu>

[ Upstream commit ca459dfa7d4ed9098fcf13e410963be6ae9b6bf3 ]

scarlett2_usb_set_config() calls scarlett2_usb_get() but was not
checking the result. Return the error if it fails rather than
continuing with an invalid value.

Signed-off-by: Geoffrey D. Bennett <g@b4.vu>
Fixes: 9e15fae6c51a ("ALSA: usb-audio: scarlett2: Allow bit-level access to config")
Link: https://lore.kernel.org/r/def110c5c31dbdf0a7414d258838a0a31c0fab67.1703001053.git.g@b4.vu
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer_scarlett2.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/sound/usb/mixer_scarlett2.c b/sound/usb/mixer_scarlett2.c
index 35e45c337383..a6e72862d30f 100644
--- a/sound/usb/mixer_scarlett2.c
+++ b/sound/usb/mixer_scarlett2.c
@@ -1577,7 +1577,10 @@ static int scarlett2_usb_set_config(
 		size = 1;
 		offset = config_item->offset;
 
-		scarlett2_usb_get(mixer, offset, &tmp, 1);
+		err = scarlett2_usb_get(mixer, offset, &tmp, 1);
+		if (err < 0)
+			return err;
+
 		if (value)
 			tmp |= (1 << index);
 		else
-- 
2.43.0



