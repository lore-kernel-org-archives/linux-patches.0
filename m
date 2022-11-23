Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 873E51C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:26:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7941C43145;
	Wed, 23 Nov 2022 09:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669195606;
	bh=fHXDeFhK45VnMTTNCv2wQtmdkU75+T7qWf1s9rN7QYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pRGjw152T0MHztsY4pr291Ztc1+ayxJBuosnrgmLMJWwsR12pYm2GCE5TxZphQCps
	 kkU1VTW2fvUY98BStoY4Px5leSmn4B/TEzIouo2ikrE20vTZBvM/+u31fep7RXQ0nI
	 jHM+ONWpC4idfAaqGdsdYD6ne7kKQe4EogLY78G4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.10 125/149] perf/x86/intel/pt: Fix sampling using single range output
Date: Wed, 23 Nov 2022 09:51:48 +0100
Message-Id: <20221123084602.425380163@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.945845710@linuxfoundation.org>
References: <20221123084557.945845710@linuxfoundation.org>
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


