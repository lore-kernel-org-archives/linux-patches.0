Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B4120E307;
	Tue, 12 Nov 2024 10:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408432; cv=none; b=cdY2hcHvUkNyhVYtgPAYd0I/A0ZMiF2fUsyagN9C9s3KKPW1CIbuHyzkHWSfURV+SYd9HtTnm8RIMmdqIFqDg3s3HIN7WYars/FugjUGU1Mmkf/rK/H9vr9MJVASxQyurSANj5WVcuKz8tyEr7HcpWlIF4qhH+8SJx78ipUjv9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408432; c=relaxed/simple;
	bh=JsfZ16XgJQslgSp5liTBwh5blbSXcYpqEA9jS336200=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iWvXw5+c77x6QB6gjoytxQ6N2f0nXQOldAFmLFy6Uyokxs9xDji10pNOqwiqhJmpncRlilSAKyYzM+03V7ajeogqVdGGiHwsd4HaAsc61yg+r4+n6bRjglqM9DdmxmzPerx0DNg75NJHEDkqI4AAM3Erl86arKVPHCfias78xw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VslQO/Z0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VslQO/Z0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4FC3C4CECD;
	Tue, 12 Nov 2024 10:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408432;
	bh=JsfZ16XgJQslgSp5liTBwh5blbSXcYpqEA9jS336200=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VslQO/Z0+1ITfuFy9GRMvNX1Tujddgww7B5Rl5LIdpY4HAEjQovuO3xmAL158eXnf
	 bujZWvfGtR5HIbVNYJp96P9ScGUPnTl3/t8qJB3sNa8+X57UNECmYj1uC0dcF6q/yk
	 toDnW1wWvEAidFap56AE46OAcyRbXmfzhK7X2NC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.11 159/184] usb: typec: fix potential out of bounds in ucsi_ccg_update_set_new_cam_cmd()
Date: Tue, 12 Nov 2024 11:21:57 +0100
Message-ID: <20241112101906.973262095@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
@@ -482,6 +482,8 @@ static void ucsi_ccg_update_set_new_cam_
 
 	port = uc->orig;
 	new_cam = UCSI_SET_NEW_CAM_GET_AM(*cmd);
+	if (new_cam >= ARRAY_SIZE(uc->updated))
+		return;
 	new_port = &uc->updated[new_cam];
 	cam = new_port->linked_idx;
 	enter_new_mode = UCSI_SET_NEW_CAM_ENTER(*cmd);


