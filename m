Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 839241ED4F
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:47:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05ED0C433C8;
	Tue, 25 Jul 2023 11:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690285626;
	bh=Luy+unPzGpIMmc+d6MvmNS30Ymyx0SnZuSKSHoTvxk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gN/4tLRyiraBSNHozFYkNePxEx9EQoXAeeRrXVwkZfo2T3lFiA5OeTcsOwTW3Psp+
	 G7v9PAtUux88u9qHpDezStCY3UXAgHWluDkTLbMxYZw23hhbQpfwP0/67/CvRJzdBu
	 JRjERjuf0JucQhfYIz/rHYok9t8WO1GxOgpz4iv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bikash Hazarika <bhazarika@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.4 272/313] scsi: qla2xxx: Correct the index of array
Date: Tue, 25 Jul 2023 12:47:05 +0200
Message-ID: <20230725104532.831998934@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104521.167250627@linuxfoundation.org>
References: <20230725104521.167250627@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bikash Hazarika <bhazarika@marvell.com>

commit b1b9d3825df4c757d653d0b1df66f084835db9c3 upstream.

Klocwork reported array 'port_dstate_str' of size 10 may use index value(s)
10..15.

Add a fix to correct the index of array.

Cc: stable@vger.kernel.org
Signed-off-by: Bikash Hazarika <bhazarika@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://lore.kernel.org/r/20230607113843.37185-8-njavali@marvell.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_inline.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -110,11 +110,13 @@ qla2x00_set_fcport_disc_state(fc_port_t
 {
 	int old_val;
 	uint8_t shiftbits, mask;
+	uint8_t port_dstate_str_sz;
 
 	/* This will have to change when the max no. of states > 16 */
 	shiftbits = 4;
 	mask = (1 << shiftbits) - 1;
 
+	port_dstate_str_sz = sizeof(port_dstate_str) / sizeof(char *);
 	fcport->disc_state = state;
 	while (1) {
 		old_val = atomic_read(&fcport->shadow_disc_state);
@@ -122,7 +124,8 @@ qla2x00_set_fcport_disc_state(fc_port_t
 		    old_val, (old_val << shiftbits) | state)) {
 			ql_dbg(ql_dbg_disc, fcport->vha, 0x2134,
 			    "FCPort %8phC disc_state transition: %s to %s - portid=%06x.\n",
-			    fcport->port_name, port_dstate_str[old_val & mask],
+			    fcport->port_name, (old_val & mask) < port_dstate_str_sz ?
+				    port_dstate_str[old_val & mask] : "Unknown",
 			    port_dstate_str[state], fcport->d_id.b24);
 			return;
 		}


