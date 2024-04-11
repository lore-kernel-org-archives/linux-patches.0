Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E915A79FD;
	Thu, 11 Apr 2024 10:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832552; cv=none; b=inrscvx6Y83rBgEQyFxt3PpBJlwsZxa2MF21GDqY8eyTc3IusVZPrbSC2gvHVRJkpBnHGtRKE0dp1dgd/UAxfqQiXaXQHMudswF7lda8Pofihu9kXwhoxWMxBkeVvzkz7gBcnyARGF+UEmQVxjL1qzTHdOifdtJvrkUOsDMF9bI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832552; c=relaxed/simple;
	bh=JdoerpNV+zIlOC76QWrOqcl5L3j73ul+RYBiGKnAuNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iQQyiyvCVAKRk8eBiOWOTNQ7p66lp4ijbs2L/PYvq8POBPYmPiTjJI5i4pV8JbktVwMG2EalnCgHDkJVWn0Ta76nmRxUTc25Uiq04/ytBdIWS1iISFu6GUdNy89StUqKC1t/hc71Xv/VWubwdwHHsvXmmPqmtWX5vTRfKoNObgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r7zr1dOm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r7zr1dOm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FEE5C433F1;
	Thu, 11 Apr 2024 10:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832551;
	bh=JdoerpNV+zIlOC76QWrOqcl5L3j73ul+RYBiGKnAuNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r7zr1dOmewPcbcXhOlGVMZhqTgrRj4StwSfmLS5iT+t8OyghReiuF2D8iXqPIGx4K
	 6oPRUsqH7OXQTGqQlI2KSLtwA4u02oMMrWUX6eQW2CJS4L5aGR9YtLPl27oaUhaNOG
	 mG3AxuHi2q54ex0g7a66MW5OxxvasJEY7tF9negk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 80/83] Bluetooth: btintel: Fixe build regression
Date: Thu, 11 Apr 2024 11:57:52 +0200
Message-ID: <20240411095415.097351290@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095412.671665933@linuxfoundation.org>
References: <20240411095412.671665933@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -405,13 +405,13 @@ int btintel_read_version(struct hci_dev
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


