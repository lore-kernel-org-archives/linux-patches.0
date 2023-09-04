Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C63C142
	for <patches@lists.linux.dev>; Mon,  4 Sep 2023 18:34:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD749C433C8;
	Mon,  4 Sep 2023 18:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693852467;
	bh=y6xhNeW6dI1i/S/QI7sNj1LkiwaPWOK10viCMe/ve00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TgDoHcZ35oxbqnUI/dkSfSrNWcULt7NlgZGJ/j8yMwGU5E8HNEf+674XFfQ3+z4lz
	 zjzkoj/jVmeFiEQvruTj422e6nrs8omJs+U2EAikbn8fJxlA5U01bxmiXSMC/KlW5G
	 g2b+EBAmwmHmHfdoWBUcMd2hL+mHwXO6CtNlVEH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 6.1 10/31] modules: only allow symbol_get of EXPORT_SYMBOL_GPL modules
Date: Mon,  4 Sep 2023 19:30:18 +0100
Message-ID: <20230904182947.512999100@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230904182946.999390199@linuxfoundation.org>
References: <20230904182946.999390199@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

commit 9011e49d54dcc7653ebb8a1e05b5badb5ecfa9f9 upstream.

It has recently come to my attention that nvidia is circumventing the
protection added in 262e6ae7081d ("modules: inherit
TAINT_PROPRIETARY_MODULE") by importing exports from their proprietary
modules into an allegedly GPL licensed module and then rexporting them.

Given that symbol_get was only ever intended for tightly cooperating
modules using very internal symbols it is logical to restrict it to
being used on EXPORT_SYMBOL_GPL and prevent nvidia from costly DMCA
Circumvention of Access Controls law suites.

All symbols except for four used through symbol_get were already exported
as EXPORT_SYMBOL_GPL, and the remaining four ones were switched over in
the preparation patches.

Fixes: 262e6ae7081d ("modules: inherit TAINT_PROPRIETARY_MODULE")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/module/main.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -1214,12 +1214,20 @@ void *__symbol_get(const char *symbol)
 	};
 
 	preempt_disable();
-	if (!find_symbol(&fsa) || strong_try_module_get(fsa.owner)) {
-		preempt_enable();
-		return NULL;
+	if (!find_symbol(&fsa))
+		goto fail;
+	if (fsa.license != GPL_ONLY) {
+		pr_warn("failing symbol_get of non-GPLONLY symbol %s.\n",
+			symbol);
+		goto fail;
 	}
+	if (strong_try_module_get(fsa.owner))
+		goto fail;
 	preempt_enable();
 	return (void *)kernel_symbol_value(fsa.sym);
+fail:
+	preempt_enable();
+	return NULL;
 }
 EXPORT_SYMBOL_GPL(__symbol_get);
 


