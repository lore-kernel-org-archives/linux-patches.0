Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 500EB1E7677;
	Mon, 21 Oct 2024 10:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507502; cv=none; b=dXQpW0ZIfV1WPsyI5tOi+rI62E2mQqt/Aip3EG9EG/2kbpBUZMNZ/W5nHvoc6Eqme2IzadvpR2HvSExIOYigUcRhMeMVAeGzozYK9z0KVs/jzZckuwUm6r3mPYaBXGn35Gxh/sr+FMsFUUDApijrEAajXfmien1Yw84pjsbU0is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507502; c=relaxed/simple;
	bh=rzQ3rpNELcpdvlBTLRARPz7vMJdvdV0Muef28PRtzhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l6sbaBhFMfY4Xqn+SAg4+VYOYUGixkyYyLgHT79RzjuPfMPerirjOPy1c7lFZgSKmR/gTH15DSiFF8B9jpH54XisG1Uum++IVfTP/TOrMih2s3A6226FLcBNudpsHzzKz1LL9FyF1spkZ6j6lZnsfMYCHqpT7LkZ3JdEANTi+MU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ulqgU16Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ulqgU16Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0E10C4CEC3;
	Mon, 21 Oct 2024 10:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507502;
	bh=rzQ3rpNELcpdvlBTLRARPz7vMJdvdV0Muef28PRtzhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ulqgU16Z/FIF0JZikdmaypaJQqi3S691snvkQB+Ct4V5Vp8yY/i753Nc4Y3Y5gtVU
	 uF/vksdVQQTRez5a+KBBV/OnGCrHFGhN5E+CaVwHGiYbOU+s1SJuTm1suwSCP8rNN/
	 t6gFr1zigydJ7y+vbngzCGNPwGr/yX/9puyv0Ek4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai-Heng Feng <kaihengf@nvidia.com>,
	Takashi Iwai <tiwai@suse.de>,
	Vasiliy Kovalev <kovalev@altlinux.org>
Subject: [PATCH 6.1 91/91] ALSA: hda/conexant - Use cached pin control for Node 0x1d on HP EliteOne 1000 G2
Date: Mon, 21 Oct 2024 12:25:45 +0200
Message-ID: <20241021102253.363665226@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102249.791942892@linuxfoundation.org>
References: <20241021102249.791942892@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 


