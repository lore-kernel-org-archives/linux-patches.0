Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 497F61CBA18;
	Mon,  2 Jun 2025 14:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873345; cv=none; b=OtMvy82h6xBWzTz27yVqKLxmopgNYXUOQ0pubitJF+5FiWpNZ5wKQe9DJOuzOMaURIO5ZcU880wy8f4sCFgHugSyPSatKLiurOkQojFwi5AohFpYaZ7PrnskSY6xl0Te6Qs6dxosj5SIqza+m+pF+P91kSJGFkRyMKUk81QaX3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873345; c=relaxed/simple;
	bh=TXUwPfffJMpuzrlP57twLveVm6p0Kq/Gz/s5aDrt8PM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iZMoHk+OcaHIAQINwhjvLKesTH4KwUWuH9SjXbo2xMQBdJRgihQY/MxmxaYxw36BK/rONxBPvNVhVFNt1MTrxMkSnQSEaEnb5wr8ziKLWxpoZsO/ou8wjEnMxIt3P8khhovwOPuSwhz8a5PeJzVfrsK4mo/IIjV085k/DDjJnIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=phMZjAyM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="phMZjAyM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC058C4CEEB;
	Mon,  2 Jun 2025 14:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873345;
	bh=TXUwPfffJMpuzrlP57twLveVm6p0Kq/Gz/s5aDrt8PM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=phMZjAyMdyLgqB1hWqw3ybP/WdPNTbiz45UIF45lIkRNDVDdznyCGXneE0SolmOpr
	 Z8JymFO0ULyYU9Yr7n/65/jwrGGd2yeIzZ55PtrjM7SkNbJ3rLBaIp2lyVBRmdgvnP
	 OoPNi7G9WkQ5/wnHI6yN4XSFMlXfDsO9nBcrZZP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanley Chu <yschu@nuvoton.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 082/444] i3c: master: svc: Fix missing STOP for master request
Date: Mon,  2 Jun 2025 15:42:26 +0200
Message-ID: <20250602134344.232694943@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanley Chu <yschu@nuvoton.com>

[ Upstream commit 0430bf9bc1ac068c8b8c540eb93e5751872efc51 ]

The controller driver nacked the master request but didn't emit a
STOP to end the transaction. The driver shall refuse the unsupported
requests and return the controller state to IDLE by emitting a STOP.

Signed-off-by: Stanley Chu <yschu@nuvoton.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20250318053606.3087121-4-yschu@nuvoton.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/svc-i3c-master.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/i3c/master/svc-i3c-master.c b/drivers/i3c/master/svc-i3c-master.c
index fa1f12a89158c..3cef3794f10d3 100644
--- a/drivers/i3c/master/svc-i3c-master.c
+++ b/drivers/i3c/master/svc-i3c-master.c
@@ -503,6 +503,7 @@ static void svc_i3c_master_ibi_work(struct work_struct *work)
 			queue_work(master->base.wq, &master->hj_work);
 		break;
 	case SVC_I3C_MSTATUS_IBITYPE_MASTER_REQUEST:
+		svc_i3c_master_emit_stop(master);
 	default:
 		break;
 	}
-- 
2.39.5



