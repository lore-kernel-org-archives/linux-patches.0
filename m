Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C61313E34;
	Sat, 30 May 2026 18:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166166; cv=none; b=rFtqd8EZ3rpa0zukqjP8tqFHEN5XZB3BhsoaXO+5cxur7waYuww+QZxbqeitj11YTaRH4CCygqD6mRVoPNBrwjarOUT8ClhgL6GSyblJQrn4SC5H/tw6JpbAPV+UwDnx/XxScgkFrt5Xhji6brWSedxhwH68Z80f0UkcxVKWLT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166166; c=relaxed/simple;
	bh=lYsFD/E8qWczhtYyABNNxxL+rfaGjXJ4IhqjkvDXgfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Skn7vCwFtwz9fP1Vya9QEa+DEDwkclYsMJU/hbtUMgppxyvjpx+r2fOT0YME/6fKWq/VoCpl7OEbJaCtwC4Q7nSyUv5Ol21O0fwlbnLnmwmoVTQHErWDL5nApQAFO4sB1gGxkv61x94UDcpRxyk67CAetqyQAahHGssrLB9VitM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=awNZaDtB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="awNZaDtB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37A4A1F00893;
	Sat, 30 May 2026 18:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166165;
	bh=X5tYppN5/feGfn600zf0TLI3W+8mPhRjlGJ1sFB31/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=awNZaDtBkGl8CtupSoFsDuPBbIwxP7YRJIGfK7bX8ZUIa/koGMoJcaiQSF+mJvPe5
	 DDp+h+ORhLeeoLF67VDbgxUi03snzPZPo3PA6rY9k/lfiwCfRt+C+/WSTwfyWqIJbY
	 0pY7nYVGTVCUzicyaK3dZ9mwfrfZpRFDJ983XhGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cole Leavitt <cole@unwrap.rs>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 294/589] pstore/ram: fix resource leak when ioremap() fails
Date: Sat, 30 May 2026 18:02:55 +0200
Message-ID: <20260530160232.668478521@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

From: Cole Leavitt <cole@unwrap.rs>

[ Upstream commit 2ddb69f686ef7a621645e97fc7329c50edf5d0e5 ]

In persistent_ram_iomap(), ioremap() or ioremap_wc() may return NULL on
failure. Currently, if this happens, the function returns NULL without
releasing the memory region acquired by request_mem_region().

This leads to a resource leak where the memory region remains reserved
but unusable.

Additionally, the caller persistent_ram_buffer_map() handles NULL
correctly by returning -ENOMEM, but without this check, a NULL return
combined with request_mem_region() succeeding leaves resources in an
inconsistent state.

This is the ioremap() counterpart to commit 05363abc7625 ("pstore:
ram_core: fix incorrect success return when vmap() fails") which fixed
a similar issue in the vmap() path.

Fixes: 404a6043385d ("staging: android: persistent_ram: handle reserving and mapping memory")
Signed-off-by: Cole Leavitt <cole@unwrap.rs>
Link: https://patch.msgid.link/20260225235406.11790-1-cole@unwrap.rs
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/pstore/ram_core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/pstore/ram_core.c b/fs/pstore/ram_core.c
index ccaa138a57b7c..80bf449a695a7 100644
--- a/fs/pstore/ram_core.c
+++ b/fs/pstore/ram_core.c
@@ -475,6 +475,10 @@ static void *persistent_ram_iomap(phys_addr_t start, size_t size,
 	else
 		va = ioremap_wc(start, size);
 
+	/* We must release the mem region if ioremap fails. */
+	if (!va)
+		release_mem_region(start, size);
+
 	/*
 	 * Since request_mem_region() and ioremap() are byte-granularity
 	 * there is no need handle anything special like we do when the
-- 
2.53.0



