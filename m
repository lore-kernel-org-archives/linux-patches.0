Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03934481247;
	Tue, 25 Aug 2026 13:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666099; cv=none; b=AICCf4PEV/eina3XQ2uP/WncxfAYSf2m8bThFO2M1R5uJ/BIuZ9cCAl60rH18/N8RAD8bvV1IKKZxePXhjSy7cJ18EboE0mPrmvbqDNwSADmuVx07jxIPG5tFSvVLKGbcadzD32QdP8O8vprb7ksMZR7AiO0iJFZs87FS/vOiR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666099; c=relaxed/simple;
	bh=ktEI4kKyQAK/TuHGRXBv3cPENh5NSxXkdYFzp2KlBuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dMcV59jdUiZZ3Vo0ilnpon3XPnRG2OApjVlq9rkoSfwhlCV+8NG8hEGJ93Rp+PlSdNK9PmGFmUUfjdPwQx4F9ViArmg7kMWEF/0JTArcIjCgBoJudgRFjBpkslC7sVmSKPsPUXTz5btRrd3Xk5ju19QSPaz6LF7w073Mj4rVy3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I3Xeg0bl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I3Xeg0bl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53B4C1F00A3A;
	Tue, 25 Aug 2026 13:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787666097;
	bh=BfIsVFR5UGl8f3i/nP2FvCpNltnHVC5cw20MtuMTE8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I3Xeg0blJkzoSHYf1HHtVzGV2MGEqGYatDIxWdDtWtxhqJCcCX9WNCBBt+kv8H4Fv
	 83FK/yHQMQ91sAspjyplzyUiZFi/XYO2EIerdO1ofdkzpcvmn8QogL9O7jPg76tWWs
	 L8CMeEMIYJ/iSCTBUG0GnrE61WI7nvM8YD+EzJzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	David Heidelberg <david@ixit.cz>
Subject: [PATCH 6.1 52/79] nfc: nci: free destination parameters when closing a connection
Date: Tue, 25 Aug 2026 15:26:32 +0200
Message-ID: <20260825132543.741952136@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.677185791@linuxfoundation.org>
References: <20260825132541.677185791@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


