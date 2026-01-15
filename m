Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CDFE3EDD47;
	Thu, 15 Jan 2026 17:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499482; cv=none; b=cKUZ/UxzC9zBTdGKUV+vePK8vpjynsy+wMeViQyM91Kext9ZDBOAEcaZrfyUwUnnUJZ9UYAka5YqKNvFwFfPfXhaDaBAyVMZgY55zcbrCJD+M3+q2vwUol2ZAA9SbefqlirdWdgmTaHGHLHFvYObzTx374yPFc8iY07wQFvbUMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499482; c=relaxed/simple;
	bh=rgOZxQOc9+AgadC7a3TC/5x8jsTgCUwDuENfEnI/tLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iY9O0VV8mlE39uKzHDkTuXN29ZM9+u2skd9zQhJNmFOl8FJyvb1wd9zxZJewUvILS3A8zY/0l1RNuSncRG7cCX1uZHgJbhQ547yjvMh0+If9B6OPzZ8JVGFJ00CfCr+JJr9JRSBvxL2ThPwZ9yaxmnWmUE/X0fGwcZfnCPHWfwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IsLydBBr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IsLydBBr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1C80C16AAE;
	Thu, 15 Jan 2026 17:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499482;
	bh=rgOZxQOc9+AgadC7a3TC/5x8jsTgCUwDuENfEnI/tLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IsLydBBrlITRNHGyLNbe7wptYzV2OXc/8KTP0T124jsn7VdoW38f/4W7j815w9Bkd
	 PC46EDSQN0Fr8C94vONzjSfds0qxhycwl814LfzM2d1rxwNIHApDxnpZPFK6xQ3y6b
	 E+llpd1Vc9+9QUxiEUqKKmDK5UpKo7HzVwFIqdbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Vatoropin <a.vatoropin@crpt.ru>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 243/451] scsi: target: Reset t_task_cdb pointer in error case
Date: Thu, 15 Jan 2026 17:47:24 +0100
Message-ID: <20260115164239.683481264@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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
@@ -1449,6 +1449,7 @@ target_cmd_init_cdb(struct se_cmd *cmd,
 		cmd->t_task_cdb = kzalloc(scsi_command_size(cdb),
 						GFP_KERNEL);
 		if (!cmd->t_task_cdb) {
+			cmd->t_task_cdb = &cmd->__t_task_cdb[0];
 			pr_err("Unable to allocate cmd->t_task_cdb"
 				" %u > sizeof(cmd->__t_task_cdb): %lu ops\n",
 				scsi_command_size(cdb),


