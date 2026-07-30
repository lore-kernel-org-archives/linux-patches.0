Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34A0941DED0;
	Thu, 30 Jul 2026 15:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426774; cv=none; b=qEWTtkijahRysNE+bMEKQ0sJ5xJ94U0Da0AiSwbQAIxvKyEXivWkWPqjeWk8mPDCh2pXF/eORa1AYu51jJqEi6r4DAykDaG0v02DpOKPLJDwjmMLcz2VqUekTmb+HheiEBDja8ZESPLPUhD0ZOceK9jk7b9M9bvCT9crq7xADcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426774; c=relaxed/simple;
	bh=qU4IJ0mtwLa67yHDSoKAGFItLRejoC6wPtg236QrFpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kZ1aTfLe9UyChK5u0yOxDRtr/6t6wMmHb/oH++EKdF/mvjtluJjz+WCP5sWgdpWhrPJ9tCUQ9UaSR+exVH5VgjRvFIcvP/FIrcDNmHZE5n3Te96Q5YFIZI0/G5UVNcSrbP57iSbH8qBeYYtypEr/fq0QrD/Dhf2Tk6zFMMennUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X5TXrVcQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X5TXrVcQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 521281F000E9;
	Thu, 30 Jul 2026 15:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426772;
	bh=GewyNw1l4M80e1arTn+dRTfCd5p6X6dqkFu4Z1dfN+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X5TXrVcQ1cZltEYng+KblmN7RPxh0a+mVjKqdwk11UjbVLzJVh5o6580SgHKLaUji
	 mHCNRGOqTkbaS+tHj/vn2WF9Nn2N9IOPVKy1040qTeRGrU/xir3xEOYCzIK9H2XlqU
	 jQcVq8fUCgL07LePMLZpxJW6U7+DqGkWjshnfHtg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qihang <q.h.hack.winter@gmail.com>,
	Dmitry Safonov <0x7f454c46@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 537/602] tcp: Decrement tcp_md5_needed static branch
Date: Thu, 30 Jul 2026 16:15:29 +0200
Message-ID: <20260730141447.305738830@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Dmitry Safonov <0x7f454c46@gmail.com>

[ Upstream commit 6f6e860e370c9e4e919b92118a25e9e1f82e9180 ]

In case of early freeing an unwanted TCP-MD5 key on TCP-AO connect(),
md5sig_info is freed right away (and set to NULL). Later, at
the moment of socket destruction, the static branch counter
is not getting decremented.

Add a missing decrement for TCP-MD5 static branch.

Reported-by: Qihang <q.h.hack.winter@gmail.com>
Fixes: 0aadc73995d0 ("net/tcp: Prevent TCP-MD5 with TCP-AO being set")
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Safonov <0x7f454c46@gmail.com>
Link: https://patch.msgid.link/20260625-tcp-md5-connect-v3-3-1fd313d6c1e0@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_output.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -4124,8 +4124,8 @@ int tcp_connect(struct sock *sk)
 			tcp_clear_md5_list(sk);
 			md5sig = rcu_replace_pointer(tp->md5sig_info, NULL,
 						     lockdep_sock_is_held(sk));
-			if (md5sig)
-				kfree_rcu(md5sig, rcu);
+			kfree_rcu(md5sig, rcu);
+			static_branch_slow_dec_deferred(&tcp_md5_needed);
 		}
 	}
 #endif


