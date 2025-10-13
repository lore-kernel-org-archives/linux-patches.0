Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA69324A044;
	Mon, 13 Oct 2025 15:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369591; cv=none; b=cVhCQCRUqEfB9KyZ/Y+/4zqEx6iIq2fM8GicmyqKnW+yy4GC6eNhHfuc1ZIwUO19spfNIMG7sfHlexDr/O/XDcoG2w8DjTOernK2r3RSN367LifclU0YBBeRaJFc/bie/D5dFvNu7gpLKDgGCRTsAqK5WC1Dj9OKVVPTD3oM5tY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369591; c=relaxed/simple;
	bh=orfqyxblrQo66zjaX2nEqAaa+yEk4+Uar8A8lOh6nyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xsmam0WHDCMnWvJUISuvtfqx3d4Kv7aDkGIlT7JD+6zD3fAN1P/QJypKMva+YeK445uEGFeM3Zg3e0szBrJzfljqXTwCLf0juKv/1FH8QSvjpLwC8diyPIt+jD0CBVJ0mQ92cZcAfZMvhh5tNA875Spr2+e9oiOXJGoVnN69+aE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=azSjcI5k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="azSjcI5k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 554BBC4CEE7;
	Mon, 13 Oct 2025 15:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369591;
	bh=orfqyxblrQo66zjaX2nEqAaa+yEk4+Uar8A8lOh6nyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=azSjcI5kY1tk9/RZAdyOtYIGLg67oa0TCUMka4U7is8/rD8KOTqCy4DI4iuatKFiK
	 2qQ6Pxm96hauSW4s5EhwdItR68BA1d9rODFHzEo0Moju7KYpcfVzcbAj7c0dtrGKzr
	 4LAyTeZxMvEpWqAd514GBA5WeqsUgVR/5uM76U9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@linaro.org>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 299/563] coresight: trbe: Add ISB after TRBLIMITR write
Date: Mon, 13 Oct 2025 16:42:40 +0200
Message-ID: <20251013144422.100401787@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Clark <james.clark@linaro.org>

[ Upstream commit 52c0164b2526bce7013fca193e076f6d9eec9c95 ]

DEN0154 states that hardware will be allowed to ignore writes to TRB*
registers while the trace buffer is enabled. Add an ISB to ensure that
it's disabled before clearing the other registers.

This is purely defensive because it's expected that arm_trbe_disable()
would be called before teardown which has the required ISB.

Fixes: a2b579c41fe9 ("coresight: trbe: Remove redundant disable call")
Signed-off-by: James Clark <james.clark@linaro.org>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20250609-james-cs-trblimitr-isb-v1-1-3a2aa4ee6770@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-trbe.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hwtracing/coresight/coresight-trbe.c b/drivers/hwtracing/coresight/coresight-trbe.c
index 8f426f94e32a1..f78c9b9dc0087 100644
--- a/drivers/hwtracing/coresight/coresight-trbe.c
+++ b/drivers/hwtracing/coresight/coresight-trbe.c
@@ -258,6 +258,7 @@ static void trbe_drain_and_disable_local(struct trbe_cpudata *cpudata)
 static void trbe_reset_local(struct trbe_cpudata *cpudata)
 {
 	write_sysreg_s(0, SYS_TRBLIMITR_EL1);
+	isb();
 	trbe_drain_buffer();
 	write_sysreg_s(0, SYS_TRBPTR_EL1);
 	write_sysreg_s(0, SYS_TRBBASER_EL1);
-- 
2.51.0



