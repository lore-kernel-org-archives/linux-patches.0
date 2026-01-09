Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 571A535BDBA;
	Fri,  9 Jan 2026 12:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962439; cv=none; b=juNdd+64BHz3C980J2ne5iAjlCaTq3aFenZ/XaS1Yp36O5ql+bQXy+thvhZ1spgkm2gdCgrJCFCAasZDx5OQRRNPKK+Cscum7gUO6WTVjn5a1MGgQRtpHi54fqenV18/I/KsdqXHQ+1Ijm6i5k9edmXH9a27zGcYDZoYCtua0iE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962439; c=relaxed/simple;
	bh=IHCrzyyubZGUL8O29g7HTQ3KWDAxWdNZW2HjsW3BgWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d35cLF0lo6oQ/uZaAB2qI+mIE77MmXQklPRwBbiriIU4sLKbC0/8K6VyQ7NiEhGcHQck21npm+WWuXuFcqieRbI9R7hDLVWET3pkdlfoBeU+fj1jrrU2g0NksHTAtYRKhcoGMAJrVi6yK6EPkWHP+OmfkbtoreooXnKfYEcgSzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h722fuuX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h722fuuX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8282C4CEF1;
	Fri,  9 Jan 2026 12:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962439;
	bh=IHCrzyyubZGUL8O29g7HTQ3KWDAxWdNZW2HjsW3BgWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h722fuuXxQNNsKNTjHEXsjbk81QPCoOZv+n+wLrpeCsAuNaKQbumf8+N6u1mu+pRt
	 zdzmn+OFaiYmPJlKCIEcFlIriCQ/Yq5TyrmqIuYRufI+QoYR5VODfefgZXdPXT+54A
	 lSFxzjzXgoEvCMCr46o+MFoOmUHNybVke2Kbi84U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Vatoropin <a.vatoropin@crpt.ru>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.1 348/634] scsi: target: Reset t_task_cdb pointer in error case
Date: Fri,  9 Jan 2026 12:40:26 +0100
Message-ID: <20260109112130.619091422@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrey Vatoropin <a.vatoropin@crpt.ru>

commit 5053eab38a4c4543522d0c320c639c56a8b59908 upstream.

If allocation of cmd->t_task_cdb fails, it remains NULL but is later
dereferenced in the 'err' path.

In case of error, reset NULL t_task_cdb value to point at the default
fixed-size buffer.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 9e95fb805dc0 ("scsi: target: Fix NULL pointer dereference")
Cc: stable@vger.kernel.org
Signed-off-by: Andrey Vatoropin <a.vatoropin@crpt.ru>
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Link: https://patch.msgid.link/20251118084014.324940-1-a.vatoropin@crpt.ru
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/target/target_core_transport.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1524,6 +1524,7 @@ target_cmd_init_cdb(struct se_cmd *cmd,
 	if (scsi_command_size(cdb) > sizeof(cmd->__t_task_cdb)) {
 		cmd->t_task_cdb = kzalloc(scsi_command_size(cdb), gfp);
 		if (!cmd->t_task_cdb) {
+			cmd->t_task_cdb = &cmd->__t_task_cdb[0];
 			pr_err("Unable to allocate cmd->t_task_cdb"
 				" %u > sizeof(cmd->__t_task_cdb): %lu ops\n",
 				scsi_command_size(cdb),


