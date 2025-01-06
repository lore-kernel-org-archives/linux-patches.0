Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54756145A03;
	Mon,  6 Jan 2025 15:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178995; cv=none; b=oozhabImJ56bSyxpELnSdMlcWzqh6pZRPIE/SS7wYYH3kfCGfQQOR7msDPmV82Wsa1IqSgk6weplcfSdzENeQAG2FdIIckYEIcvMD61j42lhgZcQsSFxooTwmuTloESmmT7BaSyVs1l1Oz+H4yiSPF59GNJjfwGuJoeq7br9qs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178995; c=relaxed/simple;
	bh=1ahbI2yI8SyAufJfBl1Rd0ymQ3Qo6pLvO9+mfOYIclo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=brsBQHuQd/arRz5wcDgB7gAnJd5vW+MKn/qYsb1B8T4CrozZirXe2R37gpQBAvZmLOqnus9tuzluMYbNE8KT62ApBKFxKdmmtpuJv9hgxvAoySwruIzTTT9FbLfebsBtuHxq9KaTZjJwuJuhR8JEJXkW9YhQFu017Anh5FYimuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iNpqWJaH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iNpqWJaH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1D7CC4CED2;
	Mon,  6 Jan 2025 15:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178995;
	bh=1ahbI2yI8SyAufJfBl1Rd0ymQ3Qo6pLvO9+mfOYIclo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iNpqWJaHGpY7xgNGlrBwlB6aK5yMCMAft4MIjiu7alxkpUn+RDtUMDFfP/spZ8LfS
	 unU9M+kIIlBt5yVeQOgLvObxMeqF9dstJLlvz53iKhiSvirpdmULcy5jz9MnspoiaG
	 NqdLONmCD2aZPSdDtmlhr+9V3yjSAjseNWm3Ideo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 160/168] modpost: fix the missed iteration for the max bit in do_input()
Date: Mon,  6 Jan 2025 16:17:48 +0100
Message-ID: <20250106151144.473264386@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 68a6b029397a..e6ab1eb5666d 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -732,7 +732,7 @@ static void do_input(char *alias,
 
 	for (i = min / BITS_PER_LONG; i < max / BITS_PER_LONG + 1; i++)
 		arr[i] = TO_NATIVE(arr[i]);
-	for (i = min; i < max; i++)
+	for (i = min; i <= max; i++)
 		if (arr[i / BITS_PER_LONG] & (1ULL << (i%BITS_PER_LONG)))
 			sprintf(alias + strlen(alias), "%X,*", i);
 }
-- 
2.39.5



