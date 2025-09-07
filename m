Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC641DE8AF;
	Sun,  7 Sep 2025 20:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277144; cv=none; b=Y8IUyBYtcy7ZHMIb3+uTUKMLAuzT7PpK3hDRmbQUQgEr5vls4QVL8r7ChThIWHwBr2ichchIYUEh+KUo+0rqvtjLqlbe4ojblEsRqnf+J+7Fy2wxWo72OG/r5y1ZwJ59dB/ukL3CrKnUf9vIOH5oWDmx8PWICRQhLNhNrC8kut0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277144; c=relaxed/simple;
	bh=umpYmhIrbr9/BZ26QdLqGa0pjJh8VQAJHqTCQBZPWL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zyv1Ae7DtbW9ht9bw1AJvSq/qtPK6Q0Z65yOmPqYhN5YDw1D4PF35+ocm1VMoD8eWxcziyh1dVtf+0Kq4OC4IibbRlxsrCQkNqBsjNyjThgfCwCJUuEPY/LUbl3livDG2kYud9AYXBh2MF5eeFq52NzCWpZHBTmnOzKkZ+IH82I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dXImGWm0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dXImGWm0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3692C4CEF0;
	Sun,  7 Sep 2025 20:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277144;
	bh=umpYmhIrbr9/BZ26QdLqGa0pjJh8VQAJHqTCQBZPWL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dXImGWm0H6Jjmaztf42mwkMueuTH9Jt99DO6CKOYpHKov7we8kw8HsW6l1VrIbykG
	 sx1Wp/CiqXpiQ/A0hRTJzpE05t699ODlAvcB4G5qtZp70M6J25iRXIS8hW8QduuXki
	 4NA/0H3K4s9l2xz87zMhJphsUtuWv41foG0HBCPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Simon Horman <horms@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 082/175] ipv4: Fix NULL vs error pointer check in inet_blackhole_dev_init()
Date: Sun,  7 Sep 2025 21:57:57 +0200
Message-ID: <20250907195616.776765186@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
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
index a55e95046984d..46fa50576f581 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -351,14 +351,13 @@ static void inetdev_destroy(struct in_device *in_dev)
 
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



