Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 053911940B5;
	Tue, 10 Sep 2024 10:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964141; cv=none; b=bFWyawMAxpKjh7HODlLCfO6E2UjsrX6QhO24nJqG994FG21+Y+6183JoVhMhteK1nOhWh9LV8/M+8a6VS+wFBvC4ehLFrJM/aITt/hIka19w7kcWEBGro1SGhyKOdI8GnsIZ44FfNV0QrBPt2pReCQxVY6Uh05s9Rp0yPHMihJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964141; c=relaxed/simple;
	bh=WVBdfIXqA37TAQKxPishu3WdOPBmYMvXlTsVlqS/X2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oNCvpLlTw+XB9DcqqHxXkASuWxG8gUh5uHjGvyjIlFBEyb6/xwzsTY4yU5Bb70ituGERWEWiOu8hBgoj36/qdv5KmfE3d+RLn8T5mk6rd6MCIivp64rR3vS7SdG3SacoQJrWa9CKJcJMLmVl4WxcDjZC/yBtrXX9/2vdw/VCd24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MCdEISzX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MCdEISzX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A0A8C4CEC3;
	Tue, 10 Sep 2024 10:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964140;
	bh=WVBdfIXqA37TAQKxPishu3WdOPBmYMvXlTsVlqS/X2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MCdEISzXJXeTx33mi4TNoOamQKru6d8eEIHgfjMdqwdUi4/czfznt9mp6O6v2DhVY
	 0EJR8r72VpNzEaKpYnpehiYmLApPgWqplur1dx8oDAL94szJ/pn3wOHq2cEqKkoCGV
	 WXKtYB18iNHa+JwwAmHyLw2VxEJ7wNwOBk9unL1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shantanu Goel <sgoel01@yahoo.com>,
	Oliver Neukum <oneukum@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 081/269] usb: uas: set host status byte on data completion error
Date: Tue, 10 Sep 2024 11:31:08 +0200
Message-ID: <20240910092611.082473962@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 451d9569163a..f794cb39cc31 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -422,6 +422,7 @@ static void uas_data_cmplt(struct urb *urb)
 			uas_log_cmd_state(cmnd, "data cmplt err", status);
 		/* error: no data transfered */
 		scsi_set_resid(cmnd, sdb->length);
+		set_host_byte(cmnd, DID_ERROR);
 	} else {
 		scsi_set_resid(cmnd, sdb->length - urb->actual_length);
 	}
-- 
2.43.0



