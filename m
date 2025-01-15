Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EBD9248BC8;
	Wed, 15 Jan 2025 10:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937639; cv=none; b=EOxhHN/2iZAcmK6GAOgGi0MSVhhL+89irDw+qrV4jAngFYl8UA0g/nAbAxJ8X5PWQCaGgclLqYv+Dbf3ELtlg/HuTc3VgWPv2hdBBz6CKT77mAnCHmTi0q97T3Hw52D9fs0GDFCswNE59Z0fgZNx7Lwr81u4H7IYMdeEghHd6LM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937639; c=relaxed/simple;
	bh=Ap3kRZU70gF6i46VQgBA5JTreu9gQufKJnFNH6TQgUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q6GL9PmdB/pzLQSs+lYKdvDWSY1YwZP+JRw/Gi7KMyEBbhMm5Rf3huykynechV+vdWkW17SgzPn0K9S8c6v6939YWdY6uP/nMLks/UthFGMcEr1nu8lKX937SZ4Ft9LmtnDpBrSX2Mzf3SDAZa5wGL8ptSRKFKZ8Y4TpKPkaUNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n+TAecfA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n+TAecfA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73E5EC4CEE1;
	Wed, 15 Jan 2025 10:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937638;
	bh=Ap3kRZU70gF6i46VQgBA5JTreu9gQufKJnFNH6TQgUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n+TAecfA5qenbUxNdCN7wgHzWzbnTzS7HyHrHmsilSDi5hZApP7X9a3PrlwD25bQ8
	 1IVmLuDTm2hLsY4+ghobCCl3GF4cRiWv06Q75/6eF2HwKalI21rt5/7d0CIVNI5LYl
	 nTvC0NyOdObSyBoafbCRSvfFS35Ug2xlpaM1BxBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 39/92] sctp: sysctl: rto_min/max: avoid using current->nsproxy
Date: Wed, 15 Jan 2025 11:36:57 +0100
Message-ID: <20250115103549.087410041@linuxfoundation.org>
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
@@ -426,7 +426,7 @@ static int proc_sctp_do_hmac_alg(struct
 static int proc_sctp_do_rto_min(struct ctl_table *ctl, int write,
 				void *buffer, size_t *lenp, loff_t *ppos)
 {
-	struct net *net = current->nsproxy->net_ns;
+	struct net *net = container_of(ctl->data, struct net, sctp.rto_min);
 	unsigned int min = *(unsigned int *) ctl->extra1;
 	unsigned int max = *(unsigned int *) ctl->extra2;
 	struct ctl_table tbl;
@@ -454,7 +454,7 @@ static int proc_sctp_do_rto_min(struct c
 static int proc_sctp_do_rto_max(struct ctl_table *ctl, int write,
 				void *buffer, size_t *lenp, loff_t *ppos)
 {
-	struct net *net = current->nsproxy->net_ns;
+	struct net *net = container_of(ctl->data, struct net, sctp.rto_max);
 	unsigned int min = *(unsigned int *) ctl->extra1;
 	unsigned int max = *(unsigned int *) ctl->extra2;
 	struct ctl_table tbl;


