Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C322572696;
	Wed,  9 Sep 2026 14:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964026; cv=none; b=j4S+rhdGl6IgZi7P6f1z+tk+3NC/n1gIA8dLHxzbSLRU+d2bpPv2R12DUMIuoWO91RB5FiFbKm3w/7YSVkKhpAUb1xpuURVU6K6NC1SeOZwqhq72hB8MuNuJ5EjGyE5j28iokxG4gDYLDITQJtcfjPnAzLZtCA1ZkzxI28+MtQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964026; c=relaxed/simple;
	bh=jTdoyh0BSv20XBf2tyV5kTd8IxEIBWE6lyFP97pwC6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s6NE0qH28N3ab//IiPX0lskikXNcYnHJRQcCcu+xubsgOh1OxPhsc5UAbyU0hL83QujXgHESgZR87EUnVY5/2QeW27SZPFXWdn5nB2/BPPYcDbQtTZdqbOhhy7THXW0c8iSZMKQCYQ8vZj49N1sKJebNn1ISt6yrCU9NkPu3SQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bEOnFCYu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bEOnFCYu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C4001F00A3A;
	Wed,  9 Sep 2026 14:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964025;
	bh=aGvlf9cC/HB82tGtJnvZ2Rjwo7QBqKrl4+7qe3FJIlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bEOnFCYuZhfOWRIR+fr5fndi2PDeyHfHQLkG9/ucN/i7biuocyeAENyarLoBQsErt
	 P2WhPvku/yVdmxoC00hoeMA41MfGmormFr8PaDm78RkTnCvZz7rL8JdYq6K8xGjtJZ
	 jOQsHSFJylISGtYw6CrroNWPVa3MS1vXGd/p0NoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 282/583] media: cobalt: Avoid freeing ALSA private data twice
Date: Wed,  9 Sep 2026 15:39:27 +0200
Message-ID: <20260909134247.820538326@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Ruoyu Wang <ruoyuw560@gmail.com>

commit 3a7d6b9c4cb5ac18cbd3f1c7f8c7b159c42ba0b1 upstream.

snd_cobalt_card_create() stores cobsc in sc->private_data and installs
snd_cobalt_card_private_free() as sc->private_free. From that point,
snd_card_free(sc) releases cobsc through the ALSA card cleanup path.

If cobalt_alsa_init() fails after snd_cobalt_card_create(), the
err_exit_free path calls snd_card_free(sc) and then kfree(cobsc). That
second free releases the same object again.

Remove the explicit kfree(cobsc) and leave ownership with the ALSA card.

This issue was found by a static analysis checker and confirmed by
manual source review.

Fixes: 85756a069c55 ("[media] cobalt: add new driver")
Cc: stable@vger.kernel.org
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/pci/cobalt/cobalt-alsa-main.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/media/pci/cobalt/cobalt-alsa-main.c
+++ b/drivers/media/pci/cobalt/cobalt-alsa-main.c
@@ -135,7 +135,6 @@ int cobalt_alsa_init(struct cobalt_strea
 err_exit_free:
 	if (sc != NULL)
 		snd_card_free(sc);
-	kfree(cobsc);
 err_exit:
 	return ret;
 }


