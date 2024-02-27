Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9274F13DBBC;
	Tue, 27 Feb 2024 14:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709044136; cv=none; b=DhlFO5PmFKGwb5FmCK1FmREKEd+kp7c2JEFAP4J7eOHO94wGfTosvoITX84WeHBCZIcuCn7+ZNfLLeue51aEgLJv6ViI4z40/JMb6gv/b6xOxx1cXFOK6xzmF1EDofsJ5ibeGQmOrC2omOa1w9skg5J2Gj4LjEu8Jxy0Nx8U+SE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709044136; c=relaxed/simple;
	bh=YL/b6ELszIvZE6cUDR1UuBhgiwfyRxrsKt5PWut5YVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z9T6PxCe8w26lJv+zjkssgRB8XEQ1KP7PwngmMpB4SmDyx4BpqHBCESuGKzjcDxSpsJkmD3PtBND5KG2M2fsMSQ86syJNSiWjqU8nUqXOob2O4GHDh3NtPxCiERIrxe6sS4Du2daN9zJ7BBAHKGUwekMD9+TD0DUYCJlP8I3ZbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aVc7h0j+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aVc7h0j+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1451BC433C7;
	Tue, 27 Feb 2024 14:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709044136;
	bh=YL/b6ELszIvZE6cUDR1UuBhgiwfyRxrsKt5PWut5YVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aVc7h0j+z5gsmqk82dydcaQD7gH1dovD6bQ7JsyheB1GWrjd4dpJydlNLpww646v2
	 pZNqG12Nqyk/AIhsCm5td0Lp5OaTFfaTpSXolLFmznIfj84xDUYg0wJTcIwXt5f87n
	 HvN74VlmBMsDE7tWh+IwmrJw3Xn85DnXSXUOdOek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 047/122] media: av7110: prevent underflow in write_ts_to_decoder()
Date: Tue, 27 Feb 2024 14:26:48 +0100
Message-ID: <20240227131600.250568080@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131558.694096204@linuxfoundation.org>
References: <20240227131558.694096204@linuxfoundation.org>
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

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit eed9496a0501357aa326ddd6b71408189ed872eb ]

The buf[4] value comes from the user via ts_play().  It is a value in
the u8 range.  The final length we pass to av7110_ipack_instant_repack()
is "len - (buf[4] + 1) - 4" so add a check to ensure that the length is
not negative.  It's not clear that passing a negative len value does
anything bad necessarily, but it's not best practice.

With the new bounds checking the "if (!len)" condition is no longer
possible or required so remove that.

Fixes: fd46d16d602a ("V4L/DVB (11759): dvb-ttpci: Add TS replay capability")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/ttpci/av7110_av.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/ttpci/av7110_av.c b/drivers/media/pci/ttpci/av7110_av.c
index ea9f7d0058a21..e201d5a56bc65 100644
--- a/drivers/media/pci/ttpci/av7110_av.c
+++ b/drivers/media/pci/ttpci/av7110_av.c
@@ -822,10 +822,10 @@ static int write_ts_to_decoder(struct av7110 *av7110, int type, const u8 *buf, s
 		av7110_ipack_flush(ipack);
 
 	if (buf[3] & ADAPT_FIELD) {
+		if (buf[4] > len - 1 - 4)
+			return 0;
 		len -= buf[4] + 1;
 		buf += buf[4] + 1;
-		if (!len)
-			return 0;
 	}
 
 	av7110_ipack_instant_repack(buf + 4, len - 4, ipack);
-- 
2.43.0



