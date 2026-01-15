Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033813D6691;
	Thu, 15 Jan 2026 17:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499798; cv=none; b=OKs9vs+m6e7dBSxMmOypi3NV6fjhy/jr0ZcoWAwV0YyErpLoD64/sevm6aEhvfedrEMac0GEfoRwEnrNuuVwGynlX19CgiZICkUdqY2M4IZDRiA/w21MKf/lXEhrgecEH1rOXKoSqKYPOz+yQJmM4BUUUOlTiR0/Ipx3esm0nXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499798; c=relaxed/simple;
	bh=eIFkHo/nYSJ1GJHb2L5pwv4t3dWrGLiy81mlYrGAlBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hxAUh9ZQ4+0QZshco4ZHOO1Uuz68d3G67Y4tGhz9JrA3hVMCe+kl3fORGPfMo4ChxPMtVrXbA2c4RHwkNAxMM01gvRwI9js+nEXuXe4QKd1bHj/RW2KoApirkA90qUBfDtx1sCbj7udVeC98MoFp/ImiH/7limlCbFhPxZKw6NI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vSCNcVyX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vSCNcVyX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 804A0C116D0;
	Thu, 15 Jan 2026 17:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499797;
	bh=eIFkHo/nYSJ1GJHb2L5pwv4t3dWrGLiy81mlYrGAlBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vSCNcVyX8F3FzEfF2aae8nBC6hhe34FTBdcd921FkfVUwytaEkNPRi3W9VC+ff20b
	 GUPWNdaePCDLxl9bnYUCsZ3ZwegWT6er29+0UcJ4RyQLUZARMRmaUzwXXiZHEWm2fT
	 kytdvbfte85tsL+f7a0skCa3rKyWGuJMLiyBuHYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 354/451] ALSA: wavefront: Clear substream pointers on close
Date: Thu, 15 Jan 2026 17:49:15 +0100
Message-ID: <20260115164243.706272321@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junrui Luo <moonafterrain@outlook.com>

[ Upstream commit e11c5c13ce0ab2325d38fe63500be1dd88b81e38 ]

Clear substream pointers in close functions to avoid leaving dangling
pointers, helping to improve code safety and
prevents potential issues.

Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Reported-by: Junrui Luo <moonafterrain@outlook.com>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Link: https://patch.msgid.link/SYBPR01MB7881DF762CAB45EE42F6D812AFC2A@SYBPR01MB7881.ausprd01.prod.outlook.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[ No guard() in older trees ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/isa/wavefront/wavefront_midi.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/isa/wavefront/wavefront_midi.c
+++ b/sound/isa/wavefront/wavefront_midi.c
@@ -291,6 +291,7 @@ static int snd_wavefront_midi_input_clos
 	        return -EIO;
 
 	spin_lock_irqsave (&midi->open, flags);
+	midi->substream_input[mpu] = NULL;
 	midi->mode[mpu] &= ~MPU401_MODE_INPUT;
 	spin_unlock_irqrestore (&midi->open, flags);
 
@@ -314,6 +315,7 @@ static int snd_wavefront_midi_output_clo
 	        return -EIO;
 
 	spin_lock_irqsave (&midi->open, flags);
+	midi->substream_output[mpu] = NULL;
 	midi->mode[mpu] &= ~MPU401_MODE_OUTPUT;
 	spin_unlock_irqrestore (&midi->open, flags);
 	return 0;


