Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B65A351DB1F;
	Thu, 17 Sep 2026 17:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665252; cv=none; b=fGSNJUKQV5dYP00SylIEathGdJOb5FHMtxDCMkVb1ilKo6OkOs6LECWlstkqGohV3dBB+++am2H5HW6FJpd/z1X605MjZ7C8YVM4TdrYEYLlYmh4/5wDIZv+Bbf+Ef8gVKkLsV5GXJ4gxCBV5UZNBRWDX9F7MAzwFCZNzzfbyjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665252; c=relaxed/simple;
	bh=9L5Erbyqy996AxZ0DDw+VjruL8jh8xlC7fk64LVH/dk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N3kvZrhWrssistj41FMKVYtCb/C+nFGeWwM5WQ1AqAh7FO0JR49g8864xYgYNl1rW7QusCSBn/zKI8yCS2VuUZzYzcJ70MY0dMmwwT+CcSQiK9911yCgB9weOZrJnZLjybV0efY/k5QwmpYCoSfUTHUUTC7lJMKxavtES9DeRb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rYdkQ9DZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rYdkQ9DZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 188AC1F000FF;
	Thu, 17 Sep 2026 17:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665251;
	bh=KZmERMGpocpF6j/oSW9zFQ44AE4nQRkGQFTy8GfYxFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rYdkQ9DZ7dBR3MvGPMXetii7AJIBPTUIz7qBKPu7u8RNhy0ROsdFP3W/1KzwkS9tK
	 EKowk/xMgmQcHDOnrzYeeP4cEk93HQWsuRN+Aa5Of282/7zkNvq/VWzJt+2TdmbH2+
	 IOz8PAedyCSlXuNvwpk3IpOq04qDoy7lgIvewip8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Yan <wangyan01@kylinos.cn>,
	Athira Rajeev <atrajeev@linux.ibm.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0641/1250] perf powerpc-vpadtl: Fix raw_size of DTL samples
Date: Thu, 17 Sep 2026 16:07:16 +0100
Message-ID: <20260917151609.264522734@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Wang Yan <wangyan01@kylinos.cn>

[ Upstream commit aadea57f532882d8bab444646863c7ef8a778ff1 ]

In powerpc_vpadtl_sample(), raw_data of the synthetic sample points to a
struct powerpc_vpadtl_entry (48 bytes), but raw_size is set to
sizeof(record).  record is a struct powerpc_vpadtl_entry pointer, so
sizeof(record) is the size of the pointer (8 bytes on 64-bit) rather
than the size of the record itself.

As a result, consumers that bound their access to raw_data by raw_size
only see or copy the first 8 bytes of each DTL entry instead of the full
record.

Use sizeof(*record) so that raw_size reflects the actual length of the
raw data.

Fixes: 8644834a482a ("perf powerpc: Process the DTL entries in queue and deliver samples")
Signed-off-by: Wang Yan <wangyan01@kylinos.cn>
Reviewed-by: Athira Rajeev <atrajeev@linux.ibm.com>
Reviewed-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/powerpc-vpadtl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/powerpc-vpadtl.c b/tools/perf/util/powerpc-vpadtl.c
index 39a3fb3f13301..55b9b6e070746 100644
--- a/tools/perf/util/powerpc-vpadtl.c
+++ b/tools/perf/util/powerpc-vpadtl.c
@@ -192,7 +192,7 @@ static int powerpc_vpadtl_sample(struct powerpc_vpadtl_entry *record,
 	sample.cpumode = PERF_RECORD_MISC_KERNEL;
 	sample.time = save;
 	sample.raw_data = record;
-	sample.raw_size = sizeof(record);
+	sample.raw_size = sizeof(*record);
 	event.sample.header.type = PERF_RECORD_SAMPLE;
 	event.sample.header.misc = sample.cpumode;
 	event.sample.header.size = sizeof(struct perf_event_header);
-- 
2.53.0



