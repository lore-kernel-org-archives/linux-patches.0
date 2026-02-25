Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8D664369A;
	Wed, 25 Feb 2026 01:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982968; cv=none; b=Wy6EqRGosfN1EiN6BB6O7J1iL9O2eE9qDSGUT8e2meexWm0I5nvmZd5qGVvhgQCefVW0bpFA6MqW2zuQg1JD9MJzFZc1vHXCcxt5DZ7D7GuFkhGwF7/GDnfszNJ+q7bG8AluocrCJmDnaUirCwMLWITZQoHmcnBEC2yeTpP6o6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982968; c=relaxed/simple;
	bh=6yjWKNKDOgh1xhUthhcifgLIhnHPPdgWFjDfFghJjUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FIodptkYwcHESnIbcY8+J4zBE8P1BIzKtIAJ/zf1A1qB8v6oLdQ5Ovq63ZA/5P9ahyl+ycT6wlsk4r8Gw3bDXG4NLbTdUZ/lISiJv1kFR9BsNWY1CK/bgUJghp4CBFq1BeqLfu5aEkNVOCfHQXj7YKcqeIMQblUeLY8TsnGptQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E4KyyvSR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E4KyyvSR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C6A0C116D0;
	Wed, 25 Feb 2026 01:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982968;
	bh=6yjWKNKDOgh1xhUthhcifgLIhnHPPdgWFjDfFghJjUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E4KyyvSR5Xpojbltst4iBb4oIlNtEw5KTvMbPjtI1mcn3YHPCXwV3WAImgMKn3yaL
	 m0HFM14j/8CB5WpGA35ARlAlTH1le86JTHdPnQaeCduU5qPHt7pDgrujgeGnZmPFZr
	 rtJdebd+JBMmxcQ+xKcQlM6n1FCkcxqQHJnHbl6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Tony Luck <tony.luck@intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 143/781] EDAC/i5400: Fix snprintf() limit calculation in calculate_dimm_size()
Date: Tue, 24 Feb 2026 17:14:12 -0800
Message-ID: <20260225012403.173760870@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 72f12683611344853ab030fe7d19b23970ed2bd8 ]

The snprintf() can't really overflow because we're writing a max of 42
bytes to a PAGE_SIZE buffer.  But my static checker complains because
the limit calculation doesn't take the first 11 space characters that
we wrote into the buffer into consideration.  Fix this for the sake of
correctness even though it doesn't affect runtime.

Also delete an earlier "space -= n;" which was not used.

Fixes: 68d086f89b80 ("i5400_edac: improve debug messages to better represent the filled memory")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Link: https://patch.msgid.link/ccd06b91748e7ed8e33eeb2ff1e7b98700879304.1765290801.git.dan.carpenter@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/i5400_edac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/edac/i5400_edac.c b/drivers/edac/i5400_edac.c
index b5cf25905b059..fb49a1d1df112 100644
--- a/drivers/edac/i5400_edac.c
+++ b/drivers/edac/i5400_edac.c
@@ -1026,13 +1026,13 @@ static void calculate_dimm_size(struct i5400_pvt *pvt)
 		space -= n;
 	}
 
-	space -= n;
 	edac_dbg(2, "%s\n", mem_buffer);
 	p = mem_buffer;
 	space = PAGE_SIZE;
 
 	n = snprintf(p, space, "           ");
 	p += n;
+	space -= n;
 	for (branch = 0; branch < MAX_BRANCHES; branch++) {
 		n = snprintf(p, space, "       branch %d       | ", branch);
 		p += n;
-- 
2.51.0



