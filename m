Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35F0224677F;
	Thu, 28 May 2026 20:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998472; cv=none; b=XCk/Ib4HnuLQq0nTeKaOhjXWJxLu/4Fm9YYzljl/3jPJA7YwJNl2Du3vxznZgzN4eWcpOGqMoIDzBvCMEad99Jc5zLz6p8UItvIOoNJesnnV0GMi0UWCSLEppTV3IEz7yyCtg6NGznBgqX14EkKSkUSA7PdYXoohwE4UGgmgdvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998472; c=relaxed/simple;
	bh=rq4SUR9/Z3z8WH5nxgzAj1X1/AAujMeDI7lD2EfQH7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=snIIRzKBziil3KpGMJlMzU08tbAV5j5lwH1nrpV1OIbDHoOoiBdNXPSvIgezL7K4eTTFJubYgZbvjMkqegyFCt9d5Q1lIepoeNKDAwclNRlpXU9HIBq9CPrnGmvjkfY2BgVT281mxpyY+KuaHqvHoK0LLh8qWjDycxp4ROd1z/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XMd0vGpy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XMd0vGpy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 522AD1F000E9;
	Thu, 28 May 2026 20:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998470;
	bh=FowXgyKjfQu8Qbj9ZvZ1zY4r84MnLcHFNCNOEHFF3Mk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XMd0vGpyTLLG2RCJMqIy43ply2fYagdBTtWuoH3ecVpAJLJag7+ixiqtTvGdXqZoz
	 6rlqXGEYpMwqPjjec62KgRG/0v6NJeyyOEnWOfDxU4Hh3ANw6Xg+WZ5i2OVpMXSMAS
	 t84SdAsVe0eZXKILvn+uOUtLheBifRekEr7euCHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 184/461] mm/memfd_luo: report error when restoring a folio fails mid-loop
Date: Thu, 28 May 2026 21:45:13 +0200
Message-ID: <20260528194652.402387980@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

From: David Carlier <devnexen@gmail.com>

[ Upstream commit 0fb1daf0b78d0e23b63b6b65de56d4a3fd83bc14 ]

memfd_luo_retrieve_folios() initialises err to -EIO, but the per-iteration
calls to mem_cgroup_charge(), shmem_add_to_page_cache() and
shmem_inode_acct_blocks() reuse and overwrite err.  Once any iteration
completes successfully, err becomes zero.

If a later iteration's kho_restore_folio() returns NULL, the failure path
jumps to put_folios without resetting err, so the function returns 0.
The caller memfd_luo_retrieve() then takes the success path, sets
args->file and reports the restore as successful, leaving userspace with
a partially populated memfd and no indication that anything went wrong.

Set err to -EIO in the kho_restore_folio() failure branch so the error
is propagated to the caller.

Signed-off-by: David Carlier <devnexen@gmail.com>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Fixes: b3749f174d68 ("mm: memfd_luo: allow preserving memfd")
Link: https://patch.msgid.link/20260415052300.362539-1-devnexen@gmail.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memfd_luo.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
index cfd665a5b7874..bb5f601418032 100644
--- a/mm/memfd_luo.c
+++ b/mm/memfd_luo.c
@@ -412,6 +412,7 @@ static int memfd_luo_retrieve_folios(struct file *file,
 		if (!folio) {
 			pr_err("Unable to restore folio at physical address: %llx\n",
 			       phys);
+			err = -EIO;
 			goto put_folios;
 		}
 		index = pfolio->index;
-- 
2.53.0



