Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE0225E813;
	Tue, 11 Mar 2025 15:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706852; cv=none; b=nJ2BQ2Dl8cj4unxGhIz/ovLnczMdG1Si9jClZN0VXFQ8CnEa48RJ81atLDOuG9cgrwrWQhjgwalhRwfb23UD8Pg9ucjQa/XL4gfWIYdowEHVqTJIacVeVvSGpgJOrjzGNlfp0RyXb301vvIAqdk0zABwM+k18Ean5K7eQXwJ4wY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706852; c=relaxed/simple;
	bh=0wCnFc3paZjDGlOGn7cpZOH3eAWY+tFvtRsp6MsJ8w8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R0eEY5gJQsbmU8AA79g+jv0zTGfma5QzwiF6HQBma23MsNOaSv48kh9zfo6b06tbxrAzGATOuah3VYLq6laBHHJLpNTJio1vU4Yi/VFLdnMXujJCZYhdQ5UPiLE6j0l9LhcPvyrMFJdr8dQeGlW3tMrgDXDU5FyDU6HkazUW6Xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M5iVxKaj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M5iVxKaj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03E7CC4CEE9;
	Tue, 11 Mar 2025 15:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706852;
	bh=0wCnFc3paZjDGlOGn7cpZOH3eAWY+tFvtRsp6MsJ8w8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M5iVxKaj8bwGGXsFfqvQNuY4ANeCZmcGneu1MF4Un7Hp3LicOUihUk/6hSPLk/JWP
	 KqrC/IoNxyqSanJyf8JShRWOvFZG/Cyf3l4LUZKs9QZ5BhUkaKdkdmdX1LSCATZ6al
	 CE/cs2B4Q9Lvi/Ku7ift6GkOqNX1DH+O1yvfjwac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 5.10 190/462] usb: gadget: f_tcm: Dont prepare BOT write request twice
Date: Tue, 11 Mar 2025 15:57:36 +0100
Message-ID: <20250311145805.865920530@linuxfoundation.org>
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

commit 94d9bf671ae314cacc2d7bf96bd233b4abc7cede upstream.

The duplicate kmalloc here is causing memory leak. The request
preparation in bot_send_write_request is also done in
usbg_prepare_w_request. Remove the duplicate work.

Fixes: c52661d60f63 ("usb-gadget: Initial merge of target module for UASP + BOT")
Cc: stable@vger.kernel.org
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/f4f26c3d586cde0d46f8c3bcb4e8ae32311b650d.1733876548.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_tcm.c |   17 -----------------
 1 file changed, 17 deletions(-)

--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -245,7 +245,6 @@ static int bot_send_write_request(struct
 {
 	struct f_uas *fu = cmd->fu;
 	struct se_cmd *se_cmd = &cmd->se_cmd;
-	struct usb_gadget *gadget = fuas_to_gadget(fu);
 	int ret;
 
 	init_completion(&cmd->write_complete);
@@ -256,22 +255,6 @@ static int bot_send_write_request(struct
 		return -EINVAL;
 	}
 
-	if (!gadget->sg_supported) {
-		cmd->data_buf = kmalloc(se_cmd->data_length, GFP_KERNEL);
-		if (!cmd->data_buf)
-			return -ENOMEM;
-
-		fu->bot_req_out->buf = cmd->data_buf;
-	} else {
-		fu->bot_req_out->buf = NULL;
-		fu->bot_req_out->num_sgs = se_cmd->t_data_nents;
-		fu->bot_req_out->sg = se_cmd->t_data_sg;
-	}
-
-	fu->bot_req_out->complete = usbg_data_write_cmpl;
-	fu->bot_req_out->length = se_cmd->data_length;
-	fu->bot_req_out->context = cmd;
-
 	ret = usbg_prepare_w_request(cmd, fu->bot_req_out);
 	if (ret)
 		goto cleanup;


