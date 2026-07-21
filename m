Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B6AD46DFFF;
	Tue, 21 Jul 2026 18:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657166; cv=none; b=hRT/N39Oo2daORL/WBKkaLVq25AK2ktqJdvDujkUWW6ielUvV7th79psZHvdy626gqdwHnGZHHrkcAhr6U4kzvU9BHl4pc4aGg54JLoBFVVihBwe8sZniC/2sbRrIOV5oWLKjRgXwG7tYY5p8NIHdrTES3LY/+ZG+rwaLpM6Ysw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657166; c=relaxed/simple;
	bh=Tf4nRtVKt5eyt3UtdTWPGgFSuwS6AMFNM/5WwunvhTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p+3/rBFevF748TKWUneYTwwifdpB/ePvUbkFvB9rzFbaY36ENiQnUAci2vmi+pmzsEu3QUpZuMl5bipuqr1C4yNyuRQC9WBYI/ZeWWHTYv8Q9kRpNEvbQVoS1C8UGfyNZsVCIyWzFPr2KPwhOkpxuXX9QOopH4pUFkd6RhCfPbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jpzwbmAg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jpzwbmAg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0492A1F00A3A;
	Tue, 21 Jul 2026 18:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657165;
	bh=SWQxpR9TC3P0LxIvJsfojh2sVoXg3GGNAhwpHMyxvF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jpzwbmAgx5vmObKhpPXewxxUcMb2Lzzp+1ReSUNDQXN51MtawfihbAYJGpzM5gi88
	 755SBxg9tj0wehMVI/OTy3d6UBS9q7dfIUi85u87UqbyzM2r+aK3YsUjZcbwa+2CWa
	 ZG8c/WPtL2CBW8fHfsFDCngy4pGRz7tBS7fPMe0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongling Zeng <zenghongling@kylinos.cn>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0663/1611] sunrpc: Fix error handling in rpc_sysfs_xprt_switch_add_xprt_store()
Date: Tue, 21 Jul 2026 17:12:59 +0200
Message-ID: <20260721152530.296756621@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Hongling Zeng <zenghongling@kylinos.cn>

[ Upstream commit 37957478be021b92981aa4c99b69f308d3b784d0 ]

xprt_create_transport() never returns NULL, only valid pointers or
error pointers. Using IS_ERR_OR_NULL() is incorrect, and PTR_ERR(NULL)
would return 0, which indicates EOF in a sysfs store function.

Fix this by using IS_ERR() instead of IS_ERR_OR_NULL().

Fixes: df210d9b0951 ("sunrpc: Add a sysfs file for adding a new xprt")
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sunrpc/sysfs.c b/net/sunrpc/sysfs.c
index 8b01b7ae2690c7..fa9892eec1b448 100644
--- a/net/sunrpc/sysfs.c
+++ b/net/sunrpc/sysfs.c
@@ -347,7 +347,7 @@ static ssize_t rpc_sysfs_xprt_switch_add_xprt_store(struct kobject *kobj,
 	xprt_create_args.reconnect_timeout = xprt->max_reconnect_timeout;
 
 	new = xprt_create_transport(&xprt_create_args);
-	if (IS_ERR_OR_NULL(new)) {
+	if (IS_ERR(new)) {
 		count = PTR_ERR(new);
 		goto out_put_xprt;
 	}
-- 
2.53.0



