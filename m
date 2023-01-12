Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55CD979C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:24:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9649DC433EF;
	Thu, 12 Jan 2023 14:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673533487;
	bh=vk0rEk4KEdQ9pp2rYAjGKe4A74Kz/oXEyEoQyQqwR1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qbsNLjAwbMd3ZtoQ2uW6lTkewVJg/c0B02UbpMMjw/qfU+zib0yZvOwQTEpWa6RyV
	 giX2evO3mvlexPCGEsjcr6PndnHvYMfalhCL3R3im+IMgWiLpmYa3W60dIHMWw8VmL
	 GwTPoXZCdKdf9mSn0zPWj1lK056oDKD3pSXpel3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Yejian <zhengyejian1@huawei.com>,
	Hanjun Guo <guohanjun@huawei.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zhang Jinhao <zhangjinhao2@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 494/783] acct: fix potential integer overflow in encode_comp_t()
Date: Thu, 12 Jan 2023 14:53:30 +0100
Message-Id: <20230112135547.088395240@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zheng Yejian <zhengyejian1@huawei.com>

[ Upstream commit c5f31c655bcc01b6da53b836ac951c1556245305 ]

The integer overflow is descripted with following codes:
  > 317 static comp_t encode_comp_t(u64 value)
  > 318 {
  > 319         int exp, rnd;
    ......
  > 341         exp <<= MANTSIZE;
  > 342         exp += value;
  > 343         return exp;
  > 344 }

Currently comp_t is defined as type of '__u16', but the variable 'exp' is
type of 'int', so overflow would happen when variable 'exp' in line 343 is
greater than 65535.

Link: https://lkml.kernel.org/r/20210515140631.369106-3-zhengyejian1@huawei.com
Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
Cc: Hanjun Guo <guohanjun@huawei.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zhang Jinhao <zhangjinhao2@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/acct.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/acct.c b/kernel/acct.c
index f175df8f6aa4..12f7dacf560e 100644
--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -331,6 +331,8 @@ static comp_t encode_comp_t(unsigned long value)
 		exp++;
 	}
 
+	if (exp > (((comp_t) ~0U) >> MANTSIZE))
+		return (comp_t) ~0U;
 	/*
 	 * Clean it up and polish it off.
 	 */
-- 
2.35.1



