Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD3E31F8F15;
	Wed,  6 Nov 2024 12:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896681; cv=none; b=ObREtUSRHM4qM2eopw+KjJd8cXzQRy3NAQ/uftMc/+Kp0sv0mkJ4Yof3B2wu4HN/DVjSb1z0tMtFRHxCP1yK4QxJfQdtS2pwause3MpxBTf9XqezPWdUX44oaE2viuople9QRIvjoPQIwTVhXHInPu7wYnBoKwbflzJYpeOu/pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896681; c=relaxed/simple;
	bh=/PFAizbs+WYEXPBHgZPkPyz4XDuHG5si1czU9g91jfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P/peo+4zjPOGadxKMPPamP9W2rlggoBB0kj1vn9Ou8SuUGSnYg/YRjsk+50xkFjs6v1KC3RX4NRa1Hk8XuM8ZuaAOhxtxJhXjGQIQmJnNxbWZ9Sy/b6wcBHYEWFBDchSUQA9hGSMzfpkUsvKZn6HNzO01vviXrFBVnU8/fVBZI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mJn/HeSt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mJn/HeSt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42248C4CECD;
	Wed,  6 Nov 2024 12:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896681;
	bh=/PFAizbs+WYEXPBHgZPkPyz4XDuHG5si1czU9g91jfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mJn/HeStdEdk4HJckLYA/4WQ5WUkAl7jCEsqa0g7RKRpu7lE6sVJvPShc0333oeCJ
	 lbSzTkb07zIdGmSX9ENWDyaMsdEuNCjcvN6OrcIz+34hc+glZhP34hqFh7JShTwVsh
	 VVoQQ1mPyd0HA1nqe+IwBRVBZvyPAjLYiGegxgTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b65e0af58423fc8a73aa@syzkaller.appspotmail.com,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 038/110] net: sched: fix use-after-free in taprio_change()
Date: Wed,  6 Nov 2024 13:04:04 +0100
Message-ID: <20241106120304.248535956@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120303.135636370@linuxfoundation.org>
References: <20241106120303.135636370@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit f504465970aebb2467da548f7c1efbbf36d0f44b ]

In 'taprio_change()', 'admin' pointer may become dangling due to sched
switch / removal caused by 'advance_sched()', and critical section
protected by 'q->current_entry_lock' is too small to prevent from such
a scenario (which causes use-after-free detected by KASAN). Fix this
by prefer 'rcu_replace_pointer()' over 'rcu_assign_pointer()' to update
'admin' immediately before an attempt to schedule freeing.

Fixes: a3d43c0d56f1 ("taprio: Add support adding an admin schedule")
Reported-by: syzbot+b65e0af58423fc8a73aa@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b65e0af58423fc8a73aa
Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Link: https://patch.msgid.link/20241018051339.418890-1-dmantipov@yandex.ru
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_taprio.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 04ed23b5f21b4..16ab7b1480661 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1590,7 +1590,8 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 
 		taprio_start_sched(sch, start, new_admin);
 
-		rcu_assign_pointer(q->admin_sched, new_admin);
+		admin = rcu_replace_pointer(q->admin_sched, new_admin,
+					    lockdep_rtnl_is_held());
 		if (admin)
 			call_rcu(&admin->rcu, taprio_free_sched_cb);
 
-- 
2.43.0



