Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4547A15FD13;
	Fri, 15 Nov 2024 06:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653866; cv=none; b=fDuI0DNytDqWHhtsKzWQlgyjaS/EEDVdn/q0RwWDwkfcZT8gXcrSU2kT5QgS0bkisIGnUxtR5GFPIFJCwsoPeK9JYN8wa2ePlPJFxYINsNOdSlS/WfqPjwKc0SMTFF3hks4qkKmcHCoXKgCTv+O55o3POjX5EPAbn5XJsVKXRSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653866; c=relaxed/simple;
	bh=Z1DRaXAdBbEDhrQA6Z4GzNwtDmLod+0fmGjz5exRBmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KWHgML2ZQyKCNzb3jGdJX5z0tbMK0brCAYOai0bRcHGn/sZGtQrggabHU/5CaiCq6OJiY5wbvH+y6ZtyPgBD6Ajts6YtlF3mrlnCzfUQ0Tas+AR9r4VUpmuLs6ScOztjnEGG+OuPhPEi9apjIU5U02qpamZj3BsuCu58yCei7YY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=En8bKxkq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="En8bKxkq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFCE3C4CECF;
	Fri, 15 Nov 2024 06:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653866;
	bh=Z1DRaXAdBbEDhrQA6Z4GzNwtDmLod+0fmGjz5exRBmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=En8bKxkqHTAUAciCs070g0AeCNEKYqv0dS5zDqjGTWkLrADFa3WKblPZ6AWfcnJgP
	 niIzUwkSGilrnq2reJPby3H4QEN2NcgH0ymVgPxDQ/c8tORLs9iukEZ7PmAadB4SUL
	 GA8z+s2PMZLBQ7QnVVe0Lp6VL7nl6bRu7WzLM7uI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 5.10 57/82] usb: typec: fix potential out of bounds in ucsi_ccg_update_set_new_cam_cmd()
Date: Fri, 15 Nov 2024 07:38:34 +0100
Message-ID: <20241115063727.612709295@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.561151311@linuxfoundation.org>
References: <20241115063725.561151311@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


