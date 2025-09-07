Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D4481B4247;
	Sun,  7 Sep 2025 20:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276588; cv=none; b=cbVlJRHPn/n5HcXDlMZjv2df+/n5dHOZhpLIheUr9Pu5qUKPVjYonId24MyVJRgmKyRLoyIYBrG2MX8hfmwCPL25dbvdszF6oQOpC3K3n39h/rhChjg3Q66WZgNHQJUMHk+VDirA9LtT7Qft4SlYuVFDv63W/EgXJer7T1Lv9vA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276588; c=relaxed/simple;
	bh=diPkuBFTMtRip8ymOi7tYnjVBqYY1wFLkZVKK/mmMzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VrwQZcBfDydVso4S+kSKzVRLYr+Hih3vNiJMh2r44qQal/E3jnG8bwtOSgtNS6dAtHv3XCC7uZUgUoIbpvc+psctbI8qsDNi1TuyUwmXy+HIVpcQK4Wxzsz4nILZUzf8CJ5K95H2hTF9/5k8IDO01rKAoH9KOy8xVUKasx/JWzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F8cEpHEP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F8cEpHEP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3C9FC4CEF0;
	Sun,  7 Sep 2025 20:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276588;
	bh=diPkuBFTMtRip8ymOi7tYnjVBqYY1wFLkZVKK/mmMzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F8cEpHEPJ4yoiLvESfZIIANOrpqS0sj+XxAroFLE1McFcNsdAa3WnJmmBKt3XmVl3
	 1P+dIMMec3ktZ5bXR2AlE01Gaodz7YfJZs0OYe7yQn+qHE1+rKD/4Y83lfrVBLgzXa
	 g4fuuvM3FpqQpT7ffo1tLrlXHAp2ffd2Ofiu/c74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 045/121] mctp: return -ENOPROTOOPT for unknown getsockopt options
Date: Sun,  7 Sep 2025 21:58:01 +0200
Message-ID: <20250907195610.977793802@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195609.817339617@linuxfoundation.org>
References: <20250907195609.817339617@linuxfoundation.org>
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
index 5f9592fb57add..805f7376cebe3 100644
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



