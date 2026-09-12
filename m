Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C045E3AEF51;
	Sat, 12 Sep 2026 12:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214740; cv=none; b=jGZGTDPkACqEbTUomhAokDvqTtX0aLnb556Ir3RVQX/SLiLhE2zd2jOc3cPi+U4h5aSxmO/94xxcnr8Afyhpd7oPHDquxppiGPFlDukvdFdw9aL5nDV5G/df7XkggH1Yz3ieqYpIuEj1c2kHpbNKlqXqD2Ndh174r5zquv63OCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214740; c=relaxed/simple;
	bh=dV4+K9JZ278+9rI+Q4VCWOyXoClW+TXS74iwsjcJFvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dj4NZQsh+AX2MYLbjAcPIT/SP1FD7SFNvSd7HSC9Lkb0VKcMIXvPwamm1lb3PQ7HICw9CjJ5Ejr0O4jlb8+gtIRGv35n9MIgxhSF6yYHdU4KV9SzLAIhfUHxFs75+XqLrWuFH7XLWIP8EuwWZMr2FEZdbYcplMsCzxCTzMdGhjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tD9AHPWc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tD9AHPWc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6B3C1F000FF;
	Sat, 12 Sep 2026 12:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214739;
	bh=G8J9iRvf9BjcW02lUE5AQOAixmHF7HlFDC2cb2E+CKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tD9AHPWc1ij4N6fj4P4f45lxumJKdo+xygrnph43wq8GRwQ2UMcQ9ws78UdoY8Ig8
	 axeg1zqG5ZSHWQdfrdfDkIhAsKSM1BBklA0CaHcZJJ3/Y3HjP0rF9M6r0aTnhcNkTH
	 P5nick1BFHbb7SRWeMyhLv8eDum+pYiJF+4Qmbwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0389/1376] soundwire: qcom: Fix port exhaustion check in stream_alloc_ports
Date: Sat, 12 Sep 2026 08:46:55 +0200
Message-ID: <20260912065616.216457321@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>

[ Upstream commit 6ccec91c3535b07310e12d32fe9c67ff8d31d965 ]

find_first_zero_bit(mask, n) returns n (not n+1) when all bits are set,
so the guard `pn > maxport` is never true on exhaustion.  The driver
would silently call set_bit(maxport, port_mask) and assign the
out-of-range port instead of returning -EBUSY.  Fix the comparison to
`pn >= maxport`.

Fixes: 02efb49aa805 ("soundwire: qcom: add support for SoundWire controller")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Assisted-by: Claude Sonnet 4.6
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Link: https://patch.msgid.link/20260701193006.4113-2-srinivas.kandagatla@oss.qualcomm.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/qcom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soundwire/qcom.c b/drivers/soundwire/qcom.c
index aed57002fd0e6..db7c8fb04f117 100644
--- a/drivers/soundwire/qcom.c
+++ b/drivers/soundwire/qcom.c
@@ -1204,7 +1204,7 @@ static int qcom_swrm_stream_alloc_ports(struct qcom_swrm_ctrl *ctrl,
 				else
 					pn = find_first_zero_bit(port_mask, maxport);
 
-				if (pn > maxport) {
+				if (pn >= maxport) {
 					dev_err(ctrl->dev, "All ports busy\n");
 					ret = -EBUSY;
 					goto out;
-- 
2.53.0



