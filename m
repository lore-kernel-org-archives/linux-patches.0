Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B7D359B5E;
	Tue, 23 Jan 2024 00:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970307; cv=none; b=ki1HZ140jA3OIRTBPyFzgh2dVsoX/HrvzOA3GmXs+6g/vS1ljSTNi1WQQ2J4DCFQBUhr3OiRr6ZbvcCVn0Ux5G54xpu6k0EeHx16d1ADCRIpAjYMeeGtuejLIy52Eq1tUI6hhYhZ/iHq/kBTkfVG1GNYWGiEiYKe9TewpaDnH38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970307; c=relaxed/simple;
	bh=e4wIeT6YRzjjGDw4zpAZhQiLMMpTLKAq7pEf2ShSg9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=khMjEJMzYjVN5qqVNrLv5NZiiGmzyvFMEQjcCmyZVvX1MdVm/AymhcbQIkzyDD5VaWXbAzhARIA2rGI82eCFCmsAaTrGjs4Mtl4mA0u9dGgceBoDAMjSpZXTl3CNo+FLlOiPkWYtSfNMR77M3pDbmYjXlp2X8hW14wPydKjoMo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fkzD3lBC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fkzD3lBC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E95FC433F1;
	Tue, 23 Jan 2024 00:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970307;
	bh=e4wIeT6YRzjjGDw4zpAZhQiLMMpTLKAq7pEf2ShSg9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fkzD3lBCFtvdK2BjK2WEGPVH0POE9mtb2e9P0nOBrXo7BgxIgZHW0JA/aiKdlT8Lz
	 c8qUUP5bJWP7AT4H5tFvhkQGq+gKvEoZcEH9TBga2aFCrg88v5AITNlfLf6ZOtnflv
	 5RFrsPjHAw07CiYSev0x8vxomSl3CT73oh9AUPiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 630/641] kdb: Fix a potential buffer overflow in kdb_local()
Date: Mon, 22 Jan 2024 15:58:54 -0800
Message-ID: <20240122235837.983177958@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 4f41d30cd6dc865c3cbc1a852372321eba6d4e4c ]

When appending "[defcmd]" to 'kdb_prompt_str', the size of the string
already in the buffer should be taken into account.

An option could be to switch from strncat() to strlcat() which does the
correct test to avoid such an overflow.

However, this actually looks as dead code, because 'defcmd_in_progress'
can't be true here.
See a more detailed explanation at [1].

[1]: https://lore.kernel.org/all/CAD=FV=WSh7wKN7Yp-3wWiDgX4E3isQ8uh0LCzTmd1v9Cg9j+nQ@mail.gmail.com/

Fixes: 5d5314d6795f ("kdb: core for kgdb back end (1 of 2)")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/debug/kdb/kdb_main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index 6b213c8252d6..d05066cb40b2 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -1348,8 +1348,6 @@ static int kdb_local(kdb_reason_t reason, int error, struct pt_regs *regs,
 		/* PROMPT can only be set if we have MEM_READ permission. */
 		snprintf(kdb_prompt_str, CMD_BUFLEN, kdbgetenv("PROMPT"),
 			 raw_smp_processor_id());
-		if (defcmd_in_progress)
-			strncat(kdb_prompt_str, "[defcmd]", CMD_BUFLEN);
 
 		/*
 		 * Fetch command from keyboard
-- 
2.43.0



