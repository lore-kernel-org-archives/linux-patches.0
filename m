Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC9FC2BCF7F;
	Tue, 25 Aug 2026 13:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787664776; cv=none; b=essKexhiH/KLQFSUiHfAXnD5Dav5RyAqiDicc3tL+PDmYNELt9nPyGNRWM//b81RT2JR3Pc4gvnqbQuT9GBxa6afdvQGTbG6V08EtqqdNs5s8KM2Y94cP53HpLTx40SS5R0zUttUcpzcPYxesHBatLYjLdgnfD/MuL6w0T7tOPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787664776; c=relaxed/simple;
	bh=tAHtpyBbHmXhQdzM7etG4/F6TwuGC088eKO9k1Qmm0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C+HJp94KBch3oj+KWIhW9OotnVHh+Q2Ob0mdnwZRCGJmvDeVbLyLyawkXFhZY3Mnen1FcEU+tPxcRNU2Gh9+TnqS8rU9TF5Jer3iAlBVVZWkAfEAMEYgZJZxjWKKOa+a/bf0NQNzQT7pfQOz+JYms3yV24xF8xzJDMp359YEjeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R42XSgKV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R42XSgKV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C981B1F000E9;
	Tue, 25 Aug 2026 13:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787664775;
	bh=MkQ9YRCyD7WKiGJR/LRY7+hcVh6AHz+Y5EpCIM2RRbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R42XSgKVVZVc6pfzL0mMTHgYJ1enTWXhNxJMgCVN/088WZo4p0G4jlxM3nQBEeFXs
	 1/XDSZwWkI7+NXfWpkh2iiT/+uJoGGdtBKtQdtHeqmJcAVH1CF8cwTn8bb24Yr2NW5
	 1crXMN8D9LoGMNRO7KSXHN5kXzo3KkTCPKs/LeI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	David Heidelberg <david@ixit.cz>
Subject: [PATCH 7.2 45/82] nfc: nci: free destination parameters when closing a connection
Date: Tue, 25 Aug 2026 15:25:32 +0200
Message-ID: <20260825132543.277911463@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.560541185@linuxfoundation.org>
References: <20260825132541.560541185@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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


