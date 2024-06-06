Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61D701A2548;
	Thu,  6 Jun 2024 14:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683740; cv=none; b=pcOtGYkizb1/som+xa9WpxABiA4JOUmXcMM9rMF25Y0URVofJAUUPiBPTHEvKXuCnuOvrTjCG1s1PlCEQGq4XXNJ+0c+yKDQbpquUDQBLFpaQcRQnCVt7r52awoSl+1ne92zxq/OBD9oRD7GZ1iKhoQ8a/5vT5lxvcI2OIz/D5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683740; c=relaxed/simple;
	bh=fr0ntyx8rtgYZ0c4qdoPIaNXaN0IueIKcO7mi8zrwTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=obfOspmVnKoyfrqq1z7P03sCO1eC6UsXEPQX0OkCImlNV29xu9B/tskEyGknHVsdOjY96MGWV4stno0o09wdGi5Xt0l/aHGe1IYSsMxeGTMmzEmfr04CZjA2d1/agJbgj4sk7dpRDOa5n6xeC5+cPFVkG09YqMS0YkkpjV7zG8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wmls72Nl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wmls72Nl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4244AC2BD10;
	Thu,  6 Jun 2024 14:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683740;
	bh=fr0ntyx8rtgYZ0c4qdoPIaNXaN0IueIKcO7mi8zrwTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wmls72Nlzp5u4w8x0veMTHyXuo4LmQMAod+RTp9xmmJSstGErPK5D3w5OdvCDuVWF
	 xFprDoGkgFohyWmN4zAa9kQuhEudoh4IotvXcUW2PKyuklkHt26qfk1tv64HnymBaQ
	 RQLA3DhsdsZ4iu1PxkNxO0mhd+05seeGX7iNocIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 659/744] i3c: master: svc: change ENXIO to EAGAIN when IBI occurs during start frame
Date: Thu,  6 Jun 2024 16:05:31 +0200
Message-ID: <20240606131753.592151273@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Frank Li <Frank.Li@nxp.com>

[ Upstream commit 7f3d633b460be5553a65a247def5426d16805e72 ]

svc_i3c_master_xfer() returns error ENXIO if an In-Band Interrupt (IBI)
occurs when the host starts the frame.

Change error code to EAGAIN to inform the client driver that this
situation has occurred and to try again sometime later.

Fixes: 5e5e3c92e748 ("i3c: master: svc: fix wrong data return when IBI happen during start frame")
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/r/20240506164009.21375-2-Frank.Li@nxp.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/svc-i3c-master.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i3c/master/svc-i3c-master.c b/drivers/i3c/master/svc-i3c-master.c
index 3966924d10668..e18bf9ca85197 100644
--- a/drivers/i3c/master/svc-i3c-master.c
+++ b/drivers/i3c/master/svc-i3c-master.c
@@ -1065,7 +1065,7 @@ static int svc_i3c_master_xfer(struct svc_i3c_master *master,
 	 * and yield the above events handler.
 	 */
 	if (SVC_I3C_MSTATUS_IBIWON(reg)) {
-		ret = -ENXIO;
+		ret = -EAGAIN;
 		*actual_len = 0;
 		goto emit_stop;
 	}
-- 
2.43.0



