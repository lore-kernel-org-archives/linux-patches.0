Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 010BB386C3B;
	Tue, 25 Aug 2026 13:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787664998; cv=none; b=e18jaUUlJ0Dh2k+v3lcmKbvKowVJ2aaC2O+TElqf4KcxLN9NnLRmUbbsN45jzC8aZD2PQy/udhoGrMUHJIa8TmiEkElMEz43lOINm7649g7ITYKlyXMeMoOiiF7Q79rTFZDo1qCeoRTiBu7O/8WJY8UYvSc+UxSJrJlpXzcKVpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787664998; c=relaxed/simple;
	bh=ZqxQn9KNjPvVYOHVkIlUCp801UIPVgHZAzNIJuTVP8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=na/J+NGlX05hmBY9u7IZFW3a5npDq7dIuILCB46e5xJZBhmkBjL08hQ5ib1hD9dwcntpQtvsGPCNUDe5XOprF8xhKQTSv/Cl1yjjqk6V01VAY4FaXpkA7jtEjbCStXojzZX4ON08Ma5a36NToJi9EFUPVgCMVy+fcbCiW+5eDNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O+tFNpo4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O+tFNpo4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26D551F000E9;
	Tue, 25 Aug 2026 13:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787664996;
	bh=rceidgqNmIytgZ1k1GWuBdfuavcd3AsOir8bMSq7Lok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O+tFNpo4Kq2IL5c0hV0WxMhwSm8cWLSFG6XSDbFyXRPgURd6sI7jdgXoU5um+x8JV
	 2e1tVNauwhMw4LNg/eSm7TwTvU4TgPct097Qn38M6uDkXs0iUKErWW3YH7abspVEcO
	 cbMo6AnEC8GI29YDJ/x4NgWH1ZgCtAJRMCCEwC9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	David Heidelberg <david@ixit.cz>
Subject: [PATCH 7.1 048/101] nfc: nci: free destination parameters when closing a connection
Date: Tue, 25 Aug 2026 15:25:26 +0200
Message-ID: <20260825132543.897517360@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.986300899@linuxfoundation.org>
References: <20260825132541.986300899@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linmao Li <lilinmao@kylinos.cn>

commit 2e65bafdfd3a8bba972b3d17b6a57816557530fc upstream.

When a connection is closed, nci_core_conn_close_rsp_packet() frees
conn_info but not conn_info->dest_params, which is a separate devm
allocation. Each connect/close cycle leaks one dest_params until the
NFC device is removed. Free dest_params along with conn_info.

Fixes: 9b8d1a4cf2aa ("nfc: nci: Add an additional parameter to identify a connection id")
Cc: stable@vger.kernel.org
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Link: https://patch.msgid.link/20260721023518.1697625-1-lilinmao@kylinos.cn
Signed-off-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/nfc/nci/rsp.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/nfc/nci/rsp.c
+++ b/net/nfc/nci/rsp.c
@@ -336,6 +336,7 @@ static void nci_core_conn_close_rsp_pack
 			list_del(&conn_info->list);
 			if (conn_info == ndev->rf_conn_info)
 				ndev->rf_conn_info = NULL;
+			devm_kfree(&ndev->nfc_dev->dev, conn_info->dest_params);
 			devm_kfree(&ndev->nfc_dev->dev, conn_info);
 		}
 	}


