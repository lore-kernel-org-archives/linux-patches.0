Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79759248BC4;
	Wed, 15 Jan 2025 10:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937635; cv=none; b=mDgo1b7KbGxMnh1qh/pr2ABidQ6GE9Tw+m1BVoTz8HY9uov/+F3f5yPBNNIwmWrh/CRtF+quLSMdboZdA2vCS5ODeVan5jEFLPb2mgsv7165VsXrK0iq9kdF0U7nDGGAJ1gR9Irx0wBXVBo1en+3wWveg8LzuRxe4S+IY9HK2mM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937635; c=relaxed/simple;
	bh=hc76LcOQB60j7H7uJ/hycBgaWFf/73SVvgzSYh0dPv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UYPP9RmPM88roWTtwHtOOBqUJVMvA/PgaCAEUEO2vYDbWqpPtXmDz3AJ5F9zNamkhg4J/aD1xSwb1hhQlv649l5owgygthorStHDa1c763JZBgMkC1vB4U7F8MSnX0z+jtZOzcCYCmYxXSwqcR4XpjCbfIC6FbQVBeIQ+ILv+qI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qp66sTdH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qp66sTdH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D861FC4CEE1;
	Wed, 15 Jan 2025 10:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937635;
	bh=hc76LcOQB60j7H7uJ/hycBgaWFf/73SVvgzSYh0dPv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qp66sTdH64Er9x3ZlGd22JWYWCiPLAOTT92zqrSUi8tcBUXLN7nFeQMlpF+T6F4A/
	 5canzfEtvAYqRdxlMw9gQcANEoilKxwYr21hiLdTmEHSHU2hgUF8aPEQuqqA6Y9t2a
	 bOHYnNn1fcOBzcryyrfcuyarwfwQnukDjjYizmuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 38/92] sctp: sysctl: cookie_hmac_alg: avoid using current->nsproxy
Date: Wed, 15 Jan 2025 11:36:56 +0100
Message-ID: <20250115103549.047359820@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103547.522503305@linuxfoundation.org>
References: <20250115103547.522503305@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -380,7 +380,8 @@ static struct ctl_table sctp_net_table[]
 static int proc_sctp_do_hmac_alg(struct ctl_table *ctl, int write,
 				 void *buffer, size_t *lenp, loff_t *ppos)
 {
-	struct net *net = current->nsproxy->net_ns;
+	struct net *net = container_of(ctl->data, struct net,
+				       sctp.sctp_hmac_alg);
 	struct ctl_table tbl;
 	bool changed = false;
 	char *none = "none";


