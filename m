Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84BEC3AEB5C;
	Sat, 30 May 2026 17:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163880; cv=none; b=DTyOEm0BdBhIpuOaTjwCza8HqXK+oWvL0dQqTkpDddfFS0Bxjaxz/D3pg4ZlX36SNRidep4st1/qH41/efG6tHf2Fxe/i+FgTPb5STwK2AyJpTHlelwntrB7xcfDbRPSUeHRiwkt7e5j02rYy44gwyrnIVKyZ/NyqIlcwsU1/Lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163880; c=relaxed/simple;
	bh=fYyvEiefXNOG40NqhrKBUWXbyBaCSxhyIXSPIzze2Ww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Usjgcs8O8txbaoKydafCW89mITEjWdWwKQDTVV3IMoBD3XqUEfmrq97F4f4xgg+OrS0GxyABo1gYDZY5Uxpey4IqKy8hces/+CLedH+hC+9fItRBASc6M1wgs852XHywy4ko6R74tit8umzSsD9G2R+YIBQZgPLgxx5+VDPQVgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C0Xk2ZjU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C0Xk2ZjU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC39C1F00893;
	Sat, 30 May 2026 17:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163878;
	bh=DNxELC3LYOV/K1eJhoBD9OSlIPex6Mg1ZAaNVluwSa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C0Xk2ZjUlQn0lMmcAnILP0fb+JV4hWjhpMhE6S6rvw9uyCiXEHrWyVFNu/STUYDOo
	 iCQ7LAuEMeL33UanSVn0k4PMnyzCnvsOT0edRH3jsNNLSfkHNR5hsBdBqhhmqsY8WY
	 /DHUzD76a1tDEOHFvY/a4Kjrx7WgaY5LeBH6ah8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cole Leavitt <cole@unwrap.rs>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 388/776] pstore/ram: fix resource leak when ioremap() fails
Date: Sat, 30 May 2026 18:01:42 +0200
Message-ID: <20260530160250.527453931@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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
index c0b3b9c6892d1..8a86b9928503d 100644
--- a/fs/pstore/ram_core.c
+++ b/fs/pstore/ram_core.c
@@ -489,6 +489,10 @@ static void *persistent_ram_iomap(phys_addr_t start, size_t size,
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



