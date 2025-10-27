Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0269532E159;
	Mon, 27 Oct 2025 18:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591279; cv=none; b=u2Nbb6mOtVILvrDfswiNWfp7S9Rwn4wkfIEWKndWlhqaih5clSk6aU8dtkV0U2X6qrDr0pF5KOWeUNk1kauI6TltKkqkPuN6kKHtpAYRxuiagRJuL1Rw6DheSxKTpy9E7i9A7CZWAG8ZG9OD8rewBvlyIRVZkk8Cm8N2Bnxguug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591279; c=relaxed/simple;
	bh=RGovrv8+QtGXwAAS903ebVzHmj05IMCZTOdkDu0ZLcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YuAYGb8Hdwv19EcvrWFOFt6R3VXzKtsWna5TS6XM6rzLfLhCyc4fuM7M3mXEqPmYi/bII6xzoeZoxs4sv9n3DpUprPnyXLT2jQcKHf8lWCgWrkzfEF5GgJurQVGdMwFqLnFV6DNlZzhwH2A7Bmc2fQ26nw7gYoH91K4hciCGPTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L4UAvJEn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L4UAvJEn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39BD2C4CEF1;
	Mon, 27 Oct 2025 18:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591278;
	bh=RGovrv8+QtGXwAAS903ebVzHmj05IMCZTOdkDu0ZLcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L4UAvJEnqfoNpTuGlNfhC6c91pDJVw+OrKzjYaH9gJoMb5KViLo2nkkndU/AWtx3U
	 9ZAEFRTUsW9BmENomlfMpucLJzG0QgNsQ8c6QdpC7J9rqnhdJvWLLDLCH4cKoX7NX+
	 jjUnBC/AsYQQghKla9GWwrvB2qvepDRl2bFfxh/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Vorel <pvorel@suse.cz>,
	Shuhao Fu <sfual@cse.ust.hk>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 5.10 135/332] drm/nouveau: fix bad ret code in nouveau_bo_move_prep
Date: Mon, 27 Oct 2025 19:33:08 +0100
Message-ID: <20251027183528.198102570@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

From: Shuhao Fu <sfual@cse.ust.hk>

commit e4bea919584ff292c9156cf7d641a2ab3cbe27b0 upstream.

In `nouveau_bo_move_prep`, if `nouveau_mem_map` fails, an error code
should be returned. Currently, it returns zero even if vmm addr is not
correctly mapped.

Cc: stable@vger.kernel.org
Reviewed-by: Petr Vorel <pvorel@suse.cz>
Signed-off-by: Shuhao Fu <sfual@cse.ust.hk>
Fixes: 9ce523cc3bf2 ("drm/nouveau: separate buffer object backing memory from nvkm structures")
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nouveau_bo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/nouveau/nouveau_bo.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
@@ -796,7 +796,7 @@ done:
 		nvif_vmm_put(vmm, &old_mem->vma[1]);
 		nvif_vmm_put(vmm, &old_mem->vma[0]);
 	}
-	return 0;
+	return ret;
 }
 
 static int


