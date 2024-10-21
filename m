Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21CA71E47B8;
	Mon, 21 Oct 2024 10:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507888; cv=none; b=l9FAPNu9/gQGDcp13i6MoTTKlWsNjsFhkm+89twd76J4mKjKkQ7Eo/pMIyu5faZfn97MD7DGPVz2vTnmbrKoGQ50aBUizE9qPll33Sk0RS0yIhout6TYMzMAUfrIm7TTNOlyjYbZvCs/T70GsMDn0NyflgnWenrCzU6zNY12/40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507888; c=relaxed/simple;
	bh=piilS1U7UhP7FOY5+tfsbMF0nmn1g/an9Xi2+Sokbvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z/jZ54nksM74iO1mnAHINKDmYvcDvLiABfr70dyhKCLvK5+l8YwzqNg2u1qwk8L+ApWScYZs/vn6b0DDGxHotQSUKw1u+Z9JK9/c6MgO9OD2Mz573AHinXvRlLmkGVQRyYDVWO2McTZpu72cWoYN7dcsF8dNRHjggsu+fdU6x4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eix+Ujqp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eix+Ujqp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96EC1C4CEC3;
	Mon, 21 Oct 2024 10:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507888;
	bh=piilS1U7UhP7FOY5+tfsbMF0nmn1g/an9Xi2+Sokbvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eix+UjqpnLePw8dfE/7QqvN1uxu6ZCBiHfJr9ZyKaRBJ/Y7l3J8vH4PbFAb9U7pLk
	 IPRTNsRFvGy3A/lRh5qeHy4SHaYRi9EudRmcMVq3e4KDPlF15+LkQgqAzamq/grfEI
	 7q39Mhg2acKUn6u5MDCEqXgYRSsE4cLpwvMEz53I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai-Heng Feng <kaihengf@nvidia.com>,
	Takashi Iwai <tiwai@suse.de>,
	Vasiliy Kovalev <kovalev@altlinux.org>
Subject: [PATCH 5.10 52/52] ALSA: hda/conexant - Use cached pin control for Node 0x1d on HP EliteOne 1000 G2
Date: Mon, 21 Oct 2024 12:26:13 +0200
Message-ID: <20241021102243.666034647@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102241.624153108@linuxfoundation.org>
References: <20241021102241.624153108@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -261,7 +261,7 @@ static void cxt_fixup_update_pinctl(stru
 		 * This is the value stored in the codec register after
 		 * the correct initialization of the previous windows boot.
 		 */
-		snd_hda_set_pin_ctl(codec, 0x1d, AC_PINCTL_HP_EN);
+		snd_hda_set_pin_ctl_cache(codec, 0x1d, AC_PINCTL_HP_EN);
 	}
 }
 


