Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4783C881F
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:39:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF24FC433D2;
	Fri, 10 Mar 2023 14:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678459172;
	bh=u8BGxXeNeMfTLDftDVe1tr5HTuXiSx3ka5bkHanXLEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v7oy4wpNx0Bs2m8k5VXKp/M7tpv25hzwb7g3SUyJAmrg9FK29x8++Kx+5zdyjgTtW
	 QhKtqOQnafqCllG0b6UDyRmZPectN/0U/Glwq7T8H/A9MLJMcIgdjtAJhCOgInV0rF
	 CGPV1BnYoCwABBtBszDgtLbAaJlDVrInHejvdMXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomas Henzl <thenzl@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.4 272/357] scsi: ses: Fix slab-out-of-bounds in ses_enclosure_data_process()
Date: Fri, 10 Mar 2023 14:39:21 +0100
Message-Id: <20230310133746.739971223@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
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

commit 9b4f5028e493cb353a5c8f5c45073eeea0303abd upstream.

A fix for:

BUG: KASAN: slab-out-of-bounds in ses_enclosure_data_process+0x949/0xe30 [ses]
Read of size 1 at addr ffff88a1b043a451 by task systemd-udevd/3271

Checking after (and before in next loop) addl_desc_ptr[1] is sufficient, we
expect the size to be sanitized before first access to addl_desc_ptr[1].
Make sure we don't walk beyond end of page.

Link: https://lore.kernel.org/r/20230202162451.15346-2-thenzl@redhat.com
Cc: stable@vger.kernel.org
Signed-off-by: Tomas Henzl <thenzl@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/ses.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -603,9 +603,11 @@ static void ses_enclosure_data_process(s
 			     /* these elements are optional */
 			     type_ptr[0] == ENCLOSURE_COMPONENT_SCSI_TARGET_PORT ||
 			     type_ptr[0] == ENCLOSURE_COMPONENT_SCSI_INITIATOR_PORT ||
-			     type_ptr[0] == ENCLOSURE_COMPONENT_CONTROLLER_ELECTRONICS))
+			     type_ptr[0] == ENCLOSURE_COMPONENT_CONTROLLER_ELECTRONICS)) {
 				addl_desc_ptr += addl_desc_ptr[1] + 2;
-
+				if (addl_desc_ptr + 1 >= ses_dev->page10 + ses_dev->page10_len)
+					addl_desc_ptr = NULL;
+			}
 		}
 	}
 	kfree(buf);


