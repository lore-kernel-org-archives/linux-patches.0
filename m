Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FFF8151CD9;
	Tue, 20 Feb 2024 21:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708462807; cv=none; b=BEIPA7n/hYPBpanNqH8b5C3sixLrWmFIX94KeG7kBu0T6pEMQBF/swp9Vh21T/MK5mWRvaqKJQc9hxOnMmhLjJ/smdq47XVhPRg5GjQaVH/ExjJA1z516KLVcUhn2nzskkyG6h3nGNtH5etK6GIj9ua+TO9lIcq2Teh+a3kRluo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708462807; c=relaxed/simple;
	bh=qVgZ22OH3GDTZVFJLtNiid5J+sLeqZjCAKDKmAHB9Mg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rshmErG+nASZDBF+cqXF0OOvC7kazZ7tL7R7ik7056/JNZuq4E50NT91qPolS4Y1/dktyB1i5QTOqB9bhDG/XOPv+P0xY/fBpZW7EkJnsrnaRP20mT+um8E5TJqEcIr0hrR+I71ISxXJSpEbPaTFnpsMpSGN1/zV6ho/gDodrbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vftdr6Iy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vftdr6Iy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EF6AC43390;
	Tue, 20 Feb 2024 21:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708462806;
	bh=qVgZ22OH3GDTZVFJLtNiid5J+sLeqZjCAKDKmAHB9Mg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vftdr6IySIAvUzscagttNerTGa3Ut37xJVXKsV2UIbnL4PvP4QRu/YTIDQG/QuiGc
	 jzFjegUaHwuk6DVW2mW3I9Jsxg56ZW6hVouzE0hGFf/Q8jXJ7eL1nwDHafMa+1KOGg
	 dIKG83nm/cJGn6F1BNg4nMattiOw//u+NxVQptuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	"Christian A. Ehrhardt" <lk@c--e.de>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 013/197] of: unittest: Fix compile in the non-dynamic case
Date: Tue, 20 Feb 2024 21:49:32 +0100
Message-ID: <20240220204841.481475829@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian A. Ehrhardt <lk@c--e.de>

[ Upstream commit 607aad1e4356c210dbef9022955a3089377909b2 ]

If CONFIG_OF_KOBJ is not set, a device_node does not contain a
kobj and attempts to access the embedded kobj via kref_read break
the compile.

Replace affected kref_read calls with a macro that reads the
refcount if it exists and returns 1 if there is no embedded kobj.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202401291740.VP219WIz-lkp@intel.com/
Fixes: 4dde83569832 ("of: Fix double free in of_parse_phandle_with_args_map")
Signed-off-by: Christian A. Ehrhardt <lk@c--e.de>
Link: https://lore.kernel.org/r/20240129192556.403271-1-lk@c--e.de
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/unittest.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/of/unittest.c b/drivers/of/unittest.c
index e541a8960f1d..ce1386074e66 100644
--- a/drivers/of/unittest.c
+++ b/drivers/of/unittest.c
@@ -49,6 +49,12 @@ static struct unittest_results {
 	failed; \
 })
 
+#ifdef CONFIG_OF_KOBJ
+#define OF_KREF_READ(NODE) kref_read(&(NODE)->kobj.kref)
+#else
+#define OF_KREF_READ(NODE) 1
+#endif
+
 /*
  * Expected message may have a message level other than KERN_INFO.
  * Print the expected message only if the current loglevel will allow
@@ -562,7 +568,7 @@ static void __init of_unittest_parse_phandle_with_args_map(void)
 			pr_err("missing testcase data\n");
 			return;
 		}
-		prefs[i] = kref_read(&p[i]->kobj.kref);
+		prefs[i] = OF_KREF_READ(p[i]);
 	}
 
 	rc = of_count_phandle_with_args(np, "phandle-list", "#phandle-cells");
@@ -685,9 +691,9 @@ static void __init of_unittest_parse_phandle_with_args_map(void)
 	unittest(rc == -EINVAL, "expected:%i got:%i\n", -EINVAL, rc);
 
 	for (i = 0; i < ARRAY_SIZE(p); ++i) {
-		unittest(prefs[i] == kref_read(&p[i]->kobj.kref),
+		unittest(prefs[i] == OF_KREF_READ(p[i]),
 			 "provider%d: expected:%d got:%d\n",
-			 i, prefs[i], kref_read(&p[i]->kobj.kref));
+			 i, prefs[i], OF_KREF_READ(p[i]));
 		of_node_put(p[i]);
 	}
 }
-- 
2.43.0



