Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9A0363B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:53:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4257EC433EF;
	Mon, 20 Feb 2023 13:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676901197;
	bh=CBExR8AHEmCoIjSQLDPHYCrxhewByaO9AoeOQU4oNjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z7ZXfNumGDD4A+9OtICkF6r7BepyHgwYpyQO9ngcuMKfwn407M8Kr+6b02netPlRo
	 o6xPfizU9Wc4V2zYyL6MI2VKHEJ4MHwYZhUzUwb/ewMADji5lSGqi42zShe73fsAB9
	 4l8/rTWdQKVFlCWcwCa2chFU4zrNRAvccD3ajJV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pietro Borrello <borrello@diag.uniroma1.it>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 59/83] sctp: sctp_sock_filter(): avoid list_entry() on possibly empty list
Date: Mon, 20 Feb 2023 14:36:32 +0100
Message-Id: <20230220133555.728508212@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.669025851@linuxfoundation.org>
References: <20230220133553.669025851@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pietro Borrello <borrello@diag.uniroma1.it>

commit a1221703a0f75a9d81748c516457e0fc76951496 upstream.

Use list_is_first() to check whether tsp->asoc matches the first
element of ep->asocs, as the list is not guaranteed to have an entry.

Fixes: 8f840e47f190 ("sctp: add the sctp_diag.c file")
Signed-off-by: Pietro Borrello <borrello@diag.uniroma1.it>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://lore.kernel.org/r/20230208-sctp-filter-v2-1-6e1f4017f326@diag.uniroma1.it
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/diag.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/net/sctp/diag.c
+++ b/net/sctp/diag.c
@@ -343,11 +343,9 @@ static int sctp_sock_filter(struct sctp_
 	struct sctp_comm_param *commp = p;
 	struct sock *sk = ep->base.sk;
 	const struct inet_diag_req_v2 *r = commp->r;
-	struct sctp_association *assoc =
-		list_entry(ep->asocs.next, struct sctp_association, asocs);
 
 	/* find the ep only once through the transports by this condition */
-	if (tsp->asoc != assoc)
+	if (!list_is_first(&tsp->asoc->asocs, &ep->asocs))
 		return 0;
 
 	if (r->sdiag_family != AF_UNSPEC && sk->sk_family != r->sdiag_family)


