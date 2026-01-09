Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A802335561;
	Fri,  9 Jan 2026 12:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960135; cv=none; b=Qp0snoMj6tfb9EKQeHHCdxyPX60aJ1BUqajONAdi8jSjhWe2k+TTBcKRLVLeIcjXTXladWm9WCrF9FTmZCOrZGtmWaY/AcWi3JHzM3+Pu1w0e2vRrsZiNfAjY+fcDbXkiBJbBPvxeWRo+wI1q4PSNTSt0PdBix9NXE2btEdx7mA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960135; c=relaxed/simple;
	bh=XYjgFRddtoFiFtqPuMssmcjwvQJ9g7PbWDkOlaPTJlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ppNaWOUhSyr40aiGmIjrauyqZkWOLt8rByms0RpWmZa7XBTVCw40SToFB4JnVeEL17e8fJKCL3LyIFcVLqpKGwMmS9vkLETk6hW1ijhSmz4nVx+Bh0hCQtfHMESTLUo2U4zwtaTIWiN9yPfiSccem4FIXV3j8U7rJyKoarYVFbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KV9ijaYI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KV9ijaYI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB4C6C19421;
	Fri,  9 Jan 2026 12:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960135;
	bh=XYjgFRddtoFiFtqPuMssmcjwvQJ9g7PbWDkOlaPTJlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KV9ijaYIXsprX91FKuoumd6xRVM9PuLLUEZOD4BKq5ZZwanYay0/CnSWpFn4RL+3K
	 ixjUHK+yYEN4geSpWiG4pQqp/4Ynh75rlcGAbbCVpuK0EWdextpA6eOSLKrLltpNy1
	 8ZhtglBOnbiCMIwBahC2axu7fuAYZey3pB+18t9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianlin Shi <jishi@redhat.com>,
	Xin Long <lucien.xin@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 298/737] ipv6: add exception routes to GC list in rt6_insert_exception
Date: Fri,  9 Jan 2026 12:37:17 +0100
Message-ID: <20260109112145.219156163@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xin Long <lucien.xin@gmail.com>

commit cfe82469a00f0c0983bf4652de3a2972637dfc56 upstream.

Commit 5eb902b8e719 ("net/ipv6: Remove expired routes with a separated list
of routes.") introduced a separated list for managing route expiration via
the GC timer.

However, it missed adding exception routes (created by ip6_rt_update_pmtu()
and rt6_do_redirect()) to this GC list. As a result, these exceptions were
never considered for expiration and removal, leading to stale entries
persisting in the routing table.

This patch fixes the issue by calling fib6_add_gc_list() in
rt6_insert_exception(), ensuring that exception routes are properly tracked
and garbage collected when expired.

Fixes: 5eb902b8e719 ("net/ipv6: Remove expired routes with a separated list of routes.")
Reported-by: Jianlin Shi <jishi@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/837e7506ffb63f47faa2b05d9b85481aad28e1a4.1744134377.git.lucien.xin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/route.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -1772,6 +1772,7 @@ out:
 	if (!err) {
 		spin_lock_bh(&f6i->fib6_table->tb6_lock);
 		fib6_update_sernum(net, f6i);
+		fib6_add_gc_list(f6i);
 		spin_unlock_bh(&f6i->fib6_table->tb6_lock);
 		fib6_force_start_gc(net);
 	}


