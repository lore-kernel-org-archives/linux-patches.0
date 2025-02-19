Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B611B4F0C;
	Wed, 19 Feb 2025 09:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956680; cv=none; b=kMp+5almbLkrMXJaRW8zUAoRaXnwDWIVQTVLIXdAGgorCpKZ06Nodkhs9WN9LH6Mthglxx7iF78GH5x1TF0pnQlzP3g0d9aDMmVzm52tAy0FHXb1lYGI8lq3bQ5GZapNhE7SS6cJit19xprNmqQz+hIv9kb9CoaXbPoJaiQFmac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956680; c=relaxed/simple;
	bh=1bC2HDm4hmDUGd1ZHuWcm4WkIEyYMgjLSyAsf2jog7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Os+XD+pWExtuGFGlfxlZYMaxh/c6F/fbubSSIEHuNXfnyols/QllsvxjudUzbcZGxgX7ApIPN21Tc5jrpQTJYL3MDG8EjRTSsIrZaSuykFQ4/e4GmmHzhi19T2qB6CKEQlk1G6oUCfSPXV7K4s4tU8k1s1suu4heHH8oc2ix5PY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wzff2kB5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wzff2kB5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C5D7C4CEE8;
	Wed, 19 Feb 2025 09:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956680;
	bh=1bC2HDm4hmDUGd1ZHuWcm4WkIEyYMgjLSyAsf2jog7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wzff2kB5f9RotkZPfP+45oamz22f4sITjhDwc8Y9MtSGzBBrUnJsdEunPqGGwydYK
	 VPRIfXcrcHdUtxF5z65sDDW9GtZ15IoS6tVgbIfMWJbJrjSPosFtXNFWPdRrn3mjYB
	 wcShWnumLobkz+2kf12Bb3+ly0UCSuc8wB3OyKUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.1 263/578] usb: gadget: f_tcm: Dont free command immediately
Date: Wed, 19 Feb 2025 09:24:27 +0100
Message-ID: <20250219082703.369401606@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


