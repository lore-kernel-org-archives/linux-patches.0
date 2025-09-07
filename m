Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 358C51B424F;
	Sun,  7 Sep 2025 20:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757275943; cv=none; b=WNAMps57oHYHP1YE9o832tpy+ySC90T7r3G4kc5PuGCIhSXHy3/qpyy4eFkxRoczTWAPFIfunm69TCzm2n5X6EVeTRdAayFUBr760C7jJA9lIXRzCOwAcweAUEZLS/2IOAGrCNRSGsKRpZH7ak0IFITL0rN+63ZJBHF6XR50FSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757275943; c=relaxed/simple;
	bh=vUV3mnv1XWvqToZsZBLVLHAVJ/Tz+TfcBna68vVxRo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iRlqe36viJAgOqNaxhJUGebAAn4/F7an7NEEYUYjnXWDWJzm19fXKsPWW1JghDWzZDym+vrTgvDCcJiCrQU9aFfPY5gvNWWOOJY80t7UCrKD1BW6IxKBuyGqOB0lpz2qI5PtuOFRPrDXeJfiEseWBrlpI6rw/D5v1qRq7sGl17Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1GaO2acy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1GaO2acy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD508C4CEF0;
	Sun,  7 Sep 2025 20:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757275943;
	bh=vUV3mnv1XWvqToZsZBLVLHAVJ/Tz+TfcBna68vVxRo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1GaO2acyhLWvhAwyZiPc9fDvTVB0JVxP7IJ0bNuR1eKh8k7nbZyGYhHM/ON9+8als
	 kGgkEz6ur3M6Q/mdB3cPKEItENtWi1xNywQ4NnwjrEUeZJgBq+aPws5zuN3IRqohlN
	 yu/uojrkhR0GxPtJyL9ggrR7dHaTAc7s0xOv4BgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 14/64] mISDN: Fix memory leak in dsp_hwec_enable()
Date: Sun,  7 Sep 2025 21:57:56 +0200
Message-ID: <20250907195603.798177392@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195603.394640159@linuxfoundation.org>
References: <20250907195603.394640159@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 0704a3da7ce50f972e898bbda88d2692a22922d9 ]

dsp_hwec_enable() allocates dup pointer by kstrdup(arg),
but then it updates dup variable by strsep(&dup, ",").
As a result when it calls kfree(dup), the dup variable may be
a modified pointer that no longer points to the original allocated
memory, causing a memory leak.

The issue is the same pattern as fixed in commit c6a502c22999
("mISDN: Fix memory leak in dsp_pipeline_build()").

Fixes: 9a4381618262 ("mISDN: Remove VLAs")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250828081457.36061-1-linmq006@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/isdn/mISDN/dsp_hwec.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/isdn/mISDN/dsp_hwec.c b/drivers/isdn/mISDN/dsp_hwec.c
index 0b3f29195330a..0cd216e28f009 100644
--- a/drivers/isdn/mISDN/dsp_hwec.c
+++ b/drivers/isdn/mISDN/dsp_hwec.c
@@ -51,14 +51,14 @@ void dsp_hwec_enable(struct dsp *dsp, const char *arg)
 		goto _do;
 
 	{
-		char *dup, *tok, *name, *val;
+		char *dup, *next, *tok, *name, *val;
 		int tmp;
 
-		dup = kstrdup(arg, GFP_ATOMIC);
+		dup = next = kstrdup(arg, GFP_ATOMIC);
 		if (!dup)
 			return;
 
-		while ((tok = strsep(&dup, ","))) {
+		while ((tok = strsep(&next, ","))) {
 			if (!strlen(tok))
 				continue;
 			name = strsep(&tok, "=");
-- 
2.50.1



