Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B912A38F658;
	Sat, 17 Oct 2026 15:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792252666; cv=none; b=md5DHSaVYY7HN7Zj1sC3vn8itE40UlIfVwxHZe2WDBM7qx7DW43edUsUbCx66x9PPutIS3D4aa3lpUJ9tJDeFFdc96gv+SJwwhu9USd89QcVC7mELrjGynWcNzSS3kzrQcZhAWGsiGaUwA0eVc4GXaxE+Ivrp9qJ7DXRGtJx5L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792252666; c=relaxed/simple;
	bh=Y2Xt7HJoEU4cAFF5yXQZtT3aNr+DFa5SnJom/cz+Tso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y65h4wR0bkECE+Ixe/ooxO013pv6aktt55MV3szzdXP03V/BdxJIrVpH4aZMukOh91M6o20NO5Z4+JRu5LMCmlMJM0pxMc3u4fTzndZv4UcBIIhDFwqRrvRAHgvpSLBJ+LgtuKWxPQMStV036+WQ2GfM9nRlbbvtk5QYTvOVcaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B0lwyX+F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B0lwyX+F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D73121F000C4;
	Sat, 17 Oct 2026 15:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792252665;
	bh=twufLCCV2Gfjx3jQ/FpRMEd9wFLOO1FQwpUYSzhfJKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B0lwyX+FlsYwPyewfolawSujDZbLomrl2N3MGaAtAI2CXaNr27yjg9uGlfa2mxBFz
	 /OY5bsXFyc25KsZm3IebN0W+czM1abj83pD6Hf+gUea6ENbj0lc8v5pYW7ow/120yZ
	 n37ZakhdydNcpkU8NYG9xcN5hKTJp4EKRaqRXGH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmed Abdelhaleem Ahmed <ahmedhal@gmail.com>,
	Laurence Oberman <loberman@redhat.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 23/52] scsi: ch: Do not keep references to data transfer element devices
Date: Sat, 17 Oct 2026 17:54:24 +0200
Message-ID: <20261017155105.604736364@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017155104.830766652@linuxfoundation.org>
References: <20261017155104.830766652@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ahmed Abdelhaleem Ahmed <ahmedhal@gmail.com>

[ Upstream commit 27c0f718d3b3c99e6d315308e95d987d0382a8a8 ]

ch_readconfig() looks up the scsi_device of every data transfer element
whose SCSI id the changer reports in READ ELEMENT STATUS, and stores it in
ch->dt[]. scsi_device_lookup() takes a reference, and nothing ever drops
it: ch_destroy() frees the array with kfree(). ch->dt[] is read nowhere
else - it only supplies the vendor, model and revision printed in the same
loop.

Once such a drive is removed, its scsi_device can never be released. It
stays on the host's device list at its address, so a new device there is
refused by anything that walks the list - target_core_pscsi reports
"scsi_device_get() failed for H:C:T:L" - and the low-level driver's module
can no longer be unloaded. Only a reboot recovers.

It shows with any changer that reports its drives' ids; with the mhvtl
virtual library (IBM 3573-TL personality), each create and remove of a
library with four drives leaves four references behind, counted by the
module's use count in lsmod. With ch not bound the count is unchanged, and
with this patch applied it is unchanged too.

Drop the reference as soon as the name has been printed, and remove the now
unused dt[] array. That also removes the array leaked when ch_probe() fails
after ch_readconfig().

The same leak was reported with an RFC patch in 2022, which was not merged.

Fixes: daa6eda65a53 ("[SCSI] add scsi changer driver")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/linux-scsi/20220719075442.6215-1-yanghao_ht@163.com/
Signed-off-by: Ahmed Abdelhaleem Ahmed <ahmedhal@gmail.com>
Reviewed-by: Laurence Oberman <loberman@redhat.com>
Fixes: daa6eda65a53 ("[SCSI] add scsi changer driver")
Link: https://patch.msgid.link/20260929-ch-dt-leak-v2-1-ddda8d635dca@gmail.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
[ sashal: Adapted allocation removal from kzalloc_objs() to the existing two-line kcalloc() call. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ch.c | 30 +++++++++---------------------
 1 file changed, 9 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index fa07a6f54003e..c2c018236517b 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -112,7 +112,6 @@ typedef struct {
 	int                 minor;
 	char                name[8];
 	struct scsi_device  *device;
-	struct scsi_device  **dt;        /* ptrs to data transfer elements */
 	u_int               firsts[CH_TYPES];
 	u_int               counts[CH_TYPES];
 	u_int		    voltags;
@@ -363,16 +362,10 @@ ch_readconfig(scsi_changer *ch)
 			vendor_labels[i]);
 	}
 
-	/* look up the devices of the data transfer elements */
-	ch->dt = kcalloc(ch->counts[CHET_DT], sizeof(*ch->dt),
-			 GFP_KERNEL);
-
-	if (!ch->dt) {
-		kfree(buffer);
-		return -ENOMEM;
-	}
-
+	/* report the devices of the data transfer elements */
 	for (elem = 0; elem < ch->counts[CHET_DT]; elem++) {
+		struct scsi_device *sdev;
+
 		id  = -1;
 		lun = 0;
 		if (elem < CH_DT_MAX  &&  -1 != dt_id[elem]) {
@@ -388,10 +381,8 @@ ch_readconfig(scsi_changer *ch)
 			VPRINTK(KERN_INFO, "dt 0x%x: ",elem+ch->firsts[CHET_DT]);
 			if (data[6] & 0x80) {
 				VPRINTK(KERN_CONT, "not this SCSI bus\n");
-				ch->dt[elem] = NULL;
 			} else if (0 == (data[6] & 0x30)) {
 				VPRINTK(KERN_CONT, "ID/LUN unknown\n");
-				ch->dt[elem] = NULL;
 			} else {
 				id  = ch->device->id;
 				lun = 0;
@@ -401,18 +392,16 @@ ch_readconfig(scsi_changer *ch)
 		}
 		if (-1 != id) {
 			VPRINTK(KERN_CONT, "ID %i, LUN %i, ",id,lun);
-			ch->dt[elem] =
-				scsi_device_lookup(ch->device->host,
-						   ch->device->channel,
-						   id,lun);
-			if (!ch->dt[elem]) {
+			sdev = scsi_device_lookup(ch->device->host,
+						  ch->device->channel,
+						  id, lun);
+			if (!sdev) {
 				/* should not happen */
 				VPRINTK(KERN_CONT, "Huh? device not found!\n");
 			} else {
 				VPRINTK(KERN_CONT, "name: %8.8s %16.16s %4.4s\n",
-					ch->dt[elem]->vendor,
-					ch->dt[elem]->model,
-					ch->dt[elem]->rev);
+					sdev->vendor, sdev->model, sdev->rev);
+				scsi_device_put(sdev);
 			}
 		}
 	}
@@ -576,7 +565,6 @@ static void ch_destroy(struct kref *ref)
 	scsi_changer *ch = container_of(ref, scsi_changer, ref);
 
 	ch->device = NULL;
-	kfree(ch->dt);
 	kfree(ch);
 }
 
-- 
2.53.0



