Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D991487CD;
	Thu, 12 Dec 2024 15:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016969; cv=none; b=sUxDs1qMfgSu4E/MgCYnRebx9thsXDfMLfY4nV0bf3+VL2ioc9kwxXX6F/KelagTMWh7I1tLBvcVinu6UO4k2gxOAo3rrLY3SPt5T/HNnY3tLGX8eRKMcscfKd7cV3tJkxMuVUZAhn8Hp9YYsI75+QX5NsyL6Sk0zWoWoENbCw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016969; c=relaxed/simple;
	bh=2FmDGy49VXvAAE7XJzqTawbNIUus5mhAjyP/gLJtIOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I6OX7HKr73KjYpNPZ1176XJpUNCuOq8RkdBOcRS5iH0ZolhTQPwvTnzY4xxjakcDsi2pGFjqKIBkaMczrpDjiaixzh3CN3T7/aYu3O40KC7F748V2mDr8y2F/tCFivpYBIxTilf6vUrMoD1QIuA+gAvCF3DFoNuoQq6akNA7n8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UrzYnvCv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UrzYnvCv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 111F3C4CED0;
	Thu, 12 Dec 2024 15:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016969;
	bh=2FmDGy49VXvAAE7XJzqTawbNIUus5mhAjyP/gLJtIOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UrzYnvCvt+5fOhA08wfKLBM6+4h2ALYmHZNOQ1oEX42avtNoL6dFnxmZnzOF1Yrl9
	 28CwjriBN1wbzxxPg5FaRYguVJOIFSQPrgmlUya77rSZyhR8hfSdhZJE3fRSmtGjdH
	 PEoQ63C73bF8i8qr/6m+S4f1eWL/EIRMESdzzcwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danil Pylaev <danstiv404@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 344/466] Bluetooth: Add new quirks for ATS2851
Date: Thu, 12 Dec 2024 15:58:33 +0100
Message-ID: <20241212144320.382285533@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danil Pylaev <danstiv404@gmail.com>

[ Upstream commit 94464a7b71634037b13d54021e0dfd0fb0d8c1f0 ]

This adds quirks for broken extended create connection,
and write auth payload timeout.

Signed-off-by: Danil Pylaev <danstiv404@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci.h      | 14 ++++++++++++++
 include/net/bluetooth/hci_core.h | 10 ++++++----
 2 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index a1864cff616ae..5bb4eaa52e14c 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -301,6 +301,20 @@ enum {
 	 */
 	HCI_QUIRK_BROKEN_SET_RPA_TIMEOUT,
 
+	/*
+	 * When this quirk is set, the HCI_OP_LE_EXT_CREATE_CONN command is
+	 * disabled. This is required for the Actions Semiconductor ATS2851
+	 * based controllers, which erroneously claims to support it.
+	 */
+	HCI_QUIRK_BROKEN_EXT_CREATE_CONN,
+
+	/*
+	 * When this quirk is set, the command WRITE_AUTH_PAYLOAD_TIMEOUT is
+	 * skipped. This is required for the Actions Semiconductor ATS2851
+	 * based controllers, due to a race condition in pairing process.
+	 */
+	HCI_QUIRK_BROKEN_WRITE_AUTH_PAYLOAD_TIMEOUT,
+
 	/* When this quirk is set, MSFT extension monitor tracking by
 	 * address filter is supported. Since tracking quantity of each
 	 * pattern is limited, this feature supports tracking multiple
diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 4c185a08c3a3a..c95f7e6ba2551 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1934,8 +1934,8 @@ void hci_conn_del_sysfs(struct hci_conn *conn);
 			   !test_bit(HCI_QUIRK_BROKEN_EXT_SCAN, &(dev)->quirks))
 
 /* Use ext create connection if command is supported */
-#define use_ext_conn(dev) ((dev)->commands[37] & 0x80)
-
+#define use_ext_conn(dev) (((dev)->commands[37] & 0x80) && \
+	!test_bit(HCI_QUIRK_BROKEN_EXT_CREATE_CONN, &(dev)->quirks))
 /* Extended advertising support */
 #define ext_adv_capable(dev) (((dev)->le_features[1] & HCI_LE_EXT_ADV))
 
@@ -1948,8 +1948,10 @@ void hci_conn_del_sysfs(struct hci_conn *conn);
  * C24: Mandatory if the LE Controller supports Connection State and either
  * LE Feature (LL Privacy) or LE Feature (Extended Advertising) is supported
  */
-#define use_enhanced_conn_complete(dev) (ll_privacy_capable(dev) || \
-					 ext_adv_capable(dev))
+#define use_enhanced_conn_complete(dev) ((ll_privacy_capable(dev) || \
+					 ext_adv_capable(dev)) && \
+					 !test_bit(HCI_QUIRK_BROKEN_EXT_CREATE_CONN, \
+						 &(dev)->quirks))
 
 /* Periodic advertising support */
 #define per_adv_capable(dev) (((dev)->le_features[1] & HCI_LE_PERIODIC_ADV))
-- 
2.43.0



