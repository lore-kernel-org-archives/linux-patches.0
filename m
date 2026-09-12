Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 224163DD51A;
	Sat, 12 Sep 2026 15:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227367; cv=none; b=KTVCo/fjZaYWRHHfZ8YLbUpk3HspnO6eEi2kB9qsa55HebkgPrONyjQxTkkNED2bhqKRO3vG0vokBGcClBlYN3V6LHHxjqu4bpibtrhCX4fjK737kqS4rsbQyIYFUyYbWTPO3GSY5ktRiMAWZXLvI7X/At0pHJbOyfDzYPZjcKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227367; c=relaxed/simple;
	bh=vGrrWXBOB1MmIKkgBUGbu3CtqzsCtlEI9M1r9sX8UQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bhq4V6K0jj47CWOcUTFtK+dXDiUBSwiPOHOTbwv/RVo9UcaAxoLBK9KknNlkx5O9ZGjnwGeo1DyiQxhqf5qRGoYOCd40IErvzDm2WlhM5dbqQXwLllFCPoiJ1aLF86zETuEydPPle17ymc0kZWGnARxP7aQH7nUK8nLVAupgDuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=skH6JZ0z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="skH6JZ0z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C31F91F000FF;
	Sat, 12 Sep 2026 15:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227365;
	bh=KG3kYBGMl0dJCoi2BnGRyGtgen7P7U4KUIocopwgUTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=skH6JZ0zMYhwwe/4IEAsWxquqHpYNSs1zKNKjb+L3lpeuOE7L6uYVRzRh+aFuT4gY
	 qwiADZNV7jbnI8Nl7OhvdJvFIB+7NyEA4p2zgBoevsYIOPd2QpErDcF7L1x3p7FO8P
	 qaHC0gX9o0qnDzepap0YKP3sJypsPq/c0hDxw25M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.1 0166/1191] nvme-tcp: do not accept C2HData based on blk_rq_payload_bytes() alone
Date: Sat, 12 Sep 2026 08:48:14 +0200
Message-ID: <20260912065551.942631884@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

commit 3a4aa9e6ad3e35f8e24d5eaf38ee4d437075fb36 upstream.

Commit 25e5cb780e62 ("nvme-tcp: fix possible crash in write_zeroes
processing") established that blk_rq_payload_bytes() must not be read
without first checking blk_rq_nr_phys_segments(), and recorded the
result in nvme_tcp_setup_cmd_pdu() as req->data_len. The receive side
was left as it was.

The two differ for REQ_OP_WRITE_ZEROES, which has no physical segments
but a non-zero blk_rq_bytes(), so setup leaves req->iter untouched
while the receive gate lets a C2HData through and nvme_tcp_recv_data()
copies into whatever the previous command on that tag left there. The
driver-private area is zeroed only when the tag set is allocated.

Reproduced with a test target that leaves a residual iterator on a tag
and then sends a C2HData for a WRITE_ZEROES command on the same tag:

BUG: KASAN: wild-memory-access in _copy_to_iter+0x642/0x1330
Write of size 512 at addr ffe728c2175dfa81 by task kworker/0:1H/103

CPU: 0 UID: 0 PID: 103 Comm: kworker/0:1H Not tainted 7.2.0-rc5-NVMETCP-gf5098b6bae76 #1 PREEMPT(lazy)
Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Workqueue: nvme_tcp_wq nvme_tcp_io_work
Call Trace:
 <TASK>
 dump_stack_lvl+0x53/0x70
 kasan_report+0xce/0x100
 ? _copy_to_iter+0x642/0x1330
 kasan_check_range+0x105/0x1b0
 __asan_memcpy+0x3c/0x60
 _copy_to_iter+0x642/0x1330
 ? __pfx_sock_has_perm+0x10/0x10
 ? worker_thread+0x45b/0xd10
 ? __pfx__copy_to_iter+0x10/0x10
 ? _raw_spin_lock_bh+0x83/0xe0
 ? __pfx__raw_spin_lock_bh+0x10/0x10
 __skb_datagram_iter+0xf3/0x820
 ? __pfx_simple_copy_to_iter+0x10/0x10
 ? __asan_memcpy+0x3c/0x60
 ? skb_copy_bits+0x58d/0x830
 skb_copy_datagram_iter+0x37/0x120
 nvme_tcp_recv_skb+0xa07/0x4320
 ? __pfx_nvme_tcp_recv_skb+0x10/0x10
 __tcp_read_sock+0x1ab/0x810
 ? __pfx_nvme_tcp_recv_skb+0x10/0x10
 ? __pfx_lock_sock_nested+0x10/0x10
 ? __pfx___tcp_read_sock+0x10/0x10
 nvme_tcp_try_recv+0x152/0x1e0
 ? __pfx_nvme_tcp_try_recv+0x10/0x10
 ? __pfx_mutex_unlock+0x10/0x10
 nvme_tcp_io_work+0x1e4/0x6c0
 ? __schedule+0x181a/0x49f0
 ? __pfx_nvme_tcp_io_work+0x10/0x10
 process_one_work+0x633/0x1030

Keep the blk_rq_payload_bytes() test and add req->data_len to it. The
old test is what rejects a C2HData naming a tag that is no longer in
flight, because blk_update_request() zeroes rq->__data_len on
completion; req->data_len and req->curr_bio are driver-private and
survive completion, so they cannot stand in for it. Setup initialises
the iterator only when both req->curr_bio and req->data_len are set, so
the gate now tests the same two.

Fixes: 25e5cb780e62 ("nvme-tcp: fix possible crash in write_zeroes processing")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/tcp.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -558,6 +558,7 @@ static int nvme_tcp_process_nvme_cqe(str
 static int nvme_tcp_handle_c2h_data(struct nvme_tcp_queue *queue,
 		struct nvme_tcp_data_pdu *pdu)
 {
+	struct nvme_tcp_request *req;
 	struct request *rq;
 
 	rq = nvme_find_rq(nvme_tcp_tagset(queue), pdu->command_id);
@@ -568,7 +569,8 @@ static int nvme_tcp_handle_c2h_data(stru
 		return -ENOENT;
 	}
 
-	if (!blk_rq_payload_bytes(rq)) {
+	req = blk_mq_rq_to_pdu(rq);
+	if (!blk_rq_payload_bytes(rq) || !req->curr_bio || !req->data_len) {
 		dev_err(queue->ctrl->ctrl.device,
 			"queue %d tag %#x unexpected data\n",
 			nvme_tcp_queue_id(queue), rq->tag);


