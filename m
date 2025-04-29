Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFAA8211A0B;
	Tue, 29 Apr 2025 17:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946329; cv=none; b=ZkA1uZs2uuTWJcWb4lo7jpFkbQoA7z4B4Bp/cQ3HXuUaKmG5qAcVcn3Vpk7JKMMROSV0TxmN8c6CQu9zFOiGSub5jCzM83BCOCyjte+NRTW4HmaFGCbmp8lBd0Pe9T7JgpxuYRNheGdKxSFvot7AKvLSq0c/kHEBvnCb03dp9x4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946329; c=relaxed/simple;
	bh=M5dgp+PX5OutkYuzBYqMtxSytw4IXZYMB3KHpnv9UWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WTIVEtPSri5CEG/3Mvf4oe9IZMG0kxhYqjIzuRGRUrjzvDzBiYtR6tTHxdTlHuLYsy68t/qK13P67W4VI5WRgxlDgLd5VC0wEX7fNVqf3TF8iIV09uU8CbMXHhJeIjwWD0erq38UesfpjKYJpxsNk08IEL4AJeN0q6n2/jMwU2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q57r4qvY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q57r4qvY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 511F5C4CEE3;
	Tue, 29 Apr 2025 17:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946328;
	bh=M5dgp+PX5OutkYuzBYqMtxSytw4IXZYMB3KHpnv9UWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q57r4qvY8htY/bNUqbh+zpupJ7AbAnmcgY8UAWNGh5yv+v64gluljJMrn5Qm63MjZ
	 LY90z2TShwUcKwxd1Sz+E/TBXqNTc/eA++AEhVCl5Dc8hbfAtjf/DRsPsa6ts1LzHS
	 jGHav0A0AYLWtWu9LtudvNIW+3Qy7kqwvQgW8kkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d69a7cc8c683c2cb7506@syzkaller.appspotmail.com,
	syzbot+483d6c9b9231ea7e1851@syzkaller.appspotmail.com,
	Ignacio Encinas <ignacio@iencinas.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 231/311] 9p/trans_fd: mark concurrent read and writes to p9_conn->err
Date: Tue, 29 Apr 2025 18:41:08 +0200
Message-ID: <20250429161130.493977290@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ignacio Encinas <ignacio@iencinas.com>

[ Upstream commit fbc0283fbeae27b88448c90305e738991457fee2 ]

Writes for the error value of a connection are spinlock-protected inside
p9_conn_cancel, but lockless reads are present elsewhere to avoid
performing unnecessary work after an error has been met.

Mark the write and lockless reads to make KCSAN happy. Mark the write as
exclusive following the recommendation in "Lock-Protected Writes with
Lockless Reads" in tools/memory-model/Documentation/access-marking.txt
while we are at it.

Mark p9_fd_request and p9_conn_cancel m->err reads despite the fact that
they do not race with concurrent writes for stylistic reasons.

Reported-by: syzbot+d69a7cc8c683c2cb7506@syzkaller.appspotmail.com
Reported-by: syzbot+483d6c9b9231ea7e1851@syzkaller.appspotmail.com
Signed-off-by: Ignacio Encinas <ignacio@iencinas.com>
Message-ID: <20250318-p9_conn_err_benign_data_race-v3-1-290bb18335cc@iencinas.com>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_fd.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index 196060dc6138a..791e4868f2d4e 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -191,12 +191,13 @@ static void p9_conn_cancel(struct p9_conn *m, int err)
 
 	spin_lock(&m->req_lock);
 
-	if (m->err) {
+	if (READ_ONCE(m->err)) {
 		spin_unlock(&m->req_lock);
 		return;
 	}
 
-	m->err = err;
+	WRITE_ONCE(m->err, err);
+	ASSERT_EXCLUSIVE_WRITER(m->err);
 
 	list_for_each_entry_safe(req, rtmp, &m->req_list, req_list) {
 		list_move(&req->req_list, &cancel_list);
@@ -283,7 +284,7 @@ static void p9_read_work(struct work_struct *work)
 
 	m = container_of(work, struct p9_conn, rq);
 
-	if (m->err < 0)
+	if (READ_ONCE(m->err) < 0)
 		return;
 
 	p9_debug(P9_DEBUG_TRANS, "start mux %p pos %zd\n", m, m->rc.offset);
@@ -450,7 +451,7 @@ static void p9_write_work(struct work_struct *work)
 
 	m = container_of(work, struct p9_conn, wq);
 
-	if (m->err < 0) {
+	if (READ_ONCE(m->err) < 0) {
 		clear_bit(Wworksched, &m->wsched);
 		return;
 	}
@@ -622,7 +623,7 @@ static void p9_poll_mux(struct p9_conn *m)
 	__poll_t n;
 	int err = -ECONNRESET;
 
-	if (m->err < 0)
+	if (READ_ONCE(m->err) < 0)
 		return;
 
 	n = p9_fd_poll(m->client, NULL, &err);
@@ -665,6 +666,7 @@ static void p9_poll_mux(struct p9_conn *m)
 static int p9_fd_request(struct p9_client *client, struct p9_req_t *req)
 {
 	__poll_t n;
+	int err;
 	struct p9_trans_fd *ts = client->trans;
 	struct p9_conn *m = &ts->conn;
 
@@ -673,9 +675,10 @@ static int p9_fd_request(struct p9_client *client, struct p9_req_t *req)
 
 	spin_lock(&m->req_lock);
 
-	if (m->err < 0) {
+	err = READ_ONCE(m->err);
+	if (err < 0) {
 		spin_unlock(&m->req_lock);
-		return m->err;
+		return err;
 	}
 
 	WRITE_ONCE(req->status, REQ_STATUS_UNSENT);
-- 
2.39.5



