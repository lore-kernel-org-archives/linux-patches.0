Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0860E2D94AB;
	Tue, 11 Nov 2025 01:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824575; cv=none; b=S8wpTzCo1OjS8zNtk6uRn2W6RaTjea5F8fdAwlxhXd48wh8wBpgLrVRyrG8LtEnmCWJ/lVWXuvaW47VcW89wHNU+DwzMBfttymz91SFPxsOX9dyatkVoI6WoOH9qZjFlJSf7AUe+H3OqYjnhPvPnxlpFZCn2tKQLzCEBw8KBPTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824575; c=relaxed/simple;
	bh=SYMPS5mP7g0Sv41PczP4vQV9TkEnasUULphEnp/HhvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YduuAUwNEuQYV5O4g3YJXZ/rdJ3E0MddiK/RSSBEJVDjbXQqDHVgRrrCNUao+gbpzCLf/coGCDfCKBYS242JBQfxEHiTjcf/wF2zmuIUlBFWxqq/bCoHQ0ju7THbj83vzQh6oWE1+OHvRdeDj6UMaeWr/3vtvTPcON0WruqSlIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=krn8ydM/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="krn8ydM/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91FA5C4CEFB;
	Tue, 11 Nov 2025 01:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824574;
	bh=SYMPS5mP7g0Sv41PczP4vQV9TkEnasUULphEnp/HhvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=krn8ydM/kW34rf0XZ1nE+HPjHyBU/WZImmtdqN3npnajwOQ9Hs+jmDnAJbd38/Ew6
	 7w/DQH/qbcEF3SfSKDH/opXlemARnHXQQebiVgsuekk8eickLUZQNOPtULzLhkRhBN
	 wDWHxM1iqFe9reyY0SAHzNcVbcykuSftJTb+7vCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d1b5dace43896bc386c3@syzkaller.appspotmail.com,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 472/565] 9p/trans_fd: p9_fd_request: kick rx thread if EPOLLIN
Date: Tue, 11 Nov 2025 09:45:28 +0900
Message-ID: <20251111004537.530112851@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

From: Oleg Nesterov <oleg@redhat.com>

[ Upstream commit e8fe3f07a357c39d429e02ca34f740692d88967a ]

p9_read_work() doesn't set Rworksched and doesn't do schedule_work(m->rq)
if list_empty(&m->req_list).

However, if the pipe is full, we need to read more data and this used to
work prior to commit aaec5a95d59615 ("pipe_read: don't wake up the writer
if the pipe is still full").

p9_read_work() does p9_fd_read() -> ... -> anon_pipe_read() which (before
the commit above) triggered the unnecessary wakeup. This wakeup calls
p9_pollwake() which kicks p9_poll_workfn() -> p9_poll_mux(), p9_poll_mux()
will notice EPOLLIN and schedule_work(&m->rq).

This no longer happens after the optimization above, change p9_fd_request()
to use p9_poll_mux() instead of only checking for EPOLLOUT.

Reported-by: syzbot+d1b5dace43896bc386c3@syzkaller.appspotmail.com
Tested-by: syzbot+d1b5dace43896bc386c3@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/68a2de8f.050a0220.e29e5.0097.GAE@google.com/
Link: https://lore.kernel.org/all/67dedd2f.050a0220.31a16b.003f.GAE@google.com/
Co-developed-by: K Prateek Nayak <kprateek.nayak@amd.com>
Signed-off-by: K Prateek Nayak <kprateek.nayak@amd.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Tested-by: K Prateek Nayak <kprateek.nayak@amd.com>
Message-ID: <20250819161013.GB11345@redhat.com>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_fd.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index 7e9d731c45976..5bdfc25689169 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -665,7 +665,6 @@ static void p9_poll_mux(struct p9_conn *m)
 
 static int p9_fd_request(struct p9_client *client, struct p9_req_t *req)
 {
-	__poll_t n;
 	int err;
 	struct p9_trans_fd *ts = client->trans;
 	struct p9_conn *m = &ts->conn;
@@ -685,13 +684,7 @@ static int p9_fd_request(struct p9_client *client, struct p9_req_t *req)
 	list_add_tail(&req->req_list, &m->unsent_req_list);
 	spin_unlock(&m->req_lock);
 
-	if (test_and_clear_bit(Wpending, &m->wsched))
-		n = EPOLLOUT;
-	else
-		n = p9_fd_poll(m->client, NULL, NULL);
-
-	if (n & EPOLLOUT && !test_and_set_bit(Wworksched, &m->wsched))
-		schedule_work(&m->wq);
+	p9_poll_mux(m);
 
 	return 0;
 }
-- 
2.51.0



