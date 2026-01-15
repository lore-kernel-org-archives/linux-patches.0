Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D189A3624C4;
	Thu, 15 Jan 2026 16:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496225; cv=none; b=M/JL5D2dyGZFmecH7i+C804s2pfjlP77bVwUTJP+OL0Nv8Az9mKZ97Gc0sICnDpBITWfqdm+Od3/i4T7LBqXZZrfD9c+U4k2tF6sI5/tTENUV+z6cCnDof5FAkujth96WmcJ+/Vheo5qTKIaS/habbO1LvREA9zEFZxaWrEhk8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496225; c=relaxed/simple;
	bh=AGABEdQBnVth9k5TR6blHigiJmGK+n2q+aCjjF0KRVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D4jav8CcKdmr4wQ2dpQXR4EFzTRXlnI++PYcHJL7VzzhebclaGWol1HUfi+1jsVrcwows6KZOs/4Ra7lSk/VyWS81yZPr9fpo35bn3rnzjBp0jb3imJkzKACItaPk1JvwfW4RNfdVfJU7SvizhSB5NP+bQxvN22SvvkEG+KAWpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dk3o850J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dk3o850J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 623CEC116D0;
	Thu, 15 Jan 2026 16:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496225;
	bh=AGABEdQBnVth9k5TR6blHigiJmGK+n2q+aCjjF0KRVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dk3o850J5KOlsVhzXa056WauXYUE8RiLIbwwlbA0gH4pWlUhWXCCKRv8oWqpVSiNm
	 RSkVgyDVtG7exE9tqTasM2WLs5KgFiCfnrRtfKC8E7VwVGVowBc6t+0XZLIX6iT1+u
	 k+6joDCJABN7XO06NNkQkteeeH3NdkWrkup17+jI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Erhardt <aer@tuxedocomputers.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	"Luke D. Jones" <luke@ljones.dev>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 122/181] PCI/VGA: Dont assume the only VGA device on a system is `boot_vga`
Date: Thu, 15 Jan 2026 17:47:39 +0100
Message-ID: <20260115164206.717711672@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

From: Mario Limonciello (AMD) <superm1@kernel.org>

[ Upstream commit fd390ff144513eb0310c350b1cf5fa8d6ddd0c53 ]

Some systems ship with multiple display class devices but not all
of them are VGA devices. If the "only" VGA device on the system is not
used for displaying the image on the screen marking it as `boot_vga`
because nothing was found is totally wrong.

This behavior actually leads to mistakes of the wrong device being
advertised to userspace and then userspace can make incorrect decisions.

As there is an accurate `boot_display` sysfs file stop lying about
`boot_vga` by assuming if nothing is found it's the right device.

Reported-by: Aaron Erhardt <aer@tuxedocomputers.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220712
Tested-by: Aaron Erhardt <aer@tuxedocomputers.com>
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: ad90860bd10ee ("fbcon: Use screen info to find primary device")
Tested-by: Luke D. Jones <luke@ljones.dev>
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patch.msgid.link/20260106044638.52906-1-superm1@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/vgaarb.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/pci/vgaarb.c b/drivers/pci/vgaarb.c
index 436fa7f4c3873..baa242b140993 100644
--- a/drivers/pci/vgaarb.c
+++ b/drivers/pci/vgaarb.c
@@ -652,13 +652,6 @@ static bool vga_is_boot_device(struct vga_device *vgadev)
 		return true;
 	}
 
-	/*
-	 * Vgadev has neither IO nor MEM enabled.  If we haven't found any
-	 * other VGA devices, it is the best candidate so far.
-	 */
-	if (!boot_vga)
-		return true;
-
 	return false;
 }
 
-- 
2.51.0



