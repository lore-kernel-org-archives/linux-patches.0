Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA63C4D37A2;
	Fri,  9 Oct 2026 14:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555604; cv=none; b=GGai4DqZAzPHez/Ea4HvM79ymCwG5ldiVcB7J3jdLx2Fy625ekCTzA5HWnghM/hZPHkbOe+HdeB3Wyt5kIhoc14/YurvCMiIsu34982h7fY9Vh6893MilO82+bbCih009BEs383rpA2WMJgDx727uAypu+Av76O08CvoTysJD9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555604; c=relaxed/simple;
	bh=QRdLmLUE6SbXTBTVcMYOvbzRkJTlMzR9j6Wn3arwh70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NwSFSN4e2LkGGzDPDFDh2+K1zWgo1nseStrBkttxJZQk+mNyPw5K+5u39hHDN6h2q5t8gEndbxP/ZVfEyy+kuz7gEAP5mlaiHE2XBcpSP4cU6AAd2VSv+KGKSTmHKh7N3AatzFjDFQqRyyjD9S74kWCEpVjthaQokfwQfGkc0VY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZVYzwdLg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZVYzwdLg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3DDF1F000FF;
	Fri,  9 Oct 2026 14:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555597;
	bh=BokL+FyOsY7dwQTf9ff3fLKvDAsyJLsr5spF7YTjXNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZVYzwdLgwSOm/5yjbvmyMQJOC+rjBmHOdM42BZHowlcMuNF4Tif/jBKevehpoH4RT
	 8xJEdvlrmKYpDjqMKmljCqu/2ekNwUgIrRTgKIv5z/hnaNerjlfErBZMKeaa5b6Wja
	 UE/YrgD30Ep+Q3PMgn6RWDIjNyaC9K2WCLPIHpuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Changyul Lee <lcy8047@gmail.com>,
	Sang-Hoon Choi <csh0052@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 085/403] Bluetooth: hci_core: free the HCI ID if naming fails
Date: Fri,  9 Oct 2026 16:07:26 +0200
Message-ID: <20261009140954.080797608@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index c0a8bd7af781e..0cb2384e385fb 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -2593,8 +2593,10 @@ int hci_register_dev(struct hci_dev *hdev)
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



