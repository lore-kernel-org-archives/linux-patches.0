Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 388572BB17;
	Tue, 11 Nov 2025 00:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822110; cv=none; b=QmZIsXdGyx6wEzAEalWFcP93nk6Iwz3Wvqe2FCHQ6gbNEqcdu7qBDo8GFbNm6TB8Jlv/lOGnacliQMrkcSRZHtbzsWaRfsdG3zu3271Up2fvCvkXGBhJ39fJAXUYsDkyqjjvkBGEQS9LVUuY3K9vVWjrjgOBCqy3T4e30qxXxx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822110; c=relaxed/simple;
	bh=qTPmcOn66S1sdY0U6RWKED/47HOiQQsSZq5XnSW5/PQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fyCVv8nc+698CMflSGRMNe1OaGCUldoW1MKsiLNlpagOm124DpYgqdDgR8uN8jfVQl2xoy375V1UYT+6IZ+2SpAaBCoYtzNm60Af8JM0Fw17DfHqLRbtVttt8+IrVcjr7TLBgOIHbqKAKnxQ2kYygAP7UfgcuE9I2Sz19UlJUNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LUtpg5Nq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LUtpg5Nq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC51CC4CEF5;
	Tue, 11 Nov 2025 00:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822110;
	bh=qTPmcOn66S1sdY0U6RWKED/47HOiQQsSZq5XnSW5/PQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LUtpg5NqofzqTZPXJ4lLU29ftav5kCbbwHQkEWf9PiPb4GT8tCLuF7JUcMDyAQ+/9
	 /TM50R6p7nvg5OffEiPlai1sJZsxko1LC3Hawzn3bjNamBdpIGg+iyhf6wtEqVm1wI
	 xQ4o6jhBwglfAxgBW3sSO5s58eS5Erswh5RQa68Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	Mat Martineau <martineau@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.17 021/849] mptcp: restore window probe
Date: Tue, 11 Nov 2025 09:33:11 +0900
Message-ID: <20251111004536.966167314@linuxfoundation.org>
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

From: Paolo Abeni <pabeni@redhat.com>

commit a824084b98d8a1dbd6e85d0842a8eb5e73467f59 upstream.

Since commit 72377ab2d671 ("mptcp: more conservative check for zero
probes") the MPTCP-level zero window probe check is always disabled, as
the TCP-level write queue always contains at least the newly allocated
skb.

Refine the relevant check tacking in account that the above condition
and that such skb can have zero length.

Fixes: 72377ab2d671 ("mptcp: more conservative check for zero probes")
Cc: stable@vger.kernel.org
Reported-by: Geliang Tang <geliang@kernel.org>
Closes: https://lore.kernel.org/d0a814c364e744ca6b836ccd5b6e9146882e8d42.camel@kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Tested-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20251028-net-mptcp-send-timeout-v1-3-38ffff5a9ec8@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1257,7 +1257,12 @@ alloc_skb:
 	if (copy == 0) {
 		u64 snd_una = READ_ONCE(msk->snd_una);
 
-		if (snd_una != msk->snd_nxt || tcp_write_queue_tail(ssk)) {
+		/* No need for zero probe if there are any data pending
+		 * either at the msk or ssk level; skb is the current write
+		 * queue tail and can be empty at this point.
+		 */
+		if (snd_una != msk->snd_nxt || skb->len ||
+		    skb != tcp_send_head(ssk)) {
 			tcp_remove_empty_skb(ssk);
 			return 0;
 		}


