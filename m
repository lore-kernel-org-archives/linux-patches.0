Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F852309DB1;
	Mon, 13 Oct 2025 15:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370044; cv=none; b=DOPmBPcR2lfH6+coMsiyMkTBfcxeYpgvQwYWqiQ+KmXdQsQfLoKW4jFzw7yxnViE+XnTLtQv/x4RZyFDVfwmVBHqepyUmAv3iT+dndP819JBGrJKKUWebcp6w9EbiceBu7Ppz09ZS3tW0OYunL8kQnM/4Lua0XEys+wmeKsPPng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370044; c=relaxed/simple;
	bh=th26xk+qs2gz5c06yLQwGHFHj2pioVBxMHBbjVi18DA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sb5lDPCWz09tt5wObudwpwGqakPMj18LgDJ61NruU6XStB0KsA2N10J+9GAsd+NEfr7IITH3arLOVeS6uYE9kGFcduUBEt1lrxLEWyX2BoIh0269V4IQvEAfaZlJMQ5hgST++C9BONxh5rv5Md68tuLgkk9Y7DUIBh+GvCSg2v8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fgya7U2T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fgya7U2T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55224C4CEE7;
	Mon, 13 Oct 2025 15:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370043;
	bh=th26xk+qs2gz5c06yLQwGHFHj2pioVBxMHBbjVi18DA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fgya7U2TDFA2TxJM7lVNRRK2M0XPZ2lkxaO6nc98PZ0QHq/x2mNRCYkodc8AVOEWe
	 7FizY4dc/CBKjMuo6e9mVI5HIIFY9p5/TRdU7kGimVBriz7Xuynqmv2tZsHBYqN0S2
	 iXCfaI+0DAUPDIyaJRGpdzFrQPcugnJSdTr3Xjcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 459/563] Bluetooth: ISO: free rx_skb if not consumed
Date: Mon, 13 Oct 2025 16:45:20 +0200
Message-ID: <20251013144427.913518869@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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
index c047a15e3fa39..9170c46eb47c6 100644
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



