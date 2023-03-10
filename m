Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3F1D882B
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 15:06:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73996C4339E;
	Fri, 10 Mar 2023 15:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678460773;
	bh=lGpvSeXcNX1cM0uufaZvRIAj2MCEdhVX/90mepeVURo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GM39d0YqHok/vIy5C0hoiyPqd8GsNeWj+2f3I4IBtq7bBtGi47etdWkPUXg5TdKFA
	 5k0n/XwSorCBN7KJtkhjODWwzKdPON5WzaMK7pW7hSV7D2vPaHfioL+V1ZF3EsReNk
	 3OLgKuLGjIaiRogWhVOaTUhSGIcSaxlSCFo2wYP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomas Henzl <thenzl@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 417/529] scsi: ses: Fix slab-out-of-bounds in ses_intf_remove()
Date: Fri, 10 Mar 2023 14:39:20 +0100
Message-Id: <20230310133824.318902352@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tomas Henzl <thenzl@redhat.com>

commit 578797f0c8cbc2e3ec5fc0dab87087b4c7073686 upstream.

A fix for:

BUG: KASAN: slab-out-of-bounds in ses_intf_remove+0x23f/0x270 [ses]
Read of size 8 at addr ffff88a10d32e5d8 by task rmmod/12013

When edev->components is zero, accessing edev->component[0] members is
wrong.

Link: https://lore.kernel.org/r/20230202162451.15346-5-thenzl@redhat.com
Cc: stable@vger.kernel.org
Signed-off-by: Tomas Henzl <thenzl@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/ses.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -856,7 +856,8 @@ static void ses_intf_remove_enclosure(st
 	kfree(ses_dev->page2);
 	kfree(ses_dev);
 
-	kfree(edev->component[0].scratch);
+	if (edev->components)
+		kfree(edev->component[0].scratch);
 
 	put_device(&edev->edev);
 	enclosure_unregister(edev);


