Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D05B8BE46;
	Tue,  8 Jul 2025 16:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993616; cv=none; b=coZzEdOIKR/hrMU5Ch0aqeC3uXmcB1o9GrpY48cR0a70otGiZ4vIN6yxUdigu1cOKPyteTrqp0CE7dpggqI9NLaMj5yI4ndsDrXuiP2bEPJ8ccGKQ9+lxhvJBF0CqZeRc3TywOmXp9LjRmDs/B7Woh0BwAJqEfMQirPdqw43ssQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993616; c=relaxed/simple;
	bh=emSj1hCOYx1Oz8HBRvF3eH/Bi+32WnC58AtIyURxM1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CrKIwpZsg3hss5KjlzT2qh1rtlVXUrzZHGSGnX+tcshGbCEA+9AmjRGraYILEflZBVBM1OkBA3X8hFF8kVxtuS2TozbH+d+6+5RC17AY6fq8U94E+GOm7+MLDqHycwOE+Xk/AO27zOoc6qZo8xRGYo2R8WYZwPTInAFpRFWFfxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uk497aN2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uk497aN2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58A45C4CEED;
	Tue,  8 Jul 2025 16:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993616;
	bh=emSj1hCOYx1Oz8HBRvF3eH/Bi+32WnC58AtIyURxM1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uk497aN2mvTcEmZk4Sm/TZaofUok5zAyfFXM4ItyFIy58IFDQ6z9EG585sKeSRLL9
	 /zXFzaK8z03u2HCH1xv3J/tH22mhWiNRG2tS/dPibS3PhBFIBi+yUUHRLtvpJsGvz9
	 5ZcjVE1/STz233Hqy4R+/cP1OUtYg0jD5EIHraw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Mike Christie <michael.christie@oracle.com>,
	John Meneghini <jmeneghi@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 134/178] scsi: target: Fix NULL pointer dereference in core_scsi3_decode_spec_i_port()
Date: Tue,  8 Jul 2025 18:22:51 +0200
Message-ID: <20250708162240.058183507@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 34cf2c399b399..70905805cb175 100644
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



