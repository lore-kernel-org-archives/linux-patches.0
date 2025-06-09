Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0F7F8F5B;
	Mon,  9 Jun 2025 13:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749476772; cv=none; b=EZNqOb2/bfEXlhfifF/NX4E7kVxpbuHYYmFJ9dHS5Wxog7kGeJYwA9ziF0sE/0Iq4/0ejlZ2Ix/wj0B0qah5Rz3349TBQvFoVlxDdL3/zkBkGo8PWDYkrdBmTFPFmv4oDwCIJrzE/y46MBw++1OaAkcCth9VmI+jScRsugyxONo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749476772; c=relaxed/simple;
	bh=qTsnulNbXyifTKMdAXe8Pqdotq4gGz2uAJ+xcynUIJc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ds7FK1POnHTAiquFu9KuF20BBBRgq2xQ6MU1w3m/ZXakna4UPPdVvepHjPoWmyueGOuCA1Sa0weGX0PRJzeNuA0AVWkpSDtkg4O30pB7zN6ylfruZPjkWCZhWPbc2DQ+vVhlL9c8cX84T3G0Elihn2HtS/SjDEn/aWQIoZe/ioM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dVbri1Jf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dVbri1Jf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FEA0C4CEEB;
	Mon,  9 Jun 2025 13:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749476772;
	bh=qTsnulNbXyifTKMdAXe8Pqdotq4gGz2uAJ+xcynUIJc=;
	h=From:To:Cc:Subject:Date:From;
	b=dVbri1Jft1qbMSdoW+47WfWmj+xG97OC5G4+tiaVHEUjRE4j/O5ubOjVsfQYnlimX
	 rDg/czLENr7YDvw+lruhREINS5YquHsMdVIGz3vP7yBC+oJwqsdBkpJCn2oIFeqLiT
	 dlRxzA1jMyBR/hJywAy9I20hzuK3EMrVU0CxFEj2uRQg6QhGxN3Ct1tZvF+mh96aDm
	 fBejGO6sAaZfm8zd861x17dSntTFEnHrJ7H++K2X/YcmAGFkfRyPZ6voqQTYMRG7Cs
	 zdOqDHiOR7MxO55YAPwTFHVT3oN0Ii5iiwYpy2n2Su3u1B3xetPYV6y6L6CGeZIxRk
	 L9fMmQbsqt6bA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Hannes Reinecke <hare@kernel.org>,
	Chris Leech <cleech@redhat.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>,
	kbusch@kernel.org,
	linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 6.12 01/23] nvme-tcp: fix I/O stalls on congested sockets
Date: Mon,  9 Jun 2025 09:45:48 -0400
Message-Id: <20250609134610.1343777-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.32
Content-Transfer-Encoding: 8bit

From: Hannes Reinecke <hare@kernel.org>

[ Upstream commit f42d4796ee100fade86086d1cf98537fb4d326c8 ]

When the socket is busy processing nvme_tcp_try_recv() might return
-EAGAIN, but this doesn't automatically imply that the sending side is
blocked, too.  So check if there are pending requests once
nvme_tcp_try_recv() returns -EAGAIN and continue with the sending loop
to avoid I/O stalls.

Signed-off-by: Hannes Reinecke <hare@kernel.org>
Acked-by: Chris Leech <cleech@redhat.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

Based on my analysis of the commit and comparison with similar commits,
here is my determination:

**YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **Fixes a real user-impacting bug**: The commit addresses I/O stalls
   on congested sockets, which is a serious issue that can cause system
   hangs or severe performance degradation. When the socket is congested
   and `nvme_tcp_try_recv()` returns -EAGAIN, the current code
   incorrectly assumes that the sending side is also blocked, leading to
   I/O stalls.

2. **Small and contained fix**: The changes are minimal and localized to
   the `nvme_tcp_io_work()` function:
   - Changes `nvme_tcp_try_recv()` to return 0 instead of -EAGAIN to
     prevent premature exit
   - Adds a check after receive processing to see if the socket became
     writable
   - Only 5 lines of actual code changes

3. **Clear logic fix**: The patch addresses a specific logic error
   where:
   - The receive side returns -EAGAIN (socket would block on receive)
   - But this doesn't mean the send side is also blocked
   - The fix checks if there are pending requests and if the socket is
     writable after receive processing

4. **Similar to other backported fixes**: Looking at the historical
   commits:
   - Commit #2 (backported): Fixed hangs waiting for icresp response
   - Commit #3 (backported): Fixed wrong stop condition in io_work
   - Commit #4 (backported): Fixed UAF when detecting digest errors
   - Commit #5 (backported): Fixed possible null deref on timed out
     connections

   All these commits that were backported involved fixing hangs, stalls,
or error conditions in the nvme-tcp driver.

5. **No architectural changes**: The commit doesn't introduce new
   features or change the architecture. It simply adds a missing check
   to prevent I/O stalls, which aligns with stable kernel criteria.

6. **Critical subsystem**: NVMe-TCP is used for storage access, and I/O
   stalls can have severe consequences for system stability and data
   integrity.

The specific code changes show:
- `return consumed == -EAGAIN ? 0 : consumed;` - prevents treating
  EAGAIN as an error
- The new check `if (nvme_tcp_queue_has_pending(queue) &&
  sk_stream_is_writeable(queue->sock->sk))` ensures that if there are
  pending requests and the socket is writable after receive processing,
  we continue processing instead of stalling.

This is exactly the type of bug fix that should be backported to stable
kernels to ensure reliable storage operation.

 drivers/nvme/host/tcp.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 4cc72be28c731..13ede6e309092 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1349,7 +1349,7 @@ static int nvme_tcp_try_recv(struct nvme_tcp_queue *queue)
 	queue->nr_cqe = 0;
 	consumed = sock->ops->read_sock(sk, &rd_desc, nvme_tcp_recv_skb);
 	release_sock(sk);
-	return consumed;
+	return consumed == -EAGAIN ? 0 : consumed;
 }
 
 static void nvme_tcp_io_work(struct work_struct *w)
@@ -1377,6 +1377,11 @@ static void nvme_tcp_io_work(struct work_struct *w)
 		else if (unlikely(result < 0))
 			return;
 
+		/* did we get some space after spending time in recv? */
+		if (nvme_tcp_queue_has_pending(queue) &&
+		    sk_stream_is_writeable(queue->sock->sk))
+			pending = true;
+
 		if (!pending || !queue->rd_enabled)
 			return;
 
-- 
2.39.5

