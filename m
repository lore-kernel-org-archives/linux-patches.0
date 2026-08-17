Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9FBB29B795;
	Mon, 17 Aug 2026 14:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977791; cv=none; b=nAeBRXna43mo+Po6xR1uppoiIIUiyvjC6nlKdE4oIQmYnWyHxw2TR0NO0A8rL9MP7z2hLr7jQkiiJ+yTWPjcNDYj9B616/UDx9EDjZmT5ZTT+OH8aZ2h44AH1/WMISN7Lw783fnsLHekxjcOIV+LKbbf+y6rR+Ea9ILLkkHLL9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977791; c=relaxed/simple;
	bh=9BFWcrzrS4I6+ChEu4Ayo5tsH5FpgBHk+OKPBELOIt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NM3Tc+5/JEA6HmmxiaTnatBuJrPkEThzxr8pa+fhq4DK70FHg8xeqGm+yn6chYfgaRItRcj81+57wnuNfO+EwDZzwHqYiA9A9Bu94mWCVk4KpEgMP7Aqun1ALEWsA3LmKJCizI3s/Icyw0IPAvr1LF4H7/nIR5zZMxSPPa8eWxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yWHHWC3p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yWHHWC3p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A1371F000E9;
	Mon, 17 Aug 2026 14:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977790;
	bh=+fjT1Q1+IS0iyaUUa1qr+759/rA1+bTc1ZMH8S3eh1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yWHHWC3pOEsK6YjKm9uNPhsHFVWZW2NfpQa8FZVCeK49eeVsaCm1Foq0UImngNaEj
	 CiUQECmPyUXIwboe2vZliwFrkD9Ral1u8zhWrxo6ttuST2JCKJt40MD+porrcxEU2Q
	 POfbLudMMztkr0N5eqlXJ8QSk7aeoEbKaiX+G654=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	John Garry <john.g.garry@oracle.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 5.15 452/456] scsi: scsi_debug: Negate wrapped memcmp() result
Date: Mon, 17 Aug 2026 15:34:02 +0200
Message-ID: <20260817132556.703710835@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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
@@ -3005,8 +3005,8 @@ static bool comp_write_worker(struct sde
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


