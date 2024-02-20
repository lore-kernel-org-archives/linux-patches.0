Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE09414AD12;
	Tue, 20 Feb 2024 21:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463348; cv=none; b=MB2CExW7I43uZ8G2V64KBE9lwX2rIL8ogEmDERtqWIUf7klzh9uV3Vm3W0tjVj5mzyMWsCm5rcLUGc5Gv6fJU0Rl/IiFxCGm66jCzyxPf2g7zBWuFy6nNVDKVeuKJMsHQKudSvxhJAu/vTLPg05dHTKSFckEllL9rBQbENuqofE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463348; c=relaxed/simple;
	bh=EUON+XYnCKsHXj9UrBo519PiuL7BLHEKCFlp3rB5spw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gS8HANFLzTYFdmnoNbSLSk8B8IECt/47JEa8Ii5Iqh6rEcH/1qn5iDWvoNOHwGYN+CpPqY1ySVDTI1X9wb4LPcW1sAGKbb9AQPx45ESOZU8fL1aZ9q4It9z7/IJvYI373ZgQ0HkH9QZTFqqfnvsQfklOU7ONvYRf4zw2UL9iA5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tJmHOdAE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tJmHOdAE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32AB1C433C7;
	Tue, 20 Feb 2024 21:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463347;
	bh=EUON+XYnCKsHXj9UrBo519PiuL7BLHEKCFlp3rB5spw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tJmHOdAE784vQQ+LJW7lBFGu5lq6rztbb23t+nJmdcTdeGJ9FifcPp/KeXYyDXBoP
	 Rxa/lKxGgChKqvG5SyS1bHUwMWjX2wJYFjI0pxy9t8A/iKUlg5F9rEJ834/7tzQbeG
	 6lAkS6pcO56C4ArXLB9pqBCZTl0Iv4uP3GaNC9V4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	"Christian A. Ehrhardt" <lk@c--e.de>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 016/331] of: unittest: Fix compile in the non-dynamic case
Date: Tue, 20 Feb 2024 21:52:12 +0100
Message-ID: <20240220205638.094902142@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f278def7ef03..4f58345b5c68 100644
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



