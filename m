Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21907349B0A;
	Thu, 15 Jan 2026 16:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496282; cv=none; b=cdlNueeKoqwkWXrD3wZ/TWhmTvTL27ciKiV9G8S3X/1JECJvSZ4qGeZwXQdXYC/S6ch/y2+FIQlVHCr8mlbEUE100LnwrDY1kb249OurK4dEJsHapw5HrputMYTt5zPKVoZC/MFku5fVSxYt+arLC9RPyE0GvOyuUmHEg699ZMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496282; c=relaxed/simple;
	bh=uhSZKxDpARUQYOLlrH8MpV0X55rOI9ZdlaKEM2jO6Mw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NOa7e8XIdyY/5p2OAZpe4NlVIxCdj4HaN7vdcmltawW/kqKn/RY0UjkJrxvwu1M3y5PZ2/BNg5H2xvzuWm0IL0fhjSZ5a1/i/UGQ9jImwHgSxBHaMQ06ASAYApFs2s+8c7tnZTWe8h1LsS9XabOPh6LTUOKf7o43lQ4/6bWpOPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rOO/bQEc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rOO/bQEc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A286AC116D0;
	Thu, 15 Jan 2026 16:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496282;
	bh=uhSZKxDpARUQYOLlrH8MpV0X55rOI9ZdlaKEM2jO6Mw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rOO/bQEc3RfE1WNS6Q94+E3F61Gb1YzEfvreuUPncPufjZBZ6CZiBjCQilF0dFvOo
	 JXc69537fe/Scbbp4ALbomrCMXZYwXOA96zfC8r0b1Gkjz2MFrzifVrovOEIR9QhWd
	 VPaVyfHm4dpFoXm4EMaEztvL8eXenH63jicgLO0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8f1c492ffa4644ff3826@syzkaller.appspotmail.com,
	Shivani Gupta <shivani07g@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 140/181] net/sched: act_api: avoid dereferencing ERR_PTR in tcf_idrinfo_destroy
Date: Thu, 15 Jan 2026 17:47:57 +0100
Message-ID: <20260115164207.371646054@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shivani Gupta <shivani07g@gmail.com>

[ Upstream commit adb25a46dc0a43173f5ea5f5f58fc8ba28970c7c ]

syzbot reported a crash in tc_act_in_hw() during netns teardown where
tcf_idrinfo_destroy() passed an ERR_PTR(-EBUSY) value as a tc_action
pointer, leading to an invalid dereference.

Guard against ERR_PTR entries when iterating the action IDR so teardown
does not call tc_act_in_hw() on an error pointer.

Fixes: 84a7d6797e6a ("net/sched: acp_api: no longer acquire RTNL in tc_action_net_exit()")
Link: https://syzkaller.appspot.com/bug?extid=8f1c492ffa4644ff3826
Reported-by: syzbot+8f1c492ffa4644ff3826@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=8f1c492ffa4644ff3826
Signed-off-by: Shivani Gupta <shivani07g@gmail.com>
Link: https://patch.msgid.link/20260105005905.243423-1-shivani07g@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_api.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index ff6be5cfe2b05..e1ab0faeb8113 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -940,6 +940,8 @@ void tcf_idrinfo_destroy(const struct tc_action_ops *ops,
 	int ret;
 
 	idr_for_each_entry_ul(idr, p, tmp, id) {
+		if (IS_ERR(p))
+			continue;
 		if (tc_act_in_hw(p) && !mutex_taken) {
 			rtnl_lock();
 			mutex_taken = true;
-- 
2.51.0



