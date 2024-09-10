Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 581E817BEAE;
	Tue, 10 Sep 2024 09:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961249; cv=none; b=r6yvPEAZ11GtYeD0NBVpbI8GelO336e35wjKSs+mk6vx0nGR7uUN3yk0EmLJj5HR2CYV/x+GmWYD/bUn/g5Vb3w/8K7Af1l2QPxi6qxMK9ZwiJyx4xwQc4IVyOp9/I73qmAIi3fN5lsHIK1lJZ2SsbGD3w3JA5I88FWM87ytf68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961249; c=relaxed/simple;
	bh=dkPHUEsMr/curxItgoO4PwGRKXwCDRhS2MjUH5sBfJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pmXd+v1QbUogbohZllJrQ4RSTb21CeCCeJCVvPm5+Rq1HKfXHpjLxyCil17nHGql2JNtDymblMSRI9GUt8/Ms1SVXe8gHM+1NJ970rojBgoawb6Q3NtAGSNXvT0UhflHb9NUokfElV058enrw9C8n4snDBBua8RDpGwy8kLWDeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KrdY8xDQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KrdY8xDQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9D71C4CEC3;
	Tue, 10 Sep 2024 09:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961249;
	bh=dkPHUEsMr/curxItgoO4PwGRKXwCDRhS2MjUH5sBfJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KrdY8xDQ7XA1E6mWkjn7Tia7gmr5tgqc+lIFF8fs64gnKrLBp22S/GxIHY0yWQPu4
	 fm3X2txF+e+cUXoGhQtFokI2sSR7SaMbgIkXe5ICQDlHCWy0hW8BfnV0oeBsT63lk6
	 E98xk2g8E3N2K3jDT5vLzneN/A5QY7WAEkh2i2VI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 96/96] netns: restore ops before calling ops_exit_list
Date: Tue, 10 Sep 2024 11:32:38 +0200
Message-ID: <20240910092545.754655127@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092541.383432924@linuxfoundation.org>
References: <20240910092541.383432924@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <lirongqing@baidu.com>

commit b272a0ad730103e84fb735fd0a8cc050cdf7f77c upstream.

ops has been iterated to first element when call pre_exit, and
it needs to restore from save_ops, not save ops to save_ops

Fixes: d7d99872c144 ("netns: add pre_exit method to struct pernet_operations")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/net_namespace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -357,7 +357,7 @@ out_undo:
 
 	synchronize_rcu();
 
-	saved_ops = ops;
+	ops = saved_ops;
 	list_for_each_entry_continue_reverse(ops, &pernet_list, list)
 		ops_exit_list(ops, &net_exit_list);
 


