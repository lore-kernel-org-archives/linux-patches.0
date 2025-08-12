Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E505E1C1AAA;
	Tue, 12 Aug 2025 19:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025267; cv=none; b=npU6tNQHDUu34/FrnnJe43HN8Y713vvup6c3TBBCCEc3gXN/kkKANjqKMrRlQYjF+CmfRgANyCTtb+p6gB/LGoAZpEpORb2PpS3BxU+/2TDRkyCpirBhSR4Nj1NT8Eu5L04qEZkCiRn1HBGh29bATXqgzuqCYf1Ukv92wVAvT4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025267; c=relaxed/simple;
	bh=eDMfVFYboCOhBz0suZXX4ZEB1uxC8NZSEVyy3ivbMMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BDWSNrNGS1MaLJFsF0ZZLDE5QKOhrlqwGT9YGFBrSSs72foybHeiPd8RS3jkPnUWdqBNJkN91dOWRAGybwfE48dSujLLaZv/cDCE8rlrxVEUlYd3u3TadZZxtJoJfWoFZckba4AQPBM4NYFYv3x1BdTEj3TZzlpT6T0QEFHE4xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kp6eSfcE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kp6eSfcE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C138C4CEF6;
	Tue, 12 Aug 2025 19:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025266;
	bh=eDMfVFYboCOhBz0suZXX4ZEB1uxC8NZSEVyy3ivbMMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kp6eSfcEZ1HASKCP6uqqpjMDD+AmNF2Ql+AwEVu923qkmsytatPWOqjx71pgWBCgI
	 szFcXI0OQLTtewZ0w18T7M7VhdmCfQs+wyE9OY3dsmwsGohisayiDS/SpmhyXOwXnE
	 xHsdzsWGf6JfAa5XXlGIXmc09QYMS4/ao51RCyRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Murphy <robin.murphy@arm.com>,
	Shouping Wang <allen.wang@hj-micro.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.16 618/627] perf/arm-ni: Set initial IRQ affinity
Date: Tue, 12 Aug 2025 19:35:13 +0200
Message-ID: <20250812173455.389918961@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robin Murphy <robin.murphy@arm.com>

commit c872d7c837382517c51a76dfdcf550332cfab231 upstream.

While we do request our IRQs with the right flags to stop their affinity
changing unexpectedly, we forgot to actually set it to start with. Oops.

Cc: stable@vger.kernel.org
Fixes: 4d5a7680f2b4 ("perf: Add driver for Arm NI-700 interconnect PMU")
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Tested-by: Shouping Wang <allen.wang@hj-micro.com>
Link: https://lore.kernel.org/r/614ced9149ee8324e58930862bd82cbf46228d27.1747149165.git.robin.murphy@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/perf/arm-ni.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/perf/arm-ni.c
+++ b/drivers/perf/arm-ni.c
@@ -544,6 +544,8 @@ static int arm_ni_init_cd(struct arm_ni
 		return err;
 
 	cd->cpu = cpumask_local_spread(0, dev_to_node(ni->dev));
+	irq_set_affinity(cd->irq, cpumask_of(cd->cpu));
+
 	cd->pmu = (struct pmu) {
 		.module = THIS_MODULE,
 		.parent = ni->dev,


