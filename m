Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDA5C16078C;
	Mon, 27 May 2024 19:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836439; cv=none; b=ITYFM2ukA0oAmjA6y7w9r+DjfUesyTYYCbpFZAyABYOnFWzSpiw4Pd1jERIETcdaVaiTvOKklMleS1uQ1KQugqlCvPvfSqElqCgbng9a1/4A3B+r7P5RRK3Ot1CWq3/DL8bXRA6PEmCnBw8dFhIeUDuQU3w3wxMoU49HEwcbNI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836439; c=relaxed/simple;
	bh=g+inkaegOasDVJXw5jfe3BKzlx016vOrzNzdfvPLQ0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U5esQfa3W3YA+vB8XWsxGjN6rFSo1fPF5Ljhf+jiNxbWmCSCcppqipzTFPUM6t01XAFl9wBPVREjfbGBkvYmlPxR7ZXfqFVyGAqR4sAPlUH2K/9sMG5IeP1f3MBZN1kFEGU2m/gwhVeZF4aBnCeDiGfqPQOka44qnDzJqOSMMSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nVH2O30g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nVH2O30g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8307C2BBFC;
	Mon, 27 May 2024 19:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836439;
	bh=g+inkaegOasDVJXw5jfe3BKzlx016vOrzNzdfvPLQ0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nVH2O30gtc1xSTGfjPrzKcSR7ysP1bTRgaAeLqQngJ3QNmE7LtxkLLPQ1giahpm8Q
	 3JsD84BOjaKNrsUsNDMWDKBWdRn9LlPOX0JMtDTxH6Dek+1jnjD+o0GJiltpb5qc4u
	 GUDCP+Q8g44WNNGNYYek+CQzIrbeC/a1E96N8sCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 055/427] s390/cio: fix tracepoint subchannel type field
Date: Mon, 27 May 2024 20:51:42 +0200
Message-ID: <20240527185606.952054698@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 86993de253451..a4c5c6736b310 100644
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



