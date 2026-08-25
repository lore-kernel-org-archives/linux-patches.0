Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DFA22D7DEA;
	Tue, 25 Aug 2026 14:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666424; cv=none; b=cXJKBTEk8CoQw4fWmkQL5HGFK5abqpN1UUDcJnavrJzkowV675G058CplE7orWRtZeAszaONqKgict5Pbwb5WequdUI/JbcjB/hR51ekas3KDCDkdCrBS7QOdxwJ9UG8zsL7SMBdAUpjc7n7abWnke+J+YpwV37MmRsZX+ejGiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666424; c=relaxed/simple;
	bh=ywu70b0bgVojsGrdQg9a5gzntHSw6g02nrKboQsha5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lBvtfecppDeNQPir3q2R0KEyvKV9XfUqADw1lvcK1uDnIBC2aOaGXskAqjoqtRHioDlRIjWLuBBVEoaPeja8RcB6R684pnjE5dDonKEWXhd9ADtftwZh941J3oo/z+B8Kr6VtYJxNtGeSkvbetHPYYBFoYiEcmF3bYdYIOWhgzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PO5aM/nQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PO5aM/nQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1B421F000E9;
	Tue, 25 Aug 2026 14:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787666423;
	bh=PnR65ZiBb8lJHjJodWmemM3Zkd8BwArIjYlL5TtyhL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PO5aM/nQWl3r+oT2RtIr9IFVBuoHp+uYSnMZ8JnEyMkYNu0S2HJjI9A7ICmla4DmH
	 Q+NXfzPgGYNdPc/qozVKFKkYRrNn952/lQI5K3027i+riSzDlxaFe109y/dtZ1uKJz
	 P3880rD2NuYhYYjrBesFraZXkteKgLtGonlwtxV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	David Heidelberg <david@ixit.cz>
Subject: [PATCH 5.10 38/57] nfc: nci: free destination parameters when closing a connection
Date: Tue, 25 Aug 2026 15:27:00 +0200
Message-ID: <20260825132542.816797381@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.342390421@linuxfoundation.org>
References: <20260825132541.342390421@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -279,6 +279,7 @@ static void nci_core_conn_close_rsp_pack
 			list_del(&conn_info->list);
 			if (conn_info == ndev->rf_conn_info)
 				ndev->rf_conn_info = NULL;
+			devm_kfree(&ndev->nfc_dev->dev, conn_info->dest_params);
 			devm_kfree(&ndev->nfc_dev->dev, conn_info);
 		}
 	}


