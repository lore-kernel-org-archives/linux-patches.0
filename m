Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C904D37DAD0;
	Fri,  4 Sep 2026 05:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499985; cv=none; b=iUAEZFLiujsQCxnp4w1v1uo0kBhXzVaZ4ViAHRELZ0Zx9f7oehV4o08uA36nAZMjyhHRb2/3Ir4jKDPLbXD5pY9oTr9u3gGQkqwrT9SoGuMqk70kK36Hb0HU+lUTYng7fS5mWDWEY3dhcY0XvbuwyN1Dj85osZNJKPP4H44wB7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499985; c=relaxed/simple;
	bh=SeycMD1LZJChTRcURVgHauTYN8SlIbp9OBmTw/4UuLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c+7JX25aRkbUWPoSMIpzsyPlK8b01lqHPmkzfOzK+5BahefzuZzWIo2DlQ9zMlIIxxJd1mWofKF1UgIeJ0Yda9/gvHvpddHT4eTJiwX6/LqtiFGsysIDObdc2vf7eK3nyMJ7J3aYcf+VgwcEZoyuvImB9HsGV5/uYHMZA0WcAwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j5n7v4oF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j5n7v4oF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 302D31F00A3D;
	Fri,  4 Sep 2026 05:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499984;
	bh=2MhVsi+CjPk0SQ4nvC23LZZst4GtuX9t25zZtOAFvpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j5n7v4oF+1Z4TDQ4r/LMQJKV9gG071VSVt4BuF2ohwlU1SpMXh5uie0nMKI/yd8Uk
	 8r/UODjlc/pxnphVcv6lUKqO3GPe//JujORK0H502yf5+vVjhjjHzzVjzDWPMG+/Ng
	 Ix73CJ1cA4GfjagscNWODDu1YgWUYcfMIThyJTGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Ye <fy15309206903@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 610/713] net: thunderbolt: Release the Rx HopID that was handed out on mismatch
Date: Fri,  4 Sep 2026 06:59:38 +0200
Message-ID: <20260904045817.500488221@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

From: Fan Ye <fy15309206903@gmail.com>

commit 2f1463554d0561a2fead81e3888604e5c1125e29 upstream.

tb_xdomain_alloc_in_hopid() passes the wanted HopID to ida_alloc_range()
as the lower bound, so a taken id is not an error there: the allocator
returns the next free one above it. tbnet_connected_work() asks for the
peer's transmit path, treats any other id as a failure and returns
without releasing what it got, so that allocation stays live for the rest
of the XDomain connection with nothing left holding a reference to it.

Release the id when it is not the one we asked for, the same way the
error unwind at the end of the function releases the expected one.

Fixes: 180b0689425c ("thunderbolt: Allow multiple DMA tunnels over a single XDomain connection")
Cc: stable@vger.kernel.org
Signed-off-by: Fan Ye <fy15309206903@gmail.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260811-b4-tbnet-hopid-v3-1-9e75d1b51331@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/thunderbolt/main.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/thunderbolt/main.c
+++ b/drivers/net/thunderbolt/main.c
@@ -647,6 +647,8 @@ static void tbnet_connected_work(struct
 	ret = tb_xdomain_alloc_in_hopid(net->xd, net->remote_transmit_path);
 	if (ret != net->remote_transmit_path) {
 		netdev_err(net->dev, "failed to allocate Rx HopID\n");
+		if (ret >= 0)
+			tb_xdomain_release_in_hopid(net->xd, ret);
 		return;
 	}
 


