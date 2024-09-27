Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E0817B515;
	Fri, 27 Sep 2024 12:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440070; cv=none; b=oKxAEhTBFTwOXBw1ixlI0/PBwLYDM5dibarMCDRPyI+RbxmAsRPcfFR7eiEOQfuDGos8kVByLXo/PrmDlVrkSqnt+IBDwJU0v/bvwpXPJWwuiZIWar+dlkIZPi8i4UZTTKSn3GkNn1m3n8ZyaHL2MjHVA2ux4ZTDFdD+O1Qd2VM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440070; c=relaxed/simple;
	bh=coIraZ0EF1DMHXeHw7ZFn5siw75tk56s4aEsf1uOHLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OExF1Spvnn4QtbgkoiMvOd0hFwLF/bLnG56sGPTgNZKX21rKrthmuG4Bxc9TGXC8WBBJ7p/P83awSIgSfGAiH+AyOBBLU4dQtL9RsH2Iahcr3nE9AwxpBqgpwhIchdQpXhQvtiQGd73oierrYfv4i4i0JjfNEvCaNG2yKvxt+6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eNzDy/wY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eNzDy/wY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5678C4CEC4;
	Fri, 27 Sep 2024 12:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440070;
	bh=coIraZ0EF1DMHXeHw7ZFn5siw75tk56s4aEsf1uOHLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eNzDy/wYs05ZqepZDNNzDu/yxdgWGsxTx0OUfNTvLkGXPTQUnEkVp37KT1ncIxioM
	 I1hsHr7nNu/HDLm2QR4gj8cSjFe9qG88qbzFLZLOcKVgAUCimr9oOI505bPPi/9BLO
	 rVtWjt5ZwiJZGTPAKHwW6XKfUhC4zEAgGUD4P8SQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sherry Yang <sherry.yang@oracle.com>,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 07/58] scsi: lpfc: Fix overflow build issue
Date: Fri, 27 Sep 2024 14:23:09 +0200
Message-ID: <20240927121719.103103662@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121718.789211866@linuxfoundation.org>
References: <20240927121718.789211866@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sherry Yang <sherry.yang@oracle.com>

[ Upstream commit 3417c9574e368f0330637505f00d3814ca8854d2 ]

Build failed while enabling "CONFIG_GCOV_KERNEL=y" and
"CONFIG_GCOV_PROFILE_ALL=y" with following error:

BUILDSTDERR: drivers/scsi/lpfc/lpfc_bsg.c: In function 'lpfc_get_cgnbuf_info':
BUILDSTDERR: ./include/linux/fortify-string.h:114:33: error: '__builtin_memcpy' accessing 18446744073709551615 bytes at offsets 0 and 0 overlaps 9223372036854775807 bytes at offset -9223372036854775808 [-Werror=restrict]
BUILDSTDERR:   114 | #define __underlying_memcpy     __builtin_memcpy
BUILDSTDERR:       |                                 ^
BUILDSTDERR: ./include/linux/fortify-string.h:637:9: note: in expansion of macro '__underlying_memcpy'
BUILDSTDERR:   637 |         __underlying_##op(p, q, __fortify_size);                        \
BUILDSTDERR:       |         ^~~~~~~~~~~~~
BUILDSTDERR: ./include/linux/fortify-string.h:682:26: note: in expansion of macro '__fortify_memcpy_chk'
BUILDSTDERR:   682 | #define memcpy(p, q, s)  __fortify_memcpy_chk(p, q, s,                  \
BUILDSTDERR:       |                          ^~~~~~~~~~~~~~~~~~~~
BUILDSTDERR: drivers/scsi/lpfc/lpfc_bsg.c:5468:9: note: in expansion of macro 'memcpy'
BUILDSTDERR:  5468 |         memcpy(cgn_buff, cp, cinfosz);
BUILDSTDERR:       |         ^~~~~~

This happens from the commit 06bb7fc0feee ("kbuild: turn on -Wrestrict by
default"). Address this issue by using size_t type.

Signed-off-by: Sherry Yang <sherry.yang@oracle.com>
Link: https://lore.kernel.org/r/20240821065131.1180791-1-sherry.yang@oracle.com
Reviewed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_bsg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 4156419c52c78..4756a3f825310 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -5410,7 +5410,7 @@ lpfc_get_cgnbuf_info(struct bsg_job *job)
 	struct get_cgnbuf_info_req *cgnbuf_req;
 	struct lpfc_cgn_info *cp;
 	uint8_t *cgn_buff;
-	int size, cinfosz;
+	size_t size, cinfosz;
 	int  rc = 0;
 
 	if (job->request_len < sizeof(struct fc_bsg_request) +
-- 
2.43.0



