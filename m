Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 675EE646;
	Tue,  3 Dec 2024 15:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239109; cv=none; b=YPD35ulRBXm7BTH98DOkPUeKnCc6QK6D2rHLQbc/zUk7j03b5qcta8ugR44sm9+sXsGYkOm7lCB+NoPG+Vu2A/S3yPbzYHrWNSnRUrcxRwdTVq2/nB4fcGbno+hpfEl1dGGwAA+dfRmEN6byMINERuyjKO7xA9oqeEm/ommIYmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239109; c=relaxed/simple;
	bh=f0/qRd4HClbfi6FMmanKgJM8VBBGZYwqfBF//O/PMcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z7kgBO1YDrQKtwW2WSyqSeDeVIVdvzg3sG4PgZYYfJqUuHDjEjJ0p2n8/0FSg1G35xwqDgiNnmX26ChI1udEsukNCT7+3ZtrN9eJ3RLem7fdDXyAg2BD0GVYnFFvmdwJD3VUqRCGMRS8JmgP1JUuzq7VefRam0OteM9hP4njSrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LdBIObeU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LdBIObeU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A8ECC4CED6;
	Tue,  3 Dec 2024 15:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239108;
	bh=f0/qRd4HClbfi6FMmanKgJM8VBBGZYwqfBF//O/PMcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LdBIObeUoJ0AlzYy3FDQv2fXICWrTGKMMwAh4TxSrqD2cO8vbJj28sWjwcIgY3+hY
	 E/cYq3uXZzJbnqVIEJ4pkDxPaaP1G00vk341RHrbSEcyHh1XHpeEno3YN86jI4mTWH
	 2rkRUARXdQhBRcQhG2SoM101s2MKxgDDJ48AL8kA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Huafei <lihuafei1@huawei.com>,
	Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
	sesse@google.com,
	kjain@linux.ibm.com,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 504/817] perf disasm: Use disasm_line__free() to properly free disasm_line
Date: Tue,  3 Dec 2024 15:41:16 +0100
Message-ID: <20241203144015.547319634@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Huafei <lihuafei1@huawei.com>

[ Upstream commit b4e0e9a1e30059f4523c9b6a1f8045ad89b5db8a ]

The structure disasm_line contains members that require dynamically
allocated memory and need to be freed correctly using
disasm_line__free().

This patch fixes the incorrect release in
symbol__disassemble_capstone().

Fixes: 6d17edc113de ("perf annotate: Use libcapstone to disassemble")
Signed-off-by: Li Huafei <lihuafei1@huawei.com>
Tested-by: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Cc: sesse@google.com
Cc: kjain@linux.ibm.com
Link: https://lore.kernel.org/r/20241019154157.282038-1-lihuafei1@huawei.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/disasm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/disasm.c b/tools/perf/util/disasm.c
index 766cbd005f32a..c2ce33e447e35 100644
--- a/tools/perf/util/disasm.c
+++ b/tools/perf/util/disasm.c
@@ -1391,7 +1391,7 @@ static int symbol__disassemble_capstone(char *filename, struct symbol *sym,
 		 */
 		list_for_each_entry_safe(dl, tmp, &notes->src->source, al.node) {
 			list_del(&dl->al.node);
-			free(dl);
+			disasm_line__free(dl);
 		}
 	}
 	count = -1;
-- 
2.43.0



