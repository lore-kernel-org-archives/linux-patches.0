Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB28F2E6D2B;
	Tue, 15 Jul 2025 13:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587023; cv=none; b=QRiW7mtH/hiLbddL2LROflhRnboFRHT3QBI7piEFNy+hp2va+k7IJIzXU+XVOQPoCr1t+vFgtKuxnHJy1LRtKhMcVa+1jQtkxxDHT/ff7HbKmjfmuHlguR90BtTwWptBF5vvQXzIukjYtg7HA5STiGtu5q4koLiLpRUr64DpqnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587023; c=relaxed/simple;
	bh=v+ly67Eq2NDrKwgpcwKUMnwt2hq2EjjUgnrBVsTxdss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LHv6KvD2vr6PZXROVnC94067oN+PF3DItHMbFzKwJK+2ONz6K85aLFUXqXcnMjwTxwvDm37NRpNmPU653ywotH241QxDEPEJQKpqR05oQmyT3JZRB446x8PnKf7S1DRb4o9k6sLqQ+IjPaly/fgwGrBVq66zguQNnp8WdBWRZpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TXgrE94q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TXgrE94q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E5A9C4CEE3;
	Tue, 15 Jul 2025 13:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587023;
	bh=v+ly67Eq2NDrKwgpcwKUMnwt2hq2EjjUgnrBVsTxdss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TXgrE94qnDU7DVvZWkL52MfpxJG2utTPyKWWOc4VimP3N1z5P4YbVGYWpUSi3kiDt
	 GY073Gc/EtQrIS7yQI+2uC7b9eUSoTJHm58NMoARQlhIU0H3SCVGpuo5WZcDVI8QFn
	 Ridw/Vjj5yYbidbLG3Wmj+VFpA9hDEY8tClmR7as=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danilo Krummrich <dakr@kernel.org>,
	Ben Skeggs <bskeggs@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 138/192] drm/nouveau/gsp: fix potential leak of memory used during acpi init
Date: Tue, 15 Jul 2025 15:13:53 +0200
Message-ID: <20250715130820.441589958@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Skeggs <bskeggs@nvidia.com>

[ Upstream commit d133036a0b23d3ef781d067ccdea6bbfb381e0cf ]

If any of the ACPI calls fail, memory allocated for the input buffer
would be leaked.  Fix failure paths to free allocated memory.

Also add checks to ensure the allocations succeeded in the first place.

Reported-by: Danilo Krummrich <dakr@kernel.org>
Fixes: 176fdcbddfd2 ("drm/nouveau/gsp/r535: add support for booting GSP-RM")
Signed-off-by: Ben Skeggs <bskeggs@nvidia.com>
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Link: https://lore.kernel.org/r/20250617040036.2932-1-bskeggs@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/nouveau/nvkm/subdev/gsp/r535.c    | 20 +++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c
index 53a4af0010392..d220c68bfe914 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c
@@ -1047,7 +1047,6 @@ r535_gsp_acpi_caps(acpi_handle handle, CAPS_METHOD_DATA *caps)
 	union acpi_object argv4 = {
 		.buffer.type    = ACPI_TYPE_BUFFER,
 		.buffer.length  = 4,
-		.buffer.pointer = kmalloc(argv4.buffer.length, GFP_KERNEL),
 	}, *obj;
 
 	caps->status = 0xffff;
@@ -1055,17 +1054,22 @@ r535_gsp_acpi_caps(acpi_handle handle, CAPS_METHOD_DATA *caps)
 	if (!acpi_check_dsm(handle, &NVOP_DSM_GUID, NVOP_DSM_REV, BIT_ULL(0x1a)))
 		return;
 
+	argv4.buffer.pointer = kmalloc(argv4.buffer.length, GFP_KERNEL);
+	if (!argv4.buffer.pointer)
+		return;
+
 	obj = acpi_evaluate_dsm(handle, &NVOP_DSM_GUID, NVOP_DSM_REV, 0x1a, &argv4);
 	if (!obj)
-		return;
+		goto done;
 
 	if (WARN_ON(obj->type != ACPI_TYPE_BUFFER) ||
 	    WARN_ON(obj->buffer.length != 4))
-		return;
+		goto done;
 
 	caps->status = 0;
 	caps->optimusCaps = *(u32 *)obj->buffer.pointer;
 
+done:
 	ACPI_FREE(obj);
 
 	kfree(argv4.buffer.pointer);
@@ -1082,24 +1086,28 @@ r535_gsp_acpi_jt(acpi_handle handle, JT_METHOD_DATA *jt)
 	union acpi_object argv4 = {
 		.buffer.type    = ACPI_TYPE_BUFFER,
 		.buffer.length  = sizeof(caps),
-		.buffer.pointer = kmalloc(argv4.buffer.length, GFP_KERNEL),
 	}, *obj;
 
 	jt->status = 0xffff;
 
+	argv4.buffer.pointer = kmalloc(argv4.buffer.length, GFP_KERNEL);
+	if (!argv4.buffer.pointer)
+		return;
+
 	obj = acpi_evaluate_dsm(handle, &JT_DSM_GUID, JT_DSM_REV, 0x1, &argv4);
 	if (!obj)
-		return;
+		goto done;
 
 	if (WARN_ON(obj->type != ACPI_TYPE_BUFFER) ||
 	    WARN_ON(obj->buffer.length != 4))
-		return;
+		goto done;
 
 	jt->status = 0;
 	jt->jtCaps = *(u32 *)obj->buffer.pointer;
 	jt->jtRevId = (jt->jtCaps & 0xfff00000) >> 20;
 	jt->bSBIOSCaps = 0;
 
+done:
 	ACPI_FREE(obj);
 
 	kfree(argv4.buffer.pointer);
-- 
2.39.5



