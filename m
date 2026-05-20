Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22AB23FE66D;
	Wed, 20 May 2026 18:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302392; cv=none; b=QK0KxFiEfBdNj7cgnc9xMfPnHxu4j+ua/DW9gzlSkqKENHhFm37sngJrMWDxu0VC0XD/Y7qcTp9kUYqHmV77j71LYqBe3TEbxrLsz7w8RlNibJ9g7LB2gYQgrNMq6onj4PbI06oTd6XYtAPkeiLKFf2mnaqvr2q9y2V+4j/MKbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302392; c=relaxed/simple;
	bh=Yan5iJO8YIHCnWTb90sCBYgMY1Bec3c+TIXcyqurMp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hAoA8CORQLAU7vXQ+5FUOjnKooa0igENWm3ExF/7/yRCUw4hSGhAVGmAig44reUfTPXVaL7jQo6Fr0aaxooHM4ZNjfdgl+xv4pCqI/zbkXP3IcwMMu8OLseSzAlxPccHXMYO2D4KJHWLzm+4Q3OkNepvpHBzfTqR+8sXiQ0P+Bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JpxXA/BE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JpxXA/BE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87AF91F00896;
	Wed, 20 May 2026 18:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302391;
	bh=OlQLAoh8NxKhoGMJU2fYN+Jvap8GPtOeYnGF4Qve7To=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JpxXA/BEqAAjHvT32pOgTwuSQNn5kMMdj0tbPHMSPBVDUM/qCBMI/R3mpY+4nSIT+
	 Gww4VUZX2wHpLOd6bEUqV5W8LBMBnTyoOIn3GXzKlMwnUpnhe/ZRc+yloIr05NcF4q
	 6c71OWr47Czq512B5chfUOFibaNV+lPOWHuf4Av0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 248/508] perf branch: Avoid incrementing NULL
Date: Wed, 20 May 2026 18:21:11 +0200
Message-ID: <20260520162104.023498858@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit c969a9d7bbf46f983c4a48566b3b2f7340b02296 ]

If the entry is NULL the value is meaningless so early return NULL to
avoid an increment of NULL. This was happening in calls from
has_stitched_lbr when running the "perf record LBR tests". The return
value isn't used in that case, so returning NULL as no effect.

Fixes: 42bbabed09ce ("perf tools: Add hw_idx in struct branch_stack")
Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/branch.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/util/branch.h b/tools/perf/util/branch.h
index e41bfffe22170..31ad6ded983ec 100644
--- a/tools/perf/util/branch.h
+++ b/tools/perf/util/branch.h
@@ -64,6 +64,9 @@ static inline struct branch_entry *perf_sample__branch_entries(struct perf_sampl
 {
 	u64 *entry = (u64 *)sample->branch_stack;
 
+	if (entry == NULL)
+		return NULL;
+
 	entry++;
 	if (sample->no_hw_idx)
 		return (struct branch_entry *)entry;
-- 
2.53.0



