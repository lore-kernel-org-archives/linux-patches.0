Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 849503A0B36;
	Sat, 12 Sep 2026 11:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210947; cv=none; b=VCdIz8PWg2JBKnJO+0mtzI6XaD8ffTvSY40352YX5nGHszAR1/bU/ddtwd4S3k1DgBNn3f7xA+n4Rd9e5NVF7AyNlnAUQwu/9+pJoZXJkG9RC3qqMrnpRE7fzYav9hQE1Di+aZn1b/Ew5Ir1gwUotp+yDbnpjCPuy2f8BVy2nto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210947; c=relaxed/simple;
	bh=5EiGxPch6EbOWe7epg7pQeo5fXd6ouXuN2NSA/9Q++g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BU6jEy7ZcVkwtFUiHuK0iy2NmyoK9sYpPvxtZzw3aCImamkYar0CFbSPs/51V+Ni80Pm/hrtqLEjx37RJLpem5/iNzJBr1qie74QL8XwShTfLiWpCbVanR9mVhl/zfLoKtYXB3L/HuyfAOXhZDKtCtIMSPmKrM1B9ioFvyoIobk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=STsC1qzw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="STsC1qzw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ACE51F000FF;
	Sat, 12 Sep 2026 11:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210946;
	bh=D82HUeq+Wn5CfJW8hC+Sh2PCSDX54WMOX4RGtnqlYDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=STsC1qzwFmd440Ht7v8BLvLRBOZNlN5WNk2SheT8aNgqfZBAv4ouR5UDrIO9+1M5z
	 AHaB3DzGYEBgSPtTLYhT7I3eDn2zdzT6U/Ve+1HAJujD999k+woBkF7KE/auj5Fo8y
	 hLx+yyMd5RAGMhfJzppq+z6Ms3vpQsbbERrTneCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1130/1518] nfc: digital: Do not dump a NULL response in command completion
Date: Sat, 12 Sep 2026 08:54:59 +0200
Message-ID: <20260912065649.017280591@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Linmao Li <lilinmao@kylinos.cn>

[ Upstream commit 1c7dd70c0adfa58fd66b5cbd03efb747ad6d8d8d ]

digital_wq_cmd_complete() dumps the response data whenever cmd->resp is
not an error pointer.  However, a driver can legitimately complete a
command with no response skb at all.

digital_tg_send_psl_res() is the only caller that passes timeout=0,
meaning no response is expected once the command has been transmitted.
On that path trf7970a completes the command with

	trf->rx_skb = ERR_PTR(0);

which evaluates to NULL.  IS_ERR(NULL) is false, so the NULL response
passes the !IS_ERR() check and cmd->resp->data and cmd->resp->len are
dereferenced whenever the debug print site is enabled.  The driver
guards its own dump with "trf->rx_skb && !IS_ERR(trf->rx_skb)"; the
digital layer is missing the NULL half of that test.

Use IS_ERR_OR_NULL() so that NULL responses are skipped as well.  The
callback on that path, digital_tg_send_psl_res_complete(), never
dereferences resp and dev_kfree_skb() accepts NULL, so only the debug
dump needs fixing.

Fixes: 59ee2361c924 ("NFC Digital: Implement driver commands mechanism")
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Link: https://patch.msgid.link/20260710061254.80975-1-lilinmao@kylinos.cn
Signed-off-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/nfc/digital_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/nfc/digital_core.c b/net/nfc/digital_core.c
index dae378f1d52b6..b180212532243 100644
--- a/net/nfc/digital_core.c
+++ b/net/nfc/digital_core.c
@@ -127,7 +127,7 @@ static void digital_wq_cmd_complete(struct work_struct *work)
 
 	mutex_unlock(&ddev->cmd_lock);
 
-	if (!IS_ERR(cmd->resp))
+	if (!IS_ERR_OR_NULL(cmd->resp))
 		print_hex_dump_debug("DIGITAL RX: ", DUMP_PREFIX_NONE, 16, 1,
 				     cmd->resp->data, cmd->resp->len, false);
 
-- 
2.53.0



