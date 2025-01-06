Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A9915854A;
	Mon,  6 Jan 2025 15:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177941; cv=none; b=tlZLkuJwjltLemBixS9pQT/DRD/DvYzwFNgTO4cZLDhIQD0PyTZOEDsY8HR2Ct/Tdf0zfzFHT+iLex3dGxWqFe/6rR0KThI6LTEhGRnjHx7HLLHr6utwUbwQd9v/II8a9Wo1hMyJ+NRZfuPNo/atROiqnmfvddFirMjr+AOSAC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177941; c=relaxed/simple;
	bh=ycRA9YV5I1BKHjZquT2fpZqK3SC/ryrL0NbUGlFhGpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mqfdUu0znmRp/Bo9rv0Ada5LQmq0C8Nuic9encSHmeBI3TAy9gAeKrDolqOnXcX3vOLJlMm0XQJtbeDQ2PLSTsm01a4opQpMj59cs/+8P+oJKVVpBQQp/TuceqDeSBe+cvVWVDYFs+I38Hu/ISNv7dWSiBij7lYHGy2kvsvh2Ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LQXa7xa/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LQXa7xa/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 623E4C4CED2;
	Mon,  6 Jan 2025 15:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177941;
	bh=ycRA9YV5I1BKHjZquT2fpZqK3SC/ryrL0NbUGlFhGpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LQXa7xa/cgdZqHM30Dg2eu5wwnRTbf9E1OHsIhbCSIq+jfseOOwj35jpkKELoBOEQ
	 kJIqQtbYKn0nbEqjQljvCnTGpfVfp0/odSa+S/XflIUP7ocYu+wgmPsoqtzoPez3up
	 XoNjS4epGH2062IAMWvbsyT1B8uQsg0iBzRn0UiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 108/156] modpost: fix the missed iteration for the max bit in do_input()
Date: Mon,  6 Jan 2025 16:16:34 +0100
Message-ID: <20250106151145.795934294@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 634e40748287..721e0e9f17ca 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -742,7 +742,7 @@ static void do_input(char *alias,
 
 	for (i = min / BITS_PER_LONG; i < max / BITS_PER_LONG + 1; i++)
 		arr[i] = TO_NATIVE(arr[i]);
-	for (i = min; i < max; i++)
+	for (i = min; i <= max; i++)
 		if (arr[i / BITS_PER_LONG] & (1ULL << (i%BITS_PER_LONG)))
 			sprintf(alias + strlen(alias), "%X,*", i);
 }
-- 
2.39.5



