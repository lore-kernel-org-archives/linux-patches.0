Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21F2F4C042D;
	Wed, 30 Sep 2026 19:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790797107; cv=none; b=mf2ExGmY3tBkvVk/eBfOhR1yJTenhuGvMOa0D70KWSH/GEONOnZaIeA5raTvxs4gQcFCGEuqHracvry2It3ZpfkCxV4FJ0R3+R1/SoVT6uKLv4Nt/zmBmpzmkSArM7ZatpNcnessmGTABzB3gIXA9zrpQJbs1WDZLAm/HUbzDis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790797107; c=relaxed/simple;
	bh=kM1OTiuH6GfXzWx/zSKqgDRUldT1dqL+6CS/RQC2SZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IXCza6zCtIGYEqopDCHLETgoFXJL1uUNIe6nmP/aUS6rNstuqw3f0bMX49naNKIqhh2wB5c254AvFNUGKiwH9dbg7yHbOPvIwwODbEke3kh/mwwA6FXyGxaOTXEdk4nVtzqBpSXXL9vMHIQOVrppmxp4eqii/xOE3JbztjbajwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iyGO0e/w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iyGO0e/w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 331C11F000FF;
	Wed, 30 Sep 2026 19:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790797105;
	bh=B9FzMFykVFUAdo0aolshM2fFLI8kPet171MFlvCvOKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iyGO0e/wmDO8vdGegn2J1jyFecQMPJOV7vYSxzxHvpSnYN9ca+c9Xu9LGXGnP00KE
	 +ErESFjMdNFDibvTk6ggm2MHbxjEyhXeq/RH2ftJa/Z1t0Tb0J9lsaNWTeoIKGYC7A
	 C1oA2ILhIwiJyCf1SIKTR2m7q4WRVPLW8kshIMsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.6 1142/1193] s390/cio: Fix NULL pointer dereference in ccw_device_get_util_str()
Date: Wed, 30 Sep 2026 17:30:26 +0200
Message-ID: <20260930152459.610998283@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
@@ -513,6 +513,8 @@ u8 *ccw_device_get_util_str(struct ccw_d
 	chp_id_init(&chpid);
 	chpid.id = sch->schib.pmcw.chpid[chp_idx];
 	chp = chpid_to_chp(chpid);
+	if (!chp)
+		return NULL;
 
 	util_str = kmalloc(sizeof(chp->desc_fmt3.util_str), GFP_KERNEL);
 	if (!util_str)


