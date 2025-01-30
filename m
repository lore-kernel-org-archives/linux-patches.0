Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F3B1BDA95;
	Thu, 30 Jan 2025 14:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246709; cv=none; b=CyA6mG3TxArKYzYXgwKA3usX3Pff21qUNEQwb/fG7djQ2fy7JML6U5kBU8BmEHNuzYaR+y0h+wWMneaXnOnmqSvUjucF7RRVIS9P19Kwptcw/7NgWGKz89q/VPzzdMVP2/Q1Q2A2Szh7+FDJzQ+074A6mBAk04RfcLvPtrMmYlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246709; c=relaxed/simple;
	bh=vXTzCZqsvRDzNg7dVQvp0P778GjNpdy7sYZHdob7XKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o0wavcSGXbI6ku0OPVpm98HLYbeLBwGBmaQ0lum8c5EvuEoI89KuMVXapqmy75crCMjDtKQMn4+n7qc5kTkxcf/8QWrh6fzTKLQvaSQVKAxAHtjT51nyJhYZLHvEJi9xv/Ps+Bad92uYCasK6S3jMeJhg8gadun4BLQxhiRtpW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rpeoVSfH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rpeoVSfH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F79BC4CED2;
	Thu, 30 Jan 2025 14:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246709;
	bh=vXTzCZqsvRDzNg7dVQvp0P778GjNpdy7sYZHdob7XKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rpeoVSfHsNySubCUYxOc+1MURUZ3JcDByMAQjrZfwrJTHKeP2kVmyRVIQkuxxFzoC
	 VtsiD7IdnK1qn/ZjOKklnANI9CAXWcktqqe9MtLc1+QROuPck1hVBPGuX+j75PflvT
	 ha4/9eR4G03dVI5JwQK/rZUrf6QnZE0Y+zZTSB8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 13/91] sctp: sysctl: auth_enable: avoid using current->nsproxy
Date: Thu, 30 Jan 2025 15:00:32 +0100
Message-ID: <20250130140134.198925063@linuxfoundation.org>
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

commit 15649fd5415eda664ef35780c2013adeb5d9c695 upstream.

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

Fixes: b14878ccb7fa ("net: sctp: cache auth_enable per endpoint")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/67769ecb.050a0220.3a8527.003f.GAE@google.com [1]
Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20250108-net-sysctl-current-nsproxy-v1-6-5df34b2083e8@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/sysctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sctp/sysctl.c
+++ b/net/sctp/sysctl.c
@@ -326,7 +326,7 @@ static int proc_sctp_do_hmac_alg(struct
 				void __user *buffer, size_t *lenp,
 				loff_t *ppos)
 {
-	struct net *net = current->nsproxy->net_ns;
+	struct net *net = container_of(ctl->data, struct net, sctp.auth_enable);
 	struct ctl_table tbl;
 	bool changed = false;
 	char *none = "none";


