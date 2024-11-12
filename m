Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D4642141B9;
	Tue, 12 Nov 2024 10:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407197; cv=none; b=Z7iBbgA+252fBJSIdcWQDTt6vIqGwVlVbE1YWiu/K4xBP74+Fq5qcKQNTpwhZTXbYai+rFx8R6V5oMsGQIf96s1nu1dD0ZTUXyfSsSa2NW5XdsYL05axUgtoIez4jRkf2puzPQVZ7Q33AXMSZumQtWxKbZj8vMS1A3Doi543SFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407197; c=relaxed/simple;
	bh=eqacKVqTjeBSbJC5wEZvVmiPSp8SA6nTrqzlY9xDfJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LqNjNJ7XHtEW9NJkyUc8mfDKCY8bCVebymZHJphfSClRPIl1cPXHya/wH8WUNk8hXy/20hU50pVO/djwR5mUpqqBR7oYxjlgPoZmDm/f7kb5llhb5F/Q8FVtRRuwOEwV2qZyol0hdbnKHWmvFa/FLEjPRyzxyBkWWthl4vv0Cvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=REWP/hrG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="REWP/hrG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EACB8C4CECD;
	Tue, 12 Nov 2024 10:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407197;
	bh=eqacKVqTjeBSbJC5wEZvVmiPSp8SA6nTrqzlY9xDfJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=REWP/hrGKv6llgmjYDr36e5tFTj1AaPj9p6T8cUchWIoSBlC6RxhQxBNkw3Y1dxfk
	 mzFsZS+FLaJgibfUL9INQiBgo8WIF+ZPTqOfP9B54wE0Rb4V/whZi2mQCEVBStpXaX
	 fbsbiSihT7SbiFI8HOP4dcs4oGQ1LFMBKphcoHSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 5.15 63/76] usb: typec: fix potential out of bounds in ucsi_ccg_update_set_new_cam_cmd()
Date: Tue, 12 Nov 2024 11:21:28 +0100
Message-ID: <20241112101842.185533958@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101839.777512218@linuxfoundation.org>
References: <20241112101839.777512218@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

commit 7dd08a0b4193087976db6b3ee7807de7e8316f96 upstream.

The "*cmd" variable can be controlled by the user via debugfs.  That means
"new_cam" can be as high as 255 while the size of the uc->updated[] array
is UCSI_MAX_ALTMODES (30).

The call tree is:
ucsi_cmd() // val comes from simple_attr_write_xsigned()
-> ucsi_send_command()
   -> ucsi_send_command_common()
      -> ucsi_run_command() // calls ucsi->ops->sync_control()
         -> ucsi_ccg_sync_control()

Fixes: 170a6726d0e2 ("usb: typec: ucsi: add support for separate DP altmode devices")
Cc: stable <stable@kernel.org>
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/325102b3-eaa8-4918-a947-22aca1146586@stanley.mountain
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi_ccg.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/typec/ucsi/ucsi_ccg.c
+++ b/drivers/usb/typec/ucsi/ucsi_ccg.c
@@ -436,6 +436,8 @@ static void ucsi_ccg_update_set_new_cam_
 
 	port = uc->orig;
 	new_cam = UCSI_SET_NEW_CAM_GET_AM(*cmd);
+	if (new_cam >= ARRAY_SIZE(uc->updated))
+		return;
 	new_port = &uc->updated[new_cam];
 	cam = new_port->linked_idx;
 	enter_new_mode = UCSI_SET_NEW_CAM_ENTER(*cmd);


