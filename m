Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAAB4145B05;
	Thu, 11 Apr 2024 10:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829980; cv=none; b=Xac2xJKiCR3T6a0pIMUYlLD8LSLYLpoe78/y0CDA2mXNw0qUVHfIu6d/9Cc5Q7aN5MixnB/mVfeJcu6ArlAn2sNuIKI5ISZsoBeqM6gKxrrmvE8R4ikXu0RHqjH7nAnFrV6lUXaYsv4U4w7Z8rz1Hv2j0YMgtueXqgVgo3hK4tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829980; c=relaxed/simple;
	bh=nlUTp/O79DLUsaC/AM/cIJrhs8qzpMFsVeGOpAT0kT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g1AOWUfzfNi6MV4rvBTZY0DBBggcJMDzANXGBwCwRvXLEAhAyEpIKiqWLt1QeiJuXMbqQWblb3GK3agxO14TQec6tg6EgNcqUp4//hNMX/inPIs5TIp5V+YSh/xzwtazE2Z034GMQ0keL2BfDMGXeqHANwsbkwPXuNptffjJDUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LLT4+a4a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LLT4+a4a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EEC2C433C7;
	Thu, 11 Apr 2024 10:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829980;
	bh=nlUTp/O79DLUsaC/AM/cIJrhs8qzpMFsVeGOpAT0kT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LLT4+a4azQxth8m7VqZe4LMd7mfIChvYSWu5DZehhTU2YuOsGkwkYlxJM4xGnrSZT
	 RCo2UKiD8vu/4HTiZOV7cPykzv0BYXBGGqVk8itddmXV1nc02JLecVcQmlA6BxM//b
	 +myuz34hXaSNylIvKfp8JXpUY2aJ0oQPi4WfKbzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 4.19 171/175] Bluetooth: btintel: Fixe build regression
Date: Thu, 11 Apr 2024 11:56:34 +0200
Message-ID: <20240411095424.712124322@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

commit 6e62ebfb49eb65bdcbfc5797db55e0ce7f79c3dd upstream.

This fixes the following build regression:

drivers-bluetooth-btintel.c-btintel_read_version()-warn:
passing-zero-to-PTR_ERR

Fixes: b79e04091010 ("Bluetooth: btintel: Fix null ptr deref in btintel_read_version")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btintel.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -355,13 +355,13 @@ int btintel_read_version(struct hci_dev
 	struct sk_buff *skb;
 
 	skb = __hci_cmd_sync(hdev, 0xfc05, 0, NULL, HCI_CMD_TIMEOUT);
-	if (IS_ERR_OR_NULL(skb)) {
+	if (IS_ERR(skb)) {
 		bt_dev_err(hdev, "Reading Intel version information failed (%ld)",
 			   PTR_ERR(skb));
 		return PTR_ERR(skb);
 	}
 
-	if (skb->len != sizeof(*ver)) {
+	if (!skb || skb->len != sizeof(*ver)) {
 		bt_dev_err(hdev, "Intel version event size mismatch");
 		kfree_skb(skb);
 		return -EILSEQ;


