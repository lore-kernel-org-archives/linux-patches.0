Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D23661863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 14:58:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58B55C433D2;
	Wed, 28 Dec 2022 14:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672239503;
	bh=2NoQsfuLFH5qjh9NeGAICdSwPArreq+lbGl/pwIFnrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z3PxGBDIRhMH3xkiHKOXqFl1nrzPaUPWwz+m7tJtuCjr4Net1kycgbaApvUfJXf1k
	 qtZQ4WUqRFeuwWbYVL7s3JhCbTp1qY+7yzPJbjov3/tW1oN6QWqADYUfHTRrraNSKF
	 ZVqIHsVzYkWdhjpQJajLKhYAMYPfUTmOha4Zqfk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiu Jianfeng <xiujianfeng@huawei.com>,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 205/731] ima: Fix misuse of dereference of pointer in template_desc_init_fields()
Date: Wed, 28 Dec 2022 15:35:12 +0100
Message-Id: <20221228144302.502656150@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xiu Jianfeng <xiujianfeng@huawei.com>

[ Upstream commit 25369175ce84813dd99d6604e710dc2491f68523 ]

The input parameter @fields is type of struct ima_template_field ***, so
when allocates array memory for @fields, the size of element should be
sizeof(**field) instead of sizeof(*field).

Actually the original code would not cause any runtime error, but it's
better to make it logically right.

Fixes: adf53a778a0a ("ima: new templates management mechanism")
Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Reviewed-by: Roberto Sassu <roberto.sassu@huawei.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/ima/ima_template.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/integrity/ima/ima_template.c b/security/integrity/ima/ima_template.c
index db1ad6d7a57f..f84a0598e4f6 100644
--- a/security/integrity/ima/ima_template.c
+++ b/security/integrity/ima/ima_template.c
@@ -241,11 +241,11 @@ int template_desc_init_fields(const char *template_fmt,
 	}
 
 	if (fields && num_fields) {
-		*fields = kmalloc_array(i, sizeof(*fields), GFP_KERNEL);
+		*fields = kmalloc_array(i, sizeof(**fields), GFP_KERNEL);
 		if (*fields == NULL)
 			return -ENOMEM;
 
-		memcpy(*fields, found_fields, i * sizeof(*fields));
+		memcpy(*fields, found_fields, i * sizeof(**fields));
 		*num_fields = i;
 	}
 
-- 
2.35.1



