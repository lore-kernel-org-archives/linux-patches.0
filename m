Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A99454781;
	Mon, 17 Aug 2026 14:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976466; cv=none; b=gnmwyNwBAHTznlBVs2IpY1fyC4heaVNaf9Zh0mdmRuVZivDS5xV/5jF+oXD44ugkuesvF+7hPH6Pf9LVFuBx9OtJvpts6TAGP19Ibdz+jcPDwxqImMB98J0AH4K9ahCuG7FmT8/JuWu5B4F49LNVAxDZKodloAp6MS5LExsxY/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976466; c=relaxed/simple;
	bh=xO+tQd1Rabs/Vb2xur3cp+KY/6VdRgkc0KRdhuEOqWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c2udMnpPbyRp2qUPc0H3Sn8dcMQARy10iVZsQ/JLUJmPtgtB+p3IoGRFEBt4ajWUcNVkxh/wGeXW8ELbJKmFn5V18S4I3lwH3XLwxtKSU3lJayGG+JAUDG+ROEUNNGPvP/TdzN/bm89+aChdlklTrCOR2Hjs+EFNIf2iBqV3CI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BitTKAtd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BitTKAtd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8484B1F000E9;
	Mon, 17 Aug 2026 14:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976465;
	bh=uh2Tya7Gu97uoTTZxBeRwZ5BGY6hgboWS88vV3F55M0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BitTKAtdpKmjy3KfGleSKcC+f3KSn809FhrIk5oRug8IOLpbXd1KdafEDcP03zZb3
	 vSb/jw5UpWKwYv11dHKj2rB8sczktqXtP/TGXS1SIxrq4T4F2f+PqVUyWnbhAe+lBq
	 QCAWelfx4cmU5cTTEXklGKKQtSzsXrGlnRhKPtFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	John Garry <john.g.garry@oracle.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 5.10 382/389] scsi: scsi_debug: Negate wrapped memcmp() result
Date: Mon, 17 Aug 2026 15:33:41 +0200
Message-ID: <20260817132553.574084333@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3004,8 +3004,8 @@ static bool comp_write_worker(struct sde
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


