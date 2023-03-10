Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 084D0882B
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 15:06:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72999C433EF;
	Fri, 10 Mar 2023 15:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678460770;
	bh=xgPvzfDy+s9/jfebMR/uI5TEh8mSleRWqfZVrNRaobg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jsVoYTRrpnHivi3ZHND2QVp47PFG1i88QTwTi7HA7Qpto41qShQ0UOHBDZq6m9OtS
	 1F7O3/nPrHWEgbXZiRwPhE9bC1xwnu282pnK/TDaP2VMXsTvh7ZWbdX87btJYGyAVM
	 MlS48veY9UPA5VVnjRlaZRW7qQJqSsib6AOR8JkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomas Henzl <thenzl@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 416/529] scsi: ses: Fix possible desc_ptr out-of-bounds accesses
Date: Fri, 10 Mar 2023 14:39:19 +0100
Message-Id: <20230310133824.265735530@linuxfoundation.org>
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

commit 801ab13d50cf3d26170ee073ea8bb4eececb76ab upstream.

Sanitize possible desc_ptr out-of-bounds accesses in
ses_enclosure_data_process().

Link: https://lore.kernel.org/r/20230202162451.15346-4-thenzl@redhat.com
Cc: stable@vger.kernel.org
Signed-off-by: Tomas Henzl <thenzl@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/ses.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -572,15 +572,19 @@ static void ses_enclosure_data_process(s
 			int max_desc_len;
 
 			if (desc_ptr) {
-				if (desc_ptr >= buf + page7_len) {
+				if (desc_ptr + 3 >= buf + page7_len) {
 					desc_ptr = NULL;
 				} else {
 					len = (desc_ptr[2] << 8) + desc_ptr[3];
 					desc_ptr += 4;
-					/* Add trailing zero - pushes into
-					 * reserved space */
-					desc_ptr[len] = '\0';
-					name = desc_ptr;
+					if (desc_ptr + len > buf + page7_len)
+						desc_ptr = NULL;
+					else {
+						/* Add trailing zero - pushes into
+						 * reserved space */
+						desc_ptr[len] = '\0';
+						name = desc_ptr;
+					}
 				}
 			}
 			if (type_ptr[0] == ENCLOSURE_COMPONENT_DEVICE ||


