Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2B92336ECB;
	Fri, 17 Oct 2025 15:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714356; cv=none; b=pYHNx6vkeuXF6xhoHkGS20AGmHlQ0YoqZkljJbfIAfmNfLDI+CZ2IScaxmsAWCIBovoX6VxW9UdwNk7wMdfN+v7XApM2s/ofJmftaurjQKCX7vntvNkn2EJD3hnxTbVirz0eBV8OEPgroVsppd6vKTq+bl3JxB5DN26CcNiaHhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714356; c=relaxed/simple;
	bh=zTnJD+cEhzz+//T9vaX/l8zJRIyBnZDdlSCG+3UCR9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XQ+psiepvauFsrBx4j5b3q22+7H/+VMiViQ+Hpw9IFuH4WRZQLW5tOjvNfGsvXZnsH7sEQeGP/Q0rh0cq6xjan69QQ3TxOyyALdbr38kCE/C4KX2JwdiyOyMZMLdBXxd4Gc58tpl9a6uZqDY7OlCcu9qcTtzFpJhqQ6qQO2KS8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z8o4w5NG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z8o4w5NG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68A6CC116B1;
	Fri, 17 Oct 2025 15:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714355;
	bh=zTnJD+cEhzz+//T9vaX/l8zJRIyBnZDdlSCG+3UCR9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z8o4w5NGf8D+B6wALnCL9LYCU9BHRSsvs1iEAPPBn1KlyU8ecquCAD+BzCeJImJm2
	 xmAQWCqe/l3k7915cAy7i5+aTJxwfGZgTDls1BqawMNJiNFMxUQIZQfvTN5kHM3wp5
	 1ywDkyRea5N+zFPv5xSdcvtgvwAe1ZJAV3ITA9F4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Vorel <pvorel@suse.cz>,
	Shuhao Fu <sfual@cse.ust.hk>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.12 117/277] drm/nouveau: fix bad ret code in nouveau_bo_move_prep
Date: Fri, 17 Oct 2025 16:52:04 +0200
Message-ID: <20251017145151.397818059@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -852,7 +852,7 @@ done:
 		nvif_vmm_put(vmm, &old_mem->vma[1]);
 		nvif_vmm_put(vmm, &old_mem->vma[0]);
 	}
-	return 0;
+	return ret;
 }
 
 static int


