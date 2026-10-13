Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57850248F7C;
	Tue, 13 Oct 2026 12:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894617; cv=none; b=apfIXkwVHEZBnCR11BR67JoesjW2zlUEDZDclD009h+n0WRY01q9wpQLOWvnEnJPuvJ2iiczD9TLPhRKuarKpLrGgNHEQ6ArjbNQg9Y159U0kb0RCeeJGco+nsg/xrdfZzVj1xoYmhdSpQOpP8m5HUch4OI9T33E6PgIMAaCUZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894617; c=relaxed/simple;
	bh=m4HDbYldv53u3scJfLh8gCCZ/8m7CruWKOgTXIEuh+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GKmGDAtOxTsyXcQO0GPKQfVwVdsfBsVGKPYAs0vjE5Ejgtvr7zcTTM9qvvFimVhGQ+K+qWIHdGwnG6afrwaY99eQx0/63U1GlwWao0ZeImhhqLoLq++C84gSHIxlirSTl/wrjaxFnkYQKr7uIn4o+Cfl8Yb2c7iaW01Q/odbHUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jtetjTFY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jtetjTFY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE32F1F000FF;
	Tue, 13 Oct 2026 12:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894615;
	bh=+WsVeZN4doxFLDC0pM+PWipLJ87KuQoGg9Fj1CS+ZuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jtetjTFYmMb68yujQ0PxKE6aJVxXpwzl6AsUKv570vWWOcS8rkuWDm2EUGeT4s9gp
	 zAtWHs8alvG9YmKLAqdR1Ks1e7o6MFw9cL+07MjE5NgH4X82+j4or2rWbs9S/95b/h
	 gkseZJR/MgYDexLL6B3Zz3tuPxr+ayYXbl7MZzSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karol Wachowski <karol.wachowski@linux.intel.com>,
	Lizhi Hou <lizhi.hou@amd.com>
Subject: [PATCH 6.18 618/621] accel/amdxdna: Fix crash when destroying a suspended hardware context
Date: Tue, 13 Oct 2026 13:40:13 +0200
Message-ID: <20261013112935.464590742@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lizhi Hou <lizhi.hou@amd.com>

commit 8363c02863332992a1822688da41f881d88d1631 upstream.

If userspace issues an ioctl to destroy a hardware context that has
already been automatically suspended, the driver may crash because the
mailbox channel pointer is NULL for the suspended context.

Fix this by checking the mailbox channel pointer in aie2_destroy_context()
before accessing it.

Fixes: 97f27573837e ("accel/amdxdna: Fix potential NULL pointer dereference in context cleanup")
Reviewed-by: Karol Wachowski <karol.wachowski@linux.intel.com>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20260206060306.4050531-1-lizhi.hou@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/amdxdna/aie2_message.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/accel/amdxdna/aie2_message.c
+++ b/drivers/accel/amdxdna/aie2_message.c
@@ -273,6 +273,9 @@ int aie2_destroy_context(struct amdxdna_
 	if (hwctx->fw_ctx_id == -1)
 		return 0;
 
+	if (!hwctx->priv->mbox_chann)
+		return 0;
+
 	xdna_mailbox_stop_channel(hwctx->priv->mbox_chann);
 	ret = aie2_destroy_context_req(ndev, hwctx->fw_ctx_id);
 	xdna_mailbox_destroy_channel(hwctx->priv->mbox_chann);


