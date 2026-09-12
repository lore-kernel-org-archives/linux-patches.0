Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7494F4746A9;
	Sat, 12 Sep 2026 11:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213945; cv=none; b=G6OM8sepu4WC6aeFcdqQBD5Dk21/BOGNFmC/o7VV+d1MoQp6AazlmXfmtNd1M2VNyt7Rn6dqDxO9ljZr7LZmscyELBW8Buo43bgoeyiuY1yc6taDyx7xsFGQKCmDJBijXcnKA+HflQOyJnZotx15+aN4EPPb/pBz9jLp6vmEli4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213945; c=relaxed/simple;
	bh=DQJgKxcs2wv3JmRXIr1wdne7Q1P5zyoHSfuokfrxEjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gIM+Xg/qlnLC4antQcr7SDsY+Ci0oC+g7e2A2GO96caLCAzZPTExhhsw3+JTOw7K5CjYqDuB1Egb4XQvphpyGhr+w69Yta7Y16VYZKi0unq8GyJpySPz1Hec19babj6OzJBdGIPRgWCfjwumi/zBBUnoCcO+6K0Zi1tK38j4sHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yVw+LB4w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yVw+LB4w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D29FC1F00893;
	Sat, 12 Sep 2026 11:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213939;
	bh=aNQPPYekKMRSG2CKxkmJGSqtVklNXLFdYLupqyj6FGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yVw+LB4wZ+pbM3wnzvG+EheA8lXwkjnCU6Ee19AMxPWS3hki1+PxP9l3II72vFrDa
	 Y4br0XsNCjh7lTHtLRYAPW/9WQh8uUwqphzJS7iU5+XeaENTc55tr3tbuFrAaVQSz1
	 2P8xdqTwgegP0iVn6AuWVrr1PBCtIN1fwtFk4Q9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 0187/1376] media: cobalt: Avoid freeing ALSA private data twice
Date: Sat, 12 Sep 2026 08:43:33 +0200
Message-ID: <20260912065611.719157370@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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


