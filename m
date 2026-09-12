Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19F542ECE86;
	Sat, 12 Sep 2026 16:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229126; cv=none; b=u/3wavojxe1pCgUgJLC3ZeX56FD6kcPd1xRqXZfYuEu3iGgMQFORcGwR818dNnfzg28KntU94u7VDNZNw7oAacPkqBRVjl6twgjC8suJC4sgDdEMY7ltwvU0lweUToNdWt/MUz8d5hkw+fYQNUp+hZP0I2NAmQw8ScBJtQNVa0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229126; c=relaxed/simple;
	bh=HopyW5iY871guHtby0MifNxmOcyggs+0Jlk3ZIi7Bpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nQCB2aUpBbnnMP03AAB1OODa2fKHqexD69V+/juSavhLWrT9d81LOIyjnA3Qwt3HZgGMMVFU9/RNNC5mRkHAOPfPJXvMJKHwvV1n8wgLezfCjAPS+gGkeWvn7RSWzbAnYVQk0Q3mx3QG01eUgWG6iTlWmzbYAtkkpdodfV8wnE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l47gfdR1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l47gfdR1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEADC1F00893;
	Sat, 12 Sep 2026 16:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229124;
	bh=/gAdFhW3yOibBkAWAbUedwZEhcMpa+q2d0nZ0j70TSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l47gfdR1t30mjEtgl4om9AK3P3tzQHAhMg5B2UUuB0DYC84BrZ8iWYBBUubOXUfqv
	 tpgQj4c8M2aBjFfAys1Tse5yGWvph4FjuRiQh7oxL+wxJnTvl69v4rkbl+ichE5PHs
	 EDVxaROjwDWNoed2x2KEbAqJOiTKExc3bxdJ4w5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0509/1191] soundwire: qcom: Fix port exhaustion check in stream_alloc_ports
Date: Sat, 12 Sep 2026 08:53:57 +0200
Message-ID: <20260912065559.677557178@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a51c8a670d38a..5d2ccccd61722 100644
--- a/drivers/soundwire/qcom.c
+++ b/drivers/soundwire/qcom.c
@@ -992,7 +992,7 @@ static int qcom_swrm_stream_alloc_ports(struct qcom_swrm_ctrl *ctrl,
 				else
 					pn = find_first_zero_bit(port_mask, maxport);
 
-				if (pn > maxport) {
+				if (pn >= maxport) {
 					dev_err(ctrl->dev, "All ports busy\n");
 					ret = -EBUSY;
 					goto err;
-- 
2.53.0



