Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CB83364C8
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QJq/m0xe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07DC4C433C9;
	Wed, 15 Nov 2023 19:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077822;
	bh=wbe3HjlHzZwBtbfu7npIvLLllsPc7et/aw+rLtQMmjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QJq/m0xe92Fw8vN/GSCAjvuxedrg1lPFosGsIJCfEk2/0lOE/45NXBxuL9VC3VhFi
	 RPJz2W0xEvH+V+E+RhUy0ZTzQ3FTjLG25lSUfP6J1MVWocSI+201mJ+uFn8brBdlhU
	 PGhdRV9uDm4SJLbtns+FBYPMrnf+KhtR/b5XuSvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiasheng@iscas.ac.cn>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 518/603] media: vidtv: psi: Add check for kstrdup
Date: Wed, 15 Nov 2023 14:17:43 -0500
Message-ID: <20231115191647.889376323@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 76a2c5df6ca8bd8ada45e953b8c72b746f42918d ]

Add check for the return value of kstrdup() and return the error
if it fails in order to avoid NULL pointer dereference.

Fixes: 7a7899f6f58e ("media: vidtv: psi: Implement an Event Information Table (EIT)")
Fixes: c2f78f0cb294 ("media: vidtv: psi: add a Network Information Table (NIT)")
Fixes: f90cf6079bf6 ("media: vidtv: add a bridge driver")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/test-drivers/vidtv/vidtv_psi.c | 45 +++++++++++++++++---
 1 file changed, 40 insertions(+), 5 deletions(-)

diff --git a/drivers/media/test-drivers/vidtv/vidtv_psi.c b/drivers/media/test-drivers/vidtv/vidtv_psi.c
index ce0b7a6e92dc3..2a51c898c11eb 100644
--- a/drivers/media/test-drivers/vidtv/vidtv_psi.c
+++ b/drivers/media/test-drivers/vidtv/vidtv_psi.c
@@ -301,16 +301,29 @@ struct vidtv_psi_desc_service *vidtv_psi_service_desc_init(struct vidtv_psi_desc
 
 	desc->service_name_len = service_name_len;
 
-	if (service_name && service_name_len)
+	if (service_name && service_name_len) {
 		desc->service_name = kstrdup(service_name, GFP_KERNEL);
+		if (!desc->service_name)
+			goto free_desc;
+	}
 
 	desc->provider_name_len = provider_name_len;
 
-	if (provider_name && provider_name_len)
+	if (provider_name && provider_name_len) {
 		desc->provider_name = kstrdup(provider_name, GFP_KERNEL);
+		if (!desc->provider_name)
+			goto free_desc_service_name;
+	}
 
 	vidtv_psi_desc_chain(head, (struct vidtv_psi_desc *)desc);
 	return desc;
+
+free_desc_service_name:
+	if (service_name && service_name_len)
+		kfree(desc->service_name);
+free_desc:
+	kfree(desc);
+	return NULL;
 }
 
 struct vidtv_psi_desc_registration
@@ -355,8 +368,13 @@ struct vidtv_psi_desc_network_name
 
 	desc->length = network_name_len;
 
-	if (network_name && network_name_len)
+	if (network_name && network_name_len) {
 		desc->network_name = kstrdup(network_name, GFP_KERNEL);
+		if (!desc->network_name) {
+			kfree(desc);
+			return NULL;
+		}
+	}
 
 	vidtv_psi_desc_chain(head, (struct vidtv_psi_desc *)desc);
 	return desc;
@@ -442,15 +460,32 @@ struct vidtv_psi_desc_short_event
 		iso_language_code = "eng";
 
 	desc->iso_language_code = kstrdup(iso_language_code, GFP_KERNEL);
+	if (!desc->iso_language_code)
+		goto free_desc;
 
-	if (event_name && event_name_len)
+	if (event_name && event_name_len) {
 		desc->event_name = kstrdup(event_name, GFP_KERNEL);
+		if (!desc->event_name)
+			goto free_desc_language_code;
+	}
 
-	if (text && text_len)
+	if (text && text_len) {
 		desc->text = kstrdup(text, GFP_KERNEL);
+		if (!desc->text)
+			goto free_desc_event_name;
+	}
 
 	vidtv_psi_desc_chain(head, (struct vidtv_psi_desc *)desc);
 	return desc;
+
+free_desc_event_name:
+	if (event_name && event_name_len)
+		kfree(desc->event_name);
+free_desc_language_code:
+	kfree(desc->iso_language_code);
+free_desc:
+	kfree(desc);
+	return NULL;
 }
 
 struct vidtv_psi_desc *vidtv_psi_desc_clone(struct vidtv_psi_desc *desc)
-- 
2.42.0



