Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F2E218BC0A;
	Fri, 27 Sep 2024 12:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727439950; cv=none; b=eQj2GBltJ1xfsk+xrhXKFRdReaFoopduCm3f3BB5Lzs+cRZQ8ucfpS6z5VzEkncEJLtDoIiTArMp+sSjqPCKK1ACxQIudySF0QtkDd5pq38SdZuijqL5gawd4JBTWuJ6/WK1OBadBf/hVTlfkQlXckqezhvsw2tNzlGb8HEhJzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727439950; c=relaxed/simple;
	bh=/QsLe7ubdCplliXcShaptpy/fLq5Sik2LvDl2ZJWhFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nBrc1yRcFlbUAvbD+QM/Wc+k2GAVqjegpKKY20JCShi3bIVPSGILJAvt7NghyJr9+mMO0F79vtaWSfHzvSTt5yyhAsnqhNKBLmi09Tf3IbNN4Ivgx1FEisIVKJkcBzA4vtb+cqraLDrWg3VpzNFZCjSi1D/iQ2TpYxKG3XuHR88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SyImi2zY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SyImi2zY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D9CEC4CEC6;
	Fri, 27 Sep 2024 12:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727439950;
	bh=/QsLe7ubdCplliXcShaptpy/fLq5Sik2LvDl2ZJWhFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SyImi2zY9yccatqKnV3TcYQhxfPgZwFgkWKkcHccJ/ICmRGwIJ700MeWjJXrwjBHr
	 L+gtNP/Q0uQRbOWn88DyuSZaz4pJQq6TeM3K5dQkejgiDb8+4TJqCLsqnJbs6Y7OqB
	 mfIRAh62Z73xi/WR359iS2JjX4bF1kx2x2JQUPbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sherry Yang <sherry.yang@oracle.com>,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 07/54] scsi: lpfc: Fix overflow build issue
Date: Fri, 27 Sep 2024 14:22:59 +0200
Message-ID: <20240927121720.020697510@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121719.714627278@linuxfoundation.org>
References: <20240927121719.714627278@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c305d16cfae9a..0166f86c7b71a 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -5409,7 +5409,7 @@ lpfc_get_cgnbuf_info(struct bsg_job *job)
 	struct get_cgnbuf_info_req *cgnbuf_req;
 	struct lpfc_cgn_info *cp;
 	uint8_t *cgn_buff;
-	int size, cinfosz;
+	size_t size, cinfosz;
 	int  rc = 0;
 
 	if (job->request_len < sizeof(struct fc_bsg_request) +
-- 
2.43.0



