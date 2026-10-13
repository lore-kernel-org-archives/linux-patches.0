Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCA5F547071;
	Tue, 13 Oct 2026 12:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895833; cv=none; b=oJUEa0qx4SKfKpz0aQ0phPF2/Tz0+iFNoDlhr0/Y2rYRPm/j3vhBNJ8gbanB9zcoOdp7EThA6hXqWtN7aYE9u8z7jPzYwO9iYKpSVPFQ6Quc3b6zNzsWQOxPavBOvGIbbUtJ495WY6oIRbq0GRP1RBJPAJJ1zTfc4/S/qxLLITc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895833; c=relaxed/simple;
	bh=v9Yl3NR89qIZrY6RBm66B/Vefxwuvu8yNdprwaBoCqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uXLGT2801VJnmliQNarWqmBGfFXDFK1gDAipkkGZpNnyisnXbC4S0NSao0PyDJDLRW8TwcqieDLm3iMv++QOnkVE+f/fnu23PaGvS4loPBQ3qkgEiEcmOREF0YUigsFpLfKkloofRikacPVGKMnfsSqJsM87/c/wJsYv0nxznXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vhzon64l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vhzon64l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FC221F00898;
	Tue, 13 Oct 2026 12:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895832;
	bh=BAo8LxIvKGCnBk1RaljNkeczCEKZbKyLj3ZiTUVziYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vhzon64lRf+jaXL/1kxY92qx6lki6Jsy/TIyOOWo2eYcsxLVMltFFzD6qbHOuc6wt
	 pHvyQb4dfvwpvNeCSa9i4V2M63DuLxIrBntnFMbnJYZK2cio0ecjSrLJoeLQQpY0+1
	 QE70AgBwdfM6myUlGkk8L3lOpSoLTdP7u+Bz9fws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 406/497] net: team: free skb when broadcast has no txable port
Date: Tue, 13 Oct 2026 13:39:33 +0200
Message-ID: <20261013112917.527762800@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weiming Shi <bestswngs@gmail.com>

commit 489114c9ecae44e523361a4b3e610ee5ebd9189c upstream.

bc_transmit() sends the original skb through the last txable port.
When no port is txable, it returns false without consuming the skb, but
team_xmit() still returns NETDEV_TX_OK. AF_PACKET sends then retain the
skb and its socket write-memory charge.

A TX-enabled, link-down port keeps the broadcast transmit op installed.
Carrier can stay up through a second link-up, TX-disabled port or be
forced on by userspace. Free the original skb on the no-port path while
leaving the existing drop accounting intact.

Discovered by Sashiko during review of previous commit.

Cc: stable@vger.kernel.org
Fixes: 5fc889911a99 ("team: add broadcast mode")
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Link: https://patch.msgid.link/20261001182326.572045-3-bestswngs@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/team/team_mode_broadcast.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/team/team_mode_broadcast.c
+++ b/drivers/net/team/team_mode_broadcast.c
@@ -37,6 +37,8 @@ static bool bc_transmit(struct team *tea
 		ret = !team_dev_queue_xmit(team, last, skb);
 		if (!sum_ret)
 			sum_ret = ret;
+	} else {
+		dev_kfree_skb_any(skb);
 	}
 	return sum_ret;
 }


