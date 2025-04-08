Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DC3826A085;
	Tue,  8 Apr 2025 12:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113815; cv=none; b=LhzasiDsVLv+d5I0LAjVqTpHhhQkl+qOudZYc1hmNz5QHF93I2kD89yQ/zcrvg4+1S90C0AUQ3wKwUJnvr0hk+XZUTKtNWfG2U+Dw4l4KrX0EQ3wfaFVnG/CpxIpQlFPEkr2OeAOynJeo2y7+lIxv6/DySCJqoDAQ9qm8mRXsS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113815; c=relaxed/simple;
	bh=Ivn6WBmWt9L1skMe1F+WdOb1+12Q2vj54MKgxmo6tjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YkJjfwpKuHPqp17XTMfJ+Xz4526fZmTEU48MRAkMvFnU2SgbZ8evuV28LIwjuJt9orDm+6EJTlZcp8NNV1cjAAsGuZBy/4LO857V7A2fsrwXgWmhkDaPCnEyon6IrHrWT77aSakK75L3qUM0bHorI7PEEeKGinyoAOOgKXvB3PI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uM74s5Da; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uM74s5Da"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92FB9C4CEE5;
	Tue,  8 Apr 2025 12:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113814;
	bh=Ivn6WBmWt9L1skMe1F+WdOb1+12Q2vj54MKgxmo6tjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uM74s5DaAMtwqJUY6zsdL+dh9PQLZdrAAaCROK+vVYFnJpBlUzduaQKdxY5wWNJIY
	 EoO6QVabIyruFS4EQhoQjn8f8XMAKHJ2eO6i0spndjtWUAcuT+NlsQornMoJDfLP0j
	 Gl/BW/p2c8J64zkLkN+VqUqxw3wAYzgFLeGcZynA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Magali Lemes <magali.lemes@canonical.com>
Subject: [PATCH 5.4 007/154] sctp: sysctl: auth_enable: avoid using current->nsproxy
Date: Tue,  8 Apr 2025 12:49:08 +0200
Message-ID: <20250408104815.526745509@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
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

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

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
Signed-off-by: Magali Lemes <magali.lemes@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/sysctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sctp/sysctl.c
+++ b/net/sctp/sysctl.c
@@ -442,7 +442,7 @@ static int proc_sctp_do_auth(struct ctl_
 			     void __user *buffer, size_t *lenp,
 			     loff_t *ppos)
 {
-	struct net *net = current->nsproxy->net_ns;
+	struct net *net = container_of(ctl->data, struct net, sctp.auth_enable);
 	struct ctl_table tbl;
 	int new_value, ret;
 


