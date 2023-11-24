Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E34A39FC3;
	Fri, 24 Nov 2023 18:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A5b7qrhU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC677C433C7;
	Fri, 24 Nov 2023 18:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849918;
	bh=5gj6qjSrXd6hLwv/Q2F6QzQ2nbx5dg1W0saAY0uTgLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A5b7qrhUAs6G1TuOtVPM9EvC0G6nQOqP1W7u4w7akZQfmPOTL52FIhFjSAMovWXW6
	 W+LdI/DnUhJRgsuhUZGoi7RjtCsT0py5X8EP7ocV+GcutrIrC101+wAgj50tHMA1Hp
	 MjaFah1YZqZY3dZSFmUGydPqC46tzUtGlCZkHdHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jose Javier Rodriguez Barbarin <JoseJavier.Rodriguez@duagon.com>,
	Jorge Sanjuan Garcia <jorge.sanjuangarcia@duagon.com>
Subject: [PATCH 6.6 372/530] mcb: fix error handling for different scenarios when parsing
Date: Fri, 24 Nov 2023 17:48:58 +0000
Message-ID: <20231124172039.339011770@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sanjuán García, Jorge <Jorge.SanjuanGarcia@duagon.com>

commit 63ba2d07b4be72b94216d20561f43e1150b25d98 upstream.

chameleon_parse_gdd() may fail for different reasons and end up
in the err tag. Make sure we at least always free the mcb_device
allocated with mcb_alloc_dev().

If mcb_device_register() fails, make sure to give up the reference
in the same place the device was added.

Fixes: 728ac3389296 ("mcb: mcb-parse: fix error handing in chameleon_parse_gdd()")
Cc: stable <stable@kernel.org>
Reviewed-by: Jose Javier Rodriguez Barbarin <JoseJavier.Rodriguez@duagon.com>
Signed-off-by: Jorge Sanjuan Garcia <jorge.sanjuangarcia@duagon.com>
Link: https://lore.kernel.org/r/20231019141434.57971-2-jorge.sanjuangarcia@duagon.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mcb/mcb-core.c  | 1 +
 drivers/mcb/mcb-parse.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mcb/mcb-core.c b/drivers/mcb/mcb-core.c
index 2a4a5e71ad4e..ba4530459de8 100644
--- a/drivers/mcb/mcb-core.c
+++ b/drivers/mcb/mcb-core.c
@@ -246,6 +246,7 @@ int mcb_device_register(struct mcb_bus *bus, struct mcb_device *dev)
 	return 0;
 
 out:
+	put_device(&dev->dev);
 
 	return ret;
 }
diff --git a/drivers/mcb/mcb-parse.c b/drivers/mcb/mcb-parse.c
index 656b6b71c768..1ae37e693de0 100644
--- a/drivers/mcb/mcb-parse.c
+++ b/drivers/mcb/mcb-parse.c
@@ -106,7 +106,7 @@ static int chameleon_parse_gdd(struct mcb_bus *bus,
 	return 0;
 
 err:
-	put_device(&mdev->dev);
+	mcb_free_dev(mdev);
 
 	return ret;
 }
-- 
2.43.0



