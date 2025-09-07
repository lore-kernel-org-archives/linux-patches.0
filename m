Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17460189BB0;
	Sun,  7 Sep 2025 20:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276582; cv=none; b=OcGtCfuuXMTqQjEoTSYVc2ky05WdzTxy4c6LwRR5rdL6BYGwK1PExLyfs9nsWDSaCQ6mloPhSqzXU0qYOUYi2DJacO0yu3J67Kup3QLRmrlY6UHhnzHgfadJvk0NodmLqZtsXNcoEkOwu/1WRb2YgX9YI/L3zbSErzP2tfEnPdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276582; c=relaxed/simple;
	bh=cDoPR+668u9df/T/1wJQ1AGmd8YZWsMKn3MsDUSMWAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YuMzIrkXRqsxjXdLJFeKjEoU/kJZTF6zVv07LCxLs/HiV8NzXdNzJRgHzY9RI998eTUJ+z5/s8nNRFbQi8W2NB1pKjNhi9y9Vzj1nulvbs6GVUnOm3/I2Jhq3sF+lgxD+FfjIGAgtKlUKc6GAeesDYUyKoALuIQdotkFWRHxk4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eFcOamnT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eFcOamnT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91AE6C4CEF0;
	Sun,  7 Sep 2025 20:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276582;
	bh=cDoPR+668u9df/T/1wJQ1AGmd8YZWsMKn3MsDUSMWAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eFcOamnTOLyeI5+k8ere/5zh1TqBi+PR8HhJvlkUrPMLL0srKSOCE08L6Rn9NVR8C
	 nmnQp7KODe6MczDj4CRTG1nn6v1Q+mPTqcJtmqkqpWe94Zi7F4lenWwCDnieYmyGV2
	 AnkgKQdlIYlt/rRfzm8QkGssC6gzGtKqE6x/MvWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Simon Horman <horms@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 043/121] ipv4: Fix NULL vs error pointer check in inet_blackhole_dev_init()
Date: Sun,  7 Sep 2025 21:57:59 +0200
Message-ID: <20250907195610.927293174@linuxfoundation.org>
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
index c33b1ecc591e4..798497c8b1923 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -336,14 +336,13 @@ static void inetdev_destroy(struct in_device *in_dev)
 
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



