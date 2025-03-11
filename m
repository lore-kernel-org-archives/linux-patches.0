Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B22E25E816;
	Tue, 11 Mar 2025 15:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705729; cv=none; b=QFrFoJLnMjmabBAZFhFz09VtP6iaoBMRUpfSleXJdm2bDkuf2ZMxACBiqalPA514erVymB/g3mvWs7Xrar9D45+vPc4UE3Uk/sOfWWMAh5ZHZoC6H2+E0M72/5AfLDGVxlceP7HImA2sFu2v9vIZZLCb7NzX9q94YYztapUH/Dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705729; c=relaxed/simple;
	bh=B3pF5MB1yfqNHrxU5n6sTjayV9CkWJ6R8LcMUZEsmJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dughL6NRXf92h7Vh0u42zJNNUbol+hDI9Ct4tMt3zG9yFbBVTwrjCBuS/CRD5i8cUNF7wbtbAatzW4dtAi3TMVThRpInsG8/HCxSlo6AJIoizbnkmJRzNESnTK2DQ3DFoxzU31oUk171GOQfFbc9TBNyMGaFiBZ7HWg/JY+tLTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nubXYzO4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nubXYzO4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D0C3C4CEE9;
	Tue, 11 Mar 2025 15:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705728;
	bh=B3pF5MB1yfqNHrxU5n6sTjayV9CkWJ6R8LcMUZEsmJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nubXYzO4882bjGjdFXfu/BXSe9Ric3mgAEG4BzmnZaSwlQe84j8JOYhV5LPuH5Mpz
	 J6OhBEI34gZPwpmdYHCSajVyTC5rmSAOaWWHwp+G9+ng2uXHro0JBDiK7PV01hKwSg
	 ifZcQ7Zp/3iRL3zC6PhR4uyFTma/uOilDjTueQKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 5.4 135/328] usb: gadget: f_tcm: Translate error to sense
Date: Tue, 11 Mar 2025 15:58:25 +0100
Message-ID: <20250311145720.269888506@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit 98fa00fd3ae43b857b4976984a135483d89d9281 upstream.

When respond with check_condition error status, clear from_transport
input so the target layer can translate the sense reason reported by
f_tcm.

Fixes: c52661d60f63 ("usb-gadget: Initial merge of target module for UASP + BOT")
Cc: stable@vger.kernel.org
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/b2a5577efe7abd0af0051229622cf7d3be5cdcd0.1733876548.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_tcm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -1063,7 +1063,7 @@ static void usbg_cmd_work(struct work_st
 
 out:
 	transport_send_check_condition_and_sense(se_cmd,
-			TCM_UNSUPPORTED_SCSI_OPCODE, 1);
+			TCM_UNSUPPORTED_SCSI_OPCODE, 0);
 }
 
 static struct usbg_cmd *usbg_get_cmd(struct f_uas *fu,
@@ -1192,7 +1192,7 @@ static void bot_cmd_work(struct work_str
 
 out:
 	transport_send_check_condition_and_sense(se_cmd,
-				TCM_UNSUPPORTED_SCSI_OPCODE, 1);
+				TCM_UNSUPPORTED_SCSI_OPCODE, 0);
 }
 
 static int bot_submit_command(struct f_uas *fu,


