Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0397235B139;
	Fri,  9 Jan 2026 12:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960565; cv=none; b=kBrq5knQ8CdUlOFntw0+l4/h0cMC7bSdX07c3ZiDGAuvPGldQxcsLCZDvS7uVsM3uZ50/fYTUXwlWs+FLKPKt7f9IuHlyyXMmL+RhKJT2NOklB+145yF53FKqBKauGzdD4KqbWZgm9OLkvz0Yo8BzAOMSpNzUP4r9/uuVdEnalI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960565; c=relaxed/simple;
	bh=zgrDCxinRA1KZcsTZSpoe/Z8n5T8F7dmADfCSbEjUac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NFUT4RqUCXgST5EbDbQVSnZtwMJ7ZrlZ5f1ugF2HlNJol8/Ou7OUYM1mAzA3oZ2NnMqOqOzMQVb6K90A6gqTvTqtgpNpMrhFbnOX54WY5bi5vJxyXFZKjwd9IUtYhHfG5feQ0JBeVuqXOiv4QtgWdUDpGRyQRdleT5vVtwMEh2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OLE5AM4e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OLE5AM4e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8516CC4CEF1;
	Fri,  9 Jan 2026 12:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960564;
	bh=zgrDCxinRA1KZcsTZSpoe/Z8n5T8F7dmADfCSbEjUac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OLE5AM4e2Fgl6KJiMLQ2QmYoLNYonYVlTk32caQDsE8EpzJdf/jQJCtpQrIu+MIng
	 KhLNjeS5qO1tWTTX+r/gxbqgnnujh9JpR8SN6yLGi5dUZP3JzAHURpEjtkd6R1evDs
	 o6n1nAAcHAlXkaq7OzYtYmsY4P040hnFkNEheoD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Vatoropin <a.vatoropin@crpt.ru>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.6 448/737] scsi: target: Reset t_task_cdb pointer in error case
Date: Fri,  9 Jan 2026 12:39:47 +0100
Message-ID: <20260109112150.849274206@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


