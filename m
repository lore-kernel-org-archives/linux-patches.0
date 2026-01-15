Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F473399011;
	Thu, 15 Jan 2026 17:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498445; cv=none; b=WR1BoUU/ZpBbSrWsqbtsK454Jyq4851rn/yGXJFd17cmv8dGdgGK5qAuHzOLtpZ1BQFuuK60NCzfQXwgcMwj4tLOC2fN3l+udqNI2q5TAKGjP3ECTiMa8gg1R1iqL02s+VIXBT8nsMc2kcnQ9ZRZKMwLcdvvDuq2GqmHv3L5keQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498445; c=relaxed/simple;
	bh=0Wla8otLegldpC9LWlbOVbfvsdwq8EaPbNj7t/bdpKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mNQa6ps01e9RZmyyk7mcaHeVvMfkLaWRMShmdNyvXksA+auEEHk30Oq/ih6e9xwA3u+D46jatKOU2jhzJWYHv8Z/asE7vX0lGf4tV/jP0CDgkEQj8b/XQb85KmbqUnOIefeAorFKPrLLtMNdDnSbvr4NeBhaUvVGsOo1uDbrPgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g6N2YrKR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g6N2YrKR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F15E6C16AAE;
	Thu, 15 Jan 2026 17:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498445;
	bh=0Wla8otLegldpC9LWlbOVbfvsdwq8EaPbNj7t/bdpKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g6N2YrKROPjb4xSOKOmmmXVz1FNMb0xaFcg8yBwVz5+R1HazfybYDbN2bUgYpe4JC
	 fzOJzKXbvyIfxV5FCZ5BZaA5QL78+paxlk77NJiunv7TO/6eZwxCw/Q99JAO/U4aH9
	 CFyrD7/XLjGTnRAhF11u6tTUzB45e9Opt12Uq/5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 435/554] ALSA: wavefront: Clear substream pointers on close
Date: Thu, 15 Jan 2026 17:48:21 +0100
Message-ID: <20260115164302.007582739@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -294,6 +294,7 @@ static int snd_wavefront_midi_input_clos
 	        return -EIO;
 
 	spin_lock_irqsave (&midi->open, flags);
+	midi->substream_input[mpu] = NULL;
 	midi->mode[mpu] &= ~MPU401_MODE_INPUT;
 	spin_unlock_irqrestore (&midi->open, flags);
 
@@ -318,6 +319,7 @@ static int snd_wavefront_midi_output_clo
 	        return -EIO;
 
 	spin_lock_irqsave (&midi->open, flags);
+	midi->substream_output[mpu] = NULL;
 	midi->mode[mpu] &= ~MPU401_MODE_OUTPUT;
 	spin_unlock_irqrestore (&midi->open, flags);
 	return 0;


