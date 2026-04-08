Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A64652727F3;
	Wed,  8 Apr 2026 18:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674133; cv=none; b=T1ThfJqsVsNCWr7w+mFyc3pMdkv/4Sx44Voa1airUiz6iqU4BhmQNiCADoD3Ea4Yw4DNpHNGQlm2S7QB2PYF+ZGLRNXCn6dEUGVuEqvTrK1jN8+Kau+cZLHHZbv8vALQ3e9ko80gHlPCKzGfPvd+9yUHlVrerzSFGPr1ZHolvoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674133; c=relaxed/simple;
	bh=Wup60e02UFerLYQfGZASkk+1VF8Pq/Ta3bWX82y4Ecw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bda+OrJ+cp0K1uY6rMuNkorYCJfcLKjPMAzETGdI+zmEtMqMlzk9oUJ9sC5ozAx/gqex8nqfZa1H+SqfIbHT5SAvAG4NBvoGFZjHoACdI7/6/His/TKmQfz251Dskdt3EtqkEgJNl9hcjsD+EjxC60U2cPLS+deuzINw9NBMj4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wuxE3XOX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wuxE3XOX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CE95C19421;
	Wed,  8 Apr 2026 18:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674133;
	bh=Wup60e02UFerLYQfGZASkk+1VF8Pq/Ta3bWX82y4Ecw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wuxE3XOXgg+PRMf56ps+C8Z7tTF8zk7b1cwVhrCoSMmbA4JQCTGQykzfXSyh3JQV5
	 ERb1upveQKJ4X1mm+arvx5AA2BQ5t1kONmvwLnCMrki6GapJ/KyCSafJYSYAQQ6LaP
	 yN0PoL0ob7XGr9oGDF9ABO5YBoBHTazNNfs8JIwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juergen Christ <jchrist@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 223/242] s390/perf_cpum_sf: Convert to use try_cmpxchg128()
Date: Wed,  8 Apr 2026 20:04:23 +0200
Message-ID: <20260408175935.438842987@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit e449399ffd295a1202b74a258227193454ef333f ]

Convert cmpxchg128() usages to try_cmpxchg128() in order to generate
slightly better code.

Reviewed-by: Juergen Christ <jchrist@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Stable-dep-of: 57ad0d4a00f5 ("s390/cpum_sf: Cap sampling rate to prevent lsctl exception")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/perf_cpum_sf.c |   24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

--- a/arch/s390/kernel/perf_cpum_sf.c
+++ b/arch/s390/kernel/perf_cpum_sf.c
@@ -1188,8 +1188,8 @@ static void hw_collect_samples(struct pe
 static void hw_perf_event_update(struct perf_event *event, int flush_all)
 {
 	unsigned long long event_overflow, sampl_overflow, num_sdb;
-	union hws_trailer_header old, prev, new;
 	struct hw_perf_event *hwc = &event->hw;
+	union hws_trailer_header prev, new;
 	struct hws_trailer_entry *te;
 	unsigned long *sdbt, sdb;
 	int done;
@@ -1233,13 +1233,11 @@ static void hw_perf_event_update(struct
 		/* Reset trailer (using compare-double-and-swap) */
 		prev.val = READ_ONCE_ALIGNED_128(te->header.val);
 		do {
-			old.val = prev.val;
 			new.val = prev.val;
 			new.f = 0;
 			new.a = 1;
 			new.overflow = 0;
-			prev.val = cmpxchg128(&te->header.val, old.val, new.val);
-		} while (prev.val != old.val);
+		} while (!try_cmpxchg128(&te->header.val, &prev.val, new.val));
 
 		/* Advance to next sample-data-block */
 		sdbt++;
@@ -1405,16 +1403,15 @@ static int aux_output_begin(struct perf_
 static bool aux_set_alert(struct aux_buffer *aux, unsigned long alert_index,
 			  unsigned long long *overflow)
 {
-	union hws_trailer_header old, prev, new;
+	union hws_trailer_header prev, new;
 	struct hws_trailer_entry *te;
 
 	te = aux_sdb_trailer(aux, alert_index);
 	prev.val = READ_ONCE_ALIGNED_128(te->header.val);
 	do {
-		old.val = prev.val;
 		new.val = prev.val;
-		*overflow = old.overflow;
-		if (old.f) {
+		*overflow = prev.overflow;
+		if (prev.f) {
 			/*
 			 * SDB is already set by hardware.
 			 * Abort and try to set somewhere
@@ -1424,8 +1421,7 @@ static bool aux_set_alert(struct aux_buf
 		}
 		new.a = 1;
 		new.overflow = 0;
-		prev.val = cmpxchg128(&te->header.val, old.val, new.val);
-	} while (prev.val != old.val);
+	} while (!try_cmpxchg128(&te->header.val, &prev.val, new.val));
 	return true;
 }
 
@@ -1454,7 +1450,7 @@ static bool aux_set_alert(struct aux_buf
 static bool aux_reset_buffer(struct aux_buffer *aux, unsigned long range,
 			     unsigned long long *overflow)
 {
-	union hws_trailer_header old, prev, new;
+	union hws_trailer_header prev, new;
 	unsigned long i, range_scan, idx;
 	unsigned long long orig_overflow;
 	struct hws_trailer_entry *te;
@@ -1486,17 +1482,15 @@ static bool aux_reset_buffer(struct aux_
 		te = aux_sdb_trailer(aux, idx);
 		prev.val = READ_ONCE_ALIGNED_128(te->header.val);
 		do {
-			old.val = prev.val;
 			new.val = prev.val;
-			orig_overflow = old.overflow;
+			orig_overflow = prev.overflow;
 			new.f = 0;
 			new.overflow = 0;
 			if (idx == aux->alert_mark)
 				new.a = 1;
 			else
 				new.a = 0;
-			prev.val = cmpxchg128(&te->header.val, old.val, new.val);
-		} while (prev.val != old.val);
+		} while (!try_cmpxchg128(&te->header.val, &prev.val, new.val));
 		*overflow += orig_overflow;
 	}
 


