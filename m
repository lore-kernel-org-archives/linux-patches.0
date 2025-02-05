Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAED41802AB;
	Wed,  5 Feb 2025 14:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766695; cv=none; b=KtkBeSTAB3NnLtzSUm0msAhw1BNF9x2XYeWcrGNblhzo+oyCda+94Y9yOjqxmRjatFYyD+QHRMY1w7KJsC6nEtebK/bU4tbSFzX6iHrVmpzikdZqU4IlxVZvHfXZkhZ/52+wXYTms+C4PVal6hbQmrlHv2Xb7f4Xy1BUphqQz6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766695; c=relaxed/simple;
	bh=BXCJfM3AXZ3EkAUMWpk7YT3yz3Lgli2VpiyseoKvGG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r25l8kjvf3MgmVnYHQ2bj5gplwmSTLoDxvH1FUqCiaut1VxcaOPez19tYpFbvn7fHhQvQcayg2Xr1nufhqENd7e5rXGBJcp8uh97yno5RRLfGbH4Za9ITzS45GMQOkYsaHuasMIyXttWJf/PKHNT7vNKZ7RZZRxaKTi/MiUVUQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HL4ULoMa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HL4ULoMa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5C98C4CED1;
	Wed,  5 Feb 2025 14:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766695;
	bh=BXCJfM3AXZ3EkAUMWpk7YT3yz3Lgli2VpiyseoKvGG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HL4ULoMaLb3prFUkLqfc/JiHFZyOIascLPj1OfHmhoQl7jQOjmxoIyQrjt81b00dj
	 Zn9Jp1lvjw+sIfEmSjlrN1CxeY7B34FTS4Ro3hJcMYvjNdxkH3Lj10/DvGDcn+F0px
	 +Xz/SpmOIir4sksUSe6UCvlfNmTJZzt8hMJHogkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.6 388/393] usb: gadget: f_tcm: Dont free command immediately
Date: Wed,  5 Feb 2025 14:45:07 +0100
Message-ID: <20250205134435.140022295@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


