Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5537E20322;
	Mon, 14 Oct 2024 14:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916472; cv=none; b=MSShz59VFFNrvbk4+OndnkNuKVX9NY2SQbtQHHMiEpr/4MIpV11a8epqiTpEE17JXiNkvwVeskX2HHSSsGjblVmf4qAE6uQJcrCJXUPo2p5+3swafAdDoAq03GSIub31uUMiczI2n9B+zYjHn3uBjA42ow4jL+KPjMRfNQhjo8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916472; c=relaxed/simple;
	bh=O4EXKoKE4Xh9Ijy5+23jjsR9VDypq9FTY9EGzuZX4/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DZzqHDkPK3EmQNf3PimwT30D+5+Kexu4LL/oKX6epOwBq8S9vhBifypJ1kfb04VYo2B+gD5fWq94HpsCtDRVmdBA+3RJdIwIysd8+9XiJjtlAE2fAyx8QCEMpk8Db0N9zoPu9kH/DADv0NVfL3A9vCTA+Edz8JoNh2b8Lpmt4A0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gmXVKRjo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gmXVKRjo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0C7EC4CEC3;
	Mon, 14 Oct 2024 14:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916472;
	bh=O4EXKoKE4Xh9Ijy5+23jjsR9VDypq9FTY9EGzuZX4/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gmXVKRjoAHJ+GK3htTVblQds5zEFcT3QzjszpxQV2pnTc6bPwdHnHYMc+jRjZXzgF
	 AvRK4+h/UR//jqcSGTAfWiobtsnaOIBxR3Yz2Bqw4re5eJSlgvvVcEWBMuG8pPfu47
	 mvi0sj5x7LZ/gKs6ieF+70EekWS/1tESDmcd2INc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ignat Korchagin <ignat@cloudflare.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.11 192/214] net: explicitly clear the sk pointer, when pf->create fails
Date: Mon, 14 Oct 2024 16:20:55 +0200
Message-ID: <20241014141052.470367643@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ignat Korchagin <ignat@cloudflare.com>

commit 631083143315d1b192bd7d915b967b37819e88ea upstream.

We have recently noticed the exact same KASAN splat as in commit
6cd4a78d962b ("net: do not leave a dangling sk pointer, when socket
creation fails"). The problem is that commit did not fully address the
problem, as some pf->create implementations do not use sk_common_release
in their error paths.

For example, we can use the same reproducer as in the above commit, but
changing ping to arping. arping uses AF_PACKET socket and if packet_create
fails, it will just sk_free the allocated sk object.

While we could chase all the pf->create implementations and make sure they
NULL the freed sk object on error from the socket, we can't guarantee
future protocols will not make the same mistake.

So it is easier to just explicitly NULL the sk pointer upon return from
pf->create in __sock_create. We do know that pf->create always releases the
allocated sk object on error, so if the pointer is not NULL, it is
definitely dangling.

Fixes: 6cd4a78d962b ("net: do not leave a dangling sk pointer, when socket creation fails")
Signed-off-by: Ignat Korchagin <ignat@cloudflare.com>
Cc: stable@vger.kernel.org
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20241003170151.69445-1-ignat@cloudflare.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/socket.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/net/socket.c
+++ b/net/socket.c
@@ -1569,8 +1569,13 @@ int __sock_create(struct net *net, int f
 	rcu_read_unlock();
 
 	err = pf->create(net, sock, protocol, kern);
-	if (err < 0)
+	if (err < 0) {
+		/* ->create should release the allocated sock->sk object on error
+		 * but it may leave the dangling pointer
+		 */
+		sock->sk = NULL;
 		goto out_module_put;
+	}
 
 	/*
 	 * Now to bump the refcnt of the [loadable] module that owns this


