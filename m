Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 103C44F3EAA;
	Wed, 30 Sep 2026 17:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787632; cv=none; b=AQcsEHKaVVQi/3Q3rxiflWc+3r+B1HCQ+KgcS+z1hu7vhMwwB6SmQAmq497y+4aqOWIULrKwt9VOIFw3/b1rMsW/EOS6/O1d5c6uIEXJncs/xAkxDp7SWVhTQM7XpOPw6fUUTa1CuxvptdtzvfnkyT5Wgrp24QNCqizSIA0PJxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787632; c=relaxed/simple;
	bh=OlZzKjch8jxebyWygMFLQwcRkGddOJu1pCfoNoU+sjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NY3ur/Z1wIz8btK3sLHUfSeIppOjtOaPWFwNsMcK6KZ3VlVilh8klUQOi4O3OdZH+wYwDvgjEZ17Lr+MUkUyqL+s58xSpK/o+Cb3yWx4HnT75fzfGO8BnhxwZ0IFbtJOKUAZYQKw11wIym54VHoCr3SZRCO8BJVkAj4X2b0xI80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0BqbXN2b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0BqbXN2b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EB5F1F000FF;
	Wed, 30 Sep 2026 17:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787630;
	bh=/tZxokQFqK0uRID7PqstND9D/6rQ3/2pdQW2kic+tAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0BqbXN2bElT+UagT7NQ+L136Om8WmogwH6NkmvpnLhv5brDrimjQ6oQrgeIyvkmEp
	 8WU1Iznsf7FOJBXA7PhXt90CkkQhIZtTWQkgik6UtXo+6lSYTjv4xb5p639hILqEzu
	 +aBncOnqWYj/TainNYTKLtab5rZvmmLpLMBb30NU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Lyude Paul <lyude@redhat.com>
Subject: [PATCH 7.2 296/457] drm/nouveau: Fix bridge reference leak in nv1a_ram_new()
Date: Wed, 30 Sep 2026 17:26:41 +0200
Message-ID: <20260930152352.420196884@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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


