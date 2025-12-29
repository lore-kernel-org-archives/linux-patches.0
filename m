Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD830330653;
	Mon, 29 Dec 2025 16:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025729; cv=none; b=Xc5yqNfLi8FYDtuIKw/jnO/t84mu48OjaEqR040vWEDHV/tCZ2KluInQzsf+CospS0FaQZUA/+5QZ3oTjxdkw3SS+45bcgU8an/l0PElZgBykmlM+Luf9mIbOeKDdpMOGO0gFgXYTYSFnXack9aBZ88I39z3SVpxafrPYOEG6AA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025729; c=relaxed/simple;
	bh=Vg1HqFPXy+pGz7Oo4kDJsAJCQbId9ypY/EfbJSi8x78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=msrhnRbXnw84KpbijIqESJaSIufItrIQjl0zYaAmhzPJY/T3r/FlLNFhrVf0NclJrTGq2YX0oTJNkJjqFlSJGeZsXNQt26AWDuIaIHQHdGoNeiRL/ISXDkRzEjOYRq2cd7WmBLX+3oGzrWNVwIJJm8R/uwe96uSFJmfILkZPkh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QoT+PE/n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QoT+PE/n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 397D4C4CEF7;
	Mon, 29 Dec 2025 16:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025729;
	bh=Vg1HqFPXy+pGz7Oo4kDJsAJCQbId9ypY/EfbJSi8x78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QoT+PE/n6EEujVxVXzi1PaKkojaM3/ln1jSzXYk9mJufWplFdUTyRaAZXchGpd87M
	 OL6c2HsxYd0ZRcYuoCDiAGRBQkCxOgSrglxElqT2VgXzTHKGuKcKgUG8Plxp1i65HK
	 obVQBh4LQTn9WXpsUGZlpnPUHNTjqGivIk6XY/r8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Vatoropin <a.vatoropin@crpt.ru>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.18 309/430] scsi: target: Reset t_task_cdb pointer in error case
Date: Mon, 29 Dec 2025 17:11:51 +0100
Message-ID: <20251229160735.704663426@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


