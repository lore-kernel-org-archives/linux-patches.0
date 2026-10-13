Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D7AD1DD0EF;
	Tue, 13 Oct 2026 12:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894829; cv=none; b=lBcw4XJaxWl8qxkZqBwaYTKl0A00QccVIB28B/opvTiKaFxOqIx8JsewN00Sjx9EK9GLJJOkDfeqE4VTSvaqvefbji33S33MTm55AzD29D3cU2xMxwfbS7pTng/QOl2j9JajqgmsdO6G5CKKV/eKCXK7O+rYpkGxv4mfHlSZz8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894829; c=relaxed/simple;
	bh=LjbheaKm4mu9sC1R8C6p1x2YvgC6r/LUQJTAYWa0b2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AKl+Ai6IzEp44e64qb3j9v03so4hhYIGFr85KY4IaML3GP2oIFwolzPZ//C5dYIyon3qDSLJTYfjWmsI7AcueOCDFy8SgPvGCbX+UdbrOXvfSl/3pMsumooKWalWpV3zH7iAmq/zWKu0Dbex904CpW5BprVDL50pblR07d63JM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ad1Vg/+8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ad1Vg/+8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5212A1F000FF;
	Tue, 13 Oct 2026 12:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894827;
	bh=DvMwHTTm6x+iv0/c2Pu8bXw2iOM+nO6BNVRGLh3yuaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ad1Vg/+8Nzq3yRg6w858ClY3Va5eHVEaPIfMSA4C7zRj0Xtk96bytRs0alYjKrVaP
	 ta/bw4eMRwiHzbwadQeqwulEZIyEnzQySxCM807v1TFADZ51ngReEngKqTLyYWAbgS
	 y8y4027mtSXsQ7xDms+jfbeYXdaMeGzIukeVzok4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Changyul Lee <lcy8047@gmail.com>,
	Sang-Hoon Choi <csh0052@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 069/497] Bluetooth: hci_core: free the HCI ID if naming fails
Date: Tue, 13 Oct 2026 13:33:56 +0200
Message-ID: <20261013112909.523707706@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a85c77ed4a13e..9f152db1e627d 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -2615,8 +2615,10 @@ int hci_register_dev(struct hci_dev *hdev)
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



