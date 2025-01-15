Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851FF248BB1;
	Wed, 15 Jan 2025 10:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937646; cv=none; b=a87pxCWDWW6kRlLjEixFBJkbNEsEs/j+knZxouJQs1kYQ1U/vbQmAhDymP0hQLtpdlRoISaOFJW6/H8Mj5ihMcpT2drvMrVvuksiQRbhyWS/+wWXWuhsFMBg+Nebc04gh6UVogyCa2fXVQsMzK60Zr3PxGo5TB/8RoGVmib/YOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937646; c=relaxed/simple;
	bh=RTxXX4TJQHqKjy2jxJFwyNOHLG9AbYV4oiK3mYgBIgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zislz/HK/FYVL/QpY9+OQtMIRdJCMh8x5iahSz1RflOhMZWPdzSns3b4MLEsQaoBYv2oMwrqwr63eB7vwaCriVDL1vE5E46VTdUx8rWW9pD7BUe6k3OiuAm/9Y7MLQJGfd6y/P0ss96CSYa+elujfmLOR92A5Q8u1as5QwTtjIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=re+MqxHL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="re+MqxHL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6886C4CEE2;
	Wed, 15 Jan 2025 10:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937646;
	bh=RTxXX4TJQHqKjy2jxJFwyNOHLG9AbYV4oiK3mYgBIgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=re+MqxHL+zv9AiaVVKAkJuRpptp92eFuuXlJ9F3L20mCr67uyWG7YMPl1GMkeyNcG
	 9FqKzlgOkAO9i7ZmcuXG78LT/nIc8h3lM6YedfLyQFdiX+4ALbsudqoKRtZZHH5bc8
	 qvDZK5Ju16sXXe7dF6Ts1EZ6mhTorzVeuBUCTNg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 41/92] sctp: sysctl: udp_port: avoid using current->nsproxy
Date: Wed, 15 Jan 2025 11:36:59 +0100
Message-ID: <20250115103549.168057819@linuxfoundation.org>
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


