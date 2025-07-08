Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B7D52E540B;
	Tue,  8 Jul 2025 16:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993088; cv=none; b=Oi4cNmZ7MWhcUCHjp//dxbd4yYiB1R21SbOFA1BOeFx9OUCiEzGTMCXadeBrvcFwYQ5RWw1s+MlTz0SKUal12ASKLSmXNpVPkYLxjpgag2bgGipY2K17gB8RaEglU5s6+CImmCxYhtFuTIn95Iae7xWeUjHb+LZBmT4R+eEZik8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993088; c=relaxed/simple;
	bh=c+5M6J3dYrPJBMwulX0EfU2IueSqtCVxA8lfgziWJWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=frdqoIM3LtoENMjCECna4OL55OjC064uER7NoU2/pD2Aa9+s9sLEbdRJRB+7sioecuMlb8YGuSBs1ATrg7f42Q0J/faDWxGi7QIRr/sRknihic5jwtLhItb4wdXOI6/4ankh/ZnsvY8TNhs1yjsNKYYckGdxH57RSNedBt13VqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pbj5Ktlv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pbj5Ktlv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A98F5C4CEED;
	Tue,  8 Jul 2025 16:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993088;
	bh=c+5M6J3dYrPJBMwulX0EfU2IueSqtCVxA8lfgziWJWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pbj5KtlvL5KoDpaagPvOFSU/uXwetPn4ruM6uJ+w7+xilO5RaAzMpB+nHFgyVYyop
	 XHsa9ztob6KUU11KwJsNNaT2C8kebcGNzEd0n5nevJEiSxqakzXqjOjAZsQSPm6DkU
	 nyVu10MRkUuQcI7LQGkL9NgF6W0ojIq0wPWejXeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Mike Christie <michael.christie@oracle.com>,
	John Meneghini <jmeneghi@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 183/232] scsi: target: Fix NULL pointer dereference in core_scsi3_decode_spec_i_port()
Date: Tue,  8 Jul 2025 18:22:59 +0200
Message-ID: <20250708162246.223029712@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit d8ab68bdb294b09a761e967dad374f2965e1913f ]

The function core_scsi3_decode_spec_i_port(), in its error code path,
unconditionally calls core_scsi3_lunacl_undepend_item() passing the
dest_se_deve pointer, which may be NULL.

This can lead to a NULL pointer dereference if dest_se_deve remains
unset.

SPC-3 PR SPEC_I_PT: Unable to locate dest_tpg
Unable to handle kernel paging request at virtual address dfff800000000012
Call trace:
  core_scsi3_lunacl_undepend_item+0x2c/0xf0 [target_core_mod] (P)
  core_scsi3_decode_spec_i_port+0x120c/0x1c30 [target_core_mod]
  core_scsi3_emulate_pro_register+0x6b8/0xcd8 [target_core_mod]
  target_scsi3_emulate_pr_out+0x56c/0x840 [target_core_mod]

Fix this by adding a NULL check before calling
core_scsi3_lunacl_undepend_item()

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Link: https://lore.kernel.org/r/20250612101556.24829-1-mlombard@redhat.com
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: John Meneghini <jmeneghi@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_pr.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 4f4ad6af416c8..47fe50b80c229 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -1842,7 +1842,9 @@ core_scsi3_decode_spec_i_port(
 		}
 
 		kmem_cache_free(t10_pr_reg_cache, dest_pr_reg);
-		core_scsi3_lunacl_undepend_item(dest_se_deve);
+
+		if (dest_se_deve)
+			core_scsi3_lunacl_undepend_item(dest_se_deve);
 
 		if (is_local)
 			continue;
-- 
2.39.5



