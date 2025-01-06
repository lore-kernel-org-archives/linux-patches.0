Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E776D16A930;
	Mon,  6 Jan 2025 16:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736179319; cv=none; b=VSWg4If8ayLQoAljCEhemhreIzc1enllKMNws3EkzVRNTsaiFHUkK0MyXyBKnOZZFTXHF5AMX+Vs7yckV2mR/SRiU3RkqTmFL9DKfb3AS1wLDdo6tQOrNuxwDOaPB80qEISP4tiUk6IT+MXybv2WHnFGQuhAr64FNO960HOqUrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736179319; c=relaxed/simple;
	bh=pULG4zdaBudeF6FRWUxl/SMPWJDr6shTuq3X1N4hhHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SsyOVHlxIj8jrSu/70VHhmcZLIJc7nnHc6RcummqON7E+yS1LAml0HX6GFPTrL+yEIz+vO1ZzWwOxmvQ5clbmUQ2fD/LIryvnlDxXDE90FDulDbqPk8XgimHD0rl9XfZkhfvrVM7tK0y5PVgXAJCmpye8TqpqtwreVhQoEThM7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bLJKzzif; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bLJKzzif"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46F7AC4CED2;
	Mon,  6 Jan 2025 16:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736179318;
	bh=pULG4zdaBudeF6FRWUxl/SMPWJDr6shTuq3X1N4hhHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bLJKzzifnMkVpD16nuhYFN/ac/HAlbL4+dWpZ8BjS/wjbyydpsdQTozfjb1gAYXqC
	 2ikcnFOIZUYbcOXnGeokvNMYUuBoOx4jO9tjTdhtrTFe6BHrZnAp4nuXmou8EM5iB1
	 ILHWu46ENDAaZq8E4AZELlcBE4Wk8sGw/4FUA8eg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 87/93] modpost: fix the missed iteration for the max bit in do_input()
Date: Mon,  6 Jan 2025 16:18:03 +0100
Message-ID: <20250106151131.987138693@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151128.686130933@linuxfoundation.org>
References: <20250106151128.686130933@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 91a1673ceace..70f38e98d5fa 100644
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



