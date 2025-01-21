Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C8531F758A;
	Tue, 21 Jan 2025 18:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482843; cv=none; b=jsGfKGVM5NP0eZ8EU/H9rexQ15Uh+ykIbsELcmRRkBPJLDnY23wWKel2ceRm3Du8lW6uDrVyOA92H/E2x5x2TdVfaNfrOasuEO/0oAbC/W8HdWlNJVSdN8dycKWASplaSPf4yf0RR4B0f/QAJlO4PmumFkOW0MuwjZN//4LqP3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482843; c=relaxed/simple;
	bh=qHrI365nZiI0shUf/Tg0UhH2J9qNiVgPuChmEf1vhfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J3p5mGCA2osyawK2DOuyVqTs/Mq0MfvPZYDMKMEYmOUh3CoGhOD3bmNGSC+joB7m5r9uMzvWuQTYcDLxxd2o5aIKLbDwTkwzOL5yLBUzHYuhqsGgwAE7tP45ebE7j6kgZZ8VB8IJFV++06BJnT3ZgozYpe0U7842ah1svEBx5po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FpAqDPjW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FpAqDPjW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 268ABC4CEDF;
	Tue, 21 Jan 2025 18:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482843;
	bh=qHrI365nZiI0shUf/Tg0UhH2J9qNiVgPuChmEf1vhfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FpAqDPjW4iKhIaH0yo3ps5xw6BDsUP15N25rvlQQDt0v48v4fbwTL7NPRNJTSQEBz
	 rWc07Z6iGKJ4eN7xBv9DPYbePrnUIcwjsPwCWPen0Aweq7n6LakV+Xu0i/3urFtBvI
	 D4/rDnOwtnZ4lFa5PmKLitemOWTtaBRvqGeOTLvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 027/127] sctp: sysctl: udp_port: avoid using current->nsproxy
Date: Tue, 21 Jan 2025 18:51:39 +0100
Message-ID: <20250121174530.717277545@linuxfoundation.org>
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

commit c10377bbc1972d858eaf0ab366a311b39f8ef1b6 upstream.

As mentioned in a previous commit of this series, using the 'net'
structure via 'current' is not recommended for different reasons:

- Inconsistency: getting info from the reader's/writer's netns vs only
  from the opener's netns.

- current->nsproxy can be NULL in some cases, resulting in an 'Oops'
  (null-ptr-deref), e.g. when the current task is exiting, as spotted by
  syzbot [1] using acct(2).

The 'net' structure can be obtained from the table->data using
container_of().

Note that table->data could also be used directly, but that would
increase the size of this fix, while 'sctp.ctl_sock' still needs to be
retrieved from 'net' structure.

Fixes: 046c052b475e ("sctp: enable udp tunneling socks")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/67769ecb.050a0220.3a8527.003f.GAE@google.com [1]
Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20250108-net-sysctl-current-nsproxy-v1-7-5df34b2083e8@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/sysctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sctp/sysctl.c
+++ b/net/sctp/sysctl.c
@@ -521,7 +521,7 @@ static int proc_sctp_do_auth(struct ctl_
 static int proc_sctp_do_udp_port(struct ctl_table *ctl, int write,
 				 void *buffer, size_t *lenp, loff_t *ppos)
 {
-	struct net *net = current->nsproxy->net_ns;
+	struct net *net = container_of(ctl->data, struct net, sctp.udp_port);
 	unsigned int min = *(unsigned int *)ctl->extra1;
 	unsigned int max = *(unsigned int *)ctl->extra2;
 	struct ctl_table tbl;


