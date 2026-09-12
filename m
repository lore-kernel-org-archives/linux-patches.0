Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A6F0364038;
	Sat, 12 Sep 2026 09:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206456; cv=none; b=p7fFZmdw2iVBpxJf61EQA9DSj8M1IIe3Auw68FEA9rUWlqf2/0K3dv6rzK4V87EdTKR+nme8e0dROdQJTIvmCQwkFAvU+BvCXpYqArNI2dHn1ZmWawJu8e8jKy7VTISgkOnyOXVj0RszVQsE9CmkBqSnuoKG/LvhaA4xgTvk+IQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206456; c=relaxed/simple;
	bh=e5mLw0NUCTIeyhuAbpez8EyqeLrObmKxsW6Vm5pQdm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZzLMDRjPw5/uRZaU6o4oIedHwgIMbofUaa+aQE2hqjwQJ8EWj5b05L8CK1bTBTSoHH1q2uQVK4E7zq+dITR4j3zLRunbdcUxJol0Yyu8zshPY/z0mN/5PhN5qUJZiqBg0PaP6rvM98A5kJStqXcZlV+97o/eb+bxQA69GNEeg3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HdHPsBhV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HdHPsBhV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE7F71F000FF;
	Sat, 12 Sep 2026 09:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206455;
	bh=req+zCyO3VOTAC6nTceVEbEi6KPVTmg6UE41b/AcU9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HdHPsBhVLdEcOWOMtHKGwW6Uno1hIfkkA1Co1zD1dE/8vY/KZX/hWCrXgLZnky+5V
	 +QnbpNDwGDtMYTjZ0l0fSiE1QP3YnPyg3hrM2xNhclaQf5UWn5GH7NQr4+8IoWJD8v
	 DqEYojwEPLjYxBw1k6wjpjUSR2TcaTgz+Kv0+BhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0184/1518] soundwire: qcom: Fix port exhaustion check in stream_alloc_ports
Date: Sat, 12 Sep 2026 08:39:13 +0200
Message-ID: <20260912065627.653196232@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 5b3078220189b..a4f108fdffddb 100644
--- a/drivers/soundwire/qcom.c
+++ b/drivers/soundwire/qcom.c
@@ -1201,7 +1201,7 @@ static int qcom_swrm_stream_alloc_ports(struct qcom_swrm_ctrl *ctrl,
 				else
 					pn = find_first_zero_bit(port_mask, maxport);
 
-				if (pn > maxport) {
+				if (pn >= maxport) {
 					dev_err(ctrl->dev, "All ports busy\n");
 					ret = -EBUSY;
 					goto out;
-- 
2.53.0



