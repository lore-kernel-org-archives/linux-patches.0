Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1FC0355811;
	Tue,  6 Jan 2026 17:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720506; cv=none; b=s1rw1FRj4ozQ+W5j0lSPKb6iddPAoDlsBE2rD9ogF30+ZFX1C7G6jiTnsc/9eZD57UMmoIMTgNodDL27Odt/YSGawyWQU+a1W961py7MdNUPjVxa22q4BmzM8BLFx4akitp0pZj5KKLtHa7+xUVVqE6auZlAUueCX0podxJ1UGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720506; c=relaxed/simple;
	bh=EOwxPVTmJAblgrXndO47YKBufuRINOTIhFsylLTn0bE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=otGoAeSQIDh++Wyqvk7CTt1nmahzXoMXIK30YTBk/X2UmWfPgVGElxt5XhpUaCBjKrcsQPvMJPyCzDBfIc1p3qkmXDEMxlfn2iNleYsMVwCOGDLVJ3Hu3+S3C2UKtiEh6jtl3/sdZpyUn17nJtIuMPPopNguKX7E26MDqJsOur0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GNNnzH28; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GNNnzH28"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 173F6C116C6;
	Tue,  6 Jan 2026 17:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720506;
	bh=EOwxPVTmJAblgrXndO47YKBufuRINOTIhFsylLTn0bE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GNNnzH28OxGdor8Je9yXzAkjvh3rJCoGHWrGoLADzNL9Isi6TbpxCz64Az6bjfVkp
	 nn1mUTGVRBvyB33Sxa0w6KqVipSZjm1c82vX+ompOLtHmndubZCXakpDWsCXRWvPjc
	 aK9gTtySdn2Tk8YM4m54k/5WuMFNvOchalJH/6xY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 258/567] ALSA: wavefront: Clear substream pointers on close
Date: Tue,  6 Jan 2026 18:00:40 +0100
Message-ID: <20260106170500.860711272@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/isa/wavefront/wavefront_midi.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/isa/wavefront/wavefront_midi.c
+++ b/sound/isa/wavefront/wavefront_midi.c
@@ -278,6 +278,7 @@ static int snd_wavefront_midi_input_clos
 	        return -EIO;
 
 	guard(spinlock_irqsave)(&midi->open);
+	midi->substream_input[mpu] = NULL;
 	midi->mode[mpu] &= ~MPU401_MODE_INPUT;
 
 	return 0;
@@ -300,6 +301,7 @@ static int snd_wavefront_midi_output_clo
 	        return -EIO;
 
 	guard(spinlock_irqsave)(&midi->open);
+	midi->substream_output[mpu] = NULL;
 	midi->mode[mpu] &= ~MPU401_MODE_OUTPUT;
 	return 0;
 }


