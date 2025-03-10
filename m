Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F39E374EA;
	Mon, 10 Mar 2025 18:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630781; cv=none; b=PSTN+FHfGb+ZiHJucGTG/d7R+P7yQS1TKwy2N7RaxRzjLWDxvuogIHjHFe/StVuUtNkb4JOo/UXhEr6WQxm678UQ9pWeCoj36kHSmnpc5c0ulpmUmT5MqNpUcwBX+KQ/Z+8PsqgEItXHtE9RE8P3QGNTWOV2YrdNicFGGhGkPpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630781; c=relaxed/simple;
	bh=bNT3t9+2FRAkG1vjZfvoVxvnZ7L78JaZgMjD/ELvicU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oqct1eFa5Iwi6j1h+NpTcxvLBeZMaLbHWEvu145ZCIIwO8MPhoe601xz5zUsmSes7/+af4IFBjRE1ynZK1/efmKq71AkAZXuYHExURDZxwth78uDDh4Yh4UJA4jU1ZcBYj5tmcfgFxXZ+UvGaDKRDACs6ghZQC3g7XSYBZUdYPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jTOYdqlx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jTOYdqlx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7D76C4CEE5;
	Mon, 10 Mar 2025 18:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630781;
	bh=bNT3t9+2FRAkG1vjZfvoVxvnZ7L78JaZgMjD/ELvicU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jTOYdqlx/jLB4G0S/6jK5PgGvguOa/JKUBc/a1LN4j5ItWE8bFE8BvsRZmPhEJYbJ
	 hB7b4L/GgoRaSFbWvQdt/0ngv1hWQG3SPFUIUAwrmLYgja3r8j6MGcY/Cmt6Xan2we
	 ViSq9xQlniJmoDjRBOC6vlod6eWPaoE44I0n5DYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 5.15 533/620] Revert "of: reserved-memory: Fix using wrong number of cells to get property alignment"
Date: Mon, 10 Mar 2025 18:06:19 +0100
Message-ID: <20250310170606.581776584@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Rob Herring (Arm) <robh@kernel.org>

commit 75f1f311d883dfaffb98be3c1da208d6ed5d4df9 upstream.

This reverts commit 267b21d0bef8e67dbe6c591c9991444e58237ec9.

Turns out some DTs do depend on this behavior. Specifically, a
downstream Pixel 6 DT. Revert the change at least until we can decide if
the DT spec can be changed instead.

Cc: stable@vger.kernel.org
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/of_reserved_mem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -105,12 +105,12 @@ static int __init __reserved_mem_alloc_s
 
 	prop = of_get_flat_dt_prop(node, "alignment", &len);
 	if (prop) {
-		if (len != dt_root_size_cells * sizeof(__be32)) {
+		if (len != dt_root_addr_cells * sizeof(__be32)) {
 			pr_err("invalid alignment property in '%s' node.\n",
 				uname);
 			return -EINVAL;
 		}
-		align = dt_mem_next_cell(dt_root_size_cells, &prop);
+		align = dt_mem_next_cell(dt_root_addr_cells, &prop);
 	}
 
 	nomap = of_get_flat_dt_prop(node, "no-map", NULL) != NULL;


