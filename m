Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E31330B06;
	Fri, 17 Oct 2025 15:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716112; cv=none; b=QPO1GrEdWNNFIyEBRZXBbPTI4gvdFEkDoPALfrNl2kdEZ5D+A6536TzBEEabn36ApAzI2nfoC8rPoX0LgeSWY5wdrXKGC61EeWYBqJWld7WNetrWoietywtHT3kOjS/yqjnOFSkKbNnXsllBLPmXiErhpAACT/Qe1nAWkUfyqhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716112; c=relaxed/simple;
	bh=4sVGd3Jdt+rkzPAbxGzCP5CE2LaT7aH8VG2lclmtuGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MngdmyC75U+l4P80CsE0cfoMw7BbbigPlK0r2OUmVVfqWmBRbuus4P0loGXhyHxrSpguQgO6i8u0FbPr4x76Qc5WDXukOOFraWIH92kxwOun0SEFJ2pB4aQQxwx35wXUpANd/HBDeIEeIZdC9VWM6iIqJsHrqrc4GGOThE4FWu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ftrKlxeN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ftrKlxeN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C66DEC4CEE7;
	Fri, 17 Oct 2025 15:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716112;
	bh=4sVGd3Jdt+rkzPAbxGzCP5CE2LaT7aH8VG2lclmtuGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ftrKlxeNqia0jDS5MmSmq2ZXyFtnW8Td5j16pJys1XwxdHNrVI+ydrldG+YH0prIx
	 QF/oHyPRoqUI57SlHuD6atQKDdAljVsaqaS3VE/6k7vQgTtomTLNuAxr2kBE6gnnB7
	 uhq5NDPoG7Hd2XTK7yd8nzwzMbQWzg9iLt6vBxvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanley Chu <yschu@nuvoton.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 044/276] i3c: master: svc: Recycle unused IBI slot
Date: Fri, 17 Oct 2025 16:52:17 +0200
Message-ID: <20251017145144.013335898@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 62a4d06bcfb5d..27f55b5e388d9 100644
--- a/drivers/i3c/master/svc-i3c-master.c
+++ b/drivers/i3c/master/svc-i3c-master.c
@@ -308,6 +308,7 @@ static int svc_i3c_master_handle_ibi(struct svc_i3c_master *master,
 						SVC_I3C_MSTATUS_COMPLETE(val), 0, 1000);
 	if (ret) {
 		dev_err(master->dev, "Timeout when polling for COMPLETE\n");
+		i3c_generic_ibi_recycle_slot(data->ibi_pool, slot);
 		return ret;
 	}
 
-- 
2.51.0



