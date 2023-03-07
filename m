Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C71E9BA4C
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 19:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4595CC433EF;
	Tue,  7 Mar 2023 19:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678215619;
	bh=1gdPd6NTN+t7wSWS5tA/rqZ4hD9Rs77xCjU7jYMwV3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nv68MdrcH553hFmMXVKDvoN4Mm+kdZ7CCY+4PEAOfph9ZrAXs1V3wAaI5a7O473ws
	 wmJduRPiXAQV+Xz5F6n8enhhO+knED9cfpFfGT5PLVRYLvPK3EBpZ7Y4YRbqS0yxe3
	 j01Gw7YjdTXhpqn3Yi1d6uTGBEQ9gvG25eUoGPgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakob Koschel <jakobkoschel@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 320/567] usb: gadget: configfs: remove using list iterator after loop body as a ptr
Date: Tue,  7 Mar 2023 18:00:56 +0100
Message-Id: <20230307165919.743587097@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jakob Koschel <jakobkoschel@gmail.com>

[ Upstream commit 36f4c25ce32ed8a2e6304ebee6246b7f0b3b9a6f ]

If the list does not contain the expected element, the value of
list_for_each_entry() iterator will not point to a valid structure.
To avoid type confusion in such case, the list iterator
scope will be limited to list_for_each_entry() loop.

In preparation to limiting scope of a list iterator to the list traversal
loop, use a dedicated pointer to point to the found element [1].
Determining if an element was found is then simply checking if
the pointer is != NULL instead of using the potentially bogus pointer.

Link: https://lore.kernel.org/all/YhdfEIwI4EdtHdym@kroah.com/
Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
Link: https://lore.kernel.org/r/20220308171818.384491-18-jakobkoschel@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 89e7252d6c7e ("usb: gadget: configfs: Restrict symlink creation is UDC already binded")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/configfs.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/gadget/configfs.c b/drivers/usb/gadget/configfs.c
index 8166e771e8663..891d8e4023221 100644
--- a/drivers/usb/gadget/configfs.c
+++ b/drivers/usb/gadget/configfs.c
@@ -418,7 +418,7 @@ static int config_usb_cfg_link(
 
 	struct usb_function_instance *fi =
 			to_usb_function_instance(usb_func_ci);
-	struct usb_function_instance *a_fi;
+	struct usb_function_instance *a_fi = NULL, *iter;
 	struct usb_function *f;
 	int ret;
 
@@ -428,11 +428,13 @@ static int config_usb_cfg_link(
 	 * from another gadget or a random directory.
 	 * Also a function instance can only be linked once.
 	 */
-	list_for_each_entry(a_fi, &gi->available_func, cfs_list) {
-		if (a_fi == fi)
-			break;
+	list_for_each_entry(iter, &gi->available_func, cfs_list) {
+		if (iter != fi)
+			continue;
+		a_fi = iter;
+		break;
 	}
-	if (a_fi != fi) {
+	if (!a_fi) {
 		ret = -EINVAL;
 		goto out;
 	}
@@ -889,15 +891,17 @@ static int os_desc_link(struct config_item *os_desc_ci,
 					struct gadget_info, os_desc_group);
 	struct usb_composite_dev *cdev = &gi->cdev;
 	struct config_usb_cfg *c_target = to_config_usb_cfg(usb_cfg_ci);
-	struct usb_configuration *c;
+	struct usb_configuration *c = NULL, *iter;
 	int ret;
 
 	mutex_lock(&gi->lock);
-	list_for_each_entry(c, &cdev->configs, list) {
-		if (c == &c_target->c)
-			break;
+	list_for_each_entry(iter, &cdev->configs, list) {
+		if (iter != &c_target->c)
+			continue;
+		c = iter;
+		break;
 	}
-	if (c != &c_target->c) {
+	if (!c) {
 		ret = -EINVAL;
 		goto out;
 	}
-- 
2.39.2



