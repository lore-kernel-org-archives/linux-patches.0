Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 497883D6CB4;
	Wed, 30 Sep 2026 19:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795840; cv=none; b=m07ywWddJToRYD9b5Hreu+BNdp2+hybruF0n7cFZBmRJUA+Zmwee92qqUoZ3rO78/BL3DR3xctzXKm0cIbnVN/NLWmsh5B46G+FIdKzsNOITt5UO8sBL0hPuYqLCYLtmJ9vTOmAEBwwSnj4hLNPDO1DQIoulQXrdaJuDsJqjPFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795840; c=relaxed/simple;
	bh=sqGbHgu27nSCz62vNCHObZRVqIMq6RHAp37Om3olsnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tl6bdPVhlKAmeLWecE8vgWZBeUCG0BBIxxZ3g0v79cGtfLnUxUxcIaA82mnwYnefY4Ukg/fmh3JILl0GGvVm0P0VVplyEApxC7p/yihKfxg/w0a0cW5L+3b6l/x+DzPksNmrKEeIgV/k0xJgkjMb267tUVWJTv46O72NsDPTvj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0J4QlY9V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0J4QlY9V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F79B1F000FF;
	Wed, 30 Sep 2026 19:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795839;
	bh=GAjJVXC/a7SKLY2LANZhkkjGo8VetoWc4gUFNM9YUww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0J4QlY9VcgTjyXNnr7tCCfj+7CLd5vzNef+xeeK3Tv5baom0K85X7c7REAiYVP6lS
	 qlJGMuWxgxZYq2eaqYcj1DfMOQU+MvQLr6MJPogJ+SIIiVgQEbNOaTtv1H4W4Jf0a4
	 D5/dksxMskY1cIARiOdsgAK9tDylk1JD/N217dAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Paolo Abeni <pabeni@redhat.com>,
	Dmitriy Okunev <dokunevdmitriy@gmail.com>
Subject: [PATCH 6.6 0700/1193] fou: Fix use-after-free in fou_create()
Date: Wed, 30 Sep 2026 17:23:04 +0200
Message-ID: <20260930152449.803153782@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Xuanqiang Luo <luoxuanqiang@kylinos.cn>

commit b14361aca6350ff7907b0e9903c7b94dc7d5d4a0 upstream.

fou_create() publishes struct fou through sk_user_data before adding the
new FOU port to the per-netns list.  If fou_add_to_port_list() fails,
the error path frees fou while it is still reachable through
sk_user_data.  A concurrent receive can then dereference the freed
object in fou_from_sock().

This ordering issue was previously noted in the linked discussion.

The failure is reachable when local port 0 is requested.  Each socket
binds to a different ephemeral port, but fou_cfg_cmp() compares the
requested port 0 and reports -EALREADY once an entry already exists.

Release the tunnel socket before freeing fou so sk_user_data is cleared
first, and defer reclamation with kfree_rcu() to protect concurrent RCU
readers.  This matches the lifetime handling in fou_release().

Fixes: 23461551c006 ("fou: Support for foo-over-udp RX path")
Suggested-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://lore.kernel.org/netdev/20260502031401.3557229-12-kuniyu@google.com/
Cc: stable@vger.kernel.org
Signed-off-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
Link: https://patch.msgid.link/20260722083858.182506-1-xuanqiang.luo@linux.dev
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Dmitriy Okunev <dokunevdmitriy@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/fou_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/fou_core.c
+++ b/net/ipv4/fou_core.c
@@ -636,9 +636,9 @@ static int fou_create(struct net *net, s
 	return 0;
 
 error:
-	kfree(fou);
 	if (sock)
 		udp_tunnel_sock_release(sock);
+	kfree_rcu(fou, rcu);
 
 	return err;
 }


