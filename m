Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A502D1BDA95;
	Thu, 30 Jan 2025 14:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246925; cv=none; b=Hx3XIbPavuXVzxHqAGYu+cjDH7Xe6AoCfKUwDOSmFr27IDaai5lDO41fpIu7HEFmB7uV4XWOwVsw7Cr4frN2nGgiezhJs1W+gtVyv/6dpdmoE/7djDLfATh7FRyjzvqquh71dwSvOV/5Rky0Qi8ZmsbtSlCIylnn/LjemXEB8fY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246925; c=relaxed/simple;
	bh=j61HdD3KIbyOhys3/bowKS8FEi/0RmYqY75iaYL1XP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DEKa00yHuUyiFZl3YjMDF/LgmpUgoqEfY/IxE8qQtztcyn44whCFRJNGpu5EGe+608lycYXllBbglL8/4fTWWrf9DNKWWF32c1aKspXjNT1VxTgmf4PEgJ474rpUPubcl+cW7lkFVlHIRzHVqZ6JDzPXJUF2KwDJRCs2NsGhanM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tGQgXK8N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tGQgXK8N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31DE4C4CED2;
	Thu, 30 Jan 2025 14:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246925;
	bh=j61HdD3KIbyOhys3/bowKS8FEi/0RmYqY75iaYL1XP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tGQgXK8NqcLH3CwGD3kndzBEXWeGgfh0wCOB/c/5O/hcBkr1TEvbqaiNeKFAayXbi
	 mErwyBAKxiNB8maR/Is2XkW6b6z1OT77WhebeRv7up/1EouLDHi9edNbOINB4d4Abs
	 F7MowEVcMrtSUo8BkFMhDlaR0T3fVuzVpkPyZNGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 022/133] sctp: sysctl: auth_enable: avoid using current->nsproxy
Date: Thu, 30 Jan 2025 15:00:11 +0100
Message-ID: <20250130140143.405718864@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140142.491490528@linuxfoundation.org>
References: <20250130140142.491490528@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -462,7 +462,7 @@ static int proc_sctp_do_alpha_beta(struc
 static int proc_sctp_do_auth(struct ctl_table *ctl, int write,
 			     void *buffer, size_t *lenp, loff_t *ppos)
 {
-	struct net *net = current->nsproxy->net_ns;
+	struct net *net = container_of(ctl->data, struct net, sctp.auth_enable);
 	struct ctl_table tbl;
 	int new_value, ret;
 


