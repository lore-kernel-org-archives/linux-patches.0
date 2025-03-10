Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5738423236F;
	Mon, 10 Mar 2025 17:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629164; cv=none; b=GrXn8y0SutTWCm/bsWHG/4enNGMrB73Zceg4O/Br6lXtDmqphnhnWnQjlQXhtXiSlb2FwsLurmi9eyZe35wkXE7HHaqnG2cx4gGyovqFWbkZorGNpftJYtpXXKIhsdqvHy3fmmx/WdwrdUKgbKA46J/YUNlQAI9JOHKjwihuzsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629164; c=relaxed/simple;
	bh=dVp9yt4Hsff8qu0xv7BQXB9j6LDnFt0JCBYNVXC+21I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FNhGFQpGEJ5wi4ZPj3gQEiS6K3S8q+GDNTrCxdD0no8nsL/AWY9MdTmkV933QLmXzK4TwYgnkT5h7aQyZAehUtF835wpDRne3f/cP9aB44iySpCiWzUNPpbdWCQ/HFbdPgLE8na2LPrV1mvJiUjpC95xHIoCuvPCllleNZqgq/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VGDf7OW3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VGDf7OW3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F141C4CEE5;
	Mon, 10 Mar 2025 17:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629163;
	bh=dVp9yt4Hsff8qu0xv7BQXB9j6LDnFt0JCBYNVXC+21I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VGDf7OW34sxeKnSCVCyep4ZhBEeA9NOjADjhMmeTQAKx+rXzZE+DVbgMW2GDTFS4c
	 +pfB1bHBJ7LUVkxnACOZUGXcUSnKbZ0/YJCCvm8QPiOFUDaLNBlzDnESpn3sBPMni7
	 2BmJRr2Qs35BUGqq7OLgLR1k9cqqM7NcVBksQibE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 5.15 199/620] usb: gadget: f_tcm: Dont free command immediately
Date: Mon, 10 Mar 2025 18:00:45 +0100
Message-ID: <20250310170553.482203756@linuxfoundation.org>
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

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit c225d006a31949d673e646d585d9569bc28feeb9 upstream.

Don't prematurely free the command. Wait for the status completion of
the sense status. It can be freed then. Otherwise we will double-free
the command.

Fixes: cff834c16d23 ("usb-gadget/tcm: Convert to TARGET_SCF_ACK_KREF I/O krefs")
Cc: stable@vger.kernel.org
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/ae919ac431f16275e05ec819bdffb3ac5f44cbe1.1733876548.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_tcm.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -1066,7 +1066,6 @@ static void usbg_cmd_work(struct work_st
 out:
 	transport_send_check_condition_and_sense(se_cmd,
 			TCM_UNSUPPORTED_SCSI_OPCODE, 1);
-	transport_generic_free_cmd(&cmd->se_cmd, 0);
 }
 
 static struct usbg_cmd *usbg_get_cmd(struct f_uas *fu,
@@ -1195,7 +1194,6 @@ static void bot_cmd_work(struct work_str
 out:
 	transport_send_check_condition_and_sense(se_cmd,
 				TCM_UNSUPPORTED_SCSI_OPCODE, 1);
-	transport_generic_free_cmd(&cmd->se_cmd, 0);
 }
 
 static int bot_submit_command(struct f_uas *fu,


