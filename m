Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 908AF3BB687;
	Mon, 17 Aug 2026 14:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975361; cv=none; b=IfKjxC3d/uZ6HH1fEIhtCE5xDE13lTh55mTq5ErWKYSNzCPHhiuHKpqaoiwmpWvKPGl6tdg8cKLKM0+iwNCgzNeT3a6heChNtoL99VtznUtYGpZCqe/YA+EsPJWL8XnTDYCQf/8EYKsZIstDeVmUIidZLd0JLDNMJaXo93jG16c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975361; c=relaxed/simple;
	bh=1NFmE1Qpif8doMz2vXdo8/VgZQuQFLY7PL6fRQWVP1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cDv+dKJwH+9NLb1dAnz28sPMUxWL06wDEUUQFzL8LyoTxVE2ewa28R/ppmx2juOxcNeGaDpkynZzxEtlX0XkSExWDrcrJzQ8jCtXTXSe4np61kLwk7oMLGA/ghogdQe8IFw6O+d497HHk21AC2Vn0dBBYjSMzgvHHxJ7dDEorpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mprAQnM8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mprAQnM8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCE771F000E9;
	Mon, 17 Aug 2026 14:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975360;
	bh=tVvwkZ4fctfMGuMGSR+kEYRlNWLHG/lwTuTCQ2oUAXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mprAQnM8YZJR4iUHQW8RVcZTnoxgEpdQh3oJArMsnONx63UdwUFfsa8UIPtcXTTN5
	 lZ2iegOwPbEBSbsXL21MioZNvwn+SJWN2E1QcvOlxCxTdy+YzgsbE77m/fEv5Y5hYR
	 WTe4PyxGMdlzBw+SSUVTc/U5sYaNFKcr/MjT8b8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	John Garry <john.g.garry@oracle.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 6.18 243/250] scsi: scsi_debug: Negate wrapped memcmp() result
Date: Mon, 17 Aug 2026 15:33:24 +0200
Message-ID: <20260817132546.420298563@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

From: Xu Rao <raoxu@uniontech.com>

commit c4f6916a99cf105c3ff340b6210fcbba3fa66b35 upstream.

comp_write_worker() returns true when the compared data matches.
memcmp() returns zero for equal data and non-zero for different data, so
its result must be negated before it is stored in a bool.

The first segment already uses !memcmp(), but the wrapped segment uses
memcmp() directly, reversing the match result. Use !memcmp() there as
well.

Fixes: 38d5c8336e60 ("scsi_debug: add Report supported opcodes+tmfs; Compare and write")
Cc: stable@vger.kernel.org
Signed-off-by: Xu Rao <raoxu@uniontech.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Link: https://patch.msgid.link/E5AD42E9C0E18633+20260803095328.3445311-1-raoxu@uniontech.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/scsi_debug.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4322,8 +4322,8 @@ static bool comp_write_worker(struct sde
 	if (!res)
 		return res;
 	if (rest)
-		res = memcmp(fsp, arr + ((num - rest) * lb_size),
-			     rest * lb_size);
+		res = !memcmp(fsp, arr + ((num - rest) * lb_size),
+			      rest * lb_size);
 	if (!res)
 		return res;
 	if (compare_only)


