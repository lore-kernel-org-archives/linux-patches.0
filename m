Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D2E51C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:37:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84CA6C433B5;
	Wed, 23 Nov 2022 09:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669196240;
	bh=fHXDeFhK45VnMTTNCv2wQtmdkU75+T7qWf1s9rN7QYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b7XM5ZwhSR/mH1k37RUZ9fJ/azClJ7Bz+PFBGXcbXZnYRt3KsZreykjaxZdBoDwZj
	 Xyr0jKwjXAiqqndnWKX+OCBa0q/RTBTFGVVPIrPNJDRRqfSDgkVex7ew6NckIWaurn
	 SDlydF8GrVMEEKVKtXxMACxpgTXCh2s3XKJfpgUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.15 156/181] perf/x86/intel/pt: Fix sampling using single range output
Date: Wed, 23 Nov 2022 09:51:59 +0100
Message-Id: <20221123084609.077857548@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>
References: <20221123084602.707860461@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Adrian Hunter <adrian.hunter@intel.com>

commit ce0d998be9274dd3a3d971cbeaa6fe28fd2c3062 upstream.

Deal with errata TGL052, ADL037 and RPL017 "Trace May Contain Incorrect
Data When Configured With Single Range Output Larger Than 4KB" by
disabling single range output whenever larger than 4KB.

Fixes: 670638477aed ("perf/x86/intel/pt: Opportunistically use single range output mode")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20221112151508.13768-1-adrian.hunter@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/pt.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/arch/x86/events/intel/pt.c
+++ b/arch/x86/events/intel/pt.c
@@ -1247,6 +1247,15 @@ static int pt_buffer_try_single(struct p
 	if (1 << order != nr_pages)
 		goto out;
 
+	/*
+	 * Some processors cannot always support single range for more than
+	 * 4KB - refer errata TGL052, ADL037 and RPL017. Future processors might
+	 * also be affected, so for now rather than trying to keep track of
+	 * which ones, just disable it for all.
+	 */
+	if (nr_pages > 1)
+		goto out;
+
 	buf->single = true;
 	buf->nr_pages = nr_pages;
 	ret = 0;


