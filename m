Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0A325DAFF;
	Tue, 11 Mar 2025 15:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705626; cv=none; b=Vn2qpSkyb+9PkqAz7GYvSIKR08voJdX50rfG9/oxXpmlgYrrm5OVJlFHoEiFH0/benN79xaEwcIrUG1v3A8cv7gqdodFfPdvlQeO/Tgz5HZKf3oRzMQzBGLgEOiv21YPnCbK+DgHycRqpRi6lzwVCbmRk07yXGXxDWpRVijVy6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705626; c=relaxed/simple;
	bh=WfiAKIYZ9ZT54NER5k9aPbmbLxVpGdX+dEPHQ7UVxEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MAR4lDv1CogsIzHozF24V1f8++rYow9OL53/Ww5ogmPHUnmh5ZDRcVOWmWmj8Q8VC7FZjjik8eF4VBvVoP6w7Gmgn/X/6HXoLd1dcKH+R5DedpzwdKXcIJ31Xewj9E9bpcnCbDHbEHoxkM2CUcArkdM8tQ9zB0/TTDdJG62/DJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dOxUPffM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dOxUPffM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A17FC4CEE9;
	Tue, 11 Mar 2025 15:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705625;
	bh=WfiAKIYZ9ZT54NER5k9aPbmbLxVpGdX+dEPHQ7UVxEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dOxUPffMJLjYh3MsUUyvpLM1oUbzKQX9oe+JpLzminMDvcxuGL9I5vbHGn/kXZrHO
	 ukPKBAb++b1FfUQei4cDs8E/Wg4zIvMQdyUq4j1bJgr6X2RwkFvGKk6bMo6hGdqWO/
	 q55ecQZcjpNwQ7mgdto4r8WUn2RaeCc/a/k23wpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 5.4 081/328] usb: gadget: f_tcm: Dont free command immediately
Date: Tue, 11 Mar 2025 15:57:31 +0100
Message-ID: <20250311145718.106568505@linuxfoundation.org>
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
@@ -1064,7 +1064,6 @@ static void usbg_cmd_work(struct work_st
 out:
 	transport_send_check_condition_and_sense(se_cmd,
 			TCM_UNSUPPORTED_SCSI_OPCODE, 1);
-	transport_generic_free_cmd(&cmd->se_cmd, 0);
 }
 
 static struct usbg_cmd *usbg_get_cmd(struct f_uas *fu,
@@ -1194,7 +1193,6 @@ static void bot_cmd_work(struct work_str
 out:
 	transport_send_check_condition_and_sense(se_cmd,
 				TCM_UNSUPPORTED_SCSI_OPCODE, 1);
-	transport_generic_free_cmd(&cmd->se_cmd, 0);
 }
 
 static int bot_submit_command(struct f_uas *fu,


