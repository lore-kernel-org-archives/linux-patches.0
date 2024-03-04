Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F15B1C687;
	Mon,  4 Mar 2024 21:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588102; cv=none; b=ei5xJM+viC1yJHYBmxx5xbXpn5jZYB1zcBj0UDrPFWOf+Vk1DmdCOltwxPbucYhbZUWrlK320bY/wdNsS6bR+/ne3FBWubqgDgmcf3RGnMHJ7klvC6cyqMxynwpb0v0QbRg1h7QsvwAvekrgY2XBIIDc0pi3N3zLYkpw1uNtnsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588102; c=relaxed/simple;
	bh=wscpWMQGQVWqbNcRd/AgeaPFQW0QxTuJ0tKPU2A4yQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CecUdRwH12chhptxFvwOqOkFHAwqg25z2fliWP2k5wRn9NUhxn0v3PKClvmw3yl6Xalrn9iIhHckhZZ1w9OEYGhgdupHdGi/zj7EJhSsb4A79/FTUHERoUP5u8X9fpcPTEwn2MAcO0jZlwwfHU7oHyKn2eqJGjxhiY3Ym7r6zZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vt40tYHJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vt40tYHJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27FD8C433F1;
	Mon,  4 Mar 2024 21:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588102;
	bh=wscpWMQGQVWqbNcRd/AgeaPFQW0QxTuJ0tKPU2A4yQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vt40tYHJ7xRkt1lsiYHLvmfxc8irI75REkyj8dye6VEDIlcb7lTydvGKBNLg5m435
	 ScDd6ojSHBrHk8P2BGQQ4Kr0trvzynZ2HIbO42TBdkU2CgBXN6fGbLBYd2jQhCyWkp
	 MfH2pdUyKWBraCER2uGjnw6eAt74BpK2MjrgBvR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunjian Wang <wangyunjian@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 07/42] tun: Fix xdp_rxq_infos queue_index when detaching
Date: Mon,  4 Mar 2024 21:23:34 +0000
Message-ID: <20240304211537.882475754@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211537.631764077@linuxfoundation.org>
References: <20240304211537.631764077@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yunjian Wang <wangyunjian@huawei.com>

[ Upstream commit 2a770cdc4382b457ca3d43d03f0f0064f905a0d0 ]

When a queue(tfile) is detached, we only update tfile's queue_index,
but do not update xdp_rxq_info's queue_index. This patch fixes it.

Fixes: 8bf5c4ee1889 ("tun: setup xdp_rxq_info")
Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
Link: https://lore.kernel.org/r/1708398727-46308-1-git-send-email-wangyunjian@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/tun.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 0b25b59f44033..bb0368272a1bb 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -665,6 +665,7 @@ static void __tun_detach(struct tun_file *tfile, bool clean)
 				   tun->tfiles[tun->numqueues - 1]);
 		ntfile = rtnl_dereference(tun->tfiles[index]);
 		ntfile->queue_index = index;
+		ntfile->xdp_rxq.queue_index = index;
 		rcu_assign_pointer(tun->tfiles[tun->numqueues - 1],
 				   NULL);
 
-- 
2.43.0



