Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE13248BD1;
	Wed, 15 Jan 2025 10:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938254; cv=none; b=EnQXv6JEmD26aYBZFIyAl52Fv7Wxngkmov9nlx7yZsUA3g+gS8ll+Q5aZ0vItWS53rtrWxrdRKICEfD7aalRO21A2//Xkz7Fe164+YycUjECEMsGmnz6dZBNUtJZE0DuUG4MKHyY53bxggA1+tRq/K16XK1vFi7K3TL0SEje3oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938254; c=relaxed/simple;
	bh=hIH+24RAEibWf4+uGns6mG5niDs5POMN8n6CCo0oJls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bfbwh+0KgKds81OuTG9lfam+8rTxKf0ATsG2LSlOrL2HsgVI6VnwKAwmNT06V1GAZQwxbtvnSe0Z/UGXgUX0vmCWqk/r8DIXEJYD65E78j/nG6IeSRvSOWqqiv7hkujaYR3G4WtluPc7UtqCnKfIKBuu6+Bkll108fTpMSiPARY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a/Wjpnat; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a/Wjpnat"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CF3EC4CEE4;
	Wed, 15 Jan 2025 10:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938254;
	bh=hIH+24RAEibWf4+uGns6mG5niDs5POMN8n6CCo0oJls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a/WjpnatSJlYbFKO/MdWKPBJxoplytIQSK4F6sgiF3z6dH3BgzkS0uSVej8gMUiYY
	 ZaV5mPm2adkn4NG7HM2o3rnYvhdRvfH9tvNugZXQYWkainaF+qAblD6qN9W7dv9H8F
	 x2eM11/4JQ0K1xf+QdSrcX0bE253rviZcmXTWofk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 098/189] sctp: sysctl: udp_port: avoid using current->nsproxy
Date: Wed, 15 Jan 2025 11:36:34 +0100
Message-ID: <20250115103610.232138099@linuxfoundation.org>
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
@@ -528,7 +528,7 @@ static int proc_sctp_do_auth(const struc
 static int proc_sctp_do_udp_port(const struct ctl_table *ctl, int write,
 				 void *buffer, size_t *lenp, loff_t *ppos)
 {
-	struct net *net = current->nsproxy->net_ns;
+	struct net *net = container_of(ctl->data, struct net, sctp.udp_port);
 	unsigned int min = *(unsigned int *)ctl->extra1;
 	unsigned int max = *(unsigned int *)ctl->extra2;
 	struct ctl_table tbl;


