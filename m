Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 667963AC0E7;
	Fri,  9 Oct 2026 14:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555942; cv=none; b=XiOSncdyaiVNU/FEv/MCPVIIyTxkWER1d7RwnOxAfScBPTMoo9tNof3gsqoPizQyTIWcBRx+D9tVOe6bb4sAUioBVvJsMFrxUmqInZYm+glog1d/I/N11UkxvMhqq6hhiJn08jp9kDJGnhf/3DYQaXBySsAweQWJqZ6mfwGNsw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555942; c=relaxed/simple;
	bh=KNpDh49Bqv0/STshliPdUTwR6D0wG7n64BYuiS48RnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qyPSDkl6xRG/VAFdQV6T5WT5oHeaQxhQkQYFwsVzYx/l37HwGpTE+34FwZNfeuvIZvZig7Z3KGA2T8chQkcUET5jLPRLOXq7+6KPrx66CaCIkvs7crf60R9J96Pc44os1FVDy5gm9tsjxMx30p00WPNRyH6GklGFkxwKJcEECI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fGmFG6z9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fGmFG6z9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C75F91F000FF;
	Fri,  9 Oct 2026 14:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555940;
	bh=fjtrqQZRkBgvVF/+dW7TcH8/aGIQn3DfbeXScBcWVBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fGmFG6z9+nmTpI3xX18X14rj21LhnfqmOkKeFAJ2em6phlWwI3nrv6f+vgFDAOefs
	 AQYEV1fchtOgKqOS9TrrHkg7rcvCFDcL1o90BRtNIzzS2ExZd1D3qWnNfiB8kHQrnA
	 g+SgCDdx01mU7ddvQ4F/qp+vveE6sOj9ozZK/DNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Changyul Lee <lcy8047@gmail.com>,
	Sang-Hoon Choi <csh0052@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 094/428] Bluetooth: hci_core: free the HCI ID if naming fails
Date: Fri,  9 Oct 2026 16:07:11 +0200
Message-ID: <20261009140948.270168387@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

From: Sang-Hoon Choi <csh0052@gmail.com>

[ Upstream commit d1ac915fb4184faad1b62148be50f317de7c24b5 ]

hci_register_dev() allocates an ID before calling dev_set_name().
If naming fails, it returns without releasing that ID. The device has
not been registered and hdev->id has not been assigned, so the normal
unregister path cannot release it.

Free the allocated ID before returning the naming error.

Fixes: dcda165706b9 ("Bluetooth: hci_core: Fix build warnings")
Reported-by: Changyul Lee <lcy8047@gmail.com>
Assisted-by: LLM
Signed-off-by: Sang-Hoon Choi <csh0052@gmail.com>
Reported-by: Changyul Lee <lcy8047@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 3ea5ea7267d9c..528736270bfda 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -2554,8 +2554,10 @@ int hci_register_dev(struct hci_dev *hdev)
 		return id;
 
 	error = dev_set_name(&hdev->dev, "hci%u", id);
-	if (error)
+	if (error) {
+		ida_free(&hci_index_ida, id);
 		return error;
+	}
 
 	hdev->name = dev_name(&hdev->dev);
 	hdev->id = id;
-- 
2.53.0



