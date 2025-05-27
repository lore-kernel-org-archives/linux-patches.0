Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA204194A45;
	Tue, 27 May 2025 16:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364651; cv=none; b=AdQPjm7PdoRXNAHbkCf64z2yzYnBNwH3vtE6XTlAbge/Fe8clktOX8jRJNPhoHcj8U6ais92vTLfMWjnbwYvxTKqc0IvKpRfgA5mFTEtxpbN1EaH5pKXjhGFiDqn+/3Wg0GBCsD3tR56CmBkaEke4GpOADNtYiwZiTGsOJMETpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364651; c=relaxed/simple;
	bh=GPedkMMfK5vnMjPFBKF5wYCZTHaiHtYSz+GqnQxgyRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t+LG8Z9jqU67LdwMFSWKtn7G4XKUXmGFhLNX1hPZ4vmagdC9DB1wNxrvMcuiTQGiaP+8ZZJgIFYdXT8mZlL6CKJxIEOjJUlmPTTq5JIu8q1HH9uAo2JugCDSp527o+7K3Yge0gg5bGbRaMOkXBVnQRDbJ9j/w2eVP4udhf7gDK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D3Ql49s+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D3Ql49s+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48EFDC4CEE9;
	Tue, 27 May 2025 16:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364651;
	bh=GPedkMMfK5vnMjPFBKF5wYCZTHaiHtYSz+GqnQxgyRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D3Ql49s+zRtASBJ6hYf6XbiDV+s3yw+fBl1fm066c4mqFnIbqRbz28jiMb5OuN74F
	 7UGHxNbsmDLWXCAmZnYYTRb9dlPNkOns2yZXOD+KgV+rhbgKVaEGCFgy/PMbmekn5b
	 ZoPnJcL+7oM8JxN+N4y4UDFu05DK5f68EAFKO718=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanley Chu <yschu@nuvoton.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 124/626] i3c: master: svc: Fix missing STOP for master request
Date: Tue, 27 May 2025 18:20:17 +0200
Message-ID: <20250527162450.069454912@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7911814ad82ac..6ffe022dbb5b4 100644
--- a/drivers/i3c/master/svc-i3c-master.c
+++ b/drivers/i3c/master/svc-i3c-master.c
@@ -511,6 +511,7 @@ static void svc_i3c_master_ibi_work(struct work_struct *work)
 			queue_work(master->base.wq, &master->hj_work);
 		break;
 	case SVC_I3C_MSTATUS_IBITYPE_MASTER_REQUEST:
+		svc_i3c_master_emit_stop(master);
 	default:
 		break;
 	}
-- 
2.39.5



