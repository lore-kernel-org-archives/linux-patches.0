Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A292B9A5;
	Tue, 22 Jul 2025 13:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192535; cv=none; b=M6U4DxK7MJoax4nJyj9hO8pS5uLoR/9kBoib2paos7nbnP31KRN0SLo7u7qRd8ejnvZhZoeoFCVQ45feQjISJ1VJxdKXp66nzs7a6gg1516F1B1/MZY8kYdU91ARnl0+pmTg7i6VBVyIM7G+0KjYL0pGVvvSedqAEXm5VdBj5xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192535; c=relaxed/simple;
	bh=oTqFxBXGo7s9rdokhze28szZMNW9ZlTpB4ZA6Bd+RpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iqxnI+PJc7KOPu0/2peweC5gS8dRuRe0jajFLVlF4H6IU4qi6AIJOsu9q8/B5X2zffuvbsHU3IMOmUHxbmjpsPjeNqiTmNXPwezZfE+8zppfyaqrM3CEW3qEy4EKDxQCGWBaikx6rVlimcYAWxJNkqvbfn+NKj9++Umw2EpK1mQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ujt4rkjJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ujt4rkjJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 888E4C4CEEB;
	Tue, 22 Jul 2025 13:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192534;
	bh=oTqFxBXGo7s9rdokhze28szZMNW9ZlTpB4ZA6Bd+RpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ujt4rkjJADc2u5ZcJnTaICBHueNvvIbDOhxupy4cFl3Li1bX6raB4dUgxThD/dwfo
	 j/FoHdS/rEiGnNSVARrZbhG0nbmdeQ2UGUPbjf+ALhOMth8SsshM41QeoMnVwe5Drl
	 6d+y8RKa7uGVZh7H2yWdpuGGTW41n/l7xrt3TG58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Brett A C Sheffield <bacs@librecast.net>
Subject: [PATCH 6.6 094/111] ipv6: make addrconf_wq single threaded
Date: Tue, 22 Jul 2025 15:45:09 +0200
Message-ID: <20250722134336.922030407@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134333.375479548@linuxfoundation.org>
References: <20250722134333.375479548@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

commit dfd2ee086a63c730022cb095576a8b3a5a752109 upstream.

Both addrconf_verify_work() and addrconf_dad_work() acquire rtnl,
there is no point trying to have one thread per cpu.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20240201173031.3654257-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Brett A C Sheffield <bacs@librecast.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/addrconf.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -7383,7 +7383,8 @@ int __init addrconf_init(void)
 	if (err < 0)
 		goto out_addrlabel;
 
-	addrconf_wq = create_workqueue("ipv6_addrconf");
+	/* All works using addrconf_wq need to lock rtnl. */
+	addrconf_wq = create_singlethread_workqueue("ipv6_addrconf");
 	if (!addrconf_wq) {
 		err = -ENOMEM;
 		goto out_nowq;


