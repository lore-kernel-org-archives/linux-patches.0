Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A09A1F540C;
	Tue, 21 Jan 2025 18:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482837; cv=none; b=CsBTrukxCKwo6Vk96tz8a4Jyd/IfSt8jW2/383zs1JIZI+9gB9XH5R4mNpAyoCi3dz8QZczuR4hLRPEmX2TBf+nNnD7S18cU9nTjTe+etsCEbTxu80AamlvzDie9PmWUWv+JeWY8gwJjBqeKJgLv5ZDZhzCmvNMHDHAl+Sb8fl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482837; c=relaxed/simple;
	bh=2nQUHW9ATwQxlY4gl9GqosFLqec8ISuPVFNmBk4da+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OETjXeElTUAoxfhE9FlT8DoycrLCOneKwE5dzXcvhf9BOquYubUnj0EYoO9ADYXa9sDnrF+3/3i2/mMAKQVoYAnytW0JMR9FimqbOB325ni3Lf2/5KupvDRTltaIr8pAvXy71N76biYDVvw+4emO1imwiquwjEVJomdDH7onti8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i1ImT2n9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i1ImT2n9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90AE4C4CEDF;
	Tue, 21 Jan 2025 18:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482835;
	bh=2nQUHW9ATwQxlY4gl9GqosFLqec8ISuPVFNmBk4da+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i1ImT2n92gvme+jHrwUAqwmq4U26LFOFaztvVWQf9Qop/bseA8MphijrEnJrb0wX8
	 F2KaE49SPWezoCbER7be5TtFCS/jnweiqaD59EDaSydbBY7nrMfbcnXSecTaccofrD
	 66Fsc/9LA4nZ0q8DhPzhcsr/UHYk23m4a9uHGq6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 024/127] sctp: sysctl: cookie_hmac_alg: avoid using current->nsproxy
Date: Tue, 21 Jan 2025 18:51:36 +0100
Message-ID: <20250121174530.605953925@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


