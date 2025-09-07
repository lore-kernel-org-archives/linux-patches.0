Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B82A1CDFAC;
	Sun,  7 Sep 2025 20:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757275921; cv=none; b=KfGLLhS5wWdbWcZqxMsA2RbAiLMAPURkSteteKuSuQB5maFr8FVcdIiE27PVzUkX6IZ4CLW9pxlX8YZlWVu7RRqW38XAR8LH3RRjDRa570EQkF+WGMpZHH4pouFy6le1BvAflCiDLork4RL7Ed/WoZGOC7SLWdIkGWC4xyxFuMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757275921; c=relaxed/simple;
	bh=wkC2S2c8URLONPg0R8ewjpRNXgB0ZyOGVYR99kR6QTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pozmvR93ZKxLpDtfJaaC9rK0sZttqoYf/4Lq1Fb1KgW03G5b0BiC/EFQdZIewU10wemEEE0XgPSQGfhgH8/e3eDjCe5rYugG8dCHg2Q0NqZjkR/r27s2Fln5ltl5beMtfv67KaAipHc4dL/VQdAC7uckwetyOfsHNPuUXyEeLDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=frj2vxXe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="frj2vxXe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A63B9C4CEF0;
	Sun,  7 Sep 2025 20:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757275921;
	bh=wkC2S2c8URLONPg0R8ewjpRNXgB0ZyOGVYR99kR6QTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=frj2vxXeL6p9cSmISKy1Kmi+jeLxSgfmd7SYOyOnuuYHtO5hfO6+53esOndL3rV2T
	 zEUoA3noRV6hqelxumEeRNeZZAk//0iP/k8cmLu8ftUWttaAZfxGFh4uf+OSiAMlzf
	 WjTqGvuord924rPS8RdPHSgvCFKzeaM14lL2n/A4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Simon Horman <horms@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 14/45] ipv4: Fix NULL vs error pointer check in inet_blackhole_dev_init()
Date: Sun,  7 Sep 2025 21:58:00 +0200
Message-ID: <20250907195601.376859006@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195600.953058118@linuxfoundation.org>
References: <20250907195600.953058118@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 6855372d57a34..b4fb75be24d9c 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -332,14 +332,13 @@ static void inetdev_destroy(struct in_device *in_dev)
 
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



