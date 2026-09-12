Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A032490BE6;
	Sat, 12 Sep 2026 19:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239992; cv=none; b=t6QE5BV9ZXThgqVxTri+haVUFF25enp8dHaRVwbl64BKuE4Y7Ij38MRfWNJd5xAblsqdYoF4yhrYdiSTVNoHYsovU5b/lxw+DH8OZ1kz/k1hm486peD8L4mr93eMCC6z6cUnwTQOzgajP5u79oSt3DA+lXEVEbGvpVAnsP1XAvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239992; c=relaxed/simple;
	bh=BxQq/oSWL6h/hOsD6G9zU/Bp8Qg/VzDlk7R2PqpIxaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fIOhAF4bn21fKtUtGCYlifXHpdcwnmCRpDBgc0NsIKRg+IvbAYNtUPN6S9M5tM/ghdZFx/zMjfEeuwzrb1VDK4ghga9hjlTkYjLsFD1RQlueLVMdz6X2xcvHWLOa8X/sBW3vlqfX5JF+NOgieYjCrqQ9yc39S9GvUW71eLWavaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c4D43rLR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c4D43rLR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 256F31F000FF;
	Sat, 12 Sep 2026 19:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239990;
	bh=yoaJpJ1ueKlbH60BqQfk1xt8Y0Z5ZsfmTVKwwkLOJ+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c4D43rLRhi2kEuEZGpzLYeznlhFL9RhSwErPvNYjur6m94GHhTH5BRHan637udbKQ
	 hZ/oRAtcKNr4u2JEg5bz5VhStjrn8YAK/NcUg4KjW4mdmB00JFkaVdqyw8QNoCxBv/
	 xjJjOGhuNk4uNiISIAwE3SbxEzQhIMQma+CDsXOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 778/935] nfc: digital: Do not dump a NULL response in command completion
Date: Sat, 12 Sep 2026 09:03:28 +0200
Message-ID: <20260912065544.669651941@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d63d2e5dc60c9..a6cf04cedd50a 100644
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



