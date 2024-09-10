Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84C9818C00C;
	Tue, 10 Sep 2024 10:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725965010; cv=none; b=hVgeFGGwnIC9g9Cf9ulZHWkzUkhjFuz8o+EoxW9dNOMWTI0QBO6Q21Qiz0n5ebjaj37FbCz0t41l0rGoHrTuSkLMOF5k8A9LCtO4cmo+ByyRdp7BiM0526S94XZ0xzh4Ij9f8akHDUEHpivQewnkonkrjJwjcJoXqUBHPNTh304=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725965010; c=relaxed/simple;
	bh=evcYoeN/UuCYb6AEydD6Ec1iIebp8M8DFvBn4X9glXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UdDgk3D+p68Ix6b/++B0lCgotldlgadJxOmsgciBzAbV+hEc1oKTxhQjZH7dtL7oWWCU76wkG9CnGyEiE3FKkzpePEfx/ec3NQrs2VQ11/JWYza7DSTu8fyoa5MfAt9bFcfWI8+KGyDNVsrzi6baKUG2IflNOtqwd/ZA3BwCiDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CbhIMxh+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CbhIMxh+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AC7EC4CEC3;
	Tue, 10 Sep 2024 10:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725965010;
	bh=evcYoeN/UuCYb6AEydD6Ec1iIebp8M8DFvBn4X9glXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CbhIMxh+XuDcSNLGVh+MHVRKs/kFCV013NgPYITODX1DSTlbgcfyxzv0icPXmRU+L
	 v0Q+GGeZec0bRTH/KhQcjwrQh3ObHpIQtDLXopzZWYQBoeWQCpXjaPYijmLWpvji3U
	 kxOCZdVmEWpy9wgB5Mj9eLT+6v4DvtprQsUILe7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shantanu Goel <sgoel01@yahoo.com>,
	Oliver Neukum <oneukum@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 107/186] usb: uas: set host status byte on data completion error
Date: Tue, 10 Sep 2024 11:33:22 +0200
Message-ID: <20240910092558.940348606@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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

From: Shantanu Goel <sgoel01@yahoo.com>

[ Upstream commit 9d32685a251a754f1823d287df233716aa23bcb9 ]

Set the host status byte when a data completion error is encountered
otherwise the upper layer may end up using the invalid zero'ed data.
The following output was observed from scsi/sd.c prior to this fix.

[   11.872824] sd 0:0:0:1: [sdf] tag#9 data cmplt err -75 uas-tag 1 inflight:
[   11.872826] sd 0:0:0:1: [sdf] tag#9 CDB: Read capacity(16) 9e 10 00 00 00 00 00 00 00 00 00 00 00 20 00 00
[   11.872830] sd 0:0:0:1: [sdf] Sector size 0 reported, assuming 512.

Signed-off-by: Shantanu Goel <sgoel01@yahoo.com>
Acked-by: Oliver Neukum <oneukum@suse.com>
Link: https://lore.kernel.org/r/87msnx4ec6.fsf@yahoo.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/storage/uas.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index ff6f41e7e068..ea1680c4cc06 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -424,6 +424,7 @@ static void uas_data_cmplt(struct urb *urb)
 			uas_log_cmd_state(cmnd, "data cmplt err", status);
 		/* error: no data transfered */
 		scsi_set_resid(cmnd, sdb->length);
+		set_host_byte(cmnd, DID_ERROR);
 	} else {
 		scsi_set_resid(cmnd, sdb->length - urb->actual_length);
 	}
-- 
2.43.0



