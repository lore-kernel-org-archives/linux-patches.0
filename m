Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D5B46C4A4;
	Tue, 21 Jul 2026 18:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657638; cv=none; b=e1wBDpMTEaTkRnRhe6naiDOsWY7KAGJ2zt52Ut7XVpiQY6Nq9R8YHNn9YmnujSRobw9P+ybMDpiaR4sPGuyDJxJBcNDzuZV7PEx+0JrxgnG/ZbH8Yixn/9g0ViDZbU+ww/vQqb8cNTMHxBMS/G2edU3hvzJt0DG+4fPOulO0pLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657638; c=relaxed/simple;
	bh=hl1jwgiN+lLN1iYOQ6fdTnA17GlC9wWxS6untf23q3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rnC8SgOLfyn99rRWrSycoDVv5jnZtPg/pUh1roMF/oW14b3ZgaRAFhIMpcCV9Ys5DoCDQYESf2uIf9gEf/xPijiBrs4iOoNGrczCZ8MjKA6dcIutrW5Gw+GRevYJtGe48YUf+sYqllRrR2yp5qMTCYIKdyx+U6Vwko35QBgisfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Keddyh0x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Keddyh0x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F8621F000E9;
	Tue, 21 Jul 2026 18:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657637;
	bh=/uShuD4IXDoYUmZZEJ9bsVwMcIGcVr6/YjnLO/GnwbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Keddyh0xF/t5bLWYl3TkzsSIU+gKbrYYr8ANnBAIqAkW+UEa0AlsGewzw/Q7WEoXQ
	 MNkeWNBiD9IYMn4iX0mZaZogXdlLIWFSFeylbitXqsGGIL6+BjS8c6ohez6H+19lAb
	 BgIm+xDLdxF7s+64raJvG2HeTHez0W++AozGOW00=
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
Subject: [PATCH 6.18 0796/1611] perf cs-etm: Validate num_cpu before metadata allocation
Date: Tue, 21 Jul 2026 17:15:12 +0200
Message-ID: <20260721152533.292505769@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index 4e5b38db7b01be..f2ea3cbea0fdfe 100644
--- a/tools/perf/util/cs-etm.c
+++ b/tools/perf/util/cs-etm.c
@@ -3442,6 +3442,18 @@ int cs_etm__process_auxtrace_info_full(union perf_event *event,
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



