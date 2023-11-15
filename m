Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 650813DBAC
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JuZdSv9v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17145C433C8;
	Wed, 15 Nov 2023 19:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078394;
	bh=LvDHmsWPYD7M4kjec7gPEsLcQ4mNMKVtTUeWxpPR6a0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JuZdSv9voaf5744pmMpNqQ4x0kc4K5xqZbjuWC7IRsEIT2FTKdHuQFBIACGMiIiLs
	 TjDAgzTdVKxgtQCN4yPYoVqoRAO/OL+cm+zNq891QhQncFWdjGaN32y0B6lu0uD/gF
	 rblCq3uthrxGxngeH3fwsC8DLlPYEt4ap6M3sH2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Gray <bgray@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 296/379] powerpc/xive: Fix endian conversion size
Date: Wed, 15 Nov 2023 14:26:11 -0500
Message-ID: <20231115192702.656169005@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
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

From: Benjamin Gray <bgray@linux.ibm.com>

[ Upstream commit ff7a60ab1e065257a0e467c13b519f4debcd7fcf ]

Sparse reports a size mismatch in the endian swap. The Opal
implementation[1] passes the value as a __be64, and the receiving
variable out_qsize is a u64, so the use of be32_to_cpu() appears to be
an error.

[1]: https://github.com/open-power/skiboot/blob/80e2b1dc73/hw/xive.c#L3854

Fixes: 88ec6b93c8e7 ("powerpc/xive: add OPAL extensions for the XIVE native exploitation support")
Signed-off-by: Benjamin Gray <bgray@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20231011053711.93427-2-bgray@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/sysdev/xive/native.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/sysdev/xive/native.c b/arch/powerpc/sysdev/xive/native.c
index 3925825954bcc..e5baa91ddd07b 100644
--- a/arch/powerpc/sysdev/xive/native.c
+++ b/arch/powerpc/sysdev/xive/native.c
@@ -804,7 +804,7 @@ int xive_native_get_queue_info(u32 vp_id, u32 prio,
 	if (out_qpage)
 		*out_qpage = be64_to_cpu(qpage);
 	if (out_qsize)
-		*out_qsize = be32_to_cpu(qsize);
+		*out_qsize = be64_to_cpu(qsize);
 	if (out_qeoi_page)
 		*out_qeoi_page = be64_to_cpu(qeoi_page);
 	if (out_escalate_irq)
-- 
2.42.0



