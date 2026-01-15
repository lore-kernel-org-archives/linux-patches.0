Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F9CB29D27A;
	Thu, 15 Jan 2026 17:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496405; cv=none; b=hDqcahXkdLa4B9mMZskSW3MiwQQsml2q6VD+g0cJOjlgdqokeh9gB/A+Ktgs5oIcJHHVuJzR4Zt0bpR1K2RpuXhKV46KQ7zYTXftiN3FB1tgX6ijcHm1neGgO0ltt+nd7yjAQS0mJoRjrRKq7v2QS/FW5ikd+uaOpWnc8ZcbSg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496405; c=relaxed/simple;
	bh=9mUuDG2hCc+Ij0q0p1a06vXcluEb1qzF/Ubc1hFteKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KvFwxo0IgHvBb+3MQPRJseoy3KiBBfLUgJaP3g3XVrF5lt+zd/3HuUaP2hHGVVdVCyOf0pxwyci64UNh0v2lx3LOc5yb+XRzOx+g8rxrVj2Ps/P2lkRjbETUydgyXNVzKOgu6vtuui7tzcF8pjXQoO1TbwYa6JH+dGFSijq5txo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x/Q5ipiH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x/Q5ipiH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9631FC116D0;
	Thu, 15 Jan 2026 17:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496405;
	bh=9mUuDG2hCc+Ij0q0p1a06vXcluEb1qzF/Ubc1hFteKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x/Q5ipiHN4Jfm9M7SnPZonbsujWjIAOPGpJVBeLiq6Z//2fKiZEWJPhRJysR/wUI0
	 NPZmLRrIVj6+sESynac7n9fq+r0ojQhkyzkpxPYEUiEPokxXg8E1tYGxQweHgUPm+h
	 P0r0cerczyqyrJ1pez2+FUxkUw8HA/0ydHoFo8mE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petko Manolov <petkan@nucleusys.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 150/181] net: usb: pegasus: fix memory leak in update_eth_regs_async()
Date: Thu, 15 Jan 2026 17:48:07 +0100
Message-ID: <20260115164207.729426195@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

From: Petko Manolov <petkan@nucleusys.com>

[ Upstream commit afa27621a28af317523e0836dad430bec551eb54 ]

When asynchronously writing to the device registers and if usb_submit_urb()
fail, the code fail to release allocated to this point resources.

Fixes: 323b34963d11 ("drivers: net: usb: pegasus: fix control urb submission")
Signed-off-by: Petko Manolov <petkan@nucleusys.com>
Link: https://patch.msgid.link/20260106084821.3746677-1-petko.manolov@konsulko.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/pegasus.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
index 81ca64debc5b9..c514483134f05 100644
--- a/drivers/net/usb/pegasus.c
+++ b/drivers/net/usb/pegasus.c
@@ -168,6 +168,8 @@ static int update_eth_regs_async(pegasus_t *pegasus)
 			netif_device_detach(pegasus->net);
 		netif_err(pegasus, drv, pegasus->net,
 			  "%s returned %d\n", __func__, ret);
+		usb_free_urb(async_urb);
+		kfree(req);
 	}
 	return ret;
 }
-- 
2.51.0



