Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B943382CB;
	Sat, 12 Sep 2026 19:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242068; cv=none; b=e518DLuoKwmOH9DG6/f6FU1s1fjudoagSidNZscdLBXD+uucpfIV09DtrjVrZG1odgLLXntnIp37ZD5xQPJX7pdj0pWdzjNvbzWzufU+m0zcSENvOA4JcvRZuvmOGAYLa68qjWa5+mMGXubrNwzfSwvWy5WKHvmeWO8E9Kj155g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242068; c=relaxed/simple;
	bh=h5FM8N5uQLQA5yUPBjfDuT3K1jBQh+QvlQ36sgRPPNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n9t2Upj6n2evB1y+AwMI5z+ZhGBhXXiXuMSZSdToM8iudfPvdhTwBOS7iI2b3sO+lI0W1+caPUSEwniroeAVt9nkCEmSZCRs3CiyAFr9guAXjaJy0D5R1gsavvGCCkIiUqKKkjZ3pC7DRCun1Dz5hR0x3EMtmG5PbN0brbS+6zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dtIdfoXp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dtIdfoXp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA08E1F000FF;
	Sat, 12 Sep 2026 19:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242067;
	bh=io3xBgY0tDt8g7PrKz2FtONgqhrPBB94ldzW1J590nQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dtIdfoXpj43D37OErPSVsPFEHF7hloCzczTNjoDxu9rTAqt37CnCvSKqaeJBcBcYk
	 QMlSoh16u5QfPhzN5qzKSZf6ZScUp4h9g4uK8NWOMkGbXjSbaHJ5BQJmh3b9fSNBif
	 gPZ+9k2tUYygFZrMfS0N5lDv+ZZqu93Zdj3HiAu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.10 273/798] media: cobalt: Avoid freeing ALSA private data twice
Date: Sat, 12 Sep 2026 08:58:21 +0200
Message-ID: <20260912065523.414179789@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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


