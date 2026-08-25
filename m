Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40B7845DF6B;
	Tue, 25 Aug 2026 13:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665682; cv=none; b=c3VeFgOlysU6M8H9XbUoDN3C/mSSm8dcB4e3vkO6w2bKUW9eIZ6imgdqEdCksyFqhpzaMGdCt0XZUvw2zrL8dkp56Lt7+tGozn/61E6ucXxhVsEFiNq7LvzKGNNG9Vi1/SYZryI9Pir08s+D/0kh0kTPFuxWnSlz7qzSxnI0r/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665682; c=relaxed/simple;
	bh=2l4Ds7SGUngoNogZfGtG3pT7YEzi/BODkEau/ioQeEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AxJeaemR32red2imDM5smT7hTL1nW7a0KbJdsi+vmZh5H0tF6n+qsmwvq2lsQ99BlNm4mwN7oKtbsLHJ7fKRvulNdVVDRRlM8GBoZ6VErU+l6/InbF+PuDesZC5hr0DcGUBEQRamQpD6qu8LUZu5d54vNS18tvC5273cQHKyr3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZcflAqHN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZcflAqHN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ADD01F000E9;
	Tue, 25 Aug 2026 13:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665680;
	bh=M5qK/Nps8RQgoGcDs2O1wpTf0tQkDIGZaIePFjogUSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZcflAqHN0HND8oyowf0FNqIkpRmB/UxFI+Dmw+SkRCESbd2CHRFwoCur7P86DB9x7
	 l9D4/ntrKolL0y3t8OBd2Htz4WVtOXytOu9GRfDUasByKVf0OqG+N9wXJTXhYSWNz0
	 NRMnHRaDiBcsXWvOcyuHSMB178sfQ39Ku4y7PFaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [PATCH 6.6 31/87] s390/vfio_ccw: Ensure first IDAW remains constant
Date: Tue, 25 Aug 2026 15:25:54 +0200
Message-ID: <20260825132543.069788359@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.813800447@linuxfoundation.org>
References: <20260825132541.813800447@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Farman <farman@linux.ibm.com>

commit 565bef268d75bf7df665bce6923a88cd0eb74592 upstream.

The first IDAW in a list does not need to be on a 2K/4K boundary
like all others, and so is read separately to accurately calculate
the size of the buffer needed to read the full IDAL.

Verify that the address found in the first IDAW is unchanged between
reads, to ensure a consistent set of IDAWs being worked with.

Fixes: 01aa26c672c0 ("s390/cio: Combine direct and indirect CCW paths")
Cc: stable@vger.kernel.org
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Eric Farman <farman@linux.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
[farman@linux.ibm.com: resolved merge conflict]
Signed-off-by: Eric Farman <farman@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/cio/vfio_ccw_cp.c |   16 ++++++++++++++++
 drivers/s390/cio/vfio_ccw_cp.h |    2 ++
 2 files changed, 18 insertions(+)

--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -521,6 +521,7 @@ static unsigned long *get_guest_idal(str
 		&container_of(cp, struct vfio_ccw_private, cp)->vdev;
 	unsigned long *idaws;
 	unsigned int *idaws_f1;
+	u64 first_idaw;
 	int idal_len = idaw_nr * sizeof(*idaws);
 	int idaw_size = idal_is_2k(cp) ? PAGE_SIZE / 2 : PAGE_SIZE;
 	int idaw_mask = ~(idaw_size - 1);
@@ -537,6 +538,18 @@ static unsigned long *get_guest_idal(str
 			kfree(idaws);
 			return ERR_PTR(ret);
 		}
+
+		idaws_f1 = (unsigned int *)idaws;
+		if (cp->orb.cmd.c64)
+			first_idaw = idaws[0];
+		else
+			first_idaw = (unsigned long)(idaws_f1[0]);
+
+		/* Unexpected mismatch from earlier read */
+		if (first_idaw != cp->guest_iova) {
+			kfree(idaws);
+			return ERR_PTR(-EINVAL);
+		}
 	} else {
 		/* Fabricate an IDAL based off CCW data address */
 		if (cp->orb.cmd.c64) {
@@ -598,6 +611,9 @@ static int ccw_count_idaws(struct ccw1 *
 		iova = ccw->cda;
 	}
 
+	/* Save the read address for later */
+	cp->guest_iova = iova;
+
 	/* Format-1 IDAWs operate on 2K each */
 	if (!cp->orb.cmd.c64)
 		return idal_2k_nr_words((void *)iova, bytes);
--- a/drivers/s390/cio/vfio_ccw_cp.h
+++ b/drivers/s390/cio/vfio_ccw_cp.h
@@ -35,6 +35,7 @@
  * @initialized: whether this instance is actually initialized
  * @guest_cp: copy of guest channel program
  * @ccwchain_count: number of channel program segments (linked by TIC)
+ * @guest_iova: first data address of a guest channel program
  *
  * @ccwchain_list is the head of a ccwchain list, that contents the
  * translated result of the guest channel program that pointed out by
@@ -46,6 +47,7 @@ struct channel_program {
 	bool initialized;
 	struct ccw1 *guest_cp;
 	unsigned int ccwchain_count;
+	u64 guest_iova;
 };
 
 int cp_init(struct channel_program *cp, union orb *orb);


