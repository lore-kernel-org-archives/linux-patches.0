Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04083848C
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:23:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E1F9C433D2;
	Fri, 10 Mar 2023 14:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678458223;
	bh=diP8d+FwxXYWw6fHk3vqyV33HfBfOi9YjorhMqKpWWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IjnVoGNHB2NF0Ldzm1mroVTEyi2+max4IUd60NWMKnaJ2bHFQIIsQftEErXeh/6S7
	 PBFEp6/1WNCh4DK13s9nU6dfFthp+Gy7SUO8kSrN1bLqx+u2pus9LU71utESLq3mf5
	 7rFX2wXSffFQP8GLzmnnO+BaoO1H8YfeTpGHxxdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ding Hui <dinghui@sangfor.com.cn>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.19 188/252] scsi: ses: Dont attach if enclosure has no components
Date: Fri, 10 Mar 2023 14:39:18 +0100
Message-Id: <20230310133724.619453729@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: James Bottomley <jejb@linux.ibm.com>

commit 3fe97ff3d94934649abb0652028dd7296170c8d0 upstream.

An enclosure with no components can't usefully be operated by the driver
(since effectively it has nothing to manage), so report the problem and
don't attach. Not attaching also fixes an oops which could occur if the
driver tries to manage a zero component enclosure.

[mkp: Switched to KERN_WARNING since this scenario is common]

Link: https://lore.kernel.org/r/c5deac044ac409e32d9ad9968ce0dcbc996bfc7a.camel@linux.ibm.com
Cc: stable@vger.kernel.org
Reported-by: Ding Hui <dinghui@sangfor.com.cn>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/ses.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -720,6 +720,12 @@ static int ses_intf_add(struct device *c
 		    type_ptr[0] == ENCLOSURE_COMPONENT_ARRAY_DEVICE)
 			components += type_ptr[1];
 	}
+
+	if (components == 0) {
+		sdev_printk(KERN_WARNING, sdev, "enclosure has no enumerated components\n");
+		goto err_free;
+	}
+
 	ses_dev->page1 = buf;
 	ses_dev->page1_len = len;
 	buf = NULL;


