Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B23D1F63CD;
	Sun,  7 Sep 2025 20:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277662; cv=none; b=cd0pyosvErFYLPh1fwz28q9L/pPucD1scwKMG+VKHiiGj6cdMQEqE8DaWajVOnKPHfTAYWzHfXTBMzEo29D9JfEb2NLF04xom92DoAu6ctZm12rst61mXQm7DuEImGsAsOEsat6ppGePWBifMBLSNqgan6DvQXIElLBA3AwvDK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277662; c=relaxed/simple;
	bh=LKI7Unqnd3hX0Di47kdGSeL9CvrWkhdsnZBeFdePPZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sED4F9Ig67cN2jN2Lie08Mqu9fXzvTrl98/m8KQKxH4R1MRMRzpW6dj4KQ/GYbIwg/3kmi5SyuTh1JLb6Mwg80rKoV3dfGHpFJc6zPnisdr8u5715jp5Rrt2r/ZBOmKuM8wc2P686RtifcOtScJ+Ckw9TGM8+2OjbP3kSwzqLWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HuedrjdE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HuedrjdE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F05BAC4CEF0;
	Sun,  7 Sep 2025 20:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277662;
	bh=LKI7Unqnd3hX0Di47kdGSeL9CvrWkhdsnZBeFdePPZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HuedrjdE2pzK0mTo6WSeFH94xRvtXixBuhFFkKMfTOk9dDGcvYqzSqH4esE3TkqPW
	 lOKznzOZo+NwSqR8MQYegYIVItFmCsVHc7RjLJr1cQTAWMyPOMp9ueVbocWJLKmw9O
	 l6pY6KNCgBhEIfaCKo5hCuY45EsSbejYkllyRYo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Simon Horman <horms@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 085/183] ipv4: Fix NULL vs error pointer check in inet_blackhole_dev_init()
Date: Sun,  7 Sep 2025 21:58:32 +0200
Message-ID: <20250907195617.814124820@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index c47d3828d4f65..942a887bf0893 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -340,14 +340,13 @@ static void inetdev_destroy(struct in_device *in_dev)
 
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



