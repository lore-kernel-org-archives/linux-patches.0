Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB4D403135;
	Tue, 21 Jul 2026 19:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660746; cv=none; b=SFXk4nDSxXzVnOlsl48a8QfnI9g5FkqU1w9uFPxg26k98/zRaG/fLaxZA4RK+wg7uOH6eQzkEnedrHLX4ikYjXgr9pGrww7FSOGJ682i5m+1v+Na3PiJLxtrBnxpUiHnSoU0BTICgSuJTjkWVNpppD2oPrdcLhgkaUCJFAjNc8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660746; c=relaxed/simple;
	bh=RkqkIxrhLkoGsnEoL045lPzywinT9fbnmu4X4YNFvsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IW3wdIAKTTsH/kQfKRnHrbqSjz/fdam7kIm8u0V5YAnI1iABnvPJ6YPACxQNr3NHj/vrSnxMMJRw1/Pl7KAs1dE/j6YHews21m/g7cpfvSnA7Pwnqz1J6D1j2Fmf1+8SqwqafuvsBgXJqdunMrzUHK+h63sdSi2UZuWvqCvfCdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WlnNnfEB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WlnNnfEB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 352941F00A3A;
	Tue, 21 Jul 2026 19:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660745;
	bh=lxDI/PcDxKJzTjEMh25H7/RT7YSBghm11ibV1KERcfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WlnNnfEB1a4XVqr73UHgejTaavDKhYjDHfS/yltkK+nP5cIxXBoKTDc1POc9raqqf
	 SkFrNP/TyvP1vQEq6V0+EZg32l2vaMNrBGdEMDdiTRLPIubnzcUMBQC5sOeWaXxEPI
	 mQ6AWX7fLQyqGKRgyuyhszEyY30A63mlyPaRmAEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	James Clark <james.clark@arm.com>,
	Leo Yan <leo.yan@linaro.org>,
	Tor Jeremiassen <tor@ti.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1095/2077] perf cs-etm: Validate num_cpu before metadata allocation
Date: Tue, 21 Jul 2026 17:12:48 +0200
Message-ID: <20260721152618.649259752@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 312d91329b8fc6989a916a3f9a12d0674167b7e4 ]

cs_etm__process_auxtrace_info_full() reads num_cpu from untrusted
perf.data and uses it to allocate the metadata pointer array:

  metadata = zalloc(sizeof(*metadata) * num_cpu);

On 32-bit, sizeof(*metadata) is 4, so num_cpu = 0x40000000 overflows
the multiplication to 0, causing zalloc(0) to return a valid zero-sized
allocation followed by out-of-bounds writes in the population loop.

Fix by computing priv_size early and using it to bound num_cpu: each
CPU needs at least one u64 metadata entry, so num_cpu cannot exceed
the total number of u64 entries in the event's private data area.

Fixes: cd8bfd8c973eaff8 ("perf tools: Add processing of coresight metadata")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: James Clark <james.clark@arm.com>
Cc: Leo Yan <leo.yan@linaro.org>
Cc: Tor Jeremiassen <tor@ti.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/cs-etm.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/tools/perf/util/cs-etm.c b/tools/perf/util/cs-etm.c
index c1169254fadb7b..2000a03657c845 100644
--- a/tools/perf/util/cs-etm.c
+++ b/tools/perf/util/cs-etm.c
@@ -3431,6 +3431,18 @@ int cs_etm__process_auxtrace_info_full(union perf_event *event,
 	/* First the global part */
 	ptr = (u64 *) auxtrace_info->priv;
 	num_cpu = ptr[CS_PMU_TYPE_CPUS] & 0xffffffff;
+
+	/*
+	 * Bound num_cpu by the event size: the global header consumes
+	 * CS_ETM_HEADER_SIZE bytes, and each CPU needs at least one u64
+	 * metadata entry after that.
+	 */
+	priv_size = total_size - event_header_size - INFO_HEADER_SIZE -
+		    CS_ETM_HEADER_SIZE;
+	if (num_cpu <= 0 || priv_size <= 0 ||
+	    num_cpu > priv_size / (int)sizeof(u64))
+		return -EINVAL;
+
 	metadata = zalloc(sizeof(*metadata) * num_cpu);
 	if (!metadata)
 		return -ENOMEM;
-- 
2.53.0



