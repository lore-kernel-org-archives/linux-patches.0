Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F97C1D0430;
	Wed,  2 Oct 2024 13:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875435; cv=none; b=QYLU0MSnkp5b7Phc0fOeHJxykToxJBRdKaOl2FkmZHlFOJn2B8KtWWKf5r15SW0WEOZcOdiTLMDbe+3s79Gy6vErCNBTzHJeWatwzMOjDwgFsnkXmblfw7MV8Oyk0jo14frW6Lo1d3Q6nDC9CslCgz6/FDucMitIeMwFoQ6m23o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875435; c=relaxed/simple;
	bh=Q0HP6Ro6FJcmOMzDBmr1e+VQR4M2T147Jcf4Hjp40lE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HYA/Ikd+74BwvNmiCWvWLoMsR7CgrzDhPUoFhZd38m5bNqDLtbyuQrg3P1I3GgWkpRvkPEjX+fDTBhggleBLewud8Dw9iXJAz2ELdx1mGjlxM9voaVcLhcWusCfUZ5m/rbx/3AUGJha45JNGv6mUiamEBCYZ0GTpWHyMfH35DXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C70jGpaE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C70jGpaE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99C01C4CEC5;
	Wed,  2 Oct 2024 13:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875435;
	bh=Q0HP6Ro6FJcmOMzDBmr1e+VQR4M2T147Jcf4Hjp40lE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C70jGpaERLHOoLguRObgKCV84x9tj8tLqzmOi8JiMmRouYuCQxgeYXFlNzoA+6hDF
	 J/9JqDA/2uOAkqIm3OazCxWJ3eOtpwR4LvKrHPCIM5gaS5+6jdtn0XP4SHYUTe4twT
	 pz0fGRQ5CDOVkPjantESDmyp5JN6QdsHtVyc14Ks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 101/695] Bluetooth: hci_sync: Ignore errors from HCI_OP_REMOTE_NAME_REQ_CANCEL
Date: Wed,  2 Oct 2024 14:51:39 +0200
Message-ID: <20241002125826.507524939@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit cfbfeee61582e638770a1a10deef866c9adb38f5 ]

This ignores errors from HCI_OP_REMOTE_NAME_REQ_CANCEL since it
shouldn't interfere with the stopping of discovery and in certain
conditions it seems to be failing.

Link: https://github.com/bluez/bluez/issues/575
Fixes: d0b137062b2d ("Bluetooth: hci_sync: Rework init stages")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 5533e6f561b3a..40ccdef168d7d 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -5380,7 +5380,10 @@ int hci_stop_discovery_sync(struct hci_dev *hdev)
 		if (!e)
 			return 0;
 
-		return hci_remote_name_cancel_sync(hdev, &e->data.bdaddr);
+		/* Ignore cancel errors since it should interfere with stopping
+		 * of the discovery.
+		 */
+		hci_remote_name_cancel_sync(hdev, &e->data.bdaddr);
 	}
 
 	return 0;
-- 
2.43.0



