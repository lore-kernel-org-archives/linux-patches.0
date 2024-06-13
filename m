Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 983B5DDB1;
	Thu, 13 Jun 2024 11:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718278766; cv=none; b=gkJDmTymjo7z6Y1wghFwg/wLW9CSvsxPrIrolBm5YtDKZ1rkeZFjEC+MlMKQiCSxvJiturKUZBB7N2P+h23I/5I0WQ2eHuM7/w40APgBo1vej7KjTOaw77PL6bX9X2TFGXDao2j3cdIyIgt19hg1dh+2jfDcVYBJx6pzBkzWKGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718278766; c=relaxed/simple;
	bh=7tYBgBWvmrIqyRZ457aUCme0zDPp+GyjWQ1e/Bf4ScI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RdgpWf1sbUYGbkz66nrOh7OSMi+E/57k1r1TkYRlFYxshoNeOdg3dWkcovLLXbv8VuZjUgz4BcD/h+fymw1nafGkcMH9Dxx8l443gOB5Dx8aRDfmQ2GPZKFZ4q+WGpGcSTFSq92WY8YWKA14x8c/meFcqWzMEZg5MAOGR5hZpNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LSeKLVFh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LSeKLVFh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1656CC2BBFC;
	Thu, 13 Jun 2024 11:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718278766;
	bh=7tYBgBWvmrIqyRZ457aUCme0zDPp+GyjWQ1e/Bf4ScI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LSeKLVFh5Q0oYxZLn8RNmLBECGIFP3P+jjbzbWzar0UrgXqdqWaUNkw94KYD7DCNV
	 D/Q7cObL88UyZ/DdX5n3HKAaKXOaE/NLPstk2AQQmuJCn7sXpnnUmnVZ6slMErLWUH
	 wSneSc+hkBwniT61E76J2F4TDxV2bhtEjSkqtvzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 063/213] ipv6: sr: fix incorrect unregister order
Date: Thu, 13 Jun 2024 13:31:51 +0200
Message-ID: <20240613113230.441158003@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 6e370a771d2985107e82d0f6174381c1acb49c20 ]

Commit 5559cea2d5aa ("ipv6: sr: fix possible use-after-free and
null-ptr-deref") changed the register order in seg6_init(). But the
unregister order in seg6_exit() is not updated.

Fixes: 5559cea2d5aa ("ipv6: sr: fix possible use-after-free and null-ptr-deref")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20240509131812.1662197-3-liuhangbin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/seg6.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/seg6.c b/net/ipv6/seg6.c
index 42ff4f421d42a..9810ce81dee81 100644
--- a/net/ipv6/seg6.c
+++ b/net/ipv6/seg6.c
@@ -500,6 +500,6 @@ void seg6_exit(void)
 	seg6_local_exit();
 	seg6_iptunnel_exit();
 #endif
-	unregister_pernet_subsys(&ip6_segments_ops);
 	genl_unregister_family(&seg6_genl_family);
+	unregister_pernet_subsys(&ip6_segments_ops);
 }
-- 
2.43.0



