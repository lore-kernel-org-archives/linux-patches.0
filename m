Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E92F3330B1F;
	Fri, 17 Oct 2025 15:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716394; cv=none; b=Vj94G39iSeGvh+ZQCWqtpZE7P4jFr8uYNlYkGZB7q0nQ5JF/4XEiUiwm1mldpNEvPT1Ah526QsHY5aVC92F5g37goag1qwsYh9kZ+nq2Y+BcDrfxify5aMJSP03o7ieY48skZJa4d0xkF5DOnPhzP1dKTNygAFes46YrKCszVv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716394; c=relaxed/simple;
	bh=tEM7CUpDYALJWsB74BUF5dQWhkDaEjbkkVIohBGax/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D4l2bLYiZp/OFfCg9YVqEDbLvBCyoCF12MB4RNaHsiOs4xGyjy+sH4GxUttJlZvvknrDOjY6D6gp4XeyzKTssjI96RVuNZQOeAn6k9S+OMgqobXj1C8w5H4tNK+o7+Dx4UN7IwkrD2AL3P3SHLmgSgO4ssTwJqib66vOKvc/EKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JoxhgJDo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JoxhgJDo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64589C4CEE7;
	Fri, 17 Oct 2025 15:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716393;
	bh=tEM7CUpDYALJWsB74BUF5dQWhkDaEjbkkVIohBGax/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JoxhgJDor9jnuw0JD/A2LA/YRzh8pv4IWMOL4OmtYTdN98+o7G3ngcABcf+S0Py9M
	 iVZ8JVawAsh7eMiSbV3vPP0Qti211U6bUawnuAEZRVAGXay0yueH19hYk6hioDQDZT
	 t+Jtu8CxQvLIDtUP/8t1JOBBtQ2RAIdWRXUhXVAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Vorel <pvorel@suse.cz>,
	Shuhao Fu <sfual@cse.ust.hk>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 5.15 174/276] drm/nouveau: fix bad ret code in nouveau_bo_move_prep
Date: Fri, 17 Oct 2025 16:54:27 +0200
Message-ID: <20251017145148.827303825@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -791,7 +791,7 @@ done:
 		nvif_vmm_put(vmm, &old_mem->vma[1]);
 		nvif_vmm_put(vmm, &old_mem->vma[0]);
 	}
-	return 0;
+	return ret;
 }
 
 static int


