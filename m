Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C55C1E0087;
	Mon, 21 Oct 2024 10:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507225; cv=none; b=VDrTWxyyAMdIsq84crQq/Q8YWZ0zOGtgcY8FJadNL5so2zog4pFEpZc6TfkaMggUF+SlpSq3JZLzlaEPJKz+gZF5adunFaxNJNGuehAnHkgrVKyQuLHmACWDhdILZtGobDWF8DMX709x23GeLZxSzROECKoMmvZTVOHGbo9UYMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507225; c=relaxed/simple;
	bh=OM8RNgTda3SQ6AriWp//9bJ8tX8Hij8Mxwk5IuaK248=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z2k3mi0Xh4kiAbfQ5WwooFTuuITzRHdHseBObBjwzS6v/WmW1ccza68Q4Yy0EzkNm+DX39DkEOeHdaqzvVC5bObrMnxlTilZ/0bU/LHUjfPS0q3Avfk+zuSvS+q4FVZsUxMlWh6Plh+7SfgAuBoHEYy7xN7I9o3A1rU9K5W2GcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HZiSv2o7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HZiSv2o7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0523C4CEEA;
	Mon, 21 Oct 2024 10:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507225;
	bh=OM8RNgTda3SQ6AriWp//9bJ8tX8Hij8Mxwk5IuaK248=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HZiSv2o7aDAP4WgPh07Nfgz95HWQ3bX6R5xF2/utmgEeQ0GwkWQ9XpF0HvLjeRlid
	 ZANcgPGgy0IzathWKIVIGKeZuZTrwlqZSpN/phZPWUkCdKIfDoqHhKjvV/brtkwvhQ
	 itSqrvhakFiLsXnFI0dIC8yplF1hPPA9hJhNHww8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai-Heng Feng <kaihengf@nvidia.com>,
	Takashi Iwai <tiwai@suse.de>,
	Vasiliy Kovalev <kovalev@altlinux.org>
Subject: [PATCH 6.6 124/124] ALSA: hda/conexant - Use cached pin control for Node 0x1d on HP EliteOne 1000 G2
Date: Mon, 21 Oct 2024 12:25:28 +0200
Message-ID: <20241021102301.523039171@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102256.706334758@linuxfoundation.org>
References: <20241021102256.706334758@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasiliy Kovalev <kovalev@altlinux.org>

commit 164cd0e077a18d6208523c82b102c98c77fdd51f upstream.

The cached version avoids redundant commands to the codec, improving
stability and reducing unnecessary operations. This change ensures
better power management and reliable restoration of pin configurations,
especially after hibernation (S4) and other power transitions.

Fixes: 9988844c457f ("ALSA: hda/conexant - Fix audio routing for HP EliteOne 1000 G2")
Suggested-by: Kai-Heng Feng <kaihengf@nvidia.com>
Suggested-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
Link: https://patch.msgid.link/20241016080713.46801-1-kovalev@altlinux.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_conexant.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -334,7 +334,7 @@ static void cxt_fixup_update_pinctl(stru
 		 * This is the value stored in the codec register after
 		 * the correct initialization of the previous windows boot.
 		 */
-		snd_hda_set_pin_ctl(codec, 0x1d, AC_PINCTL_HP_EN);
+		snd_hda_set_pin_ctl_cache(codec, 0x1d, AC_PINCTL_HP_EN);
 	}
 }
 


