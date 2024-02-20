Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997D014A4E6;
	Tue, 20 Feb 2024 21:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464423; cv=none; b=A/9KO6ZflTg2eNxemmUGl5qbXDmwlXO56+8CDNAhjJIOyhVK27mA3/DHhcgIT92T06Q9Z9yobcz5Dd6JvgSzYfMhwtfIsdxvaxKozGofVysbq3Q3rnbN34Dv+eVzzu1NwKY6E5miHhIQZF9Kxa3BWuglPWetYjGsnnZvCPOR9v8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464423; c=relaxed/simple;
	bh=gwb/3TEoin7bbCeiW2+G0EInn+/dB9wsRekf9GC4o5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tbX38o5OnmnaZisE2jdMzygzpKqPlQXcah1cMfI/rQBlZogHYQ2rqvYj+Gr74Ft7M3/d4Lr1cc3lojq49qxv4vLU5649kwcyj/1Ym6kMrH54ToZrYgxu1z0GQ6/CPO137XR59uGrcEHTjn/hXcgGvSyZCwtKWRLfimZjor0Hmbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mazhhzbR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mazhhzbR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07344C433F1;
	Tue, 20 Feb 2024 21:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464423;
	bh=gwb/3TEoin7bbCeiW2+G0EInn+/dB9wsRekf9GC4o5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mazhhzbRe/tm5Igs5BcKceh9qxv86zy1JqvXyaRvBzV5OMgulQ9/P7cD/db+7FpZK
	 tq6fqslIqwvDHhfJljz2hMnxJrlDTLSCaYrQihT4sAMpTNyUfTGCCpFKVz93cN30RK
	 +T8DhAIXrm5F6/YKEWqoX0HOsT7nz4UkZ8cdaA7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	"Christian A. Ehrhardt" <lk@c--e.de>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 020/309] of: unittest: Fix compile in the non-dynamic case
Date: Tue, 20 Feb 2024 21:52:59 +0100
Message-ID: <20240220205633.808679583@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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
index cfd60e35a899..d7593bde2d02 100644
--- a/drivers/of/unittest.c
+++ b/drivers/of/unittest.c
@@ -50,6 +50,12 @@ static struct unittest_results {
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
@@ -570,7 +576,7 @@ static void __init of_unittest_parse_phandle_with_args_map(void)
 			pr_err("missing testcase data\n");
 			return;
 		}
-		prefs[i] = kref_read(&p[i]->kobj.kref);
+		prefs[i] = OF_KREF_READ(p[i]);
 	}
 
 	rc = of_count_phandle_with_args(np, "phandle-list", "#phandle-cells");
@@ -693,9 +699,9 @@ static void __init of_unittest_parse_phandle_with_args_map(void)
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



