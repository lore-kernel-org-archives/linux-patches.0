Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57846171A1
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:21:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC92CC433EF;
	Mon, 22 May 2023 19:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684783291;
	bh=Z2i5aSkmJsMunBpgbl3Pdi0FR/dx/JbOtYWynnp15cQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mnjQ74JUcCmdzgi8wyCuk4O9r3NnLnjPqwyhW0KdG+ffHiLnifFbhYIdGNpogsTBB
	 SVhx5vxcBxep0VqUqfqQ1Q1nOLiV9B+vY8pwFRQQbomjxOtEd9f6881WjW1L7tZAat
	 GC1IQwc3YlKjF/gubhxhndl0kBtG1dJqUjEkNCLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Block <bblock@linux.ibm.com>,
	Steffen Maier <maier@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [PATCH 5.15 200/203] s390/qdio: fix do_sqbs() inline assembly constraint
Date: Mon, 22 May 2023 20:10:24 +0100
Message-Id: <20230522190400.581111691@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190354.935300867@linuxfoundation.org>
References: <20230522190354.935300867@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Heiko Carstens <hca@linux.ibm.com>

commit 2862a2fdfae875888e3c1c3634e3422e01d98147 upstream.

Use "a" constraint instead of "d" constraint to pass the state parameter to
the do_sqbs() inline assembly. This prevents that general purpose register
zero is used for the state parameter.

If the compiler would select general purpose register zero this would be
problematic for the used instruction in rsy format: the register used for
the state parameter is a base register. If the base register is general
purpose register zero the contents of the register are unexpectedly ignored
when the instruction is executed.

This only applies to z/VM guests using QIOASSIST with dedicated (pass through)
QDIO-based devices such as FCP [zfcp driver] as well as real OSA or
HiperSockets [qeth driver].

A possible symptom for this case using zfcp is the following repeating kernel
message pattern:

zfcp <devbusid>: A QDIO problem occurred
zfcp <devbusid>: A QDIO problem occurred
zfcp <devbusid>: qdio: ZFCP on SC <sc> using AI:1 QEBSM:1 PRI:1 TDD:1 SIGA: W
zfcp <devbusid>: A QDIO problem occurred
zfcp <devbusid>: A QDIO problem occurred

Each of the qdio problem message can be accompanied by the following entries
for the affected subchannel <sc> in
/sys/kernel/debug/s390dbf/qdio_error/hex_ascii for zfcp or qeth:

<sc> ccq: 69....
<sc> SQBS ERROR.

Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Cc: Steffen Maier <maier@linux.ibm.com>
Fixes: 8129ee164267 ("[PATCH] s390: qdio V=V pass-through")
Cc: <stable@vger.kernel.org>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/cio/qdio.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/cio/qdio.h b/drivers/s390/cio/qdio.h
index 5ea6249d8180..641f0dbb65a9 100644
--- a/drivers/s390/cio/qdio.h
+++ b/drivers/s390/cio/qdio.h
@@ -95,7 +95,7 @@ static inline int do_sqbs(u64 token, unsigned char state, int queue,
 		"	lgr	1,%[token]\n"
 		"	.insn	rsy,0xeb000000008a,%[qs],%[ccq],0(%[state])"
 		: [ccq] "+&d" (_ccq), [qs] "+&d" (_queuestart)
-		: [state] "d" ((unsigned long)state), [token] "d" (token)
+		: [state] "a" ((unsigned long)state), [token] "d" (token)
 		: "memory", "cc", "1");
 	*count = _ccq & 0xff;
 	*start = _queuestart & 0xff;
-- 
2.40.1



