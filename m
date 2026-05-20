Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8082D39B4AE;
	Wed, 20 May 2026 16:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294364; cv=none; b=GdwaR+2p6387t4kR4jhcHSi2SP5pI1hUin8y0ZT5GrxDkEDvg1aOHCXK1/BjJ6yo639hfxyuEHLPBqOGeh91Gx8pZ6sL/tpxMqeXlQbuTS3Ez+wE27rXZqNbmj7A/i3asD0Xjq8NvtiL3M16CT29Ol1GidzU7FZeKPQOEVv/Ez0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294364; c=relaxed/simple;
	bh=U8qX6sOP29giCfc+XQvJo3/rWJsH8uMRu+nFBep8/Tk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OMPPuy8WPTUu07jiuzfmj2SH/R0JdTh8jsM6FQqk+IsCPTITJqNLw6/iM8iml5wEGHp4DklqxpKagC7nZZzsXGRge2AqT0rX3qqGZTez8f5aNBQMsoZFAwwIDapXhJWxlEtyrao3cvUXt94456NYELIBXRU14Ky2eNy7yc9y++w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kOV86/kp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kOV86/kp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA9101F000E9;
	Wed, 20 May 2026 16:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294363;
	bh=VtYZSel5iLTR3+g8Nv5PJMHk/rL5qCI7wR+YzId8ISk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kOV86/kpOAMzOGjLEGxCt8WuXB9O5Hu/vMkcPyAuaZjaszKSJJ2SX26GMKYP8VgkX
	 yNb+HKKkwhoEWRzSi9Ok504Q9Vm+pgeewcuJLyt67ZMawZZ4P4HsFiLx0AcOPBe8w/
	 3CxLtUEAh/knW8XuiLYoiQ8Hccfuyws/ErCFBwCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cole Leavitt <cole@unwrap.rs>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0012/1146] pstore/ram: fix resource leak when ioremap() fails
Date: Wed, 20 May 2026 18:04:22 +0200
Message-ID: <20260520162148.669892758@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index ed97494abf60f..0713ef986c204 100644
--- a/fs/pstore/ram_core.c
+++ b/fs/pstore/ram_core.c
@@ -488,6 +488,10 @@ static void *persistent_ram_iomap(phys_addr_t start, size_t size,
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



