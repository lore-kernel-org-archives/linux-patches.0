Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F5C0281379;
	Thu, 13 Feb 2025 14:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457765; cv=none; b=WGBVGkQWO6Mi0bppaL2TmpYebc2Z/GsEz82Pci8SrdYpUzHDh36Zdqmjl9cZ/5T4BVjgfXkhxBHfpr+5uEjBUqJZapsIhr+YcRQWz+0YxnwcQZl1lZUgCUoeEDBTV8JzO2clxQsSJJXC9k65Txk6mGjqPcvUA/Tp6XLaOvjDBuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457765; c=relaxed/simple;
	bh=MtXU019nvs9F6xBTu5J2wfyzf59j5yJ53Kf5xO53rLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uWbY0RCnkxPEIBe+qT9g/KXMMeQymc6T3r44Hhu8RiuTY+JoGcZmJDjn8cR4GvjEROtBNrn5GWFVmLaQsKpElEUgyXrzZfBXMZp5UbC+z2liYG+FnhKiT/CSNgww3nt+4e/4DTcJ9X6YLTMfvumyOn/GFfIPRAWv8qkhcqUFveo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CBW12T6H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CBW12T6H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F30A6C4CED1;
	Thu, 13 Feb 2025 14:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457765;
	bh=MtXU019nvs9F6xBTu5J2wfyzf59j5yJ53Kf5xO53rLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CBW12T6H0H35EDRxmz+m/R8wxXHti2uwOO584Iew2DglnsbJ5tYRZ1QPyMFW6bPps
	 14ERlmKqpSSMh+TYwwbqYi6Grmt/i14WQp4lb3YdgwUrmFdMrp84Sx/OAeRXlgBtkJ
	 j7h2D5ii2Js5VrHkjgxsmMCa+gdzZPMrMUoDrYfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.12 208/422] usb: gadget: f_tcm: Translate error to sense
Date: Thu, 13 Feb 2025 15:25:57 +0100
Message-ID: <20250213142444.566900975@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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
@@ -1065,7 +1065,7 @@ static void usbg_cmd_work(struct work_st
 
 out:
 	transport_send_check_condition_and_sense(se_cmd,
-			TCM_UNSUPPORTED_SCSI_OPCODE, 1);
+			TCM_UNSUPPORTED_SCSI_OPCODE, 0);
 }
 
 static struct usbg_cmd *usbg_get_cmd(struct f_uas *fu,
@@ -1193,7 +1193,7 @@ static void bot_cmd_work(struct work_str
 
 out:
 	transport_send_check_condition_and_sense(se_cmd,
-				TCM_UNSUPPORTED_SCSI_OPCODE, 1);
+				TCM_UNSUPPORTED_SCSI_OPCODE, 0);
 }
 
 static int bot_submit_command(struct f_uas *fu,


