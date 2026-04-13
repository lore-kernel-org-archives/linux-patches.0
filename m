Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8363FCA6F;
	Mon, 13 Apr 2026 16:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097834; cv=none; b=UUW8+1JLafJN7zrbuItig+TBHBUPcpvDgYduzaz58ZytWSVKb8XUhekJcnxbYE1EQ96LjGs4gxVpUgghPRFqQ4XLaCxGE0cvAx74+X4ne572gLq/XxrTEe2vr/YWoxybCRdgudAQVAp7533qYv9FanT2SLy9MMvruv2LQeee2Rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097834; c=relaxed/simple;
	bh=Z+bL1Lnv3lT5iPPWrMHS1H8Z7rJh/znyowTVSvmQF8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WidIIHsbaB2/Or3CEVl0onX3Wz0h/acAXwPVq7G5jjbh9YrbqO0LxAN9vzMTkuV6M4bLj/8/X/M7jkkl4K5LWRz9kiL8FSUogYSmYakMjctEm3MjbJ2KzHuOw1Lx+YmYvCKfZ9gzCoGFWS3RO4RKAopFmbe3VfFFwAsScmGJaSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X6z658tA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X6z658tA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1935BC2BCAF;
	Mon, 13 Apr 2026 16:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097834;
	bh=Z+bL1Lnv3lT5iPPWrMHS1H8Z7rJh/znyowTVSvmQF8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X6z658tAE5o+YYSx9obPAs7xw+xBaen90WsnefxRM3QxaclQByp7ZePGCrXpegrmZ
	 Y2e7LeFJtB7WebxPPOnyDKyQjeB5W3wsu5KD9tIdV73XpTshR9QZtvIumn0HYpgFu2
	 EJDrhK2UFXkzAiJckRNneSK8fHuXhOW0UreKPJq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Law <objecting@objecting.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 290/570] tools/bootconfig: fix fd leak in load_xbc_file() on fstat failure
Date: Mon, 13 Apr 2026 17:57:01 +0200
Message-ID: <20260413155841.355703126@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index fc922cfdadaa6..78b252ac3817e 100644
--- a/tools/bootconfig/main.c
+++ b/tools/bootconfig/main.c
@@ -156,8 +156,11 @@ static int load_xbc_file(const char *path, char **buf)
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



