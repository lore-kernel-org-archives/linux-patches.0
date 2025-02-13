Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 370C8148855;
	Thu, 13 Feb 2025 15:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459321; cv=none; b=P81eRF0ponlXBCv567JnoJ1UY3fDZZsn05JqVbZjdOylK07qZxDaI8wNyWJpREVFoIIATqoWhXaHrbyQhRDdpBNcl9VxZKV5hTaLHo32k3Yxsr5+BkcOJpynGKj9zlxFNbUe0fwK1zBvxETmKTtBy9K4SP1gFD0IbmGbfL4t3aY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459321; c=relaxed/simple;
	bh=mpO+wJ2a/ZCMN5YzWIyLStl+UItoi0geKGFXildanYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dIpOan8BaeCM6MSyrOQVMBU7lf1GJcJ8oj/6BZrkrVAwh3P5yNplCt5gRKnkGziUuDu0WKR6O/O3274aS7V9Nve1aJCBGzWn4aH18kl2E2PKlBReWNhfM0CN6FAXbR+FW7Rg9QqVMvN5f5ycJFY2I3ifI6VRKQ1O3ex6fzJF9H0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OchVjRcO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OchVjRcO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41FB9C4CEE5;
	Thu, 13 Feb 2025 15:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459320;
	bh=mpO+wJ2a/ZCMN5YzWIyLStl+UItoi0geKGFXildanYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OchVjRcOzWgbwKsm84W69sWjLZmQff2Qfdn7UlnCWe8pKToYm6qXh+qhZQTmYKBRc
	 Sdm/AQDTiw9Lz9VBRd9NzbXP8RRJkbA1oRRDFoPQ1BB2kiPtkonEzBBkt6Lj/ZqwOR
	 LGd/LAdAranB0YmqJalyIBNZpxH8WJHK19gfw1qo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.13 230/443] usb: gadget: f_tcm: Translate error to sense
Date: Thu, 13 Feb 2025 15:26:35 +0100
Message-ID: <20250213142449.489793165@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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


