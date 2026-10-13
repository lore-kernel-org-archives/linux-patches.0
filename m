Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1CD84E80B5;
	Tue, 13 Oct 2026 11:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892186; cv=none; b=BnQSaR3ty2w2sg936TOQT5uvOji1R/2OzjQlueuM9sUbn1DYtgcOyR2tvGIzT4jgWwPMONP3YtZ6Nhin5YsK2iB6h0W+ouVeOS0PtWWUutaBIN3vZu8Uvvjif/useMfgoip9rQob5CnSZpjpBPVzNsuI5YJIoPU7fz3c+yDOfQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892186; c=relaxed/simple;
	bh=7Pv6bxRH71z+rYBBJFgQl+Ol9+Hylht2y/g4pC2pTt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XQdxlTs7pdejWNG0NE+rR3MiqdDUG40L+6BsV5rn/iNbxFWntZxcc8HnWP+b6KWhtuDfOPSIBpLE1dFL80puFoqhPL1J9budt4GPrwO1AooB8ouuQ7nb2gzI+KFpZs/GvDVS9zOyNHaB5VLvBxipTqGT/jEaz86zKJIf72001Jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LZI19Tq4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LZI19Tq4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0966D1F0089A;
	Tue, 13 Oct 2026 11:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892185;
	bh=QIu6Y+Gni1p2H8n9005oyw8WyDpPOD2n1DcszhcM5nM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LZI19Tq4ExP05t3/7b9HDD1UhPseOmHXJnz3sonFnYDgjY1cvLHerXOGbEEhc/Juo
	 BZ1LpZhzqcWnvrk4+3IDdZD8UR8+OBQVmOzMWor+9nMF1whOdTa6/BFY5Jf+4ksli0
	 aLjAmKT2T5zuVKEYMb4QeCk0Kzk85DlRzdD31DtY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 090/281] net: team: free skb when broadcast has no txable port
Date: Tue, 13 Oct 2026 13:36:46 +0200
Message-ID: <20261013112857.319701790@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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


