Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFBB11F5438;
	Tue, 21 Jan 2025 18:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482846; cv=none; b=F+A2fxf3O/YiX7kojKVYpKpdSFAcI9XzLfdnMWtIKuiW+XNr/wvQW5rriZzGcgkZndJbYCJHcJUfYLZjkl/ndUn/yGiufsYRNiWFrdSj6kHGV0cxZZaXBnwvvE9dHWVLdsQ7+/TTND71IQfoVO0+Jspr7VbmqGE0hJq/j1c3pUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482846; c=relaxed/simple;
	bh=vwP3fhDgMCkv+qLS+JnYUSTm9ZyEaFUkN5sAr7uE1nc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zx9/4mwRL6leZDC3waiQmRvEJE7GFWbNTj+ozesEKcernVrgxB0zPZSM0sslYrIfGRVWJhYcGqs82yXge+WdzpCcXqJf8PXdTAPW7Se+lk2mI8FZ7scUGyDWzjoNU+UJe5nDskuILwjW57SmfmwNxl8Jcs6ViJs6KZpe5MW+L5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rmV848Fz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rmV848Fz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E283AC4CEDF;
	Tue, 21 Jan 2025 18:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482846;
	bh=vwP3fhDgMCkv+qLS+JnYUSTm9ZyEaFUkN5sAr7uE1nc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rmV848FzYeG0t4yjvSsxqs/yJQ/mYWCpAcT4g34AKCJ0l0l6Da/bG8PNPzUYdD8qu
	 hEHAez+zVvDoo6z8oEmVJUgObvArBsDk1qnE2YCSZdhXNbFN/wQ2KqDjHR7gV586hG
	 f34JQ5yB4le76Ymmy1co3dV3B4ghNcr3QXCLPg6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 028/127] sctp: sysctl: plpmtud_probe_interval: avoid using current->nsproxy
Date: Tue, 21 Jan 2025 18:51:40 +0100
Message-ID: <20250121174530.755563608@linuxfoundation.org>
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

commit 6259d2484d0ceff42245d1f09cc8cb6ee72d847a upstream.

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
of this fix, to use '*data' everywhere 'net->sctp.probe_interval' is
used.

Fixes: d1e462a7a5f3 ("sctp: add probe_interval in sysctl and sock/asoc/transport")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/67769ecb.050a0220.3a8527.003f.GAE@google.com [1]
Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20250108-net-sysctl-current-nsproxy-v1-8-5df34b2083e8@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/sysctl.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/sctp/sysctl.c
+++ b/net/sctp/sysctl.c
@@ -562,7 +562,8 @@ static int proc_sctp_do_udp_port(struct
 static int proc_sctp_do_probe_interval(struct ctl_table *ctl, int write,
 				       void *buffer, size_t *lenp, loff_t *ppos)
 {
-	struct net *net = current->nsproxy->net_ns;
+	struct net *net = container_of(ctl->data, struct net,
+				       sctp.probe_interval);
 	struct ctl_table tbl;
 	int ret, new_value;
 


