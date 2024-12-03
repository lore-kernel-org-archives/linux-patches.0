Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF7E21F76CA;
	Tue,  3 Dec 2024 16:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241609; cv=none; b=q6uHBhKyRaDkLPpBwM4+mhHpHpEGwFM6sL2qFIDW11V0gFZ70xsX2jh2EuMyS+iqpsw3z2CiWpwV6TgjwSNj+N3qi32Z9YG5QAKYbNMX6GcMVgIOXZaPWztNFN06ka+t7XF4RPkmpJd1hzN5klwUt6+gmrR0/wKLNVI2Nn0mkPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241609; c=relaxed/simple;
	bh=+GjaJtihJEJjXSD/Z19KOnJEr+vA5pBVadj8GWzT/N0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f//TV9YVnEu+BeBxRYZESrHDNzl+Ubmking9f5Hx7AssoRyHYq/euOjGqQU58LQTRvAZnXxryA6S0pBoQalc073C29K2hKNA3aDrDpe05yFkN+a0fmMNvGkWndnJO59f6lfsSzfSRrbGLjqOE/Lm2XTZFeVuWI7OCh3VEw32/Xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PNk7jleC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PNk7jleC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F258CC4CECF;
	Tue,  3 Dec 2024 16:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241609;
	bh=+GjaJtihJEJjXSD/Z19KOnJEr+vA5pBVadj8GWzT/N0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PNk7jleCx18+eW5G6wl/6EgKHXQNwoZ2a1+veK42SLaDmdF0vFdaXF2/QkBcgO863
	 Vd5pnLQnkRRDkI7L//A63hyrNA/c2NjM7srR85ZxlerA3uZueg8bHW3jySOBTVn+VL
	 enHIiYqBF3/z1520Zo8F3b/XJyosAmOnX2ljW58Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Leo Yan <leo.yan@arm.com>,
	James Clark <james.clark@linaro.org>,
	Ben Gainey <ben.gainey@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Will Deacon <will@kernel.org>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Mike Leach <mike.leach@linaro.org>,
	Ruidong Tian <tianruidong@linux.alibaba.com>,
	Benjamin Gray <bgray@linux.ibm.com>,
	linux-arm-kernel@lists.infradead.org,
	coresight@lists.linaro.org,
	John Garry <john.g.garry@oracle.com>,
	scclevenger@os.amperecomputing.com,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 466/826] perf cs-etm: Dont flush when packet_queue fills up
Date: Tue,  3 Dec 2024 15:43:13 +0100
Message-ID: <20241203144801.941516477@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: James Clark <james.clark@linaro.org>

[ Upstream commit 5afd032961e8465808c4bc385c06e7676fbe1951 ]

cs_etm__flush(), like cs_etm__sample() is an operation that generates a
sample and then swaps the current with the previous packet. Calling
flush after processing the queues results in two swaps which corrupts
the next sample. Therefore it wasn't appropriate to call flush here so
remove it.

Flushing is still done on a discontinuity to explicitly clear the last
branch buffer, but when the packet_queue fills up before reaching a
timestamp, that's not a discontinuity and the call to
cs_etm__process_traceid_queue() already generated samples and drained
the buffers correctly.

This is visible by looking for a branch that has the same target as the
previous branch and the following source is before the address of the
last target, which is impossible as execution would have had to have
gone backwards:

  ffff800080849d40 _find_next_and_bit+0x78 => ffff80008011cadc update_sg_lb_stats+0x94
   (packet_queue fills here before a timestamp, resulting in a flush and
    branch target ffff80008011cadc is duplicated.)
  ffff80008011cb1c update_sg_lb_stats+0xd4 => ffff80008011cadc update_sg_lb_stats+0x94
  ffff8000801117c4 cpu_util+0x24 => ffff8000801117d4 cpu_util+0x34

After removing the flush the correct branch target is used for the
second sample, and ffff8000801117c4 is no longer before the previous
address:

  ffff800080849d40 _find_next_and_bit+0x78 => ffff80008011cadc update_sg_lb_stats+0x94
  ffff80008011cb1c update_sg_lb_stats+0xd4 => ffff8000801117a0 cpu_util+0x0
  ffff8000801117c4 cpu_util+0x24 => ffff8000801117d4 cpu_util+0x34

Make sure that a final branch stack is output at the end of the trace
by calling cs_etm__end_block(). This is already done for both the
timeless decode paths.

Fixes: 21fe8dc1191a ("perf cs-etm: Add support for CPU-wide trace scenarios")
Reported-by: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Closes: https://lore.kernel.org/all/20240719092619.274730-1-gankulkarni@os.amperecomputing.com/
Reviewed-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: James Clark <james.clark@linaro.org>
Tested-by: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Cc: Ben Gainey <ben.gainey@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Mike Leach <mike.leach@linaro.org>
Cc: Ruidong Tian <tianruidong@linux.alibaba.com>
Cc: Benjamin Gray <bgray@linux.ibm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: coresight@lists.linaro.org
Cc: John Garry <john.g.garry@oracle.com>
Cc: scclevenger@os.amperecomputing.com
Link: https://lore.kernel.org/r/20240916135743.1490403-2-james.clark@linaro.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/cs-etm.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/cs-etm.c b/tools/perf/util/cs-etm.c
index 40f047baef810..0bf9e5c27b599 100644
--- a/tools/perf/util/cs-etm.c
+++ b/tools/perf/util/cs-etm.c
@@ -2490,12 +2490,6 @@ static void cs_etm__clear_all_traceid_queues(struct cs_etm_queue *etmq)
 
 		/* Ignore return value */
 		cs_etm__process_traceid_queue(etmq, tidq);
-
-		/*
-		 * Generate an instruction sample with the remaining
-		 * branchstack entries.
-		 */
-		cs_etm__flush(etmq, tidq);
 	}
 }
 
@@ -2638,7 +2632,7 @@ static int cs_etm__process_timestamped_queues(struct cs_etm_auxtrace *etm)
 
 	while (1) {
 		if (!etm->heap.heap_cnt)
-			goto out;
+			break;
 
 		/* Take the entry at the top of the min heap */
 		cs_queue_nr = etm->heap.heap_array[0].queue_nr;
@@ -2721,6 +2715,23 @@ static int cs_etm__process_timestamped_queues(struct cs_etm_auxtrace *etm)
 		ret = auxtrace_heap__add(&etm->heap, cs_queue_nr, cs_timestamp);
 	}
 
+	for (i = 0; i < etm->queues.nr_queues; i++) {
+		struct int_node *inode;
+
+		etmq = etm->queues.queue_array[i].priv;
+		if (!etmq)
+			continue;
+
+		intlist__for_each_entry(inode, etmq->traceid_queues_list) {
+			int idx = (int)(intptr_t)inode->priv;
+
+			/* Flush any remaining branch stack entries */
+			tidq = etmq->traceid_queues[idx];
+			ret = cs_etm__end_block(etmq, tidq);
+			if (ret)
+				return ret;
+		}
+	}
 out:
 	return ret;
 }
-- 
2.43.0



