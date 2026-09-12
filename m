Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31BC337189C;
	Sat, 12 Sep 2026 08:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203193; cv=none; b=PtTPNdYC6fYMgOPtQxW6bsg0/1++4bsChfzgTqTlZzMO9p1ra0gPYFMbPVU/gybDHhDBywlnHxBvorudW8Rv3DdCDjzNDYW5X1C8IoCLMox/pMEOCJFwCjwCUf16TmVouLtymhKAvTUpw36PD73jk/nUK8en0Yd3YArPwJaZuFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203193; c=relaxed/simple;
	bh=rk+6c6G+N/lTHBcR2JqBdR82U5y34ktQyH2aqE/uj8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l5yU0PG5FVOJmvhFZjaxdupkAtXAIM6pGRO3ljUxAVlWPXJNu1Tz3ALzAx7xW+LAQ2luPr13OrkGdPkWjvYIWL0qE31F/+O7+v4IifnplLGQTg5eQEHwOrjFSUtvOhERHfHYBMOGMIBxsvmWVni/34Zq9l1ujNlUR0EtEyOiRvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gDtuiKrw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gDtuiKrw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF8C91F000FF;
	Sat, 12 Sep 2026 08:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203191;
	bh=GFWNnDRcGk1rJyl2+VTDQWhd0a8dHdzvJbag2ziQxcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gDtuiKrwzqpku8doS9euw8x2/mcs0b2losm1Vw+dEBTr02yp8qNYcc5S1mcfWMJgJ
	 m5lzfa9R9SD/jrd2UjY+IDD7zMQNTFXYGC5y/9po70dN7QhfdY+E+f9BZ8EuP2I2n8
	 scTXGily6lXhLEU8EP9VSfBVhmK+//l2T3+n/Gjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1357/1815] nfc: digital: Do not dump a NULL response in command completion
Date: Sat, 12 Sep 2026 08:51:47 +0200
Message-ID: <20260912065720.883719506@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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
index 7cb1e6aaae90d..18236221d8988 100644
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



