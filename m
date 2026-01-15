Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2006A86334;
	Thu, 15 Jan 2026 17:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498076; cv=none; b=Ho3YiiCKzEUP72s24fRLVuEs5xOHeczguJmbX72hASLfIEhQisT0Et7oQpih60pNL3zsZgqXXR152MfeevD/dAWeQKFbfDAZvACeRTRdKesYS7sIjuSMyXNcJI73PLcDbiuzdE6Rd4EQjKidNsO0aY/oT2blcC79UJ4r9+ggAJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498076; c=relaxed/simple;
	bh=U1YPfn0qtFilDwD537b2XVDfmpFe+7UiSLSCpt4RGNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fFjOJ+eNl8S7sPCvCPAg6+jWObT1Px3Q5Mc1FyKZDQkOU7zJVzzP7jkBnr+AQ6yNIvDppLnErovKEbznLN2Dfei3jq5PT3goWJ5jsrrFabqhhBbwy7488BRQ6bpZH+iaDPsjuFb+SFWwqQQldGy5Sj+7fuDvuyQSkjkJhYt/mPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rmOSj2vs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rmOSj2vs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78E3AC116D0;
	Thu, 15 Jan 2026 17:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498075;
	bh=U1YPfn0qtFilDwD537b2XVDfmpFe+7UiSLSCpt4RGNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rmOSj2vso/pAn+rkeIdXDdd6tJqn0N28gmI8ZIf0zAFocwGpnPAe1/YDucZXMB9+T
	 saAWlV2T1zfzhxTgqv5BwSfraAu+ltpg8kr5sb9ONnqK0R3yBoCclcB7PMtAgw7zTh
	 Aaa0oHA/Z6SZRl0skBIosCtU+SmJFoLB5tjHAJPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Vatoropin <a.vatoropin@crpt.ru>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 304/554] scsi: target: Reset t_task_cdb pointer in error case
Date: Thu, 15 Jan 2026 17:46:10 +0100
Message-ID: <20260115164257.235216810@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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
@@ -1492,6 +1492,7 @@ target_cmd_init_cdb(struct se_cmd *cmd,
 	if (scsi_command_size(cdb) > sizeof(cmd->__t_task_cdb)) {
 		cmd->t_task_cdb = kzalloc(scsi_command_size(cdb), gfp);
 		if (!cmd->t_task_cdb) {
+			cmd->t_task_cdb = &cmd->__t_task_cdb[0];
 			pr_err("Unable to allocate cmd->t_task_cdb"
 				" %u > sizeof(cmd->__t_task_cdb): %lu ops\n",
 				scsi_command_size(cdb),


