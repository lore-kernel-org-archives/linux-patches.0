Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30B0F528433;
	Thu, 17 Sep 2026 17:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664421; cv=none; b=OX/jFTh9OX/FG3QIJS2nv3m7VNBob7M33qnHt6LkPoI5u82pFolE0EJp0ZjLDjkVWb74Oiux5nLtm2S4E2hOi2qJD0a3Ejo6s7KnUTA6vatZd3DcbWFtBhzJLqhku1SKx+RJky2+bdUBrjsEprW1iDYHIyTGrefBvncJq+l5z9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664421; c=relaxed/simple;
	bh=y7gPZJMHk9Pr6ZLkKtLi/I52RqQjpcoKG0dnBqFgdUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XC2hvwxsH7tiSezz/9JKi/O4X2x5SVdE4baxPd7mvsOiAxU52w6N2ht6G+9KA6h21rqC6f1xwECnr4Jxgd0rGa0/VqJezgyr+FQ8cGw+N/vU42CCiZ7O7Kw5f83shFPEIQ2p5hHHfFbAQWP/I+HRv+KwPy/Uf+aGHxdq1NA3F+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FE7Z5/Yy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FE7Z5/Yy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A3BD1F000FF;
	Thu, 17 Sep 2026 17:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664419;
	bh=EK5fL/zTSZOsnudOJuniJMbJNM6CETOW39nw21cINaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FE7Z5/Yyyr+O6sjxNCY5wl1Saa4V8nFK7e6G70f6ScofZZnj5Jp/kUi3DMDuCgZj+
	 xD/c77kPutisF/WJ6l4fD2X/C5dszQgTpn1YydcyzuSVm1wCsWrZjAyy5vxFlaWyE8
	 YT91TkQTywdHXz0eRqqfASleKtnU1E+AR6IczzSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0367/1250] netconsole: take target_cleanup_list_lock in drop_netconsole_target()
Date: Thu, 17 Sep 2026 16:02:42 +0100
Message-ID: <20260917151602.007465456@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 91aeb87f052367a5a2743cc93777dfb4386f2f14 ]

drop_netconsole_target() unlinks the target while only holding
target_list_lock. However, when the underlying interface has been
unregistered, netconsole_netdev_event() moves the target from
target_list to target_cleanup_list, and netconsole_process_cleanups_core()
walks that list under target_cleanup_list_lock only.

If a user removes the configfs target at the same time the cleanup
worker is iterating target_cleanup_list, list_del() can corrupt the list
because the two paths take disjoint locks while operating on the same
list node.

Acquire target_cleanup_list_lock around the list_del() so the unlink is
serialised against netconsole_process_cleanups_core() regardless of
which list the target currently belongs to. The state transition that
downgrades STATE_DEACTIVATED to STATE_DISABLED is left intact and is
performed under the same combined locking, preserving the existing
ordering with resume_target().

Signed-off-by: Breno Leitao <leitao@debian.org>
Link: https://patch.msgid.link/20260604-netcons_fix_before_move-v3-3-ab055b3a6aa5@debian.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/netconsole.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
index 06345487d6aac..fec111d64f611 100644
--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -1326,9 +1326,11 @@ static void drop_netconsole_target(struct config_group *group,
 	unsigned long flags;
 	struct netconsole_target *nt = to_target(item);
 
+	mutex_lock(&target_cleanup_list_lock);
 	spin_lock_irqsave(&target_list_lock, flags);
 	list_del(&nt->list);
 	spin_unlock_irqrestore(&target_list_lock, flags);
+	mutex_unlock(&target_cleanup_list_lock);
 
 	/*
 	 * The target may have never been enabled, or was manually disabled
-- 
2.53.0



