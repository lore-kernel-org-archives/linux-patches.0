Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043558;
	b=RiUmEcdMDhH/ZvKa1ygWy9VhjbWFDX7Y6dCm2mDA9wd0GZvDGrCHDPIuE2dgcDn28G/n
	 tGoUWSG/O9dSAF9uYBOwzCUselxmeRjWgHkkb4ipGGTssCMDgDjCCOhvjWGBEWQxxWEY2
	 k2TJ2appXPyVHCACRH2/gWGp6+BeU7A91qiHKUAklwk2wrUev6lbLRUjyG3TnuNJ0g9bQ
	 EDZ1wLNKkJqK7KkoAQVdlyNBvRNOqqcDKpHVjq8LjcvV2Jeh7VqBlh+aIcqgzr7oVIBlO
	 GZRntrSTYYlRuj/iqM+c7blQuClIuw0xR5OASh0diLTyd6fEdye+e40Lq2ABEdAmDTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043558;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FV0/+hy7oXR63MjHqHkg8GXGLKnzwERnWOiqES7kL3g=;
	b=x+EDiUJUDiPxqh831cJSmRvuXfMvjdawKvJggEN3c/ctpjS2xuikIogwcrp0+H03hlFu
	 tp5jtF0or6iXLnxBtquupMHoXWQsQFGeJR9v+Qo8CHOg39HoVmUrlO6uEYSw+cGNQyfmk
	 0XA4qfyZnyR4FmTc2Ie/FdqEidDH0d83DpoB0xwCdRx1G+72tycCmyQcKeh7WTObE6RgV
	 TyOlBAKUeY4Zf7uR58VLPY1Uy73ZxlEHyZ2c8FFJ355KZX4JOB81dWL/RfvFQpIIzmZnd
	 km7mesbxXSFvqtjcBtjq1QMjcDM5yRDaJ4SwY4/v0EUHAw66pwOWNOVS7U9D7jWc7Pw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hAgZ61zs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBC1D606A325;
	Wed, 18 Nov 2026 23:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hAgZ61zs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 447C81F000C4;
	Wed, 18 Nov 2026 23:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043557;
	bh=FV0/+hy7oXR63MjHqHkg8GXGLKnzwERnWOiqES7kL3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hAgZ61zs2hun4CBI6sWooCj6NAViIW/x+7bjSg3gblBlUl0dC++ZHR7KOxs0wLEsJ
	 rHe77VxFVujCounr5ud9yq1/HXea5IxBLme+k7CM+dND0lNq/iv91LP4JOXVD2AycT
	 9g/nWO6eCFIkZzdQ58IiKd/iFYxEWw29Gia9CZFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gael Blivet <gael.blivet@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0253/2857] ksmbd: fix AsyncId zeroed before use in smb2_lock() cancel response
Date: Wed, 18 Nov 2026 15:21:27 +0100
Message-ID: <20261118150210.547826401@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d575441e265e2..4290e29d3632c 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -7389,22 +7389,25 @@ int smb2_lock(struct ksmbd_work *work)
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



