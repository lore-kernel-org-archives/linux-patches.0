Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CE7825BAAC;
	Tue, 11 Mar 2025 15:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706661; cv=none; b=mbC29QvdrB6oS7r5l5LGvi3Ajeyq05558zYNmhAVNIOR4CZ2TTeZdK3YO4LEeBvJSHHiXmGsl9j5VnUm2LbE5RNSroD4fuNvKLndFDjhXpKmPG0cEoAng9fFpyxkiGyGS0QiyIqRt7L/X3hLBO5QLIr22GHp3zEThylKE6rOFzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706661; c=relaxed/simple;
	bh=JW0KGSSf0jg3hYOqnqRHKeSYLCFcOKL/sg7rgY3jAMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cYjXvQEcH8atDrYy1Qt2dTifqafZc1Fvtg/zMzx+CTA0Qg44kkXUtfpTH6UFdmX0OgRO/vJ+KJJyI9Jj/9+xQjBOMXGv5eVO4bg4ZdeozhL+EzJ8YEFNoad/qUpDifEsYi/lodlJTZg4NJ3fJIpM5L4pgtX/i82cVGe6L5srSH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rqm+C1eN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rqm+C1eN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CADB1C4CEE9;
	Tue, 11 Mar 2025 15:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706661;
	bh=JW0KGSSf0jg3hYOqnqRHKeSYLCFcOKL/sg7rgY3jAMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rqm+C1eNwV2fRD4u2BUgYS+srySdg14tCIQkLgZdrcxlD7XKeXTVuL77etBg3SteC
	 ary8W3dnVwAvvd8iSs5GOHhRMDlMBXtR20RuloIxwuLeaU58ikOr2GaYikNWS3wJ+E
	 g+4XYld/RtJz333Q9KfVs5zFrPez2KEZa+0VmTx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 5.10 124/462] usb: gadget: f_tcm: Dont free command immediately
Date: Tue, 11 Mar 2025 15:56:30 +0100
Message-ID: <20250311145803.259596686@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1068,7 +1068,6 @@ static void usbg_cmd_work(struct work_st
 out:
 	transport_send_check_condition_and_sense(se_cmd,
 			TCM_UNSUPPORTED_SCSI_OPCODE, 1);
-	transport_generic_free_cmd(&cmd->se_cmd, 0);
 }
 
 static struct usbg_cmd *usbg_get_cmd(struct f_uas *fu,
@@ -1199,7 +1198,6 @@ static void bot_cmd_work(struct work_str
 out:
 	transport_send_check_condition_and_sense(se_cmd,
 				TCM_UNSUPPORTED_SCSI_OPCODE, 1);
-	transport_generic_free_cmd(&cmd->se_cmd, 0);
 }
 
 static int bot_submit_command(struct f_uas *fu,


