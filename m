Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C066E248BD0;
	Wed, 15 Jan 2025 10:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938676; cv=none; b=bNaptaryZSTANgJ7dmyzW1KHXS+sXaU6ldhfDk2wfc1tgKirRPsBfUTfYJ5w9gqtRtuubHKEXWk6sJJ632YMYMJDX/5iKYiy8uu7Zn1Og6SjLAi/eJXOiezmDt2JoYLn0uojHEnBbYavDn5liA9xRzDoBLWnzqx/FtBWCChNcEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938676; c=relaxed/simple;
	bh=9PQmzy+rESUNoT/vWELZTyMWpIvHeRQcrMUtrniRLoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EqQ7EtXd2FB+wsi3kfcKm9EeW3/uWosMRAhh4bj2HK0SDPQOFzZO37nIvkY78braqtUUpyvZ8UYs6L6yyzgBuzUz2NS1jXFA8vkpya1pR5/G2hibSv4vkBGMHCkcoQV/zXxKD/cYv2xyc5CgeSzlEr29CjjDPdsZIFwPgsWSJKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eq1DZaU9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eq1DZaU9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31482C4CEDF;
	Wed, 15 Jan 2025 10:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938676;
	bh=9PQmzy+rESUNoT/vWELZTyMWpIvHeRQcrMUtrniRLoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eq1DZaU9gBa9QdUFTM++OTNFZxxpky0zs2But9mdW1j93G+4JZVaHU7gJjvR4m8vm
	 twf8/t7NBX4Co6BBc/okuqxl2LALDwJkmE7Lc1KCiWXTYF+jCll55jLqLeSKNTDUQs
	 Og7E/ERoWZP7Yy/Feus9NKZY6c/x0xvw7G6vj3cQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 062/129] sctp: sysctl: cookie_hmac_alg: avoid using current->nsproxy
Date: Wed, 15 Jan 2025 11:37:17 +0100
Message-ID: <20250115103556.853988576@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
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

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit ea62dd1383913b5999f3d16ae99d411f41b528d4 upstream.

As mentioned in a previous commit of this series, using the 'net'
structure via 'current' is not recommended for different reasons:

- Inconsistency: getting info from the reader's/writer's netns vs only
  from the opener's netns.

- current->nsproxy can be NULL in some cases, resulting in an 'Oops'
  (null-ptr-deref), e.g. when the current task is exiting, as spotted by
  syzbot [1] using acct(2).

The 'net' structure can be obtained from the table->data using
container_of().

Note that table->data could also be used directly, as this is the only
member needed from the 'net' structure, but that would increase the size
of this fix, to use '*data' everywhere 'net->sctp.sctp_hmac_alg' is
used.

Fixes: 3c68198e7511 ("sctp: Make hmac algorithm selection for cookie generation dynamic")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/67769ecb.050a0220.3a8527.003f.GAE@google.com [1]
Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20250108-net-sysctl-current-nsproxy-v1-4-5df34b2083e8@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/sysctl.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/sctp/sysctl.c
+++ b/net/sctp/sysctl.c
@@ -391,7 +391,8 @@ static struct ctl_table sctp_net_table[]
 static int proc_sctp_do_hmac_alg(struct ctl_table *ctl, int write,
 				 void *buffer, size_t *lenp, loff_t *ppos)
 {
-	struct net *net = current->nsproxy->net_ns;
+	struct net *net = container_of(ctl->data, struct net,
+				       sctp.sctp_hmac_alg);
 	struct ctl_table tbl;
 	bool changed = false;
 	char *none = "none";


