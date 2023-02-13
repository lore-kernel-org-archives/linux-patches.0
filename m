Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DA7A8F57
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 15:03:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 253F8C433D2;
	Mon, 13 Feb 2023 15:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676300614;
	bh=ptTYlD0bLz2tT3XShAd5CPhUCdH6NF2cHWVBt/bDJVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pBWC7cwjTe4uKEIgnEj3PZJpizXdq8TGHbPetRpHRnlegvt40wciT63ByVbhN5NKo
	 S7f4A46kg7Mk/xMnZk7ODr71Ukb02cet7HPOq1sNehkPsiZz3EFu1b30HOFqRUp+W3
	 x8XEzdBqC/HBCaKN9HHisc49PN7xlAjXBsXfxc9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 5.10 082/139] nvmem: core: initialise nvmem->id early
Date: Mon, 13 Feb 2023 15:50:27 +0100
Message-Id: <20230213144750.193222640@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144745.696901179@linuxfoundation.org>
References: <20230213144745.696901179@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

commit 3bd747c7ea13cb145f0d84444e00df928b0842d9 upstream.

The error path for wp_gpio attempts to free the IDA nvmem->id, but
this has yet to be assigned, so will always be zero - leaking the
ID allocated by ida_alloc(). Fix this by moving the initialisation
of nvmem->id earlier.

Fixes: f7d8d7dcd978 ("nvmem: fix memory leak in error path")
Cc: stable@vger.kernel.org
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20230127104015.23839-4-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvmem/core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -625,6 +625,8 @@ struct nvmem_device *nvmem_register(cons
 		return ERR_PTR(rval);
 	}
 
+	nvmem->id = rval;
+
 	if (config->wp_gpio)
 		nvmem->wp_gpio = config->wp_gpio;
 	else
@@ -640,7 +642,6 @@ struct nvmem_device *nvmem_register(cons
 	kref_init(&nvmem->refcnt);
 	INIT_LIST_HEAD(&nvmem->cells);
 
-	nvmem->id = rval;
 	nvmem->owner = config->owner;
 	if (!nvmem->owner && config->dev->driver)
 		nvmem->owner = config->dev->driver->owner;


