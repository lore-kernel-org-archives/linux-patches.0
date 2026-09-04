Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2F36411FBF;
	Fri,  4 Sep 2026 06:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501602; cv=none; b=sVD05xJ+2z8kdXgHsjTEi0UmQaSFer60AvBBk2HoKVRcXSg2bM3Dnwp7KAI/5P3gh6fS+dldvF2Ijco31/LoQn1aAKTvQnLshOsPF8mKdCowrfDrJG1l8crmbit7W4L2OiFndsPJQX2eNZTh7HFLCkORj4zfyvIsrnAM6P5Q0ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501602; c=relaxed/simple;
	bh=GN4Pv4zzn5cvJZ7nQES0BOSyaCljJxLgWGvODheahHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lkykmnvKSnmTG9hDZp031Svm6gipjYfvukbKdWf/8yovmTDIOG9Cz6RrUTvBtNoMD9Lgqa438BdDs13QFZedEvI5oSOj0nmg/HzPsLQT8BNvQyG2yuxVcxpqCquWawVojr15MNTxu/4EfMTqMGOCd7RubKza+JQrY+xbOvSszsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F/UBq4ju; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F/UBq4ju"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 194331F00A3D;
	Fri,  4 Sep 2026 06:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501601;
	bh=uQ9A9nCMoyghr483VfU97VYj8m3Sh4ANNamr2FawBVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F/UBq4juNeNFedm9uNGjmvoRJO5yET4pJWy2jGP5QQ165AW2vEmVdgUi0DXepaQ0r
	 ezeWCtJIsVxgBCFZS470SKWZfwOzaoVmdIS6kRvj+yxDGQ3MNb542VPmw8KOmq7rbB
	 ESg0Sxv+lPyDvXZRN9odTWNAs9lSi0fXqo4xnxmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Dave Jiang <dave.jiang@intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 467/552] NTB: ntb_transport: Fail TX enqueue when the QP link is down
Date: Fri,  4 Sep 2026 07:00:24 +0200
Message-ID: <20260904045801.282917116@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Koichiro Den <den@valinux.co.jp>

commit 873ce713fef5dde0939220f04f3484ec86a16fba upstream.

Commit f195a1a6fe41 ("ntb: Drop packets when qp link is down") meant to
make ntb_transport_tx_enqueue() drop packets submitted while the QP link
is down, but it only returns 0 without consuming the packet. Zero means
success by this function's contract, so ntb_netdev reports NETDEV_TX_OK
and forgets the skb: nothing queued it, nothing frees it, and it leaks,
one skb for every transmit racing a link-down.

Return -ENOLINK instead, restoring the contract that a non-zero return
leaves the buffer owned by the caller. With the preceding patch,
ntb_netdev frees the skb on non-retryable enqueue failures and returns
NETDEV_TX_OK, so a packet racing with link-down is dropped without leaking
or entering a busy retry loop.

Fixes: f195a1a6fe41 ("ntb: Drop packets when qp link is down")
Cc: stable@vger.kernel.org
Signed-off-by: Koichiro Den <den@valinux.co.jp>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://patch.msgid.link/20260817053519.4135287-4-den@valinux.co.jp
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ntb/ntb_transport.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/ntb/ntb_transport.c
+++ b/drivers/ntb/ntb_transport.c
@@ -2315,9 +2315,8 @@ int ntb_transport_tx_enqueue(struct ntb_
 	if (!qp || !len)
 		return -EINVAL;
 
-	/* If the qp link is down already, just ignore. */
 	if (!qp->link_is_up)
-		return 0;
+		return -ENOLINK;
 
 	entry = ntb_list_rm(&qp->ntb_tx_free_q_lock, &qp->tx_free_q);
 	if (!entry) {


