Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14B8182495;
	Wed, 19 Jun 2024 13:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803117; cv=none; b=pqNHca2g2kWW8D9fkJ7tYkzV2nZr3jwG0P15mnnM+tDwOBbxl2TlwrC22TvfpNlQzuvaMegB3QHmrcXNJqFZj+MeAaAieY66azr3FjqsoGVqB4avDy60hfA0UGr1zHqhYmeJOyZYveI2REthywjBo0EfNwJgNPGub1TQpKc2jS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803117; c=relaxed/simple;
	bh=/7IvpwcKgRdOFcc6Cu9C4gc/3mXcbHaBXAo/ECjX1vM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cyDMvWmNID6XkC2lsTd16yg1nofXCNicEUCoaXI36YP+9Pl0EBMk6VpSZ0rCTBvH4jlF0GCz2CWRMsdRadBScna1f4E0mB6oVMCyDBL3G8MH5aXYtzhUMgeOO3KRR91Lcr9/2ZUKL47PhrW/vCup/l6sqMZoM/ZV6mQLWcFdiaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kg+GU3Hh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kg+GU3Hh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86ED7C4AF1D;
	Wed, 19 Jun 2024 13:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803116;
	bh=/7IvpwcKgRdOFcc6Cu9C4gc/3mXcbHaBXAo/ECjX1vM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kg+GU3HhuCqSLysPo7hCAEB46LsxHoMnrF+c5fingRiCgzZpGcaF9rSkSfvSkvDe1
	 7YfiMGnxngYeU2l7Q4wkwYPRT/OokmIwobHKH991ljNaa2pstaferBx1fWtJNlZBN1
	 VAh4gZmWjsnImxp99OobWPzOwUcqYf3YaVGNeiCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 159/281] Bluetooth: hci_sync: Fix not using correct handle
Date: Wed, 19 Jun 2024 14:55:18 +0200
Message-ID: <20240619125615.958516452@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 86fbd9f63a6b42b8f158361334f5a25762aea358 ]

When setting up an advertisement the code shall always attempt to use
the handle set by the instance since it may not be equal to the instance
ID.

Fixes: e77f43d531af ("Bluetooth: hci_core: Fix not handling hdev->le_num_of_adv_sets=1")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 64f794d198cdc..7bfa6b59ba87e 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -1194,7 +1194,7 @@ int hci_setup_ext_adv_instance_sync(struct hci_dev *hdev, u8 instance)
 
 	cp.own_addr_type = own_addr_type;
 	cp.channel_map = hdev->le_adv_channel_map;
-	cp.handle = instance;
+	cp.handle = adv ? adv->handle : instance;
 
 	if (flags & MGMT_ADV_FLAG_SEC_2M) {
 		cp.primary_phy = HCI_ADV_PHY_1M;
-- 
2.43.0



