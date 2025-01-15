Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81F24248BA1;
	Wed, 15 Jan 2025 10:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938247; cv=none; b=vFhKhV8XiYgDuunPd+Qbr5IuCoDm7c5/qAwTxAMOTWGByR6AG+aHOdV6Xb9ZN18GrD9LBQh4puGKFDDiYsQxDlJJATaQg1kS1LV7Q11olzrv1kVL4v9zNYpVEjajbms+dkDyFWadd2ndVuB386/6wL9YXLw0q5xA9K0p5spbW6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938247; c=relaxed/simple;
	bh=6nuX7+VQVs3hl8HxA2WkoHtWIYpdsb3v9yj8L5qg1pE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rfWFsuSl/CCOz/Mf/QxpJOGnr6nAwbl0c1h8ANBKVmShdvWDM7OEaA2G7QAXBn8WUYPZUATWNd+YYbuZSxX6ZqaBAnXCiPE7TUvT1YZehvcfn0mBGCYoZjsE9SCeGkfK8DE4N2JFj2O+xuXrYC6ljNrx3Eo8cC5P1MLevYLKpTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O00lvOm2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O00lvOm2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4C4AC4CEDF;
	Wed, 15 Jan 2025 10:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938247;
	bh=6nuX7+VQVs3hl8HxA2WkoHtWIYpdsb3v9yj8L5qg1pE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O00lvOm2/wqbQM9v6hhiuSuZe3lzWMnXJ23tQloXiwTjs2JlmAJNF5QtwJp4laxr8
	 QWBtdeATJERcp6uuXiZcjJo0CIsr5POQi3lgZ4usn502ex0xz05ZMOs5BF9S+JI2Qt
	 EH824sfCXaXvwqVLlzwA+MPDVECgjveOxIn09bU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 096/189] sctp: sysctl: rto_min/max: avoid using current->nsproxy
Date: Wed, 15 Jan 2025 11:36:32 +0100
Message-ID: <20250115103610.153124630@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -433,7 +433,7 @@ static int proc_sctp_do_hmac_alg(const s
 static int proc_sctp_do_rto_min(const struct ctl_table *ctl, int write,
 				void *buffer, size_t *lenp, loff_t *ppos)
 {
-	struct net *net = current->nsproxy->net_ns;
+	struct net *net = container_of(ctl->data, struct net, sctp.rto_min);
 	unsigned int min = *(unsigned int *) ctl->extra1;
 	unsigned int max = *(unsigned int *) ctl->extra2;
 	struct ctl_table tbl;
@@ -461,7 +461,7 @@ static int proc_sctp_do_rto_min(const st
 static int proc_sctp_do_rto_max(const struct ctl_table *ctl, int write,
 				void *buffer, size_t *lenp, loff_t *ppos)
 {
-	struct net *net = current->nsproxy->net_ns;
+	struct net *net = container_of(ctl->data, struct net, sctp.rto_max);
 	unsigned int min = *(unsigned int *) ctl->extra1;
 	unsigned int max = *(unsigned int *) ctl->extra2;
 	struct ctl_table tbl;


