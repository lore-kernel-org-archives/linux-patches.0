Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5730313298;
	Mon, 13 Apr 2026 16:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099161; cv=none; b=p+Mzrvz+kCA1KR6P0Q2IiMeiLsyWMwtOeLY9Ldh0BOi/K3ZI0BubZE7lTge6dxxlfteFXR8ta1oaDLP3L+fRo446XLokaAyQyokMmWVQtnUxv3Xbye5QBxsGYKxzRxOMRshGxbuyZPeow+81wn65vNPgR497KyeVO0UQMRwdqS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099161; c=relaxed/simple;
	bh=TLc2BlHl6tBRpl9EyvN02j6jrwg1v53F1q73zdNfLXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dkLt86l5hxQAXRDEa/zgnLb6ebVlSmc7C6V1iNWyET013D5JHS516wFmpqW2aH2CzByR15XoG4pdZU1L/5YWYOjQ1BSZuemovhBxdOnxsG4G9fouWt1YQLFIBK8G4TIJHWHesZGniu7urdWxb5lUxb7UQBIEpKrJoJbrf4qtKV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d7GKQ2Mg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d7GKQ2Mg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DB87C2BCAF;
	Mon, 13 Apr 2026 16:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099160;
	bh=TLc2BlHl6tBRpl9EyvN02j6jrwg1v53F1q73zdNfLXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d7GKQ2MgujsqrNHyIMapQU+Q0Bo/By7WbDhLex5n23T51JGti93CLLDfzhq+pI4c1
	 jTL/m16sFRqItGipa1G5dgHNvr1tY5+xplUc7vz3o1iKLTSzrU0VTpSBxJLAmgldg9
	 /Fqdrte9IE/0ZVBQlOS0dZFosB4ItZii40kGfgm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Law <objecting@objecting.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 233/491] tools/bootconfig: fix fd leak in load_xbc_file() on fstat failure
Date: Mon, 13 Apr 2026 17:57:58 +0200
Message-ID: <20260413155827.782244742@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 365c022fb7cdd..387cb91862dfc 100644
--- a/tools/bootconfig/main.c
+++ b/tools/bootconfig/main.c
@@ -138,8 +138,11 @@ static int load_xbc_file(const char *path, char **buf)
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



