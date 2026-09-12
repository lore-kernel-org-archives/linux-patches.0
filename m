Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 597F03C276E;
	Sat, 12 Sep 2026 07:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789196994; cv=none; b=pU9SDBMaMQx1DhAUsj/pfMn1xAOcgPDTMhSRfyy8ZndyqZpOD4Ychz5mdHbE1qdDZEnQ5EAaUXzyz26pdyyTYxyWbrtgr4qQZC/VUvvetQhKDMU5eeh0TxlIDd4mqmtfrbCBrsyvjVMZcpvPa8pTiTjZ2kv85kkou/ayc2hX4nM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789196994; c=relaxed/simple;
	bh=C97kC8VXjxV+OJKtNGDb482WufBwSi6AUY0M/GTOnUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=culNUTAmAdewPZhpsnqvcaIY2AvUxMD0iwTH/WeC3XNhEYUpLC8MIbCFVzKaiSyR0cfb1FhlEhO3ByjxpF0K/QUY0nbphSbTC9FaOLQJGgpZKVzDeKpdkkKK8JhyLzCwljnosmtoJEWsBKNvlYQLkei93sOyXZ4p1naJvWRZhC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m6sxU9Xl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m6sxU9Xl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD4FA1F00893;
	Sat, 12 Sep 2026 07:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789196993;
	bh=U37bYaAIZFilD0Qdpa2ZzqGvsy5YLDRj8AEaAz440zk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m6sxU9Xlt8u0ovuMdFpS2o+fWEqycxpU9RvDZ3/R/HbEpdWKh69SJ1ZF6bBfaZjBg
	 fnv5DRYDrmGr+DnazJj9X/j/fTx17JaThC8ayZePzwnv1/i3Zu0NswjlGfzanOWhMF
	 Z/sbJJ8ltO3bgOsQY/YDMtfZ8gufZ+B7NnP3fgww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0078/1815] clk: versaclock7: Fix APLL clock leak on probe failure
Date: Sat, 12 Sep 2026 08:30:28 +0200
Message-ID: <20260912065650.842551302@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit e25d8d35e8cbc1a4c04a8b86eed6aa7229f6449e ]

vc7_probe() registers the APLL with clk_register_fixed_rate(), which is
not devm-managed and must be explicitly unregistered on probe failure.

Most later errors already unwind through err_clk, but a failure from
vc7_get_bank_clk() in the output registration loop returned directly.
That skipped clk_unregister_fixed_rate() and leaked the APLL clock.

Route that error through the existing err_clk label so the fixed-rate
clock is released consistently with the other probe failure paths.

This issue was identified during our ongoing static-analysis research while
reviewing kernel code.

Fixes: 48c5e98fedd9 ("clk: Renesas versaclock7 ccf device driver")
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-versaclock7.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/clk-versaclock7.c b/drivers/clk/clk-versaclock7.c
index adcc603e32593..e3a36dcd98b80 100644
--- a/drivers/clk/clk-versaclock7.c
+++ b/drivers/clk/clk-versaclock7.c
@@ -1197,7 +1197,7 @@ static int vc7_probe(struct i2c_client *client)
 		if (ret) {
 			dev_err_probe(&client->dev, ret,
 				      "unable to register output %d\n", i);
-			return ret;
+			goto err_clk;
 		}
 
 		switch (bank_src_map.type) {
-- 
2.53.0



