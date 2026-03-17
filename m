Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC263F23AA;
	Tue, 17 Mar 2026 16:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766420; cv=none; b=jvgm9VhK43Jh6ZLKKYo1maHs+ZMdni31kse1su+heKYO4u9/z2DmvGsZegcpuUNuc6Q/upwnL8wWXTUJjQwLW8toEwGzeP9XuaNWtdfyLHAR14ngcrHrjtMZ1I5rV7vI/9R2SJ7uVjVbzMzEiPLbbgsx3OdF5igXIeY6ZWNCUyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766420; c=relaxed/simple;
	bh=6fQx/sgCtTzBqqwjBJGEJYZAAl+e+XNQUbaou0h59nE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iLpBUPG+0iRX1tG/rH447fGeo6Ogk1OgG/7IodpEaQlpQq0ptsHqsua4XHfrjeft1QgwmfhQ2NqfBc3lhsnMCTAnAV1wG9L60ahEp0Y/ORNqPAiLPgSAul0yv90OrFa1XpsLxwWlTHSPgCCzRX5ce1QNZS51/ICCGfX4MicuDhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tI1RzD3V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tI1RzD3V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39CE7C4CEF7;
	Tue, 17 Mar 2026 16:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766420;
	bh=6fQx/sgCtTzBqqwjBJGEJYZAAl+e+XNQUbaou0h59nE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tI1RzD3VqcWldInB/0AfC0T6ReAVngmSlGjuUswHU5F8SJ6n8he/S97OAcq8TNhMY
	 Ue5FX8Txue9Bq5wwYYRdquEpiXlj1gpKGkaPYnnrwpzl9B3w/T0vv3hhQFWfiSw1KL
	 K2jCGCVJsGdM3DiDUuO3QiurcsSrzsdhX2qN6h3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	stable@kernel.org
Subject: [PATCH 6.19 243/378] nsfs: tighten permission checks for handle opening
Date: Tue, 17 Mar 2026 17:33:20 +0100
Message-ID: <20260317163015.957951224@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

commit d2324a9317f00013facb0ba00b00440e19d2af5e upstream.

Even privileged services should not necessarily be able to see other
privileged service's namespaces so they can't leak information to each
other. Use may_see_all_namespaces() helper that centralizes this policy
until the nstree adapts.

Link: https://patch.msgid.link/20260226-work-visibility-fixes-v1-2-d2c2853313bd@kernel.org
Fixes: 5222470b2fbb ("nsfs: support file handles")
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Cc: stable@kernel.org # v6.18+
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nsfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nsfs.c
+++ b/fs/nsfs.c
@@ -614,7 +614,7 @@ static struct dentry *nsfs_fh_to_dentry(
 		return ERR_PTR(-EOPNOTSUPP);
 	}
 
-	if (owning_ns && !ns_capable(owning_ns, CAP_SYS_ADMIN)) {
+	if (owning_ns && !may_see_all_namespaces()) {
 		ns->ops->put(ns);
 		return ERR_PTR(-EPERM);
 	}


