Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0446129BDAE;
	Sun,  7 Sep 2025 20:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757275796; cv=none; b=b0qtIlG4J87xDWGn/0J5wKb4xetO5j6i9vpQbrZtK8Ex/VRogssYoy2OIe69UNIQYNU+A7EjNGLcU71bxBhbWY5P7bz8BaB1WnOByIlm/qN9eOJjmdytpFa9xl9dzdVnXFHRDJ0Yms2auRqayssg59w5iw8G09qOYg9hLQG6i14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757275796; c=relaxed/simple;
	bh=oHpsOwOOh1eRYgBghrBa9gZ/ffEHUMn7Cl5hjqn0mtg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SiK0sAygGRvifFgNI1E6VSK7Ju9Kos0kJ3pKY+sukIIMNEoRc9Tume/uJtmy2ULfevJ5xKuq0Tq5vav95534h1V1LIQZxV5BIiJeQnC9uqYO7hSrKABlhfWL17FZLDMOsfbWhEowyZWMRpVCxymDpF0gpZreNLnGdoF2dvrhn/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q+KfPhnO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q+KfPhnO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 527AEC4CEF0;
	Sun,  7 Sep 2025 20:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757275795;
	bh=oHpsOwOOh1eRYgBghrBa9gZ/ffEHUMn7Cl5hjqn0mtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q+KfPhnOsmmP8zKShGUyD3nkY5GSNKlho66lG5phhEKpqXHr+h4S+dGnza1GZOJls
	 wmwFb7R9acD72clL+RzD0/GHRgX26qPk1nIvmphxHFwaHTYkpIOIC3cfIJnny2nNcn
	 hTzj3hIPHR2SJMJnR4swEStJfLpBSZp7MoQ3cQ9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 06/45] mISDN: Fix memory leak in dsp_hwec_enable()
Date: Sun,  7 Sep 2025 21:57:52 +0200
Message-ID: <20250907195601.147463099@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195600.953058118@linuxfoundation.org>
References: <20250907195600.953058118@linuxfoundation.org>
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



