Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8990BA34;
	Mon,  6 Jan 2025 15:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178543; cv=none; b=TrOCPcZIg8mvgi8iRSLfqnnVf62w01UhiP1pSaISFO1ga5x5lrjN5i5xv20GJ6rYNyPbPOxALgDVz/cba9lUt70U+2gltLL8eWq8f6+lGcFElPjYuf2TkobgFzwdDtCpRyV+LvMKXGd8BA0jBDlzTzVyOHkInS2X3QZyEkEJOA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178543; c=relaxed/simple;
	bh=+pu5My/+TaDMzsZ0yw3IZiTkSOqr8/9ZEwX/wEnFzxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oGXx4JhYdhJWqbSnRk0sLrn/8cZpvsXjpii3cyvEerokKX/FkyXs6Jec7pMWGV6lWaOb+JJ0+3FwyO9pWyhGKHECf9vS56xKtstBhQrgNuiTkRt5IjBPyUPt1/paugwzAGngU2F16awOntqMsJxUz0RLdwViaimNYi4ZRdevtLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QH/ae+CB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QH/ae+CB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F376C4CED2;
	Mon,  6 Jan 2025 15:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178543;
	bh=+pu5My/+TaDMzsZ0yw3IZiTkSOqr8/9ZEwX/wEnFzxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QH/ae+CB9YKYXVuiSxX+PMZMgbeN4lW2vT0gcM1v6QoDGBpz6CWGFLo2kmajQ2y2+
	 XmhREHDn58E7EOGwbqVHSKo1f5BWSTUqjut88bUvj0Qq8h+hJ6DQtVOLyKHUx8/Far
	 fO7zPkRkicbiRsEwyxHkZ8ivThaXACSJjS5bU4EE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangguan Wang <guangguan.wang@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>,
	"D. Wythe" <alibuda@linux.alibaba.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 015/168] net/smc: check smcd_v2_ext_offset when receiving proposal msg
Date: Mon,  6 Jan 2025 16:15:23 +0100
Message-ID: <20250106151139.038818689@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangguan Wang <guangguan.wang@linux.alibaba.com>

[ Upstream commit 9ab332deb671d8f7e66d82a2ff2b3f715bc3a4ad ]

When receiving proposal msg in server, the field smcd_v2_ext_offset in
proposal msg is from the remote client and can not be fully trusted.
Once the value of smcd_v2_ext_offset exceed the max value, there has
the chance to access wrong address, and crash may happen.

This patch checks the value of smcd_v2_ext_offset before using it.

Fixes: 5c21c4ccafe8 ("net/smc: determine accepted ISM devices")
Signed-off-by: Guangguan Wang <guangguan.wang@linux.alibaba.com>
Reviewed-by: Wen Gu <guwen@linux.alibaba.com>
Reviewed-by: D. Wythe <alibuda@linux.alibaba.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_clc.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/smc/smc_clc.h b/net/smc/smc_clc.h
index 986dcd5db3ed..78a94b9122b6 100644
--- a/net/smc/smc_clc.h
+++ b/net/smc/smc_clc.h
@@ -311,9 +311,15 @@ smc_get_clc_v2_ext(struct smc_clc_msg_proposal *prop)
 static inline struct smc_clc_smcd_v2_extension *
 smc_get_clc_smcd_v2_ext(struct smc_clc_v2_extension *prop_v2ext)
 {
+	u16 max_offset = offsetof(struct smc_clc_msg_proposal_area, pclc_smcd_v2_ext) -
+		offsetof(struct smc_clc_msg_proposal_area, pclc_v2_ext) -
+		offsetof(struct smc_clc_v2_extension, hdr) -
+		offsetofend(struct smc_clnt_opts_area_hdr, smcd_v2_ext_offset);
+
 	if (!prop_v2ext)
 		return NULL;
-	if (!ntohs(prop_v2ext->hdr.smcd_v2_ext_offset))
+	if (!ntohs(prop_v2ext->hdr.smcd_v2_ext_offset) ||
+	    ntohs(prop_v2ext->hdr.smcd_v2_ext_offset) > max_offset)
 		return NULL;
 
 	return (struct smc_clc_smcd_v2_extension *)
-- 
2.39.5



