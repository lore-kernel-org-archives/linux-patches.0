Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F6E142911;
	Thu, 13 Jun 2024 11:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718278734; cv=none; b=dwbhJ5DKIj5/f4c04jJIkeTsp1gPN1dLD+6EmPB6MSOEPQJRmpoZP5lO7d4UQrKQ3OxmJ/hD8RKuKZD8N/PXmJV5NEdFe76USPhrdmUmu7myS32PW5olN4tQ9vuDHir6aus8BO9mzrPG8avoXDeksbKLaNtki0JIi7TCNUEtl4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718278734; c=relaxed/simple;
	bh=Fs7NsVsFFbSvG4xZfk2xmEzm+xFWPOajxIauiEZbEY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q1z4HZpD8Mwq8sDGg5P+e6xffOa1dSYWLp795OV8VDAqq8vE3iLz1uYaHlPiJ61P7EnT+C9wd6lJCCjo6momx8CF0r2m6Cr5Tr84AK7Y8o9EKhPqjdamBZ9gV/wJEMVppCjal/vxyMZIL123YyxmQFDAua9JvMcRNImrWaaKTPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0y/MPAIK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0y/MPAIK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71084C2BBFC;
	Thu, 13 Jun 2024 11:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718278733;
	bh=Fs7NsVsFFbSvG4xZfk2xmEzm+xFWPOajxIauiEZbEY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0y/MPAIKtRuIm2R0wSmBek33j4GybxZHSKcHQhjQjZFjo6eM6nh5Nmp65Kzmhr0Mz
	 Arqr/lMXhmNwCTbEtWtUo79yyaLpUKK2rTWtuIjPVngLhO57StPFAU31z2w3m4KawF
	 ZaLatspncaU8fjxhhm7zK/y6ZFX0a7zJN7KznajY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 021/213] s390/cio: fix tracepoint subchannel type field
Date: Thu, 13 Jun 2024 13:31:09 +0200
Message-ID: <20240613113228.809110690@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Oberparleiter <oberpar@linux.ibm.com>

[ Upstream commit 8692a24d0fae19f674d51726d179ad04ba95d958 ]

The subchannel-type field "st" of s390_cio_stsch and s390_cio_msch
tracepoints is incorrectly filled with the subchannel-enabled SCHIB
value "ena". Fix this by assigning the correct value.

Fixes: d1de8633d96a ("s390 cio: Rewrite trace point class s390_class_schib")
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/cio/trace.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/cio/trace.h b/drivers/s390/cio/trace.h
index 0ebb29b6fd6df..3a56f11d36e40 100644
--- a/drivers/s390/cio/trace.h
+++ b/drivers/s390/cio/trace.h
@@ -50,7 +50,7 @@ DECLARE_EVENT_CLASS(s390_class_schib,
 		__entry->devno = schib->pmcw.dev;
 		__entry->schib = *schib;
 		__entry->pmcw_ena = schib->pmcw.ena;
-		__entry->pmcw_st = schib->pmcw.ena;
+		__entry->pmcw_st = schib->pmcw.st;
 		__entry->pmcw_dnv = schib->pmcw.dnv;
 		__entry->pmcw_dev = schib->pmcw.dev;
 		__entry->pmcw_lpm = schib->pmcw.lpm;
-- 
2.43.0



