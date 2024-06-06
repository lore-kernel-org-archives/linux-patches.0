Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0174019643E;
	Thu,  6 Jun 2024 14:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683160; cv=none; b=bRFNWy/7SzOO0l+0TYfemBAbX84YCHT9xVnBN3kt+ceajdi5fSZNGnVE59sXB0xW+zfoG4KX5QWrD/Cda967un6MWcxP8Dc7VMpATHJT6hnzZmEawVpqwlHr+yTcRNpxX6PEoja4fIYTTJe/WqU2zotU86nqeeAoRFmM+p45dck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683160; c=relaxed/simple;
	bh=7bSnmqHEi1/iLttpDpncMz1u7wSA0cJ/Z4RHKhbF2OE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i6R/jsX3rF4Dqgh61xcRvQhen3AaADdLinW5yvhqikh8GFNJDNEA8T1KgWW4jqAAOGplX4YrcuSmovhRpAjzfIou/8V3uX1BJFynj4t1mR1l/pTUjCyogn/oJ81QjKhdDKO5q/TZpjZ112l0cNxf6nP7+k3MR7qfqNOL9rUCBMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wZfVBBIc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wZfVBBIc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7871C2BD10;
	Thu,  6 Jun 2024 14:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683159;
	bh=7bSnmqHEi1/iLttpDpncMz1u7wSA0cJ/Z4RHKhbF2OE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wZfVBBIcvEnjI1gMbdnxjDfluCgYkRtrRvdTu1ShZjv7PggJjCVlNx9XLyj3nooyN
	 rhumrRUNljLbsEgAFhzRMLILOYuFZFaeahohkHA7KZR46Ov959Aq8DpPA4WNDAhnAs
	 KrUl3OQo7+ao3MrsA9bvyQk0OAJCJGCkGp0kG3TA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 104/744] s390/cio: fix tracepoint subchannel type field
Date: Thu,  6 Jun 2024 15:56:16 +0200
Message-ID: <20240606131735.729796282@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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



