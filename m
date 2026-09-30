Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65BDD379C35;
	Wed, 30 Sep 2026 19:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790797004; cv=none; b=NLVVPH1PKh4+5ghCIcOQ+VU1mED7v6vQLQIzOQNFzdMY2GB36Ij7NKRDDJTcPB05E/FNDn678tw5DSdxF0TCnF1nX5ws9fGisXCzch0so6oTf37bMu19vSzxifHGZtN4U+npc7Z67Epn9jOx3g2yjp6N2k+O8ZPSPCapFBV1Rdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790797004; c=relaxed/simple;
	bh=zEjuzb75afwgFexB+nzc4+dig5J0Wr6RXHfbb9U9sQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ArO3qLgEmYEyXqz5PoMuEgrh6PgaLpM9LMvi5lgR6yftVTLOs87VPKCYUtZfHJvw9OgLaTq78DGjZCwKxAZsjxvjJXy8RjqQ0k2Ixtp7OYagzwKFm47KuaIhZzWOFI12tKz9zbL76VseuIeaV0IqtJqNq94VtS8aBIZ5iHPA9iY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EppLioJS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EppLioJS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C06FF1F000FF;
	Wed, 30 Sep 2026 19:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790797003;
	bh=1nnKucO4+VD6v/UkJSZTJyWBaHkBSW3vnkjqjNRSmrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EppLioJS2i1KV9xQSXvUhJaiq51PC23+06Kbf3HbfVYQ/DFaO0Vv0pwcw4/hY17+c
	 GMkNwlM31OGtMtKW4Da7ktv7OQHYsCdDWD6qBlMfMaLPkpAYsIEOdMzIe9EH2hvDGK
	 Dngun5PLVVvnCxbfAlIhYfralDJCrG9ggJFwNxQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Lyude Paul <lyude@redhat.com>
Subject: [PATCH 6.6 1113/1193] drm/nouveau: Fix bridge reference leak in nv1a_ram_new()
Date: Wed, 30 Sep 2026 17:29:57 +0200
Message-ID: <20260930152458.958403556@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


