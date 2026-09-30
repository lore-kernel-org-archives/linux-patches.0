Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67C9A4E36E9;
	Wed, 30 Sep 2026 15:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783916; cv=none; b=ZX1pAsq+Y0zCXEL6f+1O3XFGOSLCCzEapVj6Xui74lmB0l3u+6gd6F6Klmm0AliYNv7BrAdYvBh+Do0IWrrD1ojwDpmtHyPT64mE0y+jRbYIfmJqvzikOA6BRDk/NOPJZHLH23Lz6A2sI3lWph8Ag1JoPx1TVZBG1XhNaEcAn7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783916; c=relaxed/simple;
	bh=Cv9G/EoXZ+lI12JLkowqHtXe0tQeKBdKqUHs2y8jEQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VR4SHxoSZcpUiKfz8l2NcHYMZn1wiJeebA0hmD0YHY+C4jNYwr4g3mNNZwObhcPkN3TDMCS0DX7rVbv/mz/u1RpAAFeCJMj/+4UYyuz2XKITeT+lIRsiT3wSNqvS8P8qYHNYk2EFJnBlgkc2kbFBCVybpoTB60mGnTHEHOraCSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qFddN4ot; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qFddN4ot"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E00011F000FF;
	Wed, 30 Sep 2026 15:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783909;
	bh=iNwsGmrSC81ivWwl3l3CXmwQR9w6TmC4aXyY0QwI9GE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qFddN4otiMSipH87XL39WreLyQ1YcppbMgz3KdG2S4JG6dO9GgZvZ/sSAnoRcPIca
	 HQnpXhRXHYtkt7+oa+yOfW7J182TX1kGiKllMuHgPMFDy2YUIrwo6IOIE5HYEuv3NY
	 poNCtMJ54QDWYSsHRU2LBRNAsxBVYHfaJRvTEKfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Lyude Paul <lyude@redhat.com>
Subject: [PATCH 5.10 565/595] drm/nouveau: Fix bridge reference leak in nv1a_ram_new()
Date: Wed, 30 Sep 2026 17:27:38 +0200
Message-ID: <20260930152359.876844289@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


