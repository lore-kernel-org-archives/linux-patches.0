Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C83E42E7F0B;
	Tue, 15 Jul 2025 13:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586102; cv=none; b=FSanvG96vgJI9Fr3BfAQQZSDPFjWiH3uPpW/qkko+fHe5EadrNIIGfUB5ljhh1DBLE0uP+QYuVYFXke9aWEyQQ0XgXR1nH83vRiy/Ent/D4TVfqN//zQeLRECBm3eKTDVNP7oXHCMjYa4/rAmnsnhmZfru8VaQfqxMytwtfpGSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586102; c=relaxed/simple;
	bh=J4EtmjRxzM017yu8YCKhyBKeNnt4fFq+6GO2sHkjFA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s2E4Z2pZzksLqvlj+eutuvQKU07O59ELU5qWtWrSHPCgG17rYij/FYSHJunMj+GtX2dUPzAZLtEg73noSA+YIi/1JGWDgcd5cvUZf5GBZM0YAfzJTVj6KNKQJ2FHYv8oeZKYvUZ6ATmSE8ehmNMsGpdkF89FmPo2dTA0S5j/rHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S1bXTO06; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S1bXTO06"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ED98C4CEE3;
	Tue, 15 Jul 2025 13:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586102;
	bh=J4EtmjRxzM017yu8YCKhyBKeNnt4fFq+6GO2sHkjFA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S1bXTO06sLBn1fL1DO80oQbdCB87v4Isw1NzG9eNUi0aUZem4jdkqq4l16HwmmlKh
	 FYyeg0EjNl/m03pmAqQ8iG9+shw4lVtLrNPj5Q5s7/KBzgJ7/p1kVwTWS9Go4TjafE
	 xx+/ddua5z2D0fhZx92nadqGM31y2AixrshLEM38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Maximilian Heyne <mheyne@amazon.de>
Subject: [PATCH 5.15 17/77] fs/proc: do_task_stat: use __for_each_thread()
Date: Tue, 15 Jul 2025 15:13:16 +0200
Message-ID: <20250715130752.389295899@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130751.668489382@linuxfoundation.org>
References: <20250715130751.668489382@linuxfoundation.org>
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

From: Oleg Nesterov <oleg@redhat.com>

commit 7904e53ed5a20fc678c01d5d1b07ec486425bb6a upstream.

do/while_each_thread should be avoided when possible.

Link: https://lkml.kernel.org/r/20230909164501.GA11581@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 7601df8031fd ("fs/proc: do_task_stat: use sig->stats_lock to gather the threads/children stats")
Cc: stable@vger.kernel.org
[ mheyne: adjusted context ]
Signed-off-by: Maximilian Heyne <mheyne@amazon.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/array.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -530,18 +530,18 @@ static int do_task_stat(struct seq_file
 		cgtime = sig->cgtime;
 
 		if (whole) {
-			struct task_struct *t = task;
+			struct task_struct *t;
 
 			min_flt = sig->min_flt;
 			maj_flt = sig->maj_flt;
 			gtime = sig->gtime;
 
 			rcu_read_lock();
-			do {
+			__for_each_thread(sig, t) {
 				min_flt += t->min_flt;
 				maj_flt += t->maj_flt;
 				gtime += task_gtime(t);
-			} while_each_thread(task, t);
+			}
 			rcu_read_unlock();
 		}
 	} while (need_seqretry(&sig->stats_lock, seq));


