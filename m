Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9251917FD;
	Thu, 13 Jun 2024 12:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282339; cv=none; b=A//ga0gT+utLL6Li57sPqtbN8bOgAcavq//OMcpndZeXgKlGVxxEleC3NH0TKDb7XxZNfcrRy/YXoBY1SC1DkziN9LWaUcXoBQU4GaKZKcb1XmjRqHeMvxgnPYDvRMT/1Z4G6MCsj520HVD6eLMEPSh8Eb4ogxBJyYp+GsrdCps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282339; c=relaxed/simple;
	bh=soAMKqL7KvU9TIC0P1m8Hebq6hR9XL5Yzm1uq4Y12zs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CVgh9JLY9YWGtdDpRzuj8ds3GCTqpdrYzTCt0t1bJzsUnhCXMCnQ1JD5BxJTUTdilyiYtz4FJnbHMnUGXZbkkIxgzk8dQaQcOpMc+LHTY8PM/ZI86BWbhfot81JR+nx+xRNBSJeiG2yZTPKqd665oTw8kXiBvScGITEUa9zRJpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a4hBvSPJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a4hBvSPJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 188EFC2BBFC;
	Thu, 13 Jun 2024 12:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282339;
	bh=soAMKqL7KvU9TIC0P1m8Hebq6hR9XL5Yzm1uq4Y12zs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a4hBvSPJzwRjPjmY+zd2IUPy2AjsYl5u5DV7LlfhV/soXUsyWdETBaE62/aefqPPt
	 MuChpyxRuNLI0P8BalcHVrmfflxjjh7LFDhlC0q/2bYC1/5TAlkiEXNr6hJVN3u8o+
	 Kl/8+FU081u7yxuJo15uts6jaMFBZ6i12XmgvKVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Egorenkov <egorenar@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 243/402] s390/ipl: Fix incorrect initialization of len fields in nvme reipl block
Date: Thu, 13 Jun 2024 13:33:20 +0200
Message-ID: <20240613113311.628119535@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Egorenkov <egorenar@linux.ibm.com>

[ Upstream commit 9c922b73acaf39f867668d9cbe5dc69c23511f84 ]

Use correct symbolic constants IPL_BP_NVME_LEN and IPL_BP0_NVME_LEN
to initialize nvme reipl block when 'scp_data' sysfs attribute is
being updated. This bug had not been detected before because
the corresponding fcp and nvme symbolic constants are equal.

Fixes: 23a457b8d57d ("s390: nvme reipl")
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Egorenkov <egorenar@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/ipl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kernel/ipl.c b/arch/s390/kernel/ipl.c
index 834b1ec5dd7a0..77246ff5b0141 100644
--- a/arch/s390/kernel/ipl.c
+++ b/arch/s390/kernel/ipl.c
@@ -833,8 +833,8 @@ static ssize_t reipl_nvme_scpdata_write(struct file *filp, struct kobject *kobj,
 		scpdata_len += padding;
 	}
 
-	reipl_block_nvme->hdr.len = IPL_BP_FCP_LEN + scpdata_len;
-	reipl_block_nvme->nvme.len = IPL_BP0_FCP_LEN + scpdata_len;
+	reipl_block_nvme->hdr.len = IPL_BP_NVME_LEN + scpdata_len;
+	reipl_block_nvme->nvme.len = IPL_BP0_NVME_LEN + scpdata_len;
 	reipl_block_nvme->nvme.scp_data_len = scpdata_len;
 
 	return count;
-- 
2.43.0



