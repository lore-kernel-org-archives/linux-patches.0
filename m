Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D26E1BA3E
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:33:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35BA6C433EF;
	Tue,  7 Mar 2023 17:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678210430;
	bh=AoaApzglA4jAl6v/1JcIAusIdzId4xcrRTq1oGlPK6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E/Gl2CHyUYUDIdDJGWBy+JaeGBNDGz7af7+cZo0y+4XQb2h/SIoqPbs36ImRLgsIt
	 osfnPLLMnS5XQvRJfatqo7sQti9krJqP6R8n5wP9Hg8D7UFvU8fZ35ksgjskCYwK6V
	 7a6ksXg32cPQig/MTi8XKbSPJ5TgNvW/cNFjMyLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna Kurapati PSSNV <quic_kriskura@quicinc.com>,
	Udipto Goswami <quic_ugoswami@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0539/1001] usb: gadget: configfs: Restrict symlink creation is UDC already binded
Date: Tue,  7 Mar 2023 17:55:11 +0100
Message-Id: <20230307170044.852806663@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Udipto Goswami <quic_ugoswami@quicinc.com>

[ Upstream commit 89e7252d6c7e7eeb31971cd7df987316ecc64ff5 ]

During enumeration or composition switch,a userspace process
agnostic of the conventions of configs can try to create function
symlinks even after the UDC is bound to current config which is
not correct. Potentially it can create duplicates within the
current config.

Prevent this by adding a check if udc_name already exists, then bail
out of cfg_link.

Following is an example:

Step1:
ln -s X1 ffs.a
-->cfg_link
--> usb_get_function(ffs.a)
	->ffs_alloc

	CFG->FUNC_LIST: <ffs.a>
	C->FUNCTION: <empty>

Step2:
echo udc.name > /config/usb_gadget/g1/UDC
--> UDC_store
	->composite_bind
	->usb_add_function

	CFG->FUNC_LIST: <empty>
	C->FUNCTION: <ffs.a>

Step3:
ln -s Y1 ffs.a
-->cfg_link
-->usb_get_function(ffs.a)
	->ffs_alloc

	CFG->FUNC_LIST: <ffs.a>
	C->FUNCTION: <ffs.a>

both the lists corresponds to the same function instance ffs.a
but the usb_function* pointer is different because in step 3
ffs_alloc has created a new reference to usb_function* for
ffs.a and added it to cfg_list.

Step4:
Now a composition switch involving <ffs.b,ffs.a> is executed.

the composition switch will involve 3 things:
	1. unlinking the previous functions existing
	2. creating new symlinks
	3. writing UDC

However, the composition switch is generally taken care by
userspace process which creates the symlinks in its own
nomenclature(X*) and removes only those.
So it won't be able to remove Y1 which user had created
by own.

Due to this the new symlinks cannot be created for ffs.a
since the entry already exists in CFG->FUNC_LIST.

The state of the CFG->FUNC_LIST is as follows:
	CFG->FUNC_LIST: <ffs.a>

Fixes: 88af8bbe4ef7 ("usb: gadget: the start of the configfs interface")
Signed-off-by: Krishna Kurapati PSSNV <quic_kriskura@quicinc.com>
Signed-off-by: Udipto Goswami <quic_ugoswami@quicinc.com>
Link: https://lore.kernel.org/r/20230201132308.31523-1-quic_ugoswami@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/configfs.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/usb/gadget/configfs.c b/drivers/usb/gadget/configfs.c
index 0853536cbf2e6..2ff34dc129c40 100644
--- a/drivers/usb/gadget/configfs.c
+++ b/drivers/usb/gadget/configfs.c
@@ -430,6 +430,12 @@ static int config_usb_cfg_link(
 	 * from another gadget or a random directory.
 	 * Also a function instance can only be linked once.
 	 */
+
+	if (gi->composite.gadget_driver.udc_name) {
+		ret = -EINVAL;
+		goto out;
+	}
+
 	list_for_each_entry(iter, &gi->available_func, cfs_list) {
 		if (iter != fi)
 			continue;
-- 
2.39.2



