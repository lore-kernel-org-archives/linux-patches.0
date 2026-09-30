Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5A073BE642;
	Wed, 30 Sep 2026 18:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792716; cv=none; b=N0J+kjHpsv/W1s1aN+HfkS0GBflfSYv1pn6vGfuk5OwQQJYGlXgr2u97QCf2j79+CXy8n5mOaGxtRdqlK4UvJ35M2bRU3iYKQDu9e1LnpymMFXa0nLtRztX8Pjt/QpUH54I/0j0OR+Dai8mk1+CRlHrUMO6ahrv3HPdhiNWtc5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792716; c=relaxed/simple;
	bh=iRDckxoOFhcbNKi9NL3N83mvADHQLQpDVu4dtUA+eiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OhQWyzXbpn7FWsPKYSA2+QUw3Z5e75atme6nLWQ5Zy46AOR+VRbCFeoEvrMkfhyEcUFaQKCrYUrXbJobUBLKgZHhUsgt8uN38S/kIGh9m2tUVX1bGXTbc/BqgpvcwmYA1fPxCrhi+toZQAdXl/sadZYWwBJEIvBzGokxoTh9UHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s8Jo1RCR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s8Jo1RCR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB4861F000FF;
	Wed, 30 Sep 2026 18:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792715;
	bh=SZtlEj76h0NSX8VjRqhJIl6Ss8h3R2hYTYUrjO7Helo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s8Jo1RCRu9HE7LwhzdgVJrot6D3+W1xuCqUp+rRWw/qoSlvLUFQh7rQLh5v4NgVkm
	 3R88T0ARXLojy3+rrr3zyHOHE0WWMCEfsXeaF04+UJqPrHxfYuoupF2HNiIEoruL9P
	 Yu4OGTGqgjJlkYPvYVL5YQ1jokniYZWljoXgmlGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Lyude Paul <lyude@redhat.com>
Subject: [PATCH 5.15 709/752] drm/nouveau: Fix bridge reference leak in nv1a_ram_new()
Date: Wed, 30 Sep 2026 17:29:39 +0200
Message-ID: <20260930152413.573416201@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit 67b4411538c8341692548429d43256f25be99f7a upstream.

pci_get_domain_bus_and_slot() takes a reference to the PCI device,
which is never released once the memory size has been read from its
config space.  Drop the reference before returning.

Fixes: 2fa6d6cdaf283c05 ("drm/nouveau: deprecate pci_get_bus_and_slot()")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patch.msgid.link/20260916180036.2090118-1-vulab@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nvkm/subdev/fb/ramnv1a.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/nouveau/nvkm/subdev/fb/ramnv1a.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/fb/ramnv1a.c
@@ -51,6 +51,8 @@ nv1a_ram_new(struct nvkm_fb *fb, struct
 		mib = ((mem >> 4) & 127) + 1;
 	}
 
+	pci_dev_put(bridge);
+
 	return nvkm_ram_new_(&nv04_ram_func, fb, NVKM_RAM_TYPE_STOLEN,
 			     mib * 1024 * 1024, pram);
 }


