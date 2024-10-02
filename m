Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B00325771;
	Wed,  2 Oct 2024 13:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875182; cv=none; b=tWl9XaJ1jwtsTDy8pNw8wCoOcScCJaZ+NzUHEo1yuUMqyUFVnJPmf6JxR1uZIF6UePfT0z31tEdyPJJqqeX/djAxpghvswsFNL2pNm3WyL6SUomA8h/UYCSmewK3An4E9fB0Q5bS9WQP2uVj+DGM6fdQQBx2RXXvhHJPWO+4Juc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875182; c=relaxed/simple;
	bh=s6oI5Rr8RwBPfKqW+wIoYAX3OvQkEx/NYv2VDCWxteA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m7fHbhctTg/tlgk8xRKKRrPJ2F5TYPhP0xRNU8AdpUj5z+6vmmGqAlUNtM1D+M2PxwwSnnxYF65RyQElVOavjz2RwSBX8zsRwbafZlpc+lQXXJo1ass7NK4K9ZcjHIOI8JYmWGuyQAO86ZmbGH0EryRN2yXtF/g0MK2tf+2uyIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jDM1g7AK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jDM1g7AK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8993CC4CEC5;
	Wed,  2 Oct 2024 13:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875181;
	bh=s6oI5Rr8RwBPfKqW+wIoYAX3OvQkEx/NYv2VDCWxteA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jDM1g7AK7NikqnSn4vPENF+835yKRIvWnFdoMHxyjAK8OCvEHOJhuIwssikuNbY47
	 lV9ndER4q+W7Rlsc6Z+rfnogncCOOWLQnf1hxWpLIjcTQ+h6xGCE5oMtEGXNemXlXp
	 HK4axFb4kKYNsZYIlM6pWupQ5qoVYNnfbCiWvOcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Witwicki <michal.witwicki@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 007/695] crypto: qat - ensure correct order in VF restarting handler
Date: Wed,  2 Oct 2024 14:50:05 +0200
Message-ID: <20241002125822.778185962@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Witwicki <michal.witwicki@intel.com>

[ Upstream commit cd8d2d74292c199b433ef77762bb1d28a4821784 ]

In the process of sending the ADF_PF2VF_MSGTYPE_RESTARTING message to
Virtual Functions (VFs), the Physical Function (PF) should set the
`vf->restarting` flag to true before dispatching the message.
This change is necessary to prevent a race condition where the handling
of the ADF_VF2PF_MSGTYPE_RESTARTING_COMPLETE message (which sets the
`vf->restarting` flag to false) runs immediately after the message is sent,
but before the flag is set to true.

Set the `vf->restarting` to true before sending the message
ADF_PF2VF_MSGTYPE_RESTARTING, if supported by the version of the
protocol and if the VF is started.

Fixes: ec26f8e6c784 ("crypto: qat - update PFVF protocol for recovery")
Signed-off-by: Michal Witwicki <michal.witwicki@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/qat/qat_common/adf_pfvf_pf_msg.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_pfvf_pf_msg.c b/drivers/crypto/intel/qat/qat_common/adf_pfvf_pf_msg.c
index 0e31f4b41844e..0cee3b23dee90 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_pfvf_pf_msg.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_pfvf_pf_msg.c
@@ -18,14 +18,17 @@ void adf_pf2vf_notify_restarting(struct adf_accel_dev *accel_dev)
 
 	dev_dbg(&GET_DEV(accel_dev), "pf2vf notify restarting\n");
 	for (i = 0, vf = accel_dev->pf.vf_info; i < num_vfs; i++, vf++) {
-		vf->restarting = false;
+		if (vf->init && vf->vf_compat_ver >= ADF_PFVF_COMPAT_FALLBACK)
+			vf->restarting = true;
+		else
+			vf->restarting = false;
+
 		if (!vf->init)
 			continue;
+
 		if (adf_send_pf2vf_msg(accel_dev, i, msg))
 			dev_err(&GET_DEV(accel_dev),
 				"Failed to send restarting msg to VF%d\n", i);
-		else if (vf->vf_compat_ver >= ADF_PFVF_COMPAT_FALLBACK)
-			vf->restarting = true;
 	}
 }
 
-- 
2.43.0



