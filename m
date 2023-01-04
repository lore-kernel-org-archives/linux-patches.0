Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79ACEAD48
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 16:23:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB1AFC433D2;
	Wed,  4 Jan 2023 16:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672849434;
	bh=kDLBUV+Ye7w3eLOQ3Co93J5anMhbj5TxHng32TQWiYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xCunwhS92F5CzJifL9cehNZkpO0JCF0PqCZT8wfZN0WAy7DUPHRnUFBO5K6odSn45
	 YUQAadlUzc8Y4AeNsiE6VvZaXSTxmmWrzAjjeOdFP/csEm8YjEE/i1sRPdSwTmOryU
	 bQw4oD0P1fcP7R4PIMhGOKssV4t0Rawd3eY0xbk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Jiaming Li <lijiaming30@huawei.com>,
	Huaxin Lu <luhuaxin1@huawei.com>,
	Stefan Berger <stefanb@linux.ibm.com>,
	Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 6.0 097/177] ima: Fix a potential NULL pointer access in ima_restore_measurement_list
Date: Wed,  4 Jan 2023 17:06:28 +0100
Message-Id: <20230104160510.575144778@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
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
@@ -340,8 +340,11 @@ static struct ima_template_desc *restore
 
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


