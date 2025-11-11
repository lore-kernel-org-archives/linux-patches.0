Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F66C343D87;
	Tue, 11 Nov 2025 01:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825217; cv=none; b=Vj9hHhM6M1a9BHZRKBXFOy8sUkRc3tfJWVREQ/goHjccpS1GulInJsaZRqzdgtLlOXRXcixDYl9WjatdxBPk7GOnKoETFWV64PC0FIgI9ncit0Jgor39vwrslIdHNmi43fdwJnKPL2rd7UZKS2A+bhbC8Lu4YErEa1OxmO3UD9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825217; c=relaxed/simple;
	bh=Oc5MKJ73h1ERR3ewgfar7+dTlRre7gJTv2KyZ2SIpm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FOY7pO1uK1RsW0Htuk/ekGmYvHzWA1pQt8fS6nxSqcrqiKwIaX4ompn2GKE1U1HFw8stnBkesZ133vOrA+5pscJ3eWgtl+3ZmAeYpnWHSURIopL3pW1b+BdbmIC14lfNizWt7d89u8SDu3EmXiJU0HrYeLtjN2egLZqhUcy9J/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dyCspjIw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dyCspjIw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FBE6C4CEF5;
	Tue, 11 Nov 2025 01:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825217;
	bh=Oc5MKJ73h1ERR3ewgfar7+dTlRre7gJTv2KyZ2SIpm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dyCspjIwX1gxTs8tqnp5VDK6X3FePig7AG38WXYAMgOJ25kr8Ff01K3BlARui8eml
	 6mU8l4O8C+5h4SImp0tk4ZJwNeVmjYUVDudrdpP/HnMs6xqE8qxsf4x+8F5kKtaahI
	 F+ZFYAdApVPZyBIgoHPvXiPnNFC04eZVhzns5Jos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d1b5dace43896bc386c3@syzkaller.appspotmail.com,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 708/849] 9p/trans_fd: p9_fd_request: kick rx thread if EPOLLIN
Date: Tue, 11 Nov 2025 09:44:38 +0900
Message-ID: <20251111004553.555067672@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 8992d8bebbddf..a516745f732f7 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -666,7 +666,6 @@ static void p9_poll_mux(struct p9_conn *m)
 
 static int p9_fd_request(struct p9_client *client, struct p9_req_t *req)
 {
-	__poll_t n;
 	int err;
 	struct p9_trans_fd *ts = client->trans;
 	struct p9_conn *m = &ts->conn;
@@ -686,13 +685,7 @@ static int p9_fd_request(struct p9_client *client, struct p9_req_t *req)
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



