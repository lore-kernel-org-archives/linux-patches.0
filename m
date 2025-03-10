Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85538233703;
	Mon, 10 Mar 2025 17:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628343; cv=none; b=FwHyDD/dYGjsDJbPbaERaXubuMEFhZo/Y2TejDHM1Uj54gwwUDJniQ7Zsw8TXTWUwO60TSFd6ibQ1jqYDEfSvVAlHmKMHLO4jO6d2avmkmgBTqk4zwPg638BfJhPoe1D5bqtlNNJXFkKw0KRZnvw+th2E5vkEhlFuLYmi8oJslw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628343; c=relaxed/simple;
	bh=KNcXu+frCBUPAqfB1ICtGSrV86sdT04MwxuVaT/cdNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E19ed+66ihPJqAi6gLsssyTZxi/d7pI/jUK9KglQ+7WbdOCy2+eAULRB7w+lrXlbSnzuUsQ0WEBWA96mHGy11q73PHGr9xAZbHePu+ZJN41Plzk0Kkzwc38zNiJjGm8HoVYrjYc08qaeV6GtmyhHsvTuAZjD/21eBNyO1tpQCXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xbZNsnoH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xbZNsnoH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D5D0C4CEE5;
	Mon, 10 Mar 2025 17:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628343;
	bh=KNcXu+frCBUPAqfB1ICtGSrV86sdT04MwxuVaT/cdNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xbZNsnoH+Qxrslxy1gbT0lLeEHRjolzHtGMsVJigMhK9cN8tO4nO8bcODhoY1jCxc
	 4GEiv8vS9VPBsSNZngMqObBqwOkH0bGQEWRC3VfEQcJr3bRM2sc55SIFAgEvRyTa+z
	 LpeDYFO1ugmf+5686P/uq6MPklhzN0ejk69wefng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 026/109] Bluetooth: Add check for mgmt_alloc_skb() in mgmt_remote_name()
Date: Mon, 10 Mar 2025 18:06:10 +0100
Message-ID: <20250310170428.592682163@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170427.529761261@linuxfoundation.org>
References: <20250310170427.529761261@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

commit f2176a07e7b19f73e05c805cf3d130a2999154cb upstream.

Add check for the return value of mgmt_alloc_skb() in
mgmt_remote_name() to prevent null pointer dereference.

Fixes: ba17bb62ce41 ("Bluetooth: Fix skb allocation in mgmt_remote_name() & mgmt_device_connected()")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/mgmt.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -10514,6 +10514,8 @@ void mgmt_remote_name(struct hci_dev *hd
 
 	skb = mgmt_alloc_skb(hdev, MGMT_EV_DEVICE_FOUND,
 			     sizeof(*ev) + (name ? eir_precalc_len(name_len) : 0));
+	if (!skb)
+		return;
 
 	ev = skb_put(skb, sizeof(*ev));
 	bacpy(&ev->addr.bdaddr, bdaddr);


