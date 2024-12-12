Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37285223C62;
	Thu, 12 Dec 2024 17:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023183; cv=none; b=Z+J3Ck75bqNS2mRv8eurwq7keOrrO2PATsQ4t0AxwrvlobKcnOnmqpz3zViNZ4o6kL5FyLpe7gFW7NPNfH4mKsna0qMn6KAN8APa3zZ4JXxPDHfracLDzsfmmme/IYoAFyMZeaPxBGcc9lSUg6QosgRRmySap2P2FzbfB6YR8A4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023183; c=relaxed/simple;
	bh=pqPNmIN8NJciJ08ByRKcSixNI5NeJ4fbQ7iFh09RAy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WL+DsmLfTk409ycQxKLsckEAhpJMp8V8ZI4OdjunKUMAaDRu+Nbk/mKOYNDD7xb63xkbpmwrB4tANqoGxXTy0HfsMK2zEOyC+2SGnTkeMCqnkH7hyg7xfmEedXXhjqU+O7ig8dqMwncEvz3bjKVR/t13tA09ozl/vuYeiht5ris=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rOYJiBHk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rOYJiBHk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0928C4CECE;
	Thu, 12 Dec 2024 17:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023183;
	bh=pqPNmIN8NJciJ08ByRKcSixNI5NeJ4fbQ7iFh09RAy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rOYJiBHkMWwurejfdzYnYYITIKLq5Dz+6qBNHCNeNeM/HQOWVrZRyWktPltTJzN0X
	 h46gyPzlkdJA0g8EFh/HToDnpGXX9h0y+vvLrnSRfvCFm0hsMEJYGiSJs037Rnqc5F
	 CXNo922q1dIvrqhzYkCi2pLp4E9UsXV/pzu0lCFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 5.15 420/565] igb: Fix potential invalid memory access in igb_init_module()
Date: Thu, 12 Dec 2024 16:00:15 +0100
Message-ID: <20241212144328.266385381@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuan Can <yuancan@huawei.com>

[ Upstream commit 0566f83d206c7a864abcd741fe39d6e0ae5eef29 ]

The pci_register_driver() can fail and when this happened, the dca_notifier
needs to be unregistered, otherwise the dca_notifier can be called when
igb fails to install, resulting to invalid memory access.

Fixes: bbd98fe48a43 ("igb: Fix DCA errors and do not use context index for 82576")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index f3a433b4c7cdb..7712df5b93147 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -667,6 +667,10 @@ static int __init igb_init_module(void)
 	dca_register_notify(&dca_notifier);
 #endif
 	ret = pci_register_driver(&igb_driver);
+#ifdef CONFIG_IGB_DCA
+	if (ret)
+		dca_unregister_notify(&dca_notifier);
+#endif
 	return ret;
 }
 
-- 
2.43.0



