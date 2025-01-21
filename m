Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDD761F756A;
	Tue, 21 Jan 2025 18:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482841; cv=none; b=BPdwPO0kY1TbrqjOAn0YQ2TEiTbeqdGGZQOw3Mrh1T1721EgdNGd8z6a90aHbb7EsnFoaUbyIr+exHBf5iC+QpFP2ywqcpBzAohBsp2y1itjVO7q52Ay8HwFEAwmUyB6i4kkAjIZ8qMifiHp/BCbOqljVO0jeLIZ9oHVgwsOhDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482841; c=relaxed/simple;
	bh=pbJadYfwB1mEm+HPHBGHqVnghArJxfWunR/F5UAWzqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cch0aojrAmURmfbapBAAxI+aukdB3RPIoEPGx1ppAWaQBhdeLJopKEQIU9x3Zaur2iBU0GkIsTMWzQDJqK5bVh7SH5xfNIeJuc3yrRxpuoZ9LOaC9ZywqXdL77aBz0kUxkJzVt5MoBehcOZxKGgOTO7eGoJ4x3RqSct2EtgwtUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pzHjwzpo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pzHjwzpo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FF21C4CEE5;
	Tue, 21 Jan 2025 18:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482840;
	bh=pbJadYfwB1mEm+HPHBGHqVnghArJxfWunR/F5UAWzqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pzHjwzpoy5ZAtdyMtFKYn+nvJRf23o622WVlRYHtiHEuTNHjYGc4Ko/YjMfyfDYAp
	 Yaq8o5/WIvaN2S2AQGePbKpbhDIHSZxylcJ0ONgD33RPGWAGCSFbVuNDQMqtpfbpX5
	 tKV2b3ZZaw9XoM8G+5dETcRwI4/AUcnq/kUMsZh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 026/127] sctp: sysctl: auth_enable: avoid using current->nsproxy
Date: Tue, 21 Jan 2025 18:51:38 +0100
Message-ID: <20250121174530.681063539@linuxfoundation.org>
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
 


