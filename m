Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 988DE1A2389;
	Sun,  7 Sep 2025 20:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276209; cv=none; b=YahlBkkF1O3O/tATDFyIRkQ8LS9djOcFj1HxJ7ENAa+wqEOpQ+iZIcKvnJtJgMemJa4uFNclyJsvyOD9pRybS11YR0bYl2zeRgsFXxU/6kxU92zJvvdK1dDH0pFAXLt03m3D0ASUVV1YLsmHBUa8pVckTU/6Jbe1kZaqs2WzjB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276209; c=relaxed/simple;
	bh=FW2tWeHrjHQOgmX6D/BVBQRk0OYZRB74KOpr3r0YmSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ELC1pJL7Mv/ILyuj9UsiXlWG9F7KqsMqsMML230LJ1HgLTrJp5cS+xYR/+RXoLqkqBGdwosJfR2U3ZkwfEh/v1yaaYUWfvYtCLp+WkrNHF6NfVIxDrLlngOt4ffxqDpe09WQiuNyR6oBC8z5Mb6wfkZ71rm4gIjUe3ztOmKZf7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TDUWht3F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TDUWht3F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E6B8C4CEF0;
	Sun,  7 Sep 2025 20:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276209;
	bh=FW2tWeHrjHQOgmX6D/BVBQRk0OYZRB74KOpr3r0YmSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TDUWht3FrXRZvOz6Dt9g4K70pNDnBOcCPypyzunkLgYihA82JyYckl/iHPfY9X4qt
	 mxh0CKOFaFETWFt0lSYsNSb4ncOQz36YPXuywaRleHIXurxV3P6MHLHZbJoURaklPn
	 9lMNKwsva2wcswYeFKRQOXmVcFYDZ3u1A4uariyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Simon Horman <horms@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 032/104] ipv4: Fix NULL vs error pointer check in inet_blackhole_dev_init()
Date: Sun,  7 Sep 2025 21:57:49 +0200
Message-ID: <20250907195608.535101669@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit a51160f8da850a65afbf165f5bbac7ffb388bf74 ]

The inetdev_init() function never returns NULL.  Check for error
pointers instead.

Fixes: 22600596b675 ("ipv4: give an IPv4 dev to blackhole_netdev")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/aLaQWL9NguWmeM1i@stanley.mountain
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/devinet.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index 1738cc2bfc7f0..fee0a0b83d27b 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -335,14 +335,13 @@ static void inetdev_destroy(struct in_device *in_dev)
 
 static int __init inet_blackhole_dev_init(void)
 {
-	int err = 0;
+	struct in_device *in_dev;
 
 	rtnl_lock();
-	if (!inetdev_init(blackhole_netdev))
-		err = -ENOMEM;
+	in_dev = inetdev_init(blackhole_netdev);
 	rtnl_unlock();
 
-	return err;
+	return PTR_ERR_OR_ZERO(in_dev);
 }
 late_initcall(inet_blackhole_dev_init);
 
-- 
2.50.1



