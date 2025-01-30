Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12225383;
	Thu, 30 Jan 2025 14:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246677; cv=none; b=SBksaarknDNq3k3L6Z1c4Ab5CUO3QZ66Wp2TGmmiSxw+yhtLdNBAfoGH/FvKX6KyETI6Ol33afsCLDzxBxV00xrPVJ17wV+/Fymd2gufQjg9s1OUmI3afN8+LY/WZVsDkBhHKKjq9SqirVF7+tDJcaw2ZdI6qgKmgg+Jo3CiYII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246677; c=relaxed/simple;
	bh=0T5cce5KXv3vZ8Ji2tmU2VOHbTrjtX3+zwD01aJNUQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eaxcCM40jCK+g9rw5H/Pka+7iUsTbA1qm2gX5NrutKZpvD+6tS3yA3DuwQAeFap3m+ZvYIjPJ7N7G6DUWw6IlMa8HMyi2cFk11WD0i+mFyxlVb4KGIWqdIg4NYZD81RpN7am2taT3yWzCtxDYXCTbWwk2E/rWAfva7zMBuVy+KI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m6KrtcPB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m6KrtcPB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82412C4CED2;
	Thu, 30 Jan 2025 14:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246676;
	bh=0T5cce5KXv3vZ8Ji2tmU2VOHbTrjtX3+zwD01aJNUQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m6KrtcPBSE1JXi38mNghArKfwqVM1KqUndblpffKjW3RsDVvLYfbPnm5qMIU/fiIm
	 CHpYIQFidNlSpFl+UaHp6gBytJnXUdAIeXWcvET3DH/nMQLbmQvXA+wiJHPkJndQSM
	 RXQ6okbIhvgZFAwghhlXswgfFodunsQlqF6gwfu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 12/91] sctp: sysctl: cookie_hmac_alg: avoid using current->nsproxy
Date: Thu, 30 Jan 2025 15:00:31 +0100
Message-ID: <20250130140134.158737548@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.662535583@linuxfoundation.org>
References: <20250130140133.662535583@linuxfoundation.org>
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
@@ -441,7 +441,8 @@ static int proc_sctp_do_auth(struct ctl_
 			     void __user *buffer, size_t *lenp,
 			     loff_t *ppos)
 {
-	struct net *net = current->nsproxy->net_ns;
+	struct net *net = container_of(ctl->data, struct net,
+				       sctp.sctp_hmac_alg);
 	struct ctl_table tbl;
 	int new_value, ret;
 


