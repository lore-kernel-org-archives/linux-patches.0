Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 664912D023;
	Mon, 10 Mar 2025 17:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629342; cv=none; b=f6zNg/vDdIhpW/JqYoP4+Mi7DsuxpvbQCxc70i8JPweCldXRetyNX/1wiBXb6KSkyO3cdanl7RY2gmnR5AXJNHE7lyCwQZ4QXnpMjH/A8giXDEQCstLuuWeA+r+xhmRMgFXwAIJFGMy3nMayF2wuQ7RbDu/uNVqG7xa1wnYKuqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629342; c=relaxed/simple;
	bh=ldMkKIqzkeIVsMB2T4EVylegWe6s0xNC8OnFENajQ1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aJN1uk7qaYh5Hvz6Z7OtIPZgJAdwm0ee9G/9YF4qXrnBgCkqk1kKzGG/FmxgkI6UIwyuKbFGYdmHA/y79gudo5MXVSzeBa+RxySUIrwjmJz8sEFPBj0O3Q1XB7KcgRE4wyv6huRkq3gcAr1+FRyHy7J3fL/1WX4/pQsnWJeKwF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sLRLhxmt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sLRLhxmt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFC46C4CEE5;
	Mon, 10 Mar 2025 17:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629342;
	bh=ldMkKIqzkeIVsMB2T4EVylegWe6s0xNC8OnFENajQ1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sLRLhxmtBmPqJsbsC5Zyi091KfHdqYFjdrR55Ip+yKdpKWFeiUY38d4epdeyeLInk
	 6NjgqcTkuXi25VpX1ynssQjhHu9VLb09yMhoqCF96g39GRKZs9QRT+4eexF3TU2Gyf
	 pG/1Is9h29dISFamb/4sol4A7rWSl8rEYIqInoHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Liviu Dudau <liviu.dudau@arm.com>
Subject: [PATCH 5.15 262/620] drm/komeda: Add check for komeda_get_layer_fourcc_list()
Date: Mon, 10 Mar 2025 18:01:48 +0100
Message-ID: <20250310170555.968634357@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

commit 79fc672a092d93a7eac24fe20a571d4efd8fa5a4 upstream.

Add check for the return value of komeda_get_layer_fourcc_list()
to catch the potential exception.

Fixes: 5d51f6c0da1b ("drm/komeda: Add writeback support")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Acked-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://lore.kernel.org/r/20241219090256.146424-1-haoxiang_li2024@163.com
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/arm/display/komeda/komeda_wb_connector.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/arm/display/komeda/komeda_wb_connector.c
+++ b/drivers/gpu/drm/arm/display/komeda/komeda_wb_connector.c
@@ -160,6 +160,10 @@ static int komeda_wb_connector_add(struc
 	formats = komeda_get_layer_fourcc_list(&mdev->fmt_tbl,
 					       kwb_conn->wb_layer->layer_type,
 					       &n_formats);
+	if (!formats) {
+		kfree(kwb_conn);
+		return -ENOMEM;
+	}
 
 	err = drm_writeback_connector_init(&kms->base, wb_conn,
 					   &komeda_wb_connector_funcs,


