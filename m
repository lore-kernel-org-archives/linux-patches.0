Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DD3346B7
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:30:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7508C433D2;
	Mon, 16 Jan 2023 16:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673886635;
	bh=vxs/uePeqY9uEnTL5udaLloHxcY/GXkuhbWxtSbsUG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X7hj58rbd0QRyVdqSp/US9zOG8vOBevEnVbZOHApVGsSqTj0OPzDpFHNOJpGDz0ju
	 BjgHEtrfoy2vcKcF+Ekzf8s1e2dE2MTqTp09mT6yNZXNeH/bqBJdtqDE8VA0Y4iCqj
	 +NDU/FNjjgu+cmbwVnQ8tkxjcIpFZ8fBCkv3BCyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenwen Wang <wenwen@cs.uga.edu>,
	Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>,
	Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 5.4 504/658] media: dvb-core: Fix double free in dvb_register_device()
Date: Mon, 16 Jan 2023 16:49:52 +0100
Message-Id: <20230116154932.559804771@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>

commit 6b0d0477fce747d4137aa65856318b55fba72198 upstream.

In function dvb_register_device() -> dvb_register_media_device() ->
dvb_create_media_entity(), dvb->entity is allocated and initialized. If
the initialization fails, it frees the dvb->entity, and return an error
code. The caller takes the error code and handles the error by calling
dvb_media_device_free(), which unregisters the entity and frees the
field again if it is not NULL. As dvb->entity may not NULLed in
dvb_create_media_entity() when the allocation of dvbdev->pad fails, a
double free may occur. This may also cause an Use After free in
media_device_unregister_entity().

Fix this by storing NULL to dvb->entity when it is freed.

Link: https://lore.kernel.org/linux-media/20220426052921.2088416-1-keitasuzuki.park@sslab.ics.keio.ac.jp
Fixes: fcd5ce4b3936 ("media: dvb-core: fix a memory leak bug")
Cc: stable@vger.kernel.org
Cc: Wenwen Wang <wenwen@cs.uga.edu>
Signed-off-by: Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/dvb-core/dvbdev.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -345,6 +345,7 @@ static int dvb_create_media_entity(struc
 				       GFP_KERNEL);
 		if (!dvbdev->pads) {
 			kfree(dvbdev->entity);
+			dvbdev->entity = NULL;
 			return -ENOMEM;
 		}
 	}


