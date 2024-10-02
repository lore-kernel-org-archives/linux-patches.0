Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45ADB1D07AB;
	Wed,  2 Oct 2024 14:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879367; cv=none; b=XwOKhmn1fLhLmg94tMGgB4MBEeCci1r2GBXMza8X0+o67cqAL9lNLIJPlo4kNtufDGHp9m1G4XLpFhsyz3nIZ8u23R618ZO/20EdH4qzfccWrhxAEEVXxABeWtd6jNIRMtFlCPTj3jjlOqGylgJXoCkPhx14/wSw7Temck6PKGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879367; c=relaxed/simple;
	bh=j9dW6dNsHWwYIiVCyr6PrrWcUEi3skswc8bfQ8ytexM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PUv/BBg2NxRektaBcC15lbF8SqmfhM/oQ+c+y+xYFbaER1I7JR5lrQQzvd82g/hup5De1tn4A5x1Medhln6kllsBnMktIO/0LXNmVfRjg7g5r0tbmmYxS2fgT50iOhk7hy0nicF2Q2AgoX7/kppN5IwKDWtqB9RAfBVgLIkqnd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v2bsMXAV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v2bsMXAV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6DF1C4CEC2;
	Wed,  2 Oct 2024 14:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879367;
	bh=j9dW6dNsHWwYIiVCyr6PrrWcUEi3skswc8bfQ8ytexM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v2bsMXAVIF7H+VBHuiwNcyP/ydC5fSQEQWthZ7xqEFKcv3oxmUDi7PlymluuiD/Bz
	 Owk+DURaSkpsHoJ7FFF0dwp/rqgWRJkY8KYkj6aoIxfKNVF6DdNCEQ8hkBy4RKuds0
	 wAN1fg+aIlFhtSpKt51L2UT5bZR6xN/V2MObGNic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 063/538] Bluetooth: hci_sync: Ignore errors from HCI_OP_REMOTE_NAME_REQ_CANCEL
Date: Wed,  2 Oct 2024 14:55:02 +0200
Message-ID: <20241002125754.697118688@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index af7817a7c585b..75515a1d2923a 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -5391,7 +5391,10 @@ int hci_stop_discovery_sync(struct hci_dev *hdev)
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



