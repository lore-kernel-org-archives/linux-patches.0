Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03546333AB5;
	Wed, 17 Sep 2025 12:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113718; cv=none; b=NZWejOaqbXNXwU5uDIM0RVXW/JOjCFH0OWjH7JGRe254hXT9OLuIswYfn/Nv9cEuzMdrd2nAzaXa8M/nlAHRgz3BX95A1pCySg3cv6LN+RTpZAwRX1jPe6vTjRFdrEhxJNE91xWpjpgVuiqRQ8TK4XVN2EgvkAl7IzgfLCKwOlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113718; c=relaxed/simple;
	bh=Yo4kS1hwRlcfO/4MHVVopA7k/ZyZWKSZsaIaVE0A+NU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IgW0QJ7Qm8VJIUxWesm+0PC+hRM2QW0CTTjbO+rng/S8r8dpxFqWrVfe6ckEqGXHlmKiBmce+kv4EfIt/XWY2eXYmhti/9Ubnd9hH0eJBdTW394ceoaDn09n2vm0lvqD6dTasgtsikaI3H+tuZ4PpTeNJYxrtlLK3qyqmYpiFEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UhXUuTv0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UhXUuTv0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2020CC4CEF7;
	Wed, 17 Sep 2025 12:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113717;
	bh=Yo4kS1hwRlcfO/4MHVVopA7k/ZyZWKSZsaIaVE0A+NU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UhXUuTv0KRKgl23OqjE0MPmVwzr2hQBkeTU6gYvCS0+zbNvYJ88AOA0CCMqORZOId
	 IfBSfY7qF/lqRH/5nJmfMrW5QBbzcyvuWVfERLwEqt0CsEx4vhulZkYM94QLOrPqcb
	 73i8sNWlJqsOGMxw1kwseawyTm5SBkGTW8J7z8DU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Harshvardhan Jha <harshvardhan.j.jha@oracle.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 6.6 032/101] Revert "SUNRPC: Dont allow waiting for exiting tasks"
Date: Wed, 17 Sep 2025 14:34:15 +0200
Message-ID: <20250917123337.626672036@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123336.863698492@linuxfoundation.org>
References: <20250917123336.863698492@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit 199cd9e8d14bc14bdbd1fa3031ce26dac9781507 upstream.

This reverts commit 14e41b16e8cb677bb440dca2edba8b041646c742.

This patch breaks the LTP acct02 test, so let's revert and look for a
better solution.

Reported-by: Mark Brown <broonie@kernel.org>
Reported-by: Harshvardhan Jha <harshvardhan.j.jha@oracle.com>
Link: https://lore.kernel.org/linux-nfs/7d4d57b0-39a3-49f1-8ada-60364743e3b4@sirena.org.uk/
Cc: stable@vger.kernel.org # 6.15.x
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/sched.c |    2 --
 1 file changed, 2 deletions(-)

--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -276,8 +276,6 @@ EXPORT_SYMBOL_GPL(rpc_destroy_wait_queue
 
 static int rpc_wait_bit_killable(struct wait_bit_key *key, int mode)
 {
-	if (unlikely(current->flags & PF_EXITING))
-		return -EINTR;
 	schedule();
 	if (signal_pending_state(mode, current))
 		return -ERESTARTSYS;


