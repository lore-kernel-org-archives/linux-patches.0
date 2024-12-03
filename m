Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C255A23CE;
	Tue,  3 Dec 2024 16:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241693; cv=none; b=oJEaE28e3er+qhtdxVPmD9/mE9C455aTD+fDd5gSAil38oY842QN4cwToOhzMELsAKMaxABk049e6cYqjHJ76U79LSmyiWa2YNd3DEsVVlz+wWPV/wLLliZiXxRBvwM0OYinXdbEnxVgZ3AMsZMOQ9ce2VICdVPXe8YVMvRUGSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241693; c=relaxed/simple;
	bh=bVIIB4W2Yz2Mzl6/SMxO4o3LVkrBnhJ3VJ3e2SvBR+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jHMM3cHA3GYIqezCqXRbrMDYOUoA09lDQpwKLAoxccd9fhZRkbN6WD9WCxuv/F2/kb6keWWklBT7Oib2yoQMboQ7FBhDyKy13So6723lLhMqp9zftD+dURRUOfxDS8r80fVyjakoyoXRxiyVykiWTHgzsP/WU/JDQg2ge12tRpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K8eG0WGe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K8eG0WGe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2808BC4CECF;
	Tue,  3 Dec 2024 16:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241693;
	bh=bVIIB4W2Yz2Mzl6/SMxO4o3LVkrBnhJ3VJ3e2SvBR+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K8eG0WGee9C3XY2TEcAOnPMQrVvQs6dprAW6KrfobpS3rBkQMxm3mx/0r5Ra05qKP
	 etH7gfln6E2nrO1/sx+1ZiCyRM+CmoWN2pcZunNlLASdtdBEglV6L7Dlv7oQ3bvPwi
	 5wkeERIOKv8g3FLYJ7kjJ2iqYWF9HGwXK6qwto7U=
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
Subject: [PATCH 6.12 492/826] perf disasm: Use disasm_line__free() to properly free disasm_line
Date: Tue,  3 Dec 2024 15:43:39 +0100
Message-ID: <20241203144802.948748346@linuxfoundation.org>
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
index 2c8063660f2e8..5d5fcc4dee078 100644
--- a/tools/perf/util/disasm.c
+++ b/tools/perf/util/disasm.c
@@ -1720,7 +1720,7 @@ static int symbol__disassemble_capstone(char *filename, struct symbol *sym,
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



