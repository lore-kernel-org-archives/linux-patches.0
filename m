Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D78F14B44B3;
	Thu, 17 Sep 2026 15:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658966; cv=none; b=kVbPt2GpTBRx69HRum1m+ikVh+A097VG3IIZFSRyE9kGCqKn0mOvghsjZ10HveZ73lt07hJYMNgXk/cqNoS7yf2UdIVPQVi74o95X2w1fBh+k46c8Avu8m7DRKtXIraMS54/MxLKr3YHQAg0rYaGCL5Ycov4YpRvG1DOvhWm5Bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658966; c=relaxed/simple;
	bh=UaGfktkb+UzCe2WnNaD+zSQVgicA/OmiYAztX24qFNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SlS8LzTvPzPmqUMOD0pF0AlbqKBMzQ3kfVpXwYBRq4xYKzPW9tTnKUIsFXUUQ2BuFzZ+Sowi+BURNcz3k7b4nbCfL3Ou+5yl3TxeU/MFFXriuLygxDvblQIDB/Z1GFoHNNa7R7o6I7aa7NUjg236wB2x3lTLy0+iMWMW9AVTzHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ngQPS0cR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ngQPS0cR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 292281F000FF;
	Thu, 17 Sep 2026 15:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658959;
	bh=9hefNmIyvoM7CTeNCkA+ZXpB/9lOb/tctswDiYpuNh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ngQPS0cR9BMQFy4q1xoR4ZrHnRGjxyzQ5EuN9cneEBSElSpsQKyIiQzkDk6jMFWlA
	 pP1reURp7niFtqzpGMG95+T1I0NsDtr+M6ryjF7LiDGvWyfFGVMfzKSvUgR1lZifE8
	 M0CQApGLuhvH/Lbz4n/EZuuIVLDymBoiIODLcdQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Yan <wangyan01@kylinos.cn>,
	Athira Rajeev <atrajeev@linux.ibm.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 079/733] perf powerpc-vpadtl: Fix raw_size of DTL samples
Date: Thu, 17 Sep 2026 16:06:27 +0100
Message-ID: <20260917151352.858967203@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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
index 710f3093f3f90..af6783cfdb53d 100644
--- a/tools/perf/util/powerpc-vpadtl.c
+++ b/tools/perf/util/powerpc-vpadtl.c
@@ -196,7 +196,7 @@ static int powerpc_vpadtl_sample(struct powerpc_vpadtl_entry *record,
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



