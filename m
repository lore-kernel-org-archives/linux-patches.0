Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBBC7145B3F;
	Mon, 13 Oct 2025 15:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368564; cv=none; b=XoD0obDiJuCwMgcGWY8DcuhHinTtqBMbrTxit0BB65gxgbmEt+WaW54QXNiOsiiGEuX9qezpk20Vw6BJc3GonAmrmWTEQILPX7c28w3YC5CY5zZHiyDuLdEI8vgfXozrdKdAUR5s/pL0fibsc27UFqbzj1ssubzWEVu2DRFOfLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368564; c=relaxed/simple;
	bh=ixIYP91m5OrsNUyym9BmDO+P3O/dKDkl+qJaYLUBqSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hjhys0vc/TvNbAijMJ4SbBw7a+P92Se4ougAcw8vSo3mHqKISjiQDkAlPTUP17KT+RBu3y3ChNQvT3nLT87mt+9R76Uncw3+FLZ+pyi7NlYYQzVT8T+ASAt+u5V3KWY7TnW4MSvVfoNO5bPnaumytbvIuZm06oxXiUQ15GLaPm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UrXGDk/z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UrXGDk/z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E79EFC4CEE7;
	Mon, 13 Oct 2025 15:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368564;
	bh=ixIYP91m5OrsNUyym9BmDO+P3O/dKDkl+qJaYLUBqSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UrXGDk/zqO7mvlQdw8tfIGfhkVgJdZ3rorq7f2BKVs38G8VhEM7fPqh6BdatWYi5H
	 f8ZIwdEoTp19jjxdcn3hzBxxWfWfuD5YFgbYc1PKQyJ4Z236wpM1XuIbid1deTRm3b
	 dlLLfhjRgoigZBjclCUHjKTb5PBQFEaPy58B8ijY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 204/262] Bluetooth: ISO: free rx_skb if not consumed
Date: Mon, 13 Oct 2025 16:45:46 +0200
Message-ID: <20251013144333.591322678@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit 6ba85da5804efffe15c89b03742ea868f20b4172 ]

If iso_conn is freed when RX is incomplete, free any leftover skb piece.

Fixes: dc26097bdb86 ("Bluetooth: ISO: Use kref to track lifetime of iso_conn")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/iso.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index df21c79800fb6..e38f52638627d 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -111,6 +111,8 @@ static void iso_conn_free(struct kref *ref)
 	/* Ensure no more work items will run since hci_conn has been dropped */
 	disable_delayed_work_sync(&conn->timeout_work);
 
+	kfree_skb(conn->rx_skb);
+
 	kfree(conn);
 }
 
-- 
2.51.0



