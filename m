Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB5B41A2389;
	Sun,  7 Sep 2025 20:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276215; cv=none; b=o2dM7HGj9kbYzjPJXGL65YuZt3cnGXgwbRGIKz2/BVSzmneCozAnXYqmf547+KOUD1LPtBM4CcVmEQNyzAAaTZF80P/Ajbc8Tg2dtJOnchDl1fE+CupyydgJImPBpTE/Ko7oviR2WmBPb+IZTzQl3xW4GpHvQbELF3kOncchQss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276215; c=relaxed/simple;
	bh=PiYc0q6QaKemUWOXCLGgZeFFJMmc/MI0vvSMRdyEmTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HaXFZKug2FMe1sI0LFAQZlXVVozOiStr+JUZkutMpe1pZ2B2GDIFa7SsdsdzMoomRAErpVQJRn9CZkXJjzxoMe1F9tXJFcryjnxjjxeePeVx9C/WIyYNdoLntLbKP8hX5EqZiGdZw+jafBFIrMRer0a+wAVC9eYfgSrMVF7No2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EU+6WqJ2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EU+6WqJ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F7D0C4CEF0;
	Sun,  7 Sep 2025 20:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276215;
	bh=PiYc0q6QaKemUWOXCLGgZeFFJMmc/MI0vvSMRdyEmTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EU+6WqJ2hPBzqyPQkX4DPai8Ghk+awPPeVkacx1MbAkApX2on0Id5995nADO1lwt9
	 DjTp0jcjcyyHb2gRVpEXfHQQIiSAc3wfzlG3VEM+UVwc5xoT7tQoRK7PWtSNHi0ykk
	 rxrUxJ992sZskUz7EqI8uxHVoYvqRU6185BWDyxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 034/104] mctp: return -ENOPROTOOPT for unknown getsockopt options
Date: Sun,  7 Sep 2025 21:57:51 +0200
Message-ID: <20250907195608.584963530@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195607.664912704@linuxfoundation.org>
References: <20250907195607.664912704@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit a125c8fb9ddbcb0602103a50727a476fd30dec01 ]

In mctp_getsockopt(), unrecognized options currently return -EINVAL.
In contrast, mctp_setsockopt() returns -ENOPROTOOPT for unknown
options.

Update mctp_getsockopt() to also return -ENOPROTOOPT for unknown
options. This aligns the behavior of getsockopt() and setsockopt(),
and matches the standard kernel socket API convention for handling
unsupported options.

Fixes: 99ce45d5e7db ("mctp: Implement extended addressing")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Link: https://patch.msgid.link/20250902102059.1370008-1-alok.a.tiwari@oracle.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mctp/af_mctp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mctp/af_mctp.c b/net/mctp/af_mctp.c
index 0f49b41570f56..8f241c92e03d8 100644
--- a/net/mctp/af_mctp.c
+++ b/net/mctp/af_mctp.c
@@ -346,7 +346,7 @@ static int mctp_getsockopt(struct socket *sock, int level, int optname,
 		return 0;
 	}
 
-	return -EINVAL;
+	return -ENOPROTOOPT;
 }
 
 static int mctp_ioctl_alloctag(struct mctp_sock *msk, unsigned long arg)
-- 
2.50.1



