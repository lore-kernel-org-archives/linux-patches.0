Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9998248BA8;
	Wed, 15 Jan 2025 10:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937642; cv=none; b=s+dINY2YDUPBKGJhFsYPVZR2Y1aYNTZJ9Omf6+SMsSGgHG/9I/CXXiLhdPUT4nVJGjsgK+iGXlNotb/4icEZDWDA+gu50jIrnoH1EOBiNwqUrYkuWqtKyoyZXvJHiMNtquiP0ZySsKRQUw3APQGSyGg5C9bwlmZeBVR8VHUc4xY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937642; c=relaxed/simple;
	bh=ij+qBTOGI5mE1JuAhtQ9cu2v8FJrkgY5hIui5MWZwLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ifMcVDJNv9akVpIEDpmVqzYFSiEgsZSA3MP08pAkIQJpraX0PSXH8+YnTSYHixd3reXnK4UpMCvYVOeCbblBi4dYbGRpDAoYL/YTYBKoSreLKDW/1I3Mw7fM34Wac+Ntw35gz4OfqOVRhUEYDj+xvdDLDHk64sdkoTdGJPN8aTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mc5/krNv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mc5/krNv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6225C4CEE1;
	Wed, 15 Jan 2025 10:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937642;
	bh=ij+qBTOGI5mE1JuAhtQ9cu2v8FJrkgY5hIui5MWZwLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mc5/krNvSdTzrf4mrqsVHT1nyM0fv8sywIR4c83WpBVrOuNb9cc9N/0S0StHntvcy
	 IxwCsKS/MrF6JxxmhozIrET/xYgK8MMWZPWv9dpdtUOfnUeHz4pcKZNzYCCBkGIVr5
	 Hd7J/knh72rn/TFiAoNr3xzE/oFLg4MFU5Xt5c4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 40/92] sctp: sysctl: auth_enable: avoid using current->nsproxy
Date: Wed, 15 Jan 2025 11:36:58 +0100
Message-ID: <20250115103549.126205811@linuxfoundation.org>
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
@@ -492,7 +492,7 @@ static int proc_sctp_do_alpha_beta(struc
 static int proc_sctp_do_auth(struct ctl_table *ctl, int write,
 			     void *buffer, size_t *lenp, loff_t *ppos)
 {
-	struct net *net = current->nsproxy->net_ns;
+	struct net *net = container_of(ctl->data, struct net, sctp.auth_enable);
 	struct ctl_table tbl;
 	int new_value, ret;
 


