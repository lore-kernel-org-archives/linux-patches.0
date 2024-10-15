Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA2451C07DF;
	Tue, 15 Oct 2024 13:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997899; cv=none; b=CrGo0gYHr5zDHXwel+czY7nL2ZqKFuRU0L+ZM2u+/48+mvhSOAkqK7ujQGfI59ZkGPqTaXgPsAdgwqlFd/xOZVMZJkx+5ocDrVDhc8gJ+fkggvCDlgcWMd0E+png+HYyIHon05aCyIqhhBKhepknz10m5T/6uxDzmL9Dmw4Zans=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997899; c=relaxed/simple;
	bh=Z2u2nQVhYugad6c3hjw0N6bBIW8Ma7mVfEyMqz/WPV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bIDdlyMlqVEcg8bK8DVWNqg4SfymQHXIRcqF0+zndSbvXbbx8ms2pO99povX2tRtS8msb7u0goGRAYmpctjbL4d0YkIcYiaEWyRFlpNkSIxeR0RUs2vJ24/lRUv/YkRJf4ja3/8Z3mXbm/bHlA4fYsE+ruhKNVRR1RjhyjvhPyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VzoJuw9Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VzoJuw9Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 625A4C4CEC6;
	Tue, 15 Oct 2024 13:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997898;
	bh=Z2u2nQVhYugad6c3hjw0N6bBIW8Ma7mVfEyMqz/WPV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VzoJuw9Q3a2EXyFwqdpIR7ef36ltE7Ouj8CjW9AWJs8AH0BOj5XMIkaoQ3+Azo6kb
	 1VbjiNdQeBSE7Du2sPn5fadLVni26Y/ZBqPKIHuCt3jpQdjehcxapKowv78A7eKf+1
	 X4VfKAPsYt5slGmh/H2YxZiBQ2wWNnB4mlnEcnrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Dmitry Antipov <dmantipov@yandex.ru>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 303/518] net: sched: consistently use rcu_replace_pointer() in taprio_change()
Date: Tue, 15 Oct 2024 14:43:27 +0200
Message-ID: <20241015123928.682221309@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

[ Upstream commit d5c4546062fd6f5dbce575c7ea52ad66d1968678 ]

According to Vinicius (and carefully looking through the whole
https://syzkaller.appspot.com/bug?extid=b65e0af58423fc8a73aa
once again), txtime branch of 'taprio_change()' is not going to
race against 'advance_sched()'. But using 'rcu_replace_pointer()'
in the former may be a good idea as well.

Suggested-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_taprio.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index ec6b24edf5f93..04ed23b5f21b4 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1577,7 +1577,9 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 			goto unlock;
 		}
 
-		rcu_assign_pointer(q->admin_sched, new_admin);
+		/* Not going to race against advance_sched(), but still */
+		admin = rcu_replace_pointer(q->admin_sched, new_admin,
+					    lockdep_rtnl_is_held());
 		if (admin)
 			call_rcu(&admin->rcu, taprio_free_sched_cb);
 	} else {
-- 
2.43.0



