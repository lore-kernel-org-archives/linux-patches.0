Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03E3E33FE;
	Tue,  3 Dec 2024 15:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238253; cv=none; b=C8W+JSJMFfqsrpcfqkkXP9qU/ZysuHh6AnvfgiFV5EZbYq4Zjnw/DF9UgRQ+IIsq013KD/fQ7XcIAeMTiJWIXoqAA1LOS81Lea96kqzvYF87O4qsWRs98wH3euFqJoQGWii2hPGN6IxfBninIUdfj81ZhlMuGCWzWwagT5VWRB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238253; c=relaxed/simple;
	bh=ZSV6cY7ECoocDWsIEeUcMgfj2DibJ1cTZPLSPDCihrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZkOgmp5wdRvTYQCQBnsj5fBhO/MjSJqPnHBAEYu1JabSo3ib/RhcvWvC+XiOdWNCBQJqXY+2MgjnpI40Po6rWrpMuQKI/4AlcAA+WmMGkb4q3zlPKP9AQNOhCNoc+TazcpQEBDJKlAuqbzTn1pWpc2irJeTILBQIB6lWUfERjZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YJzTQ5/k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YJzTQ5/k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 328AAC4CECF;
	Tue,  3 Dec 2024 15:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238252;
	bh=ZSV6cY7ECoocDWsIEeUcMgfj2DibJ1cTZPLSPDCihrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YJzTQ5/kwUYdcKGUuhcYo0M+v6/pSHaziSpp6HNEOF6YqJ5VlfdwJA0a5Q2r4YGlh
	 LrNR5GiJtbBxig/VBBfnq+jzAVvtiWwBUmVPn87sEX90KLxleXHbsZx2nle36x+hYu
	 i+xcI+xEWEVKGKNp9de7y2TpFTtOlS0uuQZnl2po=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Binns <frank.binns@imgtec.com>,
	Matt Coster <matt.coster@imgtec.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 215/817] drm/imagination: Use pvr_vm_context_get()
Date: Tue,  3 Dec 2024 15:36:27 +0100
Message-ID: <20241203144004.142350917@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Coster <Matt.Coster@imgtec.com>

[ Upstream commit eb4accc5234525e2cb2b720187ccaf6db99b705f ]

I missed this open-coded kref_get() while trying to debug a refcount
bug, so let's use the helper function here to avoid that waste of time
again in the future.

Fixes: ff5f643de0bf ("drm/imagination: Add GEM and VM related code")
Reviewed-by: Frank Binns <frank.binns@imgtec.com>
Link: https://patchwork.freedesktop.org/patch/msgid/8616641d-6005-4b25-bc0a-0b53985a0e08@imgtec.com
Signed-off-by: Matt Coster <matt.coster@imgtec.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/imagination/pvr_vm.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/imagination/pvr_vm.c b/drivers/gpu/drm/imagination/pvr_vm.c
index 7bd6ba4c6e8ab..363f885a70982 100644
--- a/drivers/gpu/drm/imagination/pvr_vm.c
+++ b/drivers/gpu/drm/imagination/pvr_vm.c
@@ -654,9 +654,7 @@ pvr_vm_context_lookup(struct pvr_file *pvr_file, u32 handle)
 
 	xa_lock(&pvr_file->vm_ctx_handles);
 	vm_ctx = xa_load(&pvr_file->vm_ctx_handles, handle);
-	if (vm_ctx)
-		kref_get(&vm_ctx->ref_count);
-
+	pvr_vm_context_get(vm_ctx);
 	xa_unlock(&pvr_file->vm_ctx_handles);
 
 	return vm_ctx;
-- 
2.43.0



