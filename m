Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F5254F4049;
	Wed, 30 Sep 2026 15:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783919; cv=none; b=bAFDeJCZwi1fTXJtTKMxhA329GXlLPxkHi8Gp5rS80C/54LrOQMRMaiL6WFa7DrhD+wysv70xK/bpCb/4K6ZQh08EVSEa19MWshxgWGZYQi+wTAuVeHXzousYpnUoslIpiwUQrrgAenQyYXwsn9d9x+FKpz5w39XBDuFFjclcFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783919; c=relaxed/simple;
	bh=470FanY1inLPmsX0IRclhpo+0HtzXQGfs2rdczS633I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JOzjAtrTDPzcHrPy3X9lEoGwHLffhjdbWkACXzGh9I2zK4BjutXlZ139dvp/EUYal5+DlFZN7uotGEEUzASFuldfsslXQpsxaGZTz6324CP/8KQHS1TzFlKxtpaHCVpanYaOz1WIDnk68806dtdbaUSmBnZZC436v3jiFUEtcA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qJaCv++b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qJaCv++b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ACDD1F0089A;
	Wed, 30 Sep 2026 15:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783915;
	bh=PG2ncsra7ReEugwF3fWRpDKCLWFAb5Ia3pdS7qQBpwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qJaCv++buErwyrhfpqzuH4KJCYr40EPDmfwL7Wv2j2ck7mZsmAPEUxnTGxYFJJNNf
	 HA3aCyNuxhSlBKypkc1QA8X71dCYCzBZ6OSh3NSqlU/3THtCuLOxjpThpuvux+LYEA
	 rgR27eXXjAzHWa6qW/q+ZU+g/eSJJ0u6QIDS6Lqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Lyude Paul <lyude@redhat.com>
Subject: [PATCH 5.10 567/595] drm/nouveau: Fix gem reference leak in validate_init()
Date: Wed, 30 Sep 2026 17:27:40 +0200
Message-ID: <20260930152359.920116511@linuxfoundation.org>
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

commit 5ea72f7b7139b123713a7983448f910bc4514d9e upstream.

On the ttm_bo_reserve() failure and "vma not found" error paths, the
loop breaks without adding the looked-up object to any validate list,
so the reference taken by drm_gem_object_lookup() is never released;
validate_fini() only walks the spliced lists.  Drop the reference
before breaking out on both paths.

Fixes: 19ca10d82e33bcfe ("drm/nouveau/gem: lookup VMAs for buffers referenced by pushbuf ioctl")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patch.msgid.link/20260916180202.2090231-1-vulab@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nouveau_gem.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/nouveau/nouveau_gem.c
+++ b/drivers/gpu/drm/nouveau/nouveau_gem.c
@@ -421,6 +421,7 @@ retry:
 			if (unlikely(ret)) {
 				if (ret != -ERESTARTSYS)
 					NV_PRINTK(err, cli, "fail reserve\n");
+				drm_gem_object_put(gem);
 				break;
 			}
 		}
@@ -430,6 +431,7 @@ retry:
 			struct nouveau_vma *vma = nouveau_vma_find(nvbo, vmm);
 			if (!vma) {
 				NV_PRINTK(err, cli, "vma not found!\n");
+				drm_gem_object_put(gem);
 				ret = -EINVAL;
 				break;
 			}


