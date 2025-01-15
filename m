Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8B0248BD0;
	Wed, 15 Jan 2025 10:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938680; cv=none; b=ApjWPQN0mdj9qBhT9D2M4KPkkO5omDncD50U4vyKi3eQp1k5mC/PLhWXu/KR+cvuDFosaF6qwHFNfR0lwo3/BdwZdS2t9psTZ1dZGkvTnLL2D3mbVbxxvQtwNOyKGqHN9CIllT4gMpUNUjVY50j8QIgT8A6AB2QEWMUHo4ORvj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938680; c=relaxed/simple;
	bh=cqESr7Tf5Fz8Qk/4scQoV4ileADtq8+WwJRkdkNqo7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KCocJTTwdDptNTo/ZsbyUdlcAXg0HM+wDM1dvNKRQ7qmrNGFpFaQuX7g/Ch/bwgzr1Kj1mHY8qKCVojlR7E1f+blTKDgfV1XK6e1ViNPQtqdEq8lRxpEr6joqjXCZnoYXcE48tylSZ6ZdHiAkyt1yBGT85GYMfR/S2xitbcSZV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cp+DpYOq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cp+DpYOq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F66BC4CEDF;
	Wed, 15 Jan 2025 10:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938680;
	bh=cqESr7Tf5Fz8Qk/4scQoV4ileADtq8+WwJRkdkNqo7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cp+DpYOqMjrPJr9drwIG9eFfGIlTJmHuVnfzyScAbDxmmENU9x/LMhal6XDTw0UoO
	 j9gBmU9YHZHE1tMoZKRCRo7Z/5Y79tU1TIqaMedqSN/e6NuT8iqXJbIonn5xMAy1ei
	 blVXmY7KlZ8g8QhXJAdRGLIGB2uvcPDvvylY9x5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 063/129] sctp: sysctl: rto_min/max: avoid using current->nsproxy
Date: Wed, 15 Jan 2025 11:37:18 +0100
Message-ID: <20250115103556.892608896@linuxfoundation.org>
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

commit 9fc17b76fc70763780aa78b38fcf4742384044a5 upstream.

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
of this fix, to use '*data' everywhere 'net->sctp.rto_min/max' is used.

Fixes: 4f3fdf3bc59c ("sctp: add check rto_min and rto_max in sysctl")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/67769ecb.050a0220.3a8527.003f.GAE@google.com [1]
Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20250108-net-sysctl-current-nsproxy-v1-5-5df34b2083e8@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/sysctl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/sctp/sysctl.c
+++ b/net/sctp/sysctl.c
@@ -437,7 +437,7 @@ static int proc_sctp_do_hmac_alg(struct
 static int proc_sctp_do_rto_min(struct ctl_table *ctl, int write,
 				void *buffer, size_t *lenp, loff_t *ppos)
 {
-	struct net *net = current->nsproxy->net_ns;
+	struct net *net = container_of(ctl->data, struct net, sctp.rto_min);
 	unsigned int min = *(unsigned int *) ctl->extra1;
 	unsigned int max = *(unsigned int *) ctl->extra2;
 	struct ctl_table tbl;
@@ -465,7 +465,7 @@ static int proc_sctp_do_rto_min(struct c
 static int proc_sctp_do_rto_max(struct ctl_table *ctl, int write,
 				void *buffer, size_t *lenp, loff_t *ppos)
 {
-	struct net *net = current->nsproxy->net_ns;
+	struct net *net = container_of(ctl->data, struct net, sctp.rto_max);
 	unsigned int min = *(unsigned int *) ctl->extra1;
 	unsigned int max = *(unsigned int *) ctl->extra2;
 	struct ctl_table tbl;


