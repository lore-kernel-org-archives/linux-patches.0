Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2471B23CE;
	Tue,  3 Dec 2024 16:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241697; cv=none; b=uBMLehwZyFYr7FfuRFfsiHoql2aSZrVDMYJqLw17zznPZ/E5Ndlqznwt33MF5EOcnsDfd0dQrVnNx6gBZcZdnIPMsEYIQd7BUxaPF5lCHmVXwd8o+wAhXs/o0PW3pNKQmJSbOBCHe7a8vhqHxxynO1xKSTXg18lOqusSKu8/aFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241697; c=relaxed/simple;
	bh=VjEQ1oOZOUJZ13WSIws48NRIcpTkp9Z5gnq7w3Hbzoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SUaLdh+uWZ4GuJ1TKn0VLju5l5NTfimQ4e1prkvnvnQ+o1Nx3Cdz3jHluu6IeqL/NypQKSinPsUthDUcr9FyGVmaVpJoIxBBBfrXDtV3JA5bEtsixvC9Or+AbmvvMowg1pPBK48rkJ7dUfDdRLYRfTRX29/4U4AnB95+7Eu/W7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vDxV79Cd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vDxV79Cd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8171CC4CECF;
	Tue,  3 Dec 2024 16:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241697;
	bh=VjEQ1oOZOUJZ13WSIws48NRIcpTkp9Z5gnq7w3Hbzoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vDxV79CdRhjNnrpGbyQyh0caKqOuJqIeFaBtYXi5o91WxXSVNVSNaa1mIzNPZ6547
	 EKwLSdrqx+69YIBqOT6oOWdJgZI9q5UW/vX3B53eS7S5mXheP6O2TO45UibuirPRoO
	 rLvbmNEctGjZVsc9AXfsRpE8dTGzOhQ+Rnnp3cJc=
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
Subject: [PATCH 6.12 493/826] perf disasm: Fix not cleaning up disasm_line in symbol__disassemble_raw()
Date: Tue,  3 Dec 2024 15:43:40 +0100
Message-ID: <20241203144802.987227906@linuxfoundation.org>
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

[ Upstream commit 150dab31d5609f896fbfaa06b442ca314da79858 ]

In symbol__disassemble_raw(), the created disasm_line should be
discarded before returning an error. When creating disasm_line fails,
break the loop and then release the created lines.

Fixes: 0b971e6bf1c3 ("perf annotate: Add support to capture and parse raw instruction in powerpc using dso__data_read_offset utility")
Signed-off-by: Li Huafei <lihuafei1@huawei.com>
Tested-by: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Cc: sesse@google.com
Cc: kjain@linux.ibm.com
Link: https://lore.kernel.org/r/20241019154157.282038-3-lihuafei1@huawei.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/disasm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/disasm.c b/tools/perf/util/disasm.c
index 5d5fcc4dee078..648e8d87ef194 100644
--- a/tools/perf/util/disasm.c
+++ b/tools/perf/util/disasm.c
@@ -1785,7 +1785,7 @@ static int symbol__disassemble_raw(char *filename, struct symbol *sym,
 		sprintf(args->line, "%x", line[i]);
 		dl = disasm_line__new(args);
 		if (dl == NULL)
-			goto err;
+			break;
 
 		annotation_line__add(&dl->al, &notes->src->source);
 		offset += 4;
-- 
2.43.0



