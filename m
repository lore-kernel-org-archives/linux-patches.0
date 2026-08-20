Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B901374E5A;
	Thu, 20 Aug 2026 16:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243321; cv=none; b=euSu2Ea8XA3pty4kLnPZqKkfGT8BZ7mCM6YpPzAU2esRwqDNmXKoIye4F0XS7dq1fUYwhhEVoxM8rkLeXUM1erB726rU0c+8bI7PZUSN1PGynDIblGl0CHZVIfO85CdC8OZB+/ncsacYPiMpXdjPCJAJU4tOxfjCkDsHHdRZDLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243321; c=relaxed/simple;
	bh=4JaqX3/pJd+Vjxf63kzj8Dg49RaOR3In33YBe/Go20g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FSmji/FU7P78ASF6B+BPcM6mDwsFWhO/uoIMG4oCBfJ7Haocv6YugF/Nf6+YgoKO9MGtixLGjMb0w22eu5LLjjZ1n0eFbBQAF4mkAkfDe/7Rm3uJBhutzBC5iCAgDbZnQ2h9enS5xu91bWizs03GwWoeAv27WTCTsCCO57RAlug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Llni5Zqv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Llni5Zqv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A82C21F000E9;
	Thu, 20 Aug 2026 16:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243320;
	bh=t0pj1fS2P6A31uLorrfw4L2mf+xHiY5X/RXqT92/t4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Llni5Zqvmd3F3eV/KdiiYwo34/xR4sImU/cWEHmB9ZkwSz/roKbfrgBl2BUnVjd7y
	 dzyAeV+YmqwVdmpUkxP/xEeyWPxbuoEVku1H7owTkwI1C1Ys+GLJonNvyaWFair6rI
	 Hk7AxR4AsUUAcnxLNVrlMKM8ZZN4qOcYmyJoTLHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 054/272] i2c: davinci: Unregister cpufreq notifier on probe failure
Date: Thu, 20 Aug 2026 16:53:58 +0200
Message-ID: <20260820145232.835189788@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

[ Upstream commit e43f32816a1b1fe5a86279411626fe3a9be56d45 ]

davinci_i2c_probe() registers a cpufreq transition notifier before adding
the I2C adapter.  If i2c_add_numbered_adapter() fails, the probe error path
releases the device resources without unregistering the notifier.

Add a dedicated error path to unregister the cpufreq notifier after
i2c_add_numbered_adapter() fails.

Fixes: 82c0de11b734 ("i2c: davinci: Add cpufreq support")
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Cc: <stable@vger.kernel.org> # v2.6.36+
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20260610030513.2651018-1-haoxiang_li2024@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-davinci.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-davinci.c
+++ b/drivers/i2c/busses/i2c-davinci.c
@@ -874,13 +874,15 @@ static int davinci_i2c_probe(struct plat
 	adap->nr = pdev->id;
 	r = i2c_add_numbered_adapter(adap);
 	if (r)
-		goto err_unuse_clocks;
+		goto err_cpufreq;
 
 	pm_runtime_mark_last_busy(dev->dev);
 	pm_runtime_put_autosuspend(dev->dev);
 
 	return 0;
 
+err_cpufreq:
+	i2c_davinci_cpufreq_deregister(dev);
 err_unuse_clocks:
 	pm_runtime_dont_use_autosuspend(dev->dev);
 	pm_runtime_put_sync(dev->dev);


