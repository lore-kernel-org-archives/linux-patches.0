Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE50079C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:33:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 143E9C433EF;
	Thu, 12 Jan 2023 14:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673533980;
	bh=Kfi5YBkUkH2qNCOxezaTbY0IFAJU3qA9OcICJaQkH6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZZfIFWcPYWiU57kVaGASNasqLIfclkto1oyPrUkHHgSr/BurgX0+FYradP+FXc/YY
	 JRKAXSYayqHBur8E9+hTzF1oFdQzB4eEwirwb6Vh3t/PnzsgnA4XpjHb9+AFvRGEkS
	 tq04+wvh8zi15kwCecixLucdqp66oKMoSfxLEto8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Jiaming Li <lijiaming30@huawei.com>,
	Huaxin Lu <luhuaxin1@huawei.com>,
	Stefan Berger <stefanb@linux.ibm.com>,
	Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 5.10 655/783] ima: Fix a potential NULL pointer access in ima_restore_measurement_list
Date: Thu, 12 Jan 2023 14:56:11 +0100
Message-Id: <20230112135554.702635535@linuxfoundation.org>
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

From: Huaxin Lu <luhuaxin1@huawei.com>

commit 11220db412edae8dba58853238f53258268bdb88 upstream.

In restore_template_fmt, when kstrdup fails, a non-NULL value will still be
returned, which causes a NULL pointer access in template_desc_init_fields.

Fixes: c7d09367702e ("ima: support restoring multiple template formats")
Cc: stable@kernel.org
Co-developed-by: Jiaming Li <lijiaming30@huawei.com>
Signed-off-by: Jiaming Li <lijiaming30@huawei.com>
Signed-off-by: Huaxin Lu <luhuaxin1@huawei.com>
Reviewed-by: Stefan Berger <stefanb@linux.ibm.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/integrity/ima/ima_template.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/security/integrity/ima/ima_template.c
+++ b/security/integrity/ima/ima_template.c
@@ -290,8 +290,11 @@ static struct ima_template_desc *restore
 
 	template_desc->name = "";
 	template_desc->fmt = kstrdup(template_name, GFP_KERNEL);
-	if (!template_desc->fmt)
+	if (!template_desc->fmt) {
+		kfree(template_desc);
+		template_desc = NULL;
 		goto out;
+	}
 
 	spin_lock(&template_list);
 	list_add_tail_rcu(&template_desc->list, &defined_templates);


