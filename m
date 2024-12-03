Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64ED31E009A;
	Tue,  3 Dec 2024 16:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241670; cv=none; b=qijms5S+0MTMuzos09KoiXnKcRw9uUMbT+eS3Tk9jCqPk9ePhOp7/jvJV2dHUQQZad1xonZvuoXfUycCPP/qRsiGBdwvOqLzTacq8g28cbsgvpORSPeb214sCyNJzVnNsyKjgs2CLpJcKwPNLVeKx4hX4LurHK0/AcoHQ1VY/4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241670; c=relaxed/simple;
	bh=cIEcAL8IOvh3p4/JE/mvc3sRXcgvukVkHPlDvoPgaAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FwlPn23OKEKOTrVFjm2B7CL7GrvbZt7cDNyl1bTurr/j7/Ns1wRdMIO2h5bRXWydZO1+iIXuCNFwjjs19RH70jD7yY1QHoUdfRG6R5amPSmTbbCAHMkSO4juMZ35A+0N4q/gurh24ZgOryYnBzRCJzn3jFXeiSlEBxwLeyyvOqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KSj7V6D8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KSj7V6D8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97FADC4CECF;
	Tue,  3 Dec 2024 16:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241670;
	bh=cIEcAL8IOvh3p4/JE/mvc3sRXcgvukVkHPlDvoPgaAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KSj7V6D8/6zZAfOsAe8kSnmly3D9VzvgTN9mp9YADpCsJnZdjnxLiq5EQ7AMjc7Bq
	 4iBJptEokneK2IcHo72pCeM8Vap9yVjtVae3/pTbaIm31v51FcWjKg0zHRP/zBxaEF
	 9ZimUlZtF/d78HMC9A/J8D8dV3PVHAvErsWP6/mk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	James Clark <james.clark@linaro.org>,
	"David S. Miller" <davem@davemloft.net>,
	"Steinar H. Gunderson" <sesse@google.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Kajol Jain <kjain@linux.ibm.com>,
	Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
	Hemant Kumar <hemant@linux.vnet.ibm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 485/826] perf disasm: Fix capstone memory leak
Date: Tue,  3 Dec 2024 15:43:32 +0100
Message-ID: <20241203144802.679932775@linuxfoundation.org>
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

From: Ian Rogers <irogers@google.com>

[ Upstream commit 1280f012e06e1555de47e3c3a9be898d8cbda5fb ]

The insn argument passed to cs_disasm needs freeing. To support
accurately having count, add an additional free_count variable.

Fixes: c5d60de1813a ("perf annotate: Add support to use libcapstone in powerpc")
Signed-off-by: Ian Rogers <irogers@google.com>
Reviewed-by: James Clark <james.clark@linaro.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Steinar H. Gunderson <sesse@google.com>
Cc: Alexander Lobakin <aleksander.lobakin@intel.com>
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Kajol Jain <kjain@linux.ibm.com>
Cc: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Cc: Hemant Kumar <hemant@linux.vnet.ibm.com>
Link: https://lore.kernel.org/r/20241016235622.52166-2-irogers@google.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/disasm.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/disasm.c b/tools/perf/util/disasm.c
index f05ba7739c1e9..2c8063660f2e8 100644
--- a/tools/perf/util/disasm.c
+++ b/tools/perf/util/disasm.c
@@ -1627,12 +1627,12 @@ static int symbol__disassemble_capstone(char *filename, struct symbol *sym,
 	u64 start = map__rip_2objdump(map, sym->start);
 	u64 len;
 	u64 offset;
-	int i, count;
+	int i, count, free_count;
 	bool is_64bit = false;
 	bool needs_cs_close = false;
 	u8 *buf = NULL;
 	csh handle;
-	cs_insn *insn;
+	cs_insn *insn = NULL;
 	char disasm_buf[512];
 	struct disasm_line *dl;
 
@@ -1664,7 +1664,7 @@ static int symbol__disassemble_capstone(char *filename, struct symbol *sym,
 
 	needs_cs_close = true;
 
-	count = cs_disasm(handle, buf, len, start, len, &insn);
+	free_count = count = cs_disasm(handle, buf, len, start, len, &insn);
 	for (i = 0, offset = 0; i < count; i++) {
 		int printed;
 
@@ -1702,8 +1702,11 @@ static int symbol__disassemble_capstone(char *filename, struct symbol *sym,
 	}
 
 out:
-	if (needs_cs_close)
+	if (needs_cs_close) {
 		cs_close(&handle);
+		if (free_count > 0)
+			cs_free(insn, free_count);
+	}
 	free(buf);
 	return count < 0 ? count : 0;
 
-- 
2.43.0



