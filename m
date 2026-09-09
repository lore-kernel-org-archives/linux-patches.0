Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52614581228;
	Wed,  9 Sep 2026 14:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964285; cv=none; b=jJ4R82R0f4moJoD8dWQafrUNIkEcedazbnH8fqWRfaGCkjfhpiM7Jx7zEC0bNqm0JM1JZQHBZBIxY5sfKM1VeHr5wYZsLVHe+JDPXbIIEGu+tVvaBC66at2N9bx9k8PG84k0b71yF1p8OwZftyi8v1LcUPPErXiWPn7VwySA0ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964285; c=relaxed/simple;
	bh=Mq7a6MFRiAt1mu3GOlnM/DLYTR32JGKbcuNlsXkLVqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E4e72Xb+iw2fkzRoBqnvAXg6pwQz1seQ2qzamMGP3qDVwPGJrwIDM+ebKIFkPid4CimRJBwIoxiqJl70C5vdvQU5f8tsKir4q1ZoXu6YzT2KhDfwfKIZOypOX33ARRB94/H+XRDKYAUu/vIXC70yO7u2PhZNFxbZf+2iWaphcUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tRJcVjXO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tRJcVjXO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CB151F00A3A;
	Wed,  9 Sep 2026 14:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964284;
	bh=vTYUSWIpyCdfDrirvvISyFuVAShD00BUEkjniJHhziQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tRJcVjXONXzja04AyXnh3EkhK9Syt3LmMM//ZaA5lQKTQmvgxmJnSBqpMZY7XgtZU
	 FF825TxKOlhnGMKtSnrDpkNCipBot0KZaZDymWk8TdQZYm6kxSWAQlDEKSLuHhrmoo
	 RjNzkG0/Skeqq44Qr80/xFNmPGXA86wh7mjcV26o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Osama Abdelkader <osama.abdelkader@gmail.com>,
	Steven Price <steven.price@arm.com>
Subject: [PATCH 6.18 371/583] drm/panthor: harden firmware build-info bounds checks
Date: Wed,  9 Sep 2026 15:40:56 +0200
Message-ID: <20260909134250.882307237@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Osama Abdelkader <osama.abdelkader@gmail.com>

commit 8321b093fa6c297b80586460ce6914d9655df170 upstream.

panthor_fw_read_build_info() checks whether the metadata range fits in the
firmware image with hdr.meta_start + hdr.meta_size. Both fields are u32, so
the addition can wrap and let an out-of-bounds range pass validation.

The function also reads the "git_sha: " prefix without first checking that
the metadata is long enough, and meta_size == 0 can underflow the NULL
terminator index.

Use subtraction-based bounds checking and reject metadata that is too short
to contain the expected prefix and trailing NULL byte.

Fixes: 2718d91816ee ("drm/panthor: Add the FW logical block")
Cc: stable@vger.kernel.org
Signed-off-by: Osama Abdelkader <osama.abdelkader@gmail.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Link: https://patch.msgid.link/20260720113212.11981-1-osama.abdelkader@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/panthor/panthor_fw.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/panthor/panthor_fw.c
+++ b/drivers/gpu/drm/panthor/panthor_fw.c
@@ -657,7 +657,8 @@ static int panthor_fw_read_build_info(st
 		return ret;
 
 	if (hdr.meta_start > fw->size ||
-	    hdr.meta_start + hdr.meta_size > fw->size) {
+	    hdr.meta_size > fw->size - hdr.meta_start ||
+	    hdr.meta_size <= header_len) {
 		drm_err(&ptdev->base, "Firmware build info corrupt\n");
 		/* We don't need the build info, so continue */
 		return 0;


