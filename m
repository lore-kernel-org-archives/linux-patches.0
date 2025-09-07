Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A886F20E00B;
	Sun,  7 Sep 2025 20:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277668; cv=none; b=p7GiBbCKfPf8I7Z+zSCnA9f6hQ+tLVZVdf5z9MjcG+x48MukcX0eBN9JQQ0HziZVz8nggogChs9zh3bsYBTQTgoMT1df5ivBSLBbL7KJmRh1hMRC9lvYBNMuR4REDFMF6fUPRGC3o178b6pFNnVtTZtlVpw3v4o6H9xJrfOIrSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277668; c=relaxed/simple;
	bh=OKiN3jqzfSyA1OoeSG1OoIu5XsHmrKNb02hf4gWTX5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IbpG/p/DD++YGSpA1UUU685JR7biCW9qlXNvh9FIDI0icn6ZINOnQdVGnhIkT7IJ+taOr54pqHU8/ApzZyJ8A8s01zdgrcWIAFi/IXgZItMnDFWwmQX8KVAgrDXOGHPDbztlGm4+TfqAseK5v6K4yBLJNCELnMCAJ8MBU953BI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=psDtDgz7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="psDtDgz7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28564C4CEF0;
	Sun,  7 Sep 2025 20:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277668;
	bh=OKiN3jqzfSyA1OoeSG1OoIu5XsHmrKNb02hf4gWTX5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=psDtDgz7QBF/3HWKEmheLLUGK68xYSAgJy5/qRz14+nloNviE8+ZgrUQ0XY6g/UfM
	 nsXe8EILtkOrzfqTzaVZzoFWUJiTYq1jzC+U/aV0OdFYoWtt0PFb7CZo0O6FIXhsai
	 +smKXwOCkYiEDcqoSZNrU1x6PLNBiixB5910K8/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 087/183] mctp: return -ENOPROTOOPT for unknown getsockopt options
Date: Sun,  7 Sep 2025 21:58:34 +0200
Message-ID: <20250907195617.858715067@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit a125c8fb9ddbcb0602103a50727a476fd30dec01 ]

In mctp_getsockopt(), unrecognized options currently return -EINVAL.
In contrast, mctp_setsockopt() returns -ENOPROTOOPT for unknown
options.

Update mctp_getsockopt() to also return -ENOPROTOOPT for unknown
options. This aligns the behavior of getsockopt() and setsockopt(),
and matches the standard kernel socket API convention for handling
unsupported options.

Fixes: 99ce45d5e7db ("mctp: Implement extended addressing")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Link: https://patch.msgid.link/20250902102059.1370008-1-alok.a.tiwari@oracle.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mctp/af_mctp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mctp/af_mctp.c b/net/mctp/af_mctp.c
index 9d5db3feedec5..4dee06171361e 100644
--- a/net/mctp/af_mctp.c
+++ b/net/mctp/af_mctp.c
@@ -346,7 +346,7 @@ static int mctp_getsockopt(struct socket *sock, int level, int optname,
 		return 0;
 	}
 
-	return -EINVAL;
+	return -ENOPROTOOPT;
 }
 
 /* helpers for reading/writing the tag ioc, handling compatibility across the
-- 
2.50.1



