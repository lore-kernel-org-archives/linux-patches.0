Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F9701F131C;
	Mon, 21 Oct 2024 10:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507751; cv=none; b=mTQzQaScGgCJiKXyQgAk8p2OyypVfQ8G4gu4pVGeoTXB5Ue71eHgdPabh7poO6ebVyHl2+0jwrXx5ns1oJJxotD04Bg8qjIt9V2GyuPAta7Mn5yr7AOIgZPG9rGv81UbgOvuInME5SBUlpNLHMbX4QfpnYJLZQ6RX5IOrsE9E5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507751; c=relaxed/simple;
	bh=dDIf64GQarnrpx2zB/iXz2IWjnD54YPwoPF6TDhi2AM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LRyu+9SmGS0+T47BFIk5tJq3UCtPllqZFVuuY/mhOStchRzAfywCa6YcFVuHWukNjRzaii4GnwXQ0+FLy6xc5mhDgeTzkg2z68P1wStLQqgAvXRkg1hMA9Y8c7QctyuNRQNxkZqHc4Dtcczqts/EHjKyPBdrD5BFdCc0srK5FuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2jmdpa4x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2jmdpa4x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91FA7C4CEC3;
	Mon, 21 Oct 2024 10:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507751;
	bh=dDIf64GQarnrpx2zB/iXz2IWjnD54YPwoPF6TDhi2AM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2jmdpa4xZa1p2PZxfYXufZnEjyvFnPeYd3RL7vPOFkUruUC+TX15ipZQ+kfo2tPHZ
	 mEa2IIwAMxrZqPLYEQQEaf0Yf8UUZJaVt2AsRu/3ud73TcDBtAxz0x3y/4wiEjg0O6
	 QCyBKLGWDviaj1DR/p1hBXp2x+SqZznuiwTK0X5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai-Heng Feng <kaihengf@nvidia.com>,
	Takashi Iwai <tiwai@suse.de>,
	Vasiliy Kovalev <kovalev@altlinux.org>
Subject: [PATCH 5.15 82/82] ALSA: hda/conexant - Use cached pin control for Node 0x1d on HP EliteOne 1000 G2
Date: Mon, 21 Oct 2024 12:26:03 +0200
Message-ID: <20241021102250.457950649@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102247.209765070@linuxfoundation.org>
References: <20241021102247.209765070@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 


