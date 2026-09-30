Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 025C751CF41;
	Wed, 30 Sep 2026 18:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792660; cv=none; b=c5sMkwXk2gP/erEr5ISvnpThH9EEC22vk1RxPpvcat3SjQcPeVSfo3fsTfKKM8sdeJEH7IsSio2l+jVijcD2BGIf1hkYoglfO86AmQ3B5AHvSMRI2rAqHnJCgPdxtltcP4eGcSs3p/9fp2XvvE6m4TziLohN2WR+KY4xY1K7+W0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792660; c=relaxed/simple;
	bh=sr8ZvCA1Msn7+DUyoNCu4Cg+FllolTRjLS0bG91ytUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eew43h3fttdgWO9kaBcSfolLDwPL3TCdWOYftB4mMng+yyC+Qf/lxeeRHn+ZEh85qk+wH+2Gm1IRIDskA6gr+XkkO5WboA8M820vWUkhms4Y2dNCEzCrsX96DofHoJaQYsO+n51kO5NwdeUrOOfHr8dTITQa264iSY5nVn1tGo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dALlj0R+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dALlj0R+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 331FE1F000FF;
	Wed, 30 Sep 2026 18:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792658;
	bh=Xw/TXG15T5lS2vXm845tBtxbBMDNhF9e+PPkaiQ5PbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dALlj0R+GSSfM1zf7MgSjW2OVTxg6Yy20QSQIFOcpzTEgj+edxn7MRk2QjPbcBTUy
	 qqPmaut2N+9EM5heZBnXjS2a+FQaKCMsV4in7j5r1OziDi8DGCiSbMr0W6MTlRrJPQ
	 rmaKIQTBiYyPHbiLNTlRR4taB6+izr+37a0ggim4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 5.15 732/752] s390/cio: Fix NULL pointer dereference in ccw_device_get_util_str()
Date: Wed, 30 Sep 2026 17:30:02 +0200
Message-ID: <20260930152414.056590496@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vineeth Vijayan <vneethv@linux.ibm.com>

commit 5b76268dac968612f7283d59b539036de955b7d9 upstream.

The channel path registry entry associated with a CHPID may be removed
while the subchannel's PMCW still references that CHPID. In this case,
chpid_to_chp() can return NULL, leading to a NULL pointer dereference.

Add the missing NULL check before dereferencing the returned pointer.

Fixes: 199652309a4d ("s390/cio: add helper to query utility strings per given ccw device")
Cc: stable@vger.kernel.org
Signed-off-by: Vineeth Vijayan <vneethv@linux.ibm.com>
Reviewed-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/cio/device_ops.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/s390/cio/device_ops.c
+++ b/drivers/s390/cio/device_ops.c
@@ -509,6 +509,8 @@ u8 *ccw_device_get_util_str(struct ccw_d
 	chp_id_init(&chpid);
 	chpid.id = sch->schib.pmcw.chpid[chp_idx];
 	chp = chpid_to_chp(chpid);
+	if (!chp)
+		return NULL;
 
 	util_str = kmalloc(sizeof(chp->desc_fmt3.util_str), GFP_KERNEL);
 	if (!util_str)


