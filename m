Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C7D3DA5B6;
	Wed, 20 May 2026 18:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301759; cv=none; b=bsxBC+rp/7WjXtWTYyIBgyDPddTqpgozfQum5y4q+1leXtt41HhpWkvKvHYSkJiqFRjj3MynCnb8xC1FLAEAfmshxqW90zsEo7UQej4qbpLPfSjxuWAhgdfAvZmF6sDuDrpd/FbvI49YVqEOjIgqvYV+nWHREo+ffetmlUpxEns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301759; c=relaxed/simple;
	bh=P39NYcGAtnuiF/Hau4tWrAfV/iuz/CpgKlwnpuhqb+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ECpuBjM+m7L5PIzyX7BRcw+GhZOrUW3wyjHhnhcMTHW0BTorooZMBX3p+gQdlApEGY4H6uH06gnnJmkOMXOIYvxAoR/a5loCR6md8Au2XQLRFIjI+MY+ClKeydL9O6EPw6DfMJOF/B1ORdfWJL7YfHKxGx/4N8/WwMsJsTHn7Fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZpQGLf6a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZpQGLf6a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66B701F000E9;
	Wed, 20 May 2026 18:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301757;
	bh=72mb3awnbYp1hVVYNsKAog7oX2A4PxmxkcR53snI0PA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZpQGLf6aweHZKvUyoJfFQ0Msy5fI1mAzsAMnrtQMVWAb0uGSEBFPw2ax1IrsfCRUQ
	 Nf7Wk+GYvBi/EPuY2Ymv1EFWsYRocW7ajovFFViR2nCi7bGpqc/EFULJKv/dhz6Sik
	 ITxst0gm+5B8XiIvqqfaMqhnBnONyOglEBZ+1ifM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 010/508] devres: fix missing node debug info in devm_krealloc()
Date: Wed, 20 May 2026 18:17:13 +0200
Message-ID: <20260520162058.805032515@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danilo Krummrich <dakr@kernel.org>

[ Upstream commit f813ec9e84b4d0ca81ec1da94ab07bfb4a29266c ]

Fix missing call to set_node_dbginfo() for new devres nodes created by
devm_krealloc().

Fixes: f82485722e5d ("devres: provide devm_krealloc()")
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/20260202235210.55176-2-dakr@kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/devres.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/base/devres.c b/drivers/base/devres.c
index 8a0f000221271..8069b7ca26fbc 100644
--- a/drivers/base/devres.c
+++ b/drivers/base/devres.c
@@ -913,6 +913,8 @@ void *devm_krealloc(struct device *dev, void *ptr, size_t new_size, gfp_t gfp)
 	if (!new_dr)
 		return NULL;
 
+	set_node_dbginfo(&new_dr->node, "devm_krealloc_release", new_size);
+
 	/*
 	 * The spinlock protects the linked list against concurrent
 	 * modifications but not the resource itself.
-- 
2.53.0



