Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E347935946;
	Wed,  5 Feb 2025 15:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768613; cv=none; b=jS4zOWxNHyU7RgTHOt1+C55aVriH+HnwwKmAPkPyr1PtKTOAHLy2dfQmpWFJnT2zxFM5e0OMxCLj0bST5Rb6kZwHYByzD+nUTRAMekl+2qEEaxNTQPo1y6vNJEnE/wedtj2rOORbdeE60DJGrX7EnMYv2ByRl+wpvm9RpMeYmyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768613; c=relaxed/simple;
	bh=tAoxc+WOZU+te16IWAMQw792sakkvWw8e2AxRJfcxSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BaPbUlQ8LUYtZLje7U12ct5nPlqn9QCoK69MdJl8oz3px7uSAUa9p3CHyqIe/P7pINOn20r5xP2XKAqjitbeUARCwElKqZXsPi79yc+B749QIFcaY9kmOgeFWzJKzIW8q01ZiZIjMK7FCJeCg6n5s+N7PFsJ2nrYNm3eWfmu+eI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DpuYveRc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DpuYveRc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66652C4CED1;
	Wed,  5 Feb 2025 15:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768612;
	bh=tAoxc+WOZU+te16IWAMQw792sakkvWw8e2AxRJfcxSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DpuYveRc0/IBHjyrjLaghGLvzwd/kO7obEfuJRuIwatHwlOIKttNggVvpP9JFpH3N
	 J6qAUyiMjkxzoFC6Yw/UKFXwyCl/xtOdMjf4/hVyA9QZrUjIr5924xxHiAXAe1tD39
	 iH3L2Um5+IIZJooqBb3L5D0mMLztsy563o11L4DU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.13 607/623] usb: gadget: f_tcm: Dont free command immediately
Date: Wed,  5 Feb 2025 14:45:49 +0100
Message-ID: <20250205134519.441633672@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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


