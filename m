Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BEEC145B10;
	Thu, 13 Jun 2024 12:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280774; cv=none; b=b5Qi9VcGRTnqfOU0ahKhkplf+wZLjmvSwp20JOy/h6bd/JQ9rkAbIAVqRE8OZSbGedzSG9TmpfGiSOT9y9CEzQeMZncVKqw91xYaWrStQCj7bKRS0J2dsPTfV4F2HBa9NqzTK6uGg+zF3XXG4kY025x4FU51QYt/9+CUgyG2sOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280774; c=relaxed/simple;
	bh=Jjl0KzdrnKIRoI7e9+4KNNwjnW5v86RH6UKr9V9TSBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EjnhYOcbsGYknRgbd/sp4Pb4bbTLIeoUsPmbBqVWdtlc5BsQywn4Gr3LQnYQXfqndgzzpBKyknkKjj+4cqgrO11+fwOnJy93gSKkezd4HWcj8KRO43TOaOZIWHRjQwn27rKT89cpiAT3vFoqsivOFvgvBl6WzVkz0qVmLrikwWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SnHw4zye; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SnHw4zye"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 791A8C2BBFC;
	Thu, 13 Jun 2024 12:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280773;
	bh=Jjl0KzdrnKIRoI7e9+4KNNwjnW5v86RH6UKr9V9TSBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SnHw4zyeg1FsSbYocJ3C6iQFeydQW/VkY3DFPR5RuQv+cH+oauzjdsfmG2OltME+B
	 Ks4vRAq7qPEdP3YDpIOvrIPVPaqc07zmk4zCXqEN+HSM6oNvm+2qs6B757+/+TDJ81
	 UROvehy72rquz7bkq3BjX8oJI9cKe51dlBxxhej8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 029/317] s390/cio: fix tracepoint subchannel type field
Date: Thu, 13 Jun 2024 13:30:47 +0200
Message-ID: <20240613113248.668327809@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 4803139bce149..4716798b1368a 100644
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



