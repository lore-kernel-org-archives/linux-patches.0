Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20EAB39BED5;
	Tue, 16 Dec 2025 12:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888701; cv=none; b=jAYo3EfFlw5c64DseL5gtZ14euvEm4ZfqGxgEt/eOqNmZk9I0molcIEf1Hs7M54IK8676I5q4F1vPliULgXl8PJYL14xLaNq+PZsNx/yt7a/G4yPPaPldSfu6I3fHDQnrykmXDkil6OnmrFzhpcopQ2Bw9YjcaPXC9eAPlj540E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888701; c=relaxed/simple;
	bh=2pDT528ahAGL9ZkKgX6xHYnStW3uFb7OnOtRd559vLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i5dGLZlxslnF5RWI/Cys7DaCe8FqvmOu+Yf32MaTLjFlsb2hc2yAJS4KPDSYMdKYlL0X+O4WoIDQtkvIzMGeUZNZqlmHj0rIZfNvgpud+WnnwXFgfPn7557+wphM65ksDpoBK94mp/YB1SNmPRxGTi/bJ8RIAJmdHazBEToMzP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IwBjDDUJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IwBjDDUJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93237C4CEF1;
	Tue, 16 Dec 2025 12:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888701;
	bh=2pDT528ahAGL9ZkKgX6xHYnStW3uFb7OnOtRd559vLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IwBjDDUJEJHF/a5HfNETTMwr8DVCC1U104BfQWbtJpYJO/EeYsQvDjVhzwgZxMO32
	 EX2FMqrvP1yL28axW7iqv1HzIM/IF3su/6CkrQNKXaYqA6aFuYGR8zRLqMKmFStRWx
	 ynl+Ex9mHm8n9rHu16tdbhDc8xFVUQ/8bTrjVYDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 613/614] ALSA: wavefront: Clear substream pointers on close
Date: Tue, 16 Dec 2025 12:16:20 +0100
Message-ID: <20251216111423.609444878@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Junrui Luo <moonafterrain@outlook.com>

commit e11c5c13ce0ab2325d38fe63500be1dd88b81e38 upstream.

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


