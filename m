Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82197BA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:51:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC584C433EF;
	Tue,  7 Mar 2023 18:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678215066;
	bh=rKB0FxikJvQEdMDRr6dKmEejodVwNxIn9xdLwPhOZkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gxpxldwBQsOtw13fj6v7aKDeEmpSjKKKa/Kc5Ffcdth4tiGGVAzEBGvofrz6jD3/D
	 EY5gSiQrDo/6L2CN6QWTluynQUoHlOMfoVH7CDnk7WvQjmnA+ewiSdubm+nLsRxbfv
	 z26xhHMHoBoFY+z/XQ+tBE3+2erYKu6bFHC9Pvww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Halil Pasic <pasic@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 140/567] s390/ap: fix status returned by ap_qact()
Date: Tue,  7 Mar 2023 17:57:56 +0100
Message-Id: <20230307165911.978458250@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Halil Pasic <pasic@linux.ibm.com>

[ Upstream commit a2522c80f074c35254974fec39fffe8b8d75befe ]

Since commit 159491f3b509 ("s390/ap: rework assembler functions to use
unions for in/out register variables") the  function ap_qact() tries to
grab the status from the wrong part of the register. Thus we always end
up with zeros. Which is wrong, among others, because we detect failures
via status.response_code.

Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
Reported-by: Harald Freudenberger <freude@linux.ibm.com>
Fixes: 159491f3b509 ("s390/ap: rework assembler functions to use unions for in/out register variables")
Reviewed-by: Harald Freudenberger <freude@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/ap.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/s390/include/asm/ap.h b/arch/s390/include/asm/ap.h
index 8a8c0b157b551..859e6d87b108b 100644
--- a/arch/s390/include/asm/ap.h
+++ b/arch/s390/include/asm/ap.h
@@ -290,7 +290,10 @@ static inline struct ap_queue_status ap_qact(ap_qid_t qid, int ifbit,
 	unsigned long reg0 = qid | (5UL << 24) | ((ifbit & 0x01) << 22);
 	union {
 		unsigned long value;
-		struct ap_queue_status status;
+		struct {
+			u32 _pad;
+			struct ap_queue_status status;
+		};
 	} reg1;
 	unsigned long reg2;
 
-- 
2.39.2



