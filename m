Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D8B3DC4DA;
	Wed, 20 May 2026 17:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297403; cv=none; b=k3xakmoRubDfloQclSq1rskBorZbXgbz5VrIHYQv7DJk2PHCj3VqAg4VVXTz8Nvs+9noDqJI/mdClgvVpbMyheEquAosxbYCmkyYXttLlQbXMORbhea1W20v/Z7JcfsQz1bqr8sujwvj+IP0rK2att6HO7dhPMDxNphlCepcQjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297403; c=relaxed/simple;
	bh=9IKl3NTpmZdrZRzB/N/HPDK9/+/Lxw9HwC4LGeVmVDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B2/Gh2arhiyEZevukcEAOeNTP0YdaKC6ZXCMpr4LE3JQe8Ty7tRLjvcoKNhXg2HX3p8bABHgUNAcjI+utdl5b/GdLzyVcZ2zBCI61gUJKlj2W//ziLWnqEYugv5MwXTPKmUw7+vFEq2dJSbxVOAVwZbTtwV0a8XsLjNWhkmVdxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Spx2aMv2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Spx2aMv2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F7021F000E9;
	Wed, 20 May 2026 17:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297402;
	bh=Cp3ZyUqpvZ0bdNKCOHjla6dS10YvFgEgKByyak00wcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Spx2aMv2bT7/h23u5YnDnYl4b4YK0NLnQikpT0SZXiULjUkNJ0eZ0/02zmkGwmTUZ
	 /VFyAKwRUb2oVL0TUbGlJ342EhFOLP21Y1+c9i2ap9Gapm81X8NqWI18JypKjFcLGQ
	 NbYxloouceyNe1phl/DM63eZpTXEPPQMTTcNmSlM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 019/957] OPP: Move break out of scoped_guard in dev_pm_opp_xlate_required_opp()
Date: Wed, 20 May 2026 18:08:22 +0200
Message-ID: <20260520162134.977680055@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Viresh Kumar <viresh.kumar@linaro.org>

[ Upstream commit 3d2398f44a2d48fb1c575a6e0bc6b38f3e689e22 ]

The commit ff9c512041f2 ("OPP: Use mutex locking guards")
unintentionally made the for loop run longer than required.

scoped_guard() is implemented as a for loop. The break statement now
breaks out out the scoped_guard() and not out of the outer for loop.
The outer loop always iterates to completion.

Fix it.

Fixes: ff9c512041f2 ("OPP: Use mutex locking guards")
Reported-by: David Lechner <dlechner@baylibre.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/opp/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/opp/core.c b/drivers/opp/core.c
index 775d4a36f2f54..157c84b689feb 100644
--- a/drivers/opp/core.c
+++ b/drivers/opp/core.c
@@ -2741,8 +2741,8 @@ struct dev_pm_opp *dev_pm_opp_xlate_required_opp(struct opp_table *src_table,
 					break;
 				}
 			}
-			break;
 		}
+		break;
 	}
 
 	if (IS_ERR(dest_opp)) {
-- 
2.53.0



