Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8900749F
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:21:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46158C433D2;
	Thu, 12 Jan 2023 14:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673533289;
	bh=50ow/X8mAdybbxLFGEt5Qy11Y+GlBtkQEH/rytZpPvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wzIkbfNlKjjWcvx23/ngAb+/vLBxRzcta5W5JJw9WaWrm9KzDlQ84BzTYoYua3uDx
	 U1Pr9VLL9ZnevG6RneCn5Cl9PIOOIUoNl/DTdd1ntGjdBa14dC1kR4pJM8hDQpvSIh
	 XZK0EkE2WXzOlTGFwRXVbcyOhwC/hL8LipojPaus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 430/783] macintosh: fix possible memory leak in macio_add_one_device()
Date: Thu, 12 Jan 2023 14:52:26 +0100
Message-Id: <20230112135544.248875397@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 5ca86eae55a2f006e6c1edd2029b2cacb6979515 ]

Afer commit 1fa5ae857bb1 ("driver core: get rid of struct device's
bus_id string array"), the name of device is allocated dynamically. It
needs to be freed when of_device_register() fails. Call put_device() to
give up the reference that's taken in device_initialize(), so that it
can be freed in kobject_cleanup() when the refcount hits 0.

macio device is freed in macio_release_dev(), so the kfree() can be
removed.

Fixes: 1fa5ae857bb1 ("driver core: get rid of struct device's bus_id string array")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20221104032551.1075335-1-yangyingliang@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/macintosh/macio_asic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/macintosh/macio_asic.c b/drivers/macintosh/macio_asic.c
index 49af60bdac92..7db2e23a5ac8 100644
--- a/drivers/macintosh/macio_asic.c
+++ b/drivers/macintosh/macio_asic.c
@@ -425,7 +425,7 @@ static struct macio_dev * macio_add_one_device(struct macio_chip *chip,
 	if (of_device_register(&dev->ofdev) != 0) {
 		printk(KERN_DEBUG"macio: device registration error for %s!\n",
 		       dev_name(&dev->ofdev.dev));
-		kfree(dev);
+		put_device(&dev->ofdev.dev);
 		return NULL;
 	}
 
-- 
2.35.1



