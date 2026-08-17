Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5678B3DD851;
	Mon, 17 Aug 2026 14:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978761; cv=none; b=YFrupthiIUnnGd7Bhss8VoOna6FX5YUXhrkWbGyhs1qucwLh3YX30C0uUH00VRaTsUmeQdrcKthD7WfceIM/PJHx6jLoqrNww1pMXbdm59WhUKsI7Ief1pxarfw/R8XTy3KQJTAjYcUpNp2YvakItKg7Hah/d5ZyJVsvGzZghSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978761; c=relaxed/simple;
	bh=sIAb7zQY9aIG7MxCqinUez+uJPfkKjmHe+FBzXYC+eo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UNyKw6f72qBfi/In3oHas287ql4QOa52GO4SjKtmuhTgwoDCONtVhejoh+FADNHhoonYmGffK/MmF0krr2gE6ECkQtQ14HenXfVFYl/YPMF6kS+QWsn1MajNogDBWUwWD+nqy2YIF0jo9kePEDZL9U8F8adTqiFTze3Oc7MYOvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V5UsCJe6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V5UsCJe6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B041E1F00A3A;
	Mon, 17 Aug 2026 14:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978760;
	bh=8l9GWySKVYEg7zQVt0HROn4SCWFbPY3hR0pgbuPSptk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V5UsCJe6+Hz1OIuKSzFQN8uETMu8UBA7B+jiXJZlaz7fWjl2e/oAAB7RHToYvq5G0
	 C4gtgCIjXqJSkHA4dHtUBPYIBA6hZrp5NAxdUJ3sBdJysx5sEfSnjuq2TeFT5n2QRz
	 kUq+Ji8Rc+6KmnkK7srVnjZas1RD0CSv+UCsdi0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	John Garry <john.g.garry@oracle.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 6.6 148/156] scsi: scsi_debug: Negate wrapped memcmp() result
Date: Mon, 17 Aug 2026 15:34:42 +0200
Message-ID: <20260817132540.528127491@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132534.666299318@linuxfoundation.org>
References: <20260817132534.666299318@linuxfoundation.org>
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
@@ -3077,8 +3077,8 @@ static bool comp_write_worker(struct sde
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


