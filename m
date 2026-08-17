Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EE1E437845;
	Mon, 17 Aug 2026 14:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977364; cv=none; b=iFFjkGl2CvLHg8prYRRQoQXCaKfl+23eB2sEbC2+jw72eyY9IVUPadHL+mcMs5tOPwTLf6s10fhXU7K02kHodVcxhZdaBS61nfRhjYbJe/KpJRuR7eMMEh9499cI19pXnfZE25hozgR1tzp22dABrXplqjlc1HV2UoIH2OZSCfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977364; c=relaxed/simple;
	bh=2XEL+ekQuzqnKFeYwTl8/11lMDOK6QiQG1rjcVaKuRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t3BpN28M+toqZmBM4Nk8Uvm9+YH/izSW6s67h9WYps4OZA/mFOXAcyelfYF7bnBgBU1slb2mMpkPB8YtYrBjUE6bpaNT7PHNNPbZLJpVj4I9U9WrN3zXuM1shNrEaGzxxzzgLGL+0j1x63L6ApFeuqE9WVLkHL80sndpPA9P4EY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l8SdG2oq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l8SdG2oq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D339E1F00A3A;
	Mon, 17 Aug 2026 14:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977360;
	bh=jRpb5FLRDf9F11qKT8XuA7X6fKHSxIBkCOeUQCoi8mg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l8SdG2oq/+DkwOfOcEPjc7k1B59/Pn5fGvLow7FS5NGx7LIt6+BlNLZO77fHh3Kfd
	 YrGaSeFqTr2jWdcSqC9Gs/IfX4AO2uruXuVzjEXYZ1RRv6oun96VcxQf+TbTevQBxB
	 ouX2KHJ3LuBz9oc3KGM8ZNZWbQhATQhZiUST8syg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Subject: [PATCH 5.15 301/456] ALSA: 6fire: Fix UAF at error handling during probe
Date: Mon, 17 Aug 2026 15:31:31 +0200
Message-ID: <20260817132551.584503123@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

commit a54bf16965f896415c3337bc4fbb40fb11941d99 upstream.

Although 6fire driver had a few fixes for dealing with the early error
handling during the probe phase, it forgot a pending URB before
freeing the resources, which may lead to a UAF.

This patch addresses it by doing the almost same cleanup procedure
like the normal disconnect phase at the error path.

Reported-and-tested-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Closes: https://lore.kernel.org/20260724030900.1984491-1-shuangpeng.kernel@gmail.com
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20260726074821.2288158-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/6fire/chip.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/sound/usb/6fire/chip.c
+++ b/sound/usb/6fire/chip.c
@@ -158,6 +158,10 @@ static int usb6fire_chip_probe(struct us
 	return 0;
 
 destroy_chip:
+	chip->shutdown = true;
+	if (card)
+		snd_card_disconnect(card);
+	usb6fire_chip_abort(chip);
 	snd_card_free(card);
 	return ret;
 }


