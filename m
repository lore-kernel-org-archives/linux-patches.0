Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C46A81E5B94;
	Sun,  7 Sep 2025 20:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276972; cv=none; b=eYKpFujFNcNQqk8c+N0B96Hqtw8UKkivhYvTstIucXkvWdGhFZXPDCS4+vbkyTmdviQv27zyOG7rh4XUmCs5IY9xcrCz5MMyHbMLSEyMKPoG1B925lp8ezRrdsvMtjFwetTzojCAOiohZG8qY51Bzn+2GW5QUkQmC9+lo7ks3D8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276972; c=relaxed/simple;
	bh=EjTJKbc/0nLsYEEdjUAXJLYKWIwABMEJKrx73PpOztg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rN1VMv4jEtImNEFrh1ZRxgMqytn/WHpCccLhscINJIuDQNJAmveqJwGKyUsdCHO2/W36/jHHTDYB+H6nx9x3I3N0qE97dPs65RZY3vmMgk5Eaj0hYa+JpzhIXgxBNqYreL738LeGqRfHuV+ncRHFwjx+14l8aj8L9SItNbJQlIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TQdPcbwT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TQdPcbwT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45216C4CEF0;
	Sun,  7 Sep 2025 20:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276972;
	bh=EjTJKbc/0nLsYEEdjUAXJLYKWIwABMEJKrx73PpOztg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TQdPcbwT66MayiW5x2hfRjscv7z+X9+8ktpmwrmEDPRrWDjFSUerILh9cSdWOKMgF
	 3vRNC3nWtCXT63qV2KjIoRkxX6yrrpbje55PikEdn4JcXebyiLAfTVY4poDkL6QMJt
	 oEfbezyEbXc37EL6twpUyCJcq5t1uG1wSHMa3VBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 047/175] mISDN: Fix memory leak in dsp_hwec_enable()
Date: Sun,  7 Sep 2025 21:57:22 +0200
Message-ID: <20250907195615.961821313@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
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



