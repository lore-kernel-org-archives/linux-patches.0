Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF8821DF749;
	Tue, 11 Mar 2025 15:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706843; cv=none; b=KuuFN3MYs3DowXq+V//hDqiIbnO2pRlnxybafHlXCdaX60Ia1MxOkmY2d8gSlOZjv5z4ooQhPCXBnavAxFCr8os+KyEywFpKJ8mX2RFzQAoKDfbfcuDZRrYZgK//J6T34f9PMQAcZ3XwoIqAyYmj7JpvBcbJoFs+sXd4M5w69vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706843; c=relaxed/simple;
	bh=LZG9Qr3md11er0F4vfneixaaqRYv8latpYuCEAodobg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KCJqvKlQ3QQ2Gu7PgwcthqmlorceaR0d5Mn4TC0tFCWrnB6dyvfoswso8TjFIgH8Zi3EcHgMxs6ZZ1JhLKefNXvbr/YfK62iKGNhShhrZtCG4zyhaRBSI8CrzfAnuK6+Llu115iKf6g4KzwuBzgDiEkmJYWAORny5a2UO4Ml0eY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DxygN8gm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DxygN8gm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BB27C4CEE9;
	Tue, 11 Mar 2025 15:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706843;
	bh=LZG9Qr3md11er0F4vfneixaaqRYv8latpYuCEAodobg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DxygN8gmFNtanXY9daEfkdqIdeSyWHu5yrPqmCVpIjFtyeU5/C9ijelE4YtL7ut2q
	 7zFgQHJmhzdD3xXjyQnt5CS/uJPNOlMtseqWTmRm8v0hVpj1kbJ8breeezKspYgmIN
	 rEwtDE8JkPWpZoZ8xIPkwvAJ7pqxY9hNJFhYix7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 5.10 187/462] usb: gadget: f_tcm: Translate error to sense
Date: Tue, 11 Mar 2025 15:57:33 +0100
Message-ID: <20250311145805.745052440@linuxfoundation.org>
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
@@ -1067,7 +1067,7 @@ static void usbg_cmd_work(struct work_st
 
 out:
 	transport_send_check_condition_and_sense(se_cmd,
-			TCM_UNSUPPORTED_SCSI_OPCODE, 1);
+			TCM_UNSUPPORTED_SCSI_OPCODE, 0);
 }
 
 static struct usbg_cmd *usbg_get_cmd(struct f_uas *fu,
@@ -1197,7 +1197,7 @@ static void bot_cmd_work(struct work_str
 
 out:
 	transport_send_check_condition_and_sense(se_cmd,
-				TCM_UNSUPPORTED_SCSI_OPCODE, 1);
+				TCM_UNSUPPORTED_SCSI_OPCODE, 0);
 }
 
 static int bot_submit_command(struct f_uas *fu,


