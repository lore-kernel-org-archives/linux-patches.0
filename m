Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53CF3377A93;
	Fri,  7 Aug 2026 15:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115009; cv=none; b=Df2tGN/yENicI3tfwlRfJZ37bvLrX5/joRB3VFpWhORy75LBb5jrQ4UWnS5cGyyWR9gqiiSSUMgwYoBx/0GY8JpVZ+be3cONznymznI0DTE6TrJRIzCP4U2RwQCYIZJ9zHo8PGqEYve45MvsC+nGS2/AFML2yXSk7Drs3yCXyXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115009; c=relaxed/simple;
	bh=2kTJiPY7RyRLC0nCyWbNiUhyXq/O23O1lRfbu989pKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m/O0Ig82FaOCdT6ULNZG6rcikLqTuWa8rkOBu55P/IF9I3WphSdBFM2Cgxtou+29Dhh0gcz3jA2VI6KXGe6zuXTYphUe8d01PWiDr7L8LJGM8VClAXbchCKdcWnxEgd3DY5PzlPWb9qZ/xhMQ2D/9Juz/c5+3GgaG+Hih8HKMQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IMIy9WH/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IMIy9WH/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A79D01F000E9;
	Fri,  7 Aug 2026 15:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115008;
	bh=PvZf5PmoA5DehGhA5xj7zzCNCZ252EGt+ExS/TtENyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IMIy9WH/Fa0Nu5yY2wzlnYqK4uutv/zm9rFLHYdv98b26SYoupQI1ZgLEFalAkb6u
	 43aumah5WajfeWQHIdNrATVAW5HjaDtU4zXPHyaSrGU0CtaUFJoxh3Bquxk/bc7tE0
	 nguSWV+W73iWz9FgVNics6op6Ih4w7anMrpBjeP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 124/396] Bluetooth: hci_sync: fix hci_conn_del() use in hci_le_create_conn_sync
Date: Fri,  7 Aug 2026 16:34:44 +0200
Message-ID: <20260807143426.984206308@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit 2c1e4e00613dfd105f978be2276e5e265801ec9f ]

hci_conn_del() caller must hold hdev->lock, check the conn was not
concurrently deleted, and usually inform socket the conn is going to be
deleted.

Use hci_abort_conn_sync() instead of calling hci_conn_del() without
locks etc.

Fixes: 8e8b92ee60de5 ("Bluetooth: hci_sync: Add hci_le_create_conn_sync")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index ca002269306c4..27c5cc1457e65 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -6620,7 +6620,9 @@ static int hci_le_create_conn_sync(struct hci_dev *hdev, void *data)
 		if (hci_dev_test_flag(hdev, HCI_LE_SCAN) &&
 		    hdev->le_scan_type == LE_SCAN_ACTIVE &&
 		    !hci_dev_test_flag(hdev, HCI_LE_SIMULTANEOUS_ROLES)) {
-			hci_conn_del(conn);
+			conn->state = BT_OPEN;
+			hci_abort_conn_sync(hdev, conn,
+					    HCI_ERROR_REJ_LIMITED_RESOURCES);
 			hci_conn_put(conn);
 			return -EBUSY;
 		}
-- 
2.53.0



