Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42ADD21345;
	Wed,  5 Feb 2025 15:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768227; cv=none; b=byrwSwGKLi6/nkwu3Ad+GvX4z4uXnQdvTB2TSIcOUDn1n0QLe52+GCrpg1yBFUQV1HAuu5nGZGJhi25zCax62KuwEI+5UltMdCVnDoNiiJ85OgBclERpuILxwNJOnc5FwdTZbp96s+E4sNAu19upcLfDqOFNNSCr/il3M1NL3co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768227; c=relaxed/simple;
	bh=w8PDmPM8zpWTMjPCGy9LBUdIsaYW+iWbGXJjvMnZR0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JZGQmDtS6gB49XbVH/FA+bEzzt4swtF98FRYNRdIuIS7jzxTS4jN2mYVkp54dUM/5xbjxJZNi0muGTJMj47+hmfwOOcDsQ9NG6eDX2GzOfMAOzT6fIYDgA0FFHzq7nnnICoOyDxzmLytQc+GKojFsmuzGU9uPM4dzCWl8dBK9xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rj4o83/W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rj4o83/W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9C68C4CED6;
	Wed,  5 Feb 2025 15:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768227;
	bh=w8PDmPM8zpWTMjPCGy9LBUdIsaYW+iWbGXJjvMnZR0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rj4o83/WzoEMdqDtNVCN4P1FAyPNaRU1aPDDCl8Xi/YohpYAETTb7D3tMLmZZbjQ/
	 eeAJzNCneA+33YY/lPqzAS8Mcz05sVNBYArpIwzVf4WINKpjIQqZqwjUqHMWEupGq3
	 5Gzdcadp2CWTRAKcrYnxaMlSV8kPePZOhihpZ+zc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.12 570/590] usb: gadget: f_tcm: Dont free command immediately
Date: Wed,  5 Feb 2025 14:45:25 +0100
Message-ID: <20250205134517.074924489@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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


