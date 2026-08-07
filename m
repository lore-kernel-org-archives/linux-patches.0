Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B86E8397958;
	Fri,  7 Aug 2026 15:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117382; cv=none; b=p+iJWdjdPcODrSvwSYa/c9TJQj7fSaOCsJFVvVcYM4cRIvsqNKI0XErmjSr2Myh9UvlNQ7+8ZKO7BCloSg6eZZRcEGyT36V0BwaU9VDMbyyVhwp6jm00xGTjAPmwRviZ8P4Geep7Uc6S0prL57CCqdhLylIjMi2iRNOFM39Me+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117382; c=relaxed/simple;
	bh=Ofecrbf+Narxx7V4l7hscqcj7Tqs7k4icWQjJD99bd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oMvwKSaQ0PL3AB0eLJoh62nU58HHkEYY3BTPuLYJvInfV0d2lpVRwfloTU6OqT4g8rysheoIxa+rHnaBk+gOax3TCTbEC6bP6g1RlYt5qm1ciphW9yol9aTykfk9SWeV+j2NNyyzTNUNrUlRoIrKfzvEJoL8EZ8fX+L0fmuhW5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Da4ZTN2v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Da4ZTN2v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D01071F00A3A;
	Fri,  7 Aug 2026 15:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117381;
	bh=G6wfEr3x7SQUOwFHNOz8rzfFGHzHJUdmGhDQJhO/hTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Da4ZTN2v0ToHr+Zg9TUqumHesHX668Cj+8+o0AlKR+Cg+/yFIvPGvwZ+YfvoS7LpD
	 YTe826p4X3ROYtP0IUeisP9lZ4mVDNCCxlJxYFxAOisUe3jdXLpyGsZoRq0xgd6jM1
	 SnPHEPv7CGLom8kM1cgjDbunbUkGXAO1mns5At0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	SeongJae Park <sj@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.1 297/438] mm: memcg: initialize *locked in memcg1_oom_prepare() stub
Date: Fri,  7 Aug 2026 16:38:13 +0200
Message-ID: <20260807143434.305097468@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

From: Breno Leitao <leitao@debian.org>

commit 1833ce36b35426504c64600c94f322437ea44bb2 upstream.

mem_cgroup_oom() passes an uninitialized "locked" to memcg1_oom_prepare()
and reads it back in memcg1_oom_finish():

	bool locked, ret;
	...
	if (!memcg1_oom_prepare(memcg, &locked))
		return false;
	ret = mem_cgroup_out_of_memory(memcg, mask, order);
	memcg1_oom_finish(memcg, locked);

This relies on memcg1_oom_prepare() setting *locked whenever it returns
true.  The CONFIG_MEMCG_V1=y version does, but the stub used when
CONFIG_MEMCG_V1=n returns true without touching *locked, so
memcg1_oom_finish() consumes an uninitialized value.  On a memcg OOM this
is reported by UBSAN:

  UBSAN: invalid-load in mm/memcontrol.c:1932:27
  load of value 0 is not a valid value for type 'bool' (aka '_Bool')

Initialize *locked to false in the stub; with cgroup v1 compiled out there
is no OOM lock to take.

Link: https://lore.kernel.org/20260716-memcg-oom-uninit-locked-v2-1-63631d878eb4@debian.org
Fixes: e93d4166b40a ("mm: memcg: put cgroup v1-specific code under a config option")
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memcontrol-v1.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/memcontrol-v1.h
+++ b/mm/memcontrol-v1.h
@@ -107,7 +107,11 @@ static inline void memcg1_remove_from_tr
 static inline void memcg1_soft_limit_reset(struct mem_cgroup *memcg) {}
 static inline void memcg1_css_offline(struct mem_cgroup *memcg) {}
 
-static inline bool memcg1_oom_prepare(struct mem_cgroup *memcg, bool *locked) { return true; }
+static inline bool memcg1_oom_prepare(struct mem_cgroup *memcg, bool *locked)
+{
+	*locked = false;
+	return true;
+}
 static inline void memcg1_oom_finish(struct mem_cgroup *memcg, bool locked) {}
 static inline void memcg1_oom_recover(struct mem_cgroup *memcg) {}
 


