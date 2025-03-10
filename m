Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B00782309B6;
	Mon, 10 Mar 2025 17:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626630; cv=none; b=i5H0OW2bYomFlTJFa+Y4hTOx65EB7jAFi7BHmZBBCjSUTwUKDQG4KU9vdp6/XWr/TEPu/+Fh8QfCvwNRImw4vjV0+U9/HDOASx92GE/IsuTwLH2mLtyhwY+WojxpwcMEw5ZtuustfMFoOekQf1bUDpgYxIVUYLA6fTVx8okL7jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626630; c=relaxed/simple;
	bh=weIp/do5TdKy7Tbd3Urtio7zdPqjfL5Gc6Iq3OLxmg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JQ/DFK/KEuJDksNhKjsgQXr4E2Kk8UyBppxgJ6fu63mY3OaEMUuykRqHV69SSzjHuf6MV86Md1d0v7Axy1jr2omy6Jkc8J2Y7gvLKohk57PYXmOIFuoWKUvrG1/kntGOlaHssrwLMo7lEAJEXsKFavCiK0sjI+xXtig+dk+o41Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k7kciFzF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k7kciFzF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39D7AC4CEE5;
	Mon, 10 Mar 2025 17:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626630;
	bh=weIp/do5TdKy7Tbd3Urtio7zdPqjfL5Gc6Iq3OLxmg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k7kciFzFOsv9cUZW5RO9Z6qAiFria00jHzttsNlzEHxhZ9UnjPlbtF3Jpm3S91vFZ
	 SV+w39J8nuLmvcklaSWl6+2nFBar2GtT5yGHIm+AA0mhyJ3EVRzRlt+YFvNyB5kmW9
	 HUq4P27cnMLMu8wfYZKbbrgzEmL/g59lVeR5h4v8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.13 058/207] Bluetooth: Add check for mgmt_alloc_skb() in mgmt_remote_name()
Date: Mon, 10 Mar 2025 18:04:11 +0100
Message-ID: <20250310170450.079683803@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -10544,6 +10544,8 @@ void mgmt_remote_name(struct hci_dev *hd
 
 	skb = mgmt_alloc_skb(hdev, MGMT_EV_DEVICE_FOUND,
 			     sizeof(*ev) + (name ? eir_precalc_len(name_len) : 0));
+	if (!skb)
+		return;
 
 	ev = skb_put(skb, sizeof(*ev));
 	bacpy(&ev->addr.bdaddr, bdaddr);


