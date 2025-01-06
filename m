Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 712731422DD;
	Mon,  6 Jan 2025 15:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178477; cv=none; b=cp1Db96V2NfvLEq0oIDOp8mDnGeuax7IB+Hc+zwnjuSMTJYFcJHQLCMckEG1k9rY07eytYrYqFIb3JEvqzEoMsawDk5QDwbnMS0n5zpP2ZaPyaxSpYuVRkyivsQuT1WYOIMJ7VsX9EgpdCi8vJ9ZPubsoQtdbdMmLTnHVE0+mak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178477; c=relaxed/simple;
	bh=SlJumpOQNkFYFPdABzaP6uzn/WN6ACTV907UcBeq4JQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MtcYMFWMNB97eILAfv20DF21SEH/9eKZghD9FB5CcblwY50/mya4fce0wVeEhgFyV2FBSeuHN/6w/O3eFSvFV9Im/j7p7xs7gkUALdLdKDCiLeT3+hypjulWwqb+bipazkKOTkV62HdBQrx6zcpG9HtRfLy9ERLaWV2d8UwAa9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZqSkiBts; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZqSkiBts"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDE2AC4CED2;
	Mon,  6 Jan 2025 15:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178477;
	bh=SlJumpOQNkFYFPdABzaP6uzn/WN6ACTV907UcBeq4JQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZqSkiBts7Uly9Gj3ZiIcOAxvEh6X4s99nUZAdHX1FX6urA+1xRbF4wR0U9Z86S6WX
	 66h+x79Ry2Zs9H7EcIv8Tf2oeZUjsZzdrCr5J6KCi/DXDnjlEn7pcVQ2j6nzHzroea
	 BtkW4Ou+bPOQiu/zgLmopVwZz3jHVsg34itnLBRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 132/138] modpost: fix the missed iteration for the max bit in do_input()
Date: Mon,  6 Jan 2025 16:17:36 +0100
Message-ID: <20250106151138.232007033@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit bf36b4bf1b9a7a0015610e2f038ee84ddb085de2 ]

This loop should iterate over the range from 'min' to 'max' inclusively.
The last interation is missed.

Fixes: 1d8f430c15b3 ("[PATCH] Input: add modalias support")
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Tested-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/mod/file2alias.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index 2febe2b8bedb..92b9b9e8bf10 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -719,7 +719,7 @@ static void do_input(char *alias,
 
 	for (i = min / BITS_PER_LONG; i < max / BITS_PER_LONG + 1; i++)
 		arr[i] = TO_NATIVE(arr[i]);
-	for (i = min; i < max; i++)
+	for (i = min; i <= max; i++)
 		if (arr[i / BITS_PER_LONG] & (1ULL << (i%BITS_PER_LONG)))
 			sprintf(alias + strlen(alias), "%X,*", i);
 }
-- 
2.39.5



