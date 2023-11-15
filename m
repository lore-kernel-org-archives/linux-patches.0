Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DA9C381D1
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S4+cr30D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1F16C433C7;
	Wed, 15 Nov 2023 20:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078446;
	bh=hFGLgSYKODDJ049/fpk4wWz4nbJA/vcePD0m/PXXdgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S4+cr30DJGzDnbjseQO+LULG93qtD/OrQtEaIUeH1parbX0pKWkEHcRBSc5Q3F5CQ
	 wACCZzHdArrHk+2gtv5I4o8zVVj5CA3d1hYEDC1Tt4FA6o/ciHJV+axeeew3KUp2V2
	 neiz71f+0VDctT3rDoub+kEf75ZC4fWlqD9HDdY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	Sandipan Das <sandipan.das@amd.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	German Gomez <german.gomez@arm.com>,
	James Clark <james.clark@arm.com>,
	Nick Terrell <terrelln@fb.com>,
	Sean Christopherson <seanjc@google.com>,
	Changbin Du <changbin.du@huawei.com>,
	liuwenyu <liuwenyu7@huawei.com>,
	Yang Jihong <yangjihong1@huawei.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Song Liu <song@kernel.org>,
	Leo Yan <leo.yan@linaro.org>,
	Kajol Jain <kjain@linux.ibm.com>,
	Andi Kleen <ak@linux.intel.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
	Yanteng Si <siyanteng@loongson.cn>,
	Liam Howlett <liam.howlett@oracle.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 302/379] perf machine: Avoid out of bounds LBR memory read
Date: Wed, 15 Nov 2023 14:26:17 -0500
Message-ID: <20231115192703.009775703@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit ab8ce150781d326c6bfbe1e09f175ffde1186f80 ]

Running perf top with address sanitizer and "--call-graph=lbr" fails
due to reading sample 0 when no samples exist. Add a guard to prevent
this.

Fixes: e2b23483eb1d ("perf machine: Factor out lbr_callchain_add_lbr_ip()")
Signed-off-by: Ian Rogers <irogers@google.com>
Cc: K Prateek Nayak <kprateek.nayak@amd.com>
Cc: Ravi Bangoria <ravi.bangoria@amd.com>
Cc: Sandipan Das <sandipan.das@amd.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: German Gomez <german.gomez@arm.com>
Cc: James Clark <james.clark@arm.com>
Cc: Nick Terrell <terrelln@fb.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Changbin Du <changbin.du@huawei.com>
Cc: liuwenyu <liuwenyu7@huawei.com>
Cc: Yang Jihong <yangjihong1@huawei.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Song Liu <song@kernel.org>
Cc: Leo Yan <leo.yan@linaro.org>
Cc: Kajol Jain <kjain@linux.ibm.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Cc: Yanteng Si <siyanteng@loongson.cn>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Link: https://lore.kernel.org/r/20231024222353.3024098-3-irogers@google.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/machine.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 76316e459c3de..9cd52f50ea7ac 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -2555,16 +2555,18 @@ static int lbr_callchain_add_lbr_ip(struct thread *thread,
 		save_lbr_cursor_node(thread, cursor, i);
 	}
 
-	/* Add LBR ip from first entries.to */
-	ip = entries[0].to;
-	flags = &entries[0].flags;
-	*branch_from = entries[0].from;
-	err = add_callchain_ip(thread, cursor, parent,
-			       root_al, &cpumode, ip,
-			       true, flags, NULL,
-			       *branch_from);
-	if (err)
-		return err;
+	if (lbr_nr > 0) {
+		/* Add LBR ip from first entries.to */
+		ip = entries[0].to;
+		flags = &entries[0].flags;
+		*branch_from = entries[0].from;
+		err = add_callchain_ip(thread, cursor, parent,
+				root_al, &cpumode, ip,
+				true, flags, NULL,
+				*branch_from);
+		if (err)
+			return err;
+	}
 
 	return 0;
 }
-- 
2.42.0



