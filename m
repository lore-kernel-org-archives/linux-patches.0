Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05969A32;
	Tue, 22 Jul 2025 14:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192980; cv=none; b=tZUc5tYx+6xH1ykbYMMANAglRX820Ju6s02LIFUdMkHpu1m8pA+UDbfzYkrig/letLmS2Z9QIU3oObq6hKJohHrepm5xq0M/jaqW12sLq6MClhAT48tR14YNkY/PmozCK3znLVGgQcx/hFXxzuKaVM0CugL2oGxUmJTgg47Z740=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192980; c=relaxed/simple;
	bh=7yGs3NgQkhhIJ2tuHGZsmWFR3VAhSM3srEQF9IGIcUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P5UyFYcy8TdXYg/3mwayv5wZOf/kSjii0leX38YA8EC9CHnjMSB5LFDWnu0Xpz5xx88e6s7OPXvFmYKP3KIuCTMoaGddGqJoTDjYQzj1mh25/mRuxLqoamR4Ay5HQ5K0QkihYDuQl4p4IiL7oB3E0+Le4nv4MnvHDMR598FvnD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fcbfluSc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fcbfluSc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FB9CC4CEEB;
	Tue, 22 Jul 2025 14:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192979;
	bh=7yGs3NgQkhhIJ2tuHGZsmWFR3VAhSM3srEQF9IGIcUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fcbfluScd3QWjRF4nJdXbhYtcKHpfRBw+3VGvWoUCEHMR24eB8sl1uzTssH7vqLLX
	 O6lnVHNSfanVqwbLUoG3M8a4Duxl+iDRq5MOr2HK5XySZorNrw89iWfwTeNRCjh/gr
	 v3r9Uwg9jJSuIR9QncOF6oIZ5OtuGH8t6qWPgUE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 116/158] Bluetooth: SMP: Fix using HCI_ERROR_REMOTE_USER_TERM on timeout
Date: Tue, 22 Jul 2025 15:45:00 +0200
Message-ID: <20250722134345.076391123@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 6ef99c917688a8510259e565bd1b168b7146295a ]

This replaces the usage of HCI_ERROR_REMOTE_USER_TERM, which as the name
suggest is to indicate a regular disconnection initiated by an user,
with HCI_ERROR_AUTH_FAILURE to indicate the session has timeout thus any
pairing shall be considered as failed.

Fixes: 1e91c29eb60c ("Bluetooth: Use hci_disconnect for immediate disconnection from SMP")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/smp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
index 879cfc7ae4f24..a31971fe2fd7e 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -1379,7 +1379,7 @@ static void smp_timeout(struct work_struct *work)
 
 	bt_dev_dbg(conn->hcon->hdev, "conn %p", conn);
 
-	hci_disconnect(conn->hcon, HCI_ERROR_REMOTE_USER_TERM);
+	hci_disconnect(conn->hcon, HCI_ERROR_AUTH_FAILURE);
 }
 
 static struct smp_chan *smp_chan_create(struct l2cap_conn *conn)
-- 
2.39.5



