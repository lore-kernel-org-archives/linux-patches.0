Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B8CC2580F2;
	Mon, 13 Oct 2025 14:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367546; cv=none; b=hdLPYxbgyoWNXLcxqYNQF9ki5rbHlFknYg3c/NbjsODIp140OXkrCrbmLfkGEoVbT8WlP4hOhAd7GWkcPYU5u+X9q0EzmiV8AuRz63a+0ZSkulqVvv1d4Kk/P0Rk5HLpDM68mh6f+f+k/yjrGQZb7ONelhVVZjzvurcK0fet49I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367546; c=relaxed/simple;
	bh=Ycis8vmIwAzRvUPrJlfRIt6VjBJBwPS7+JBdlUzMr4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P07S+ZoeV9tIeb+cgo/IktrJS71y4QtTdvejXf5kB1Y3WwEBxQZRZOQBCCU9OjNpslUcnIy3a4qjdjN1AfLyWktnrJ/2k8mTOPnTDM/P2nWCxIx0fx31b5KSeJ2Uby7lMkcSmZgxaitLYU+5DWST73xpA6FeQhRKVgUMmBzd5Uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r1CGzyFZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r1CGzyFZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FAF1C4CEE7;
	Mon, 13 Oct 2025 14:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367546;
	bh=Ycis8vmIwAzRvUPrJlfRIt6VjBJBwPS7+JBdlUzMr4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r1CGzyFZMhQBVFvEQSZgDWJRuftrwVEdCf1g/vS5M1nJ1k2nFClrLSFppdmQRiEG+
	 c7QBolb3VyUSPZL1XHZv2EmvdJXcxFlaVOETf0HXXIjXl22LEvocsj8Px7ZH3srV6p
	 l1o4s3XX2Pt9SyN5OEzLN+4vWxEHxJvwzvZF7LA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanley Chu <yschu@nuvoton.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 049/196] i3c: master: svc: Recycle unused IBI slot
Date: Mon, 13 Oct 2025 16:44:00 +0200
Message-ID: <20251013144316.975178701@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Stanley Chu <stanley.chuys@gmail.com>

[ Upstream commit 3448a934ba6f803911ac084d05a2ffce507ea6c6 ]

In svc_i3c_master_handle_ibi(), an IBI slot is fetched from the pool
to store the IBI payload. However, when an error condition is encountered,
the function returns without recycling the IBI slot, resulting in an IBI
slot leak.

Fixes: c85e209b799f ("i3c: master: svc: fix ibi may not return mandatory data byte")
Signed-off-by: Stanley Chu <yschu@nuvoton.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20250829012309.3562585-3-yschu@nuvoton.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/svc-i3c-master.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/i3c/master/svc-i3c-master.c b/drivers/i3c/master/svc-i3c-master.c
index 1cfc8f480d15c..277884b5e1ca4 100644
--- a/drivers/i3c/master/svc-i3c-master.c
+++ b/drivers/i3c/master/svc-i3c-master.c
@@ -369,6 +369,7 @@ static int svc_i3c_master_handle_ibi(struct svc_i3c_master *master,
 						SVC_I3C_MSTATUS_COMPLETE(val), 0, 1000);
 	if (ret) {
 		dev_err(master->dev, "Timeout when polling for COMPLETE\n");
+		i3c_generic_ibi_recycle_slot(data->ibi_pool, slot);
 		return ret;
 	}
 
-- 
2.51.0



