Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 613E52F260C;
	Sat, 12 Sep 2026 18:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237050; cv=none; b=KP46ZBeDuIdAQ3dSrF2UEyWnoojMJiK6EoSkk1IJJSU3VaUzEjMsTSGclX9+TCIA0eQjL7N/H+F2H+Lj7CsRWugFo8ecvJ1icga2Etfg2U/xgMkhcd5xBSwTsd6euzCO77lO+FYSLDYG+P8CJT/DPB0pNXuLLFZGInJgRefVgc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237050; c=relaxed/simple;
	bh=PHg8qevhEnqT0ILq4+uM+WPyCOvP2gsy70VBZprHjrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ez5t0GWm8yIjzrPBwI8p4vCeiUEQf26fCWAaZxbrefkcan/6F3n6UMZCZ6r0sSt+tJ57/8zSP3NMRLvRIsprxqZy/o186aflVY5DgfUVyUPh2NGgiFVtQGytea6RuUZ77D7bxJHOX6Box0O4OzZrLt0K9jheOaXCo5VXiTF82RQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G5ywRJ5X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G5ywRJ5X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19F0A1F000FF;
	Sat, 12 Sep 2026 18:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237049;
	bh=iP120Pm/WegWRCuDvB5FMxYLWvSJ3ybpjW2Selhcb60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G5ywRJ5XII1xKEWA6leJ1I0kRCJhJ2XRntcw/t//x8cG4CExNLCZw7rG/pvys5yrf
	 eMuXqnVvBPn342J7fPgTndBD8iAgxeZZjQQyOaZ2aNtXLp3PzDTSZkutkKumk0LsUL
	 6fs6rqrvBtXtKUEgBojJpkHec46G0yr1KwpBYV58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Dave Jiang <dave.jiang@intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 181/935] NTB: ntb_transport: Fail TX enqueue when the QP link is down
Date: Sat, 12 Sep 2026 08:53:31 +0200
Message-ID: <20260912065530.969164584@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2291,9 +2291,8 @@ int ntb_transport_tx_enqueue(struct ntb_
 	if (!qp || !len)
 		return -EINVAL;
 
-	/* If the qp link is down already, just ignore. */
 	if (!qp->link_is_up)
-		return 0;
+		return -ENOLINK;
 
 	entry = ntb_list_rm(&qp->ntb_tx_free_q_lock, &qp->tx_free_q);
 	if (!entry) {


