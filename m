Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19CDA269D18;
	Tue,  8 Apr 2025 12:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114800; cv=none; b=IY80ciR0oV2WjKAcbMggkAgrtp6DFESih0MEWiaQBva/VpQRQHpP45csDogPLnbdzteRM1q1ZnZaKlvB9FE72w9zchsha4iVQAAXn2LI/OfcjP9b+yIHbBeOX0z2Irp8Aw0pD+LLQqWEUjtnEo1Q4en8WJiK4q/UDmwGSDqVnAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114800; c=relaxed/simple;
	bh=SaGVF8vscy9L28hULLkCK0XXQpDNE/XoBEkaTGhE67Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BsxOZiS5L33UK4m6sHjG94FT+u97ccbuRa5GtJXhmcW8itWVMimuoDEwjJ50r2GGZir91gRbX5a7/xJ+I/vWRPucFL4doDpVJQFiLpEPE/kNKysyPDYe8z14kOeROfW9d1NkOZVPV2JTwBm4suO4Mi2tySVbIZzR9KX0w6KrwDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kxjcHPVG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kxjcHPVG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40B28C4CEEB;
	Tue,  8 Apr 2025 12:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114799;
	bh=SaGVF8vscy9L28hULLkCK0XXQpDNE/XoBEkaTGhE67Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kxjcHPVGa+GnEaG9sesdBoFHs7l0EaoAti9ABhLHljr3cywvOe4/GZmxEEgRj9pBX
	 bLKQBboIPfaMbiyuJNmQ8J6/st7PBLnPj94p733TYffc4kxt9jz5Fq+q5mxK6ROrfs
	 juVUBY5e6psGqHDqxRh2vjEuSzKSyYhtzVWVQnho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Thomas Falcon <thomas.falcon@intel.com>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 238/499] perf x86/topdown: Fix topdown leader sampling test error on hybrid
Date: Tue,  8 Apr 2025 12:47:30 +0200
Message-ID: <20250408104857.152304173@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

[ Upstream commit b74683b3bb224eccb644cf260753dfc82e802d92 ]

When running topdown leader smapling test on Intel hybrid platforms,
such as LNL/ARL, we see the below error.

Topdown leader sampling test
Topdown leader sampling [Failed topdown events not reordered correctly]

It indciates the below command fails.

perf record -o "${perfdata}" -e "{instructions,slots,topdown-retiring}:S" true

The root cause is that perf tool creats a perf event for each PMU type
if it can create.

As for this command, there would be 5 perf events created,
cpu_atom/instructions/,cpu_atom/topdown_retiring/,
cpu_core/slots/,cpu_core/instructions/,cpu_core/topdown-retiring/

For these 5 events, the 2 cpu_atom events are in a group and the other 3
cpu_core events are in another group.

When arch_topdown_sample_read() traverses all these 5 events, events
cpu_atom/instructions/ and cpu_core/slots/ don't have a same group
leade, and then return false directly and lead to cpu_core/slots/ event
is used to sample and this is not allowed by PMU driver.

It's a overkill to return false directly if "evsel->core.leader !=
 leader->core.leader" since there could be multiple groups in the event
list.

Just "continue" instead of "return false" to fix this issue.

Fixes: 1e53e9d1787b ("perf x86/topdown: Correct leader selection with sample_read enabled")
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Tested-by: Thomas Falcon <thomas.falcon@intel.com>
Tested-by: Ian Rogers <irogers@google.com>
Link: https://lore.kernel.org/r/20250307023906.1135613-2-irogers@google.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/arch/x86/util/topdown.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/arch/x86/util/topdown.c b/tools/perf/arch/x86/util/topdown.c
index f63747d0abdf9..d1c6548390496 100644
--- a/tools/perf/arch/x86/util/topdown.c
+++ b/tools/perf/arch/x86/util/topdown.c
@@ -81,7 +81,7 @@ bool arch_topdown_sample_read(struct evsel *leader)
 	 */
 	evlist__for_each_entry(leader->evlist, evsel) {
 		if (evsel->core.leader != leader->core.leader)
-			return false;
+			continue;
 		if (evsel != leader && arch_is_topdown_metrics(evsel))
 			return true;
 	}
-- 
2.39.5



