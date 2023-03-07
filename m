Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABFC2BA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EF20C433D2;
	Tue,  7 Mar 2023 17:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209613;
	bh=s+B3LnhsW5Uqu4KBKDffU/YnyS0l0TmXFRcnmdemX1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qIPeMU+a3XJjgNZHw9Jgkh5xJv2EX1IWUlX3+SWxWLL12bLGu7+smjm3MP3U/OJjN
	 twz+sXxuhg+AvGHFKWEet7uGJdQAuhPxXVGkHsmFnqrU994qjQLqExyYYCxP8tuONq
	 16JWVwnDV5QXTUJNmco65fhP68lNGNQcb8L1itHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Halil Pasic <pasic@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0275/1001] s390/ap: fix status returned by ap_aqic()
Date: Tue,  7 Mar 2023 17:50:47 +0100
Message-Id: <20230307170033.604918154@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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

[ Upstream commit 394740d7645ea767795074287769dd26dbd4d782 ]

There function ap_aqic() tries to grab the status from the
wrong part of the register. Thus we always end up with
zeros. Which is wrong, among others, because we detect
failures via status.response_code.

Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
Reported-by: Janosch Frank <frankja@linux.ibm.com>
Fixes: 159491f3b509 ("s390/ap: rework assembler functions to use unions for in/out register variables")
Reviewed-by: Harald Freudenberger <freude@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/ap.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/s390/include/asm/ap.h b/arch/s390/include/asm/ap.h
index f508f5025e388..876afe46f316d 100644
--- a/arch/s390/include/asm/ap.h
+++ b/arch/s390/include/asm/ap.h
@@ -239,7 +239,10 @@ static inline struct ap_queue_status ap_aqic(ap_qid_t qid,
 	union {
 		unsigned long value;
 		struct ap_qirq_ctrl qirqctrl;
-		struct ap_queue_status status;
+		struct {
+			u32 _pad;
+			struct ap_queue_status status;
+		};
 	} reg1;
 	unsigned long reg2 = pa_ind;
 
@@ -253,7 +256,7 @@ static inline struct ap_queue_status ap_aqic(ap_qid_t qid,
 		"	lgr	%[reg1],1\n"		/* gr1 (status) into reg1 */
 		: [reg1] "+&d" (reg1)
 		: [reg0] "d" (reg0), [reg2] "d" (reg2)
-		: "cc", "0", "1", "2");
+		: "cc", "memory", "0", "1", "2");
 
 	return reg1.status;
 }
-- 
2.39.2



