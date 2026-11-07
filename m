Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061009;
	b=PbHb4bxxj3BkKhbpPmOth8NFBpvwQ48M210R+zCeAzHw8pY0MK/vGHriS6synj38jySf
	 OQdrDWOK5rmTR+K/ITOA7jNPPccF0w/msvBKQCclhFMx7aeKVOQ55SyjozE2aSx24AS7y
	 qdYDXe1fMunnK9tCqZ+RoQKhFCyiR8txzSMjlXKQQ32Bw3BJXnZxz93Td/5Sibr4kt9Sw
	 OD+aB7u00jGxqrR9E/n1inPBkKDlipnvfngY3SYD4N4Xl5H+p7E01Vb3kgnjVFMHAtreu
	 j3aANlHjIP3AKXvQHapwnHEPwnGDRoewn10C6SCPwdCOfI/Hm6yg8T8ckGyZRpsxH0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061009;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zVcIyZf5DMH1evznkkC8MkOqGAj6s+M3UmaWke6BHNE=;
	b=Q3kyPgqeviznJFImE9tZyeQanIpHRwXs/FXJx9QNF7upcYN+XrLU/iio/tjWs7auFesO
	 Z2rUchMQlnev1+Vfw84+1n5XN+WVnMciDganqLZ5Md6z10Pljy7bO0/EIoVms7EbvoGVa
	 JpZmVvBQxZgdGuoBo4fUlGPA+Zmp4VFiw8+ckRkAqtlDYSq33iAl9ZPQnFbVxbJa+aiVp
	 vjj3FAiA8nlyNkn53A3niuzNFBN6Ew4FoM28eiIuze9Xws7bq99zrTXr/ImNqFKm1b6iu
	 O1sIw88XT8yQj/VZjrmu+G7GTCUuj/4nEzB+j2bAANqdPhIT4AMWE9zxtsfTymCRwiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="rb/eRffr";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C91C606D810;
	Sat,  7 Nov 2026 14:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rb/eRffr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED05C1F0089F;
	Sat,  7 Nov 2026 14:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061009;
	bh=zVcIyZf5DMH1evznkkC8MkOqGAj6s+M3UmaWke6BHNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rb/eRffrbLsX6Gb9fiYxdHex8h4PrL1ihegc0T1x2DCSsqMNU4DSLlXU57flpzNI7
	 UbUD99sGmX8cdjcre58v/tpMhCe572Kq+DP/KPqxSs5rbpUMbdsIrBD0/czQsvRJXp
	 vhUZhRtL6IxxCYCn1Vv7B4Ahla2jswMogqP7OJgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gael Blivet <gael.blivet@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0352/1536] ksmbd: fix AsyncId zeroed before use in smb2_lock() cancel response
Date: Sat,  7 Nov 2026 08:39:28 -0500
Message-ID: <20261107135007.558775310@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gael Blivet <gael.blivet@gmail.com>

[ Upstream commit 7b461610882c8baa64d56dade57cdbfb686739fa ]

release_async_work() zeroes work->async_id before the CANCELLED path
calls smb2_send_interim_resp(work, STATUS_CANCELLED), which reads
work->async_id to build the response's AsyncId field. The cancellation
response for a cancelled blocked-lock request is sent with AsyncId=0
instead of the id the client received in the original STATUS_PENDING
response for this request.

Checked against every other release_async_work() call site in this
file: smb2_read()/smb2_write() don't send a further async response
afterward (their status goes out on the synchronous path instead), and
smb2_notify()'s two async paths already transfer the id to a separate
struct before releasing, so this reordering is scoped to smb2_lock()
only.

Send the STATUS_CANCELLED response while work->async_id is still valid,
then release the async work afterward.

Signed-off-by: Gael Blivet <gael.blivet@gmail.com>
Assisted-by: Claude:claude-sonnet-5
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 5cee1fbdf8af5..e5d5a08022198 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -7867,22 +7867,25 @@ int smb2_lock(struct ksmbd_work *work)
 				spin_unlock(&fp->f_lock);
 
 				list_del(&smb_lock->llist);
-				release_async_work(work);
-
-				if (work->state == KSMBD_WORK_ACTIVE)
-					goto retry;
-
-				locks_free_lock(flock);
 
 				if (work->state == KSMBD_WORK_CANCELLED) {
 					rsp->hdr.Status = STATUS_CANCELLED;
 					kfree(smb_lock);
 					smb2_send_interim_resp(work,
 							STATUS_CANCELLED);
+					release_async_work(work);
+					locks_free_lock(flock);
 					work->send_no_response = 1;
 					goto out;
 				}
 
+				release_async_work(work);
+
+				if (work->state == KSMBD_WORK_ACTIVE)
+					goto retry;
+
+				locks_free_lock(flock);
+
 				rsp->hdr.Status =
 					STATUS_RANGE_NOT_LOCKED;
 				kfree(smb_lock);
-- 
2.53.0



