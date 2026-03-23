Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCC1B3AF667;
	Mon, 23 Mar 2026 14:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274458; cv=none; b=oBuZwd+V5f+z4krqiZ/6lF9GPdLXlEdLNzNH8/Xw6kT4gu5KOF948b3muhSlMQCxUYOHkhSTR51sksL6NSuP8b7wu0lAslPUh/bx+69vo17seWqadItcBFXdrTv4EZa4WBM34Gn8PQpg3QHNlARkutH2NA6nnLx0THNWQHM0yIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274458; c=relaxed/simple;
	bh=Lp4RofuN4yeBPETDd/4Ho3i+C8Ywu9DvykOJDhtSR/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gKusnyPk7xf/zSVHiOgf34k75uCWOBEXmfkIhCigTmiZTKuKFiSNOkSKwwpOvDJ5KVyFLW+lA08Ky78x0J7rpbUMJkfSgyWZOu5r9BfElY3nQfmdvtwS7B5trPqoZGI9Ko/wX+NM6rAHrlQMNpEBjpD8hUD9lbGuTmrF+WQ4Do8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zcHQq2W2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zcHQq2W2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04909C2BC9E;
	Mon, 23 Mar 2026 14:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274458;
	bh=Lp4RofuN4yeBPETDd/4Ho3i+C8Ywu9DvykOJDhtSR/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zcHQq2W2y4F1hnhRMvU521bsD+2bxqzt8S7+M1Dd7pbadNLviHwDEwBpJl2t6Yqmm
	 93ALMr2JCH7WjvBrnUNMRLgl+XClULkdEuBhFVUizKHRIwuai6hwxapUyDnCTr8Tax
	 eSAs6NrzLpxJ5tjNsS7p98abSRvlHcRirPGgPnvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Law <objecting@objecting.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 217/220] tools/bootconfig: fix fd leak in load_xbc_file() on fstat failure
Date: Mon, 23 Mar 2026 14:46:34 +0100
Message-ID: <20260323134511.367749017@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Law <objecting@objecting.org>

[ Upstream commit 3b2c2ab4ceb82af484310c3087541eab00ea288b ]

If fstat() fails after open() succeeds, the function returns without
closing the file descriptor. Also preserve errno across close(), since
close() may overwrite it before the error is returned.

Link: https://lore.kernel.org/all/20260318155847.78065-3-objecting@objecting.org/

Fixes: 950313ebf79c ("tools: bootconfig: Add bootconfig command")
Signed-off-by: Josh Law <objecting@objecting.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bootconfig/main.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/bootconfig/main.c b/tools/bootconfig/main.c
index 55d59ed507d54..643f707b8f1da 100644
--- a/tools/bootconfig/main.c
+++ b/tools/bootconfig/main.c
@@ -162,8 +162,11 @@ static int load_xbc_file(const char *path, char **buf)
 	if (fd < 0)
 		return -errno;
 	ret = fstat(fd, &stat);
-	if (ret < 0)
-		return -errno;
+	if (ret < 0) {
+		ret = -errno;
+		close(fd);
+		return ret;
+	}
 
 	ret = load_xbc_fd(fd, buf, stat.st_size);
 
-- 
2.51.0



