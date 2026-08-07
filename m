Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEA004746B7;
	Fri,  7 Aug 2026 15:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117701; cv=none; b=t9/VUlClaRA1IossYNhel83DprikKokS5QnjXVln0Lz/e3wH10oBuJxJF0dTQJ+drlqJ2EOqqcSCCjqCJkZ3itBO4wwlXKD555P5pqqIhff68jdQCHrf7lqZJdCcU1JWOQLYKjD+0emwbIJ2lmBl5RSV2mxodkDmcmaMe6gNCrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117701; c=relaxed/simple;
	bh=IKUfCx57KbE5ZA5LT8tIfrRWse3CXaQ7WwX8Zht+Bsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dJxBl5ytDFLlwcGmtbSwlLRjGWQuK73cpe8QrJ/UHPsWY01418CNGl1Mxy45H33jMF4vUvhIbBB/zjl2zlgSrr37CoBHy8RItflOOnrOB8zsbRr91mt8NnJeRH4vMfJYPs27x4C445ICZunarIKiMFm0mZbsLEqjpXS0fTTJw/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o8EPWrog; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o8EPWrog"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 067EE1F000E9;
	Fri,  7 Aug 2026 15:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117700;
	bh=WiSwArTilISxCCyaObj64Od0uTzm/l/mklpNONAh4Xs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o8EPWrogEO0o//wPVBrklnnxx8AQjnwNtGS2+zoYRXgtdLWqLqbmr/sS1TS8ohgzo
	 nTsVmV+vTeImMhCpxDgMOqAK+kx3qXkzQHDvN8tZntHmNFxLP2e3Q8j3XmtZg3Sxx3
	 0iNTv34cTa4vtpFGG7wQKWdv0Twv3NDZc/0O+N4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zack Rusin <zack.rusin@broadcom.com>,
	Ian Forbes <ian.forbes@broadcom.com>
Subject: [PATCH 7.1 412/438] drm/vmwgfx: validate DRAW_PRIMITIVES header size before division
Date: Fri,  7 Aug 2026 16:40:08 +0200
Message-ID: <20260807143436.748401862@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zack Rusin <zack.rusin@broadcom.com>

commit 85891d174707d8bddcec7a888fb4e1d17def34f3 upstream.

vmw_cmd_draw() computes

	maxnum = (header->size - sizeof(cmd->body)) / sizeof(*decl);

where header->size is u32 and is taken straight from the user-supplied
command stream.  When header->size is less than sizeof(cmd->body) the
unsigned subtraction wraps to nearly 4 GiB, producing a huge maxnum.
Any user-controlled cmd->body.numVertexDecls then passes the bound and
the loop dereferences decl[i] far past the end of the kernel command
bounce buffer, producing an out-of-bounds read of kernel memory.

Reject undersized headers up front.

Fixes: 7a73ba7469cb ("drm/vmwgfx: Use TTM handles instead of SIDs as user-space surface handles.")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4.7
Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Reviewed-by: Ian Forbes <ian.forbes@broadcom.com>
Link: https://patch.msgid.link/20260505222728.519626-7-zack.rusin@broadcom.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
@@ -1571,11 +1571,17 @@ static int vmw_cmd_draw(struct vmw_priva
 	uint32_t maxnum;
 	int ret;
 
+	cmd = container_of(header, typeof(*cmd), header);
+
+	if (unlikely(header->size < sizeof(cmd->body))) {
+		VMW_DEBUG_USER("Illegal DRAW_PRIMITIVES header size.\n");
+		return -EINVAL;
+	}
+
 	ret = vmw_cmd_cid_check(dev_priv, sw_context, header);
 	if (unlikely(ret != 0))
 		return ret;
 
-	cmd = container_of(header, typeof(*cmd), header);
 	maxnum = (header->size - sizeof(cmd->body)) / sizeof(*decl);
 
 	if (unlikely(cmd->body.numVertexDecls > maxnum)) {


