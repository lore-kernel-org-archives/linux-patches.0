Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 318F238DC69;
	Sat, 12 Sep 2026 19:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242326; cv=none; b=JLyQ6YanDmQRHtvLgx1FMA04ntU3fhGhM57AaebEyS1ltlskvkgaTNZmde2/+5RtrLCzKU3Bb4n3r0hQNn0duT7QlASdrcHpfjgLrUpxDpXOeftg+rwxIBJEDR7ItWuVPioAl9qpXOvmXEVjaNaT/TTjNWaiyE90D+f/9D6Koyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242326; c=relaxed/simple;
	bh=WiYLGpwkLgg91d8woskmwI2a9IMly6wIR8+wTuBdu80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IOwnJZaxbeSiRfFOqvIhZM0SwiYXiC/xZPtZaDPbD6H7/ZubG+7j46VPR7FpSZg0kfGABiQPTAkL/K6qdwHu9L1/ZCULfr48qnXCDzLTZwEN1Gt7rtQz78o2JpqLlw+FWfUim+50H/dNTUJp6M6ey0y0sfTGtzYYvX5fGPFGxzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pWxWFtNF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pWxWFtNF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80F031F00893;
	Sat, 12 Sep 2026 19:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242325;
	bh=n2wKpjSIseCHsSResNA3zJ0niU8Yb+xkVV0FAVOXu5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pWxWFtNF80c0hIbbTAyxctkOpgOAaG+wQYkQ1N4cERE4M7Zuzn9ky5fXhsF486ZeQ
	 iECew8S4a9OwRk4s2fgY0v2bsRGQ304FdN16/wKfED3QOo8XQpQCJr5Dwqe7rlEAZg
	 Qc9HKIZfX5vL5sDZHVo4CkACcXxdQcUsUSkvOUqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 364/798] soundwire: qcom: Fix port exhaustion check in stream_alloc_ports
Date: Sat, 12 Sep 2026 08:59:52 +0200
Message-ID: <20260912065525.501793778@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index d4091b6a58d59..1302e463e0a86 100644
--- a/drivers/soundwire/qcom.c
+++ b/drivers/soundwire/qcom.c
@@ -568,7 +568,7 @@ static int qcom_swrm_stream_alloc_ports(struct qcom_swrm_ctrl *ctrl,
 				else
 					pn = find_first_zero_bit(port_mask, maxport);
 
-				if (pn > maxport) {
+				if (pn >= maxport) {
 					dev_err(ctrl->dev, "All ports busy\n");
 					ret = -EBUSY;
 					goto err;
-- 
2.53.0



