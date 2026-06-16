Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 280F23A9627;
	Tue, 16 Jun 2026 17:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630445; cv=none; b=OEbETl3D3Rj7mX9iVYELVSC3QoLP7LksiESN9WAhIVv7xHokSq8GCqJQw67ONcmydgWqnTAccxuNBFGwa/39nYGtWWMSzWKYMj2vI9xEJ4hPLjePwAaJWyMhe7ayKVKQDKA6EgHpnkU0YwHO2kHUGUGD0c2DgH2l3lOWSF9FYLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630445; c=relaxed/simple;
	bh=sBQroUR3SDRG8mArL3xve1lPX0M2gX0KnQulhRR9vkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qzOa6MVDRdYWWWiMVLudT6xkoNchMw4VqrKkAiDu+/XppMr2QLlYvHbJecrfQPRBwZAllgjZNrKZViEStrWdTS7S11bPJ65Vli404BT1NrfIEyUm3viSxAuDDOo1NZAnFYwoiZJjw93LPwcyW5/soUiTUJgp8JmMG61rNSisDTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vU7Fj7uu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vU7Fj7uu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D72F1F000E9;
	Tue, 16 Jun 2026 17:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630444;
	bh=qucrC1euLrTubRFaHHnhA0Wfyb4zNQtlGaJQX8sddO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vU7Fj7uuo7EIzRU7KD2vsMDc0jv1GSpA9Y9iRXsVQeZ/iNE26J+QYNBrT6YaaWwDl
	 czCFXW8GzLUnZdjNzzieAA+hvVgHoguZOqcpnU7eQK9P7ZxouE17TpLr9g0hfPdWuv
	 YmM4AVKHKOP6tuQELGwZSc117uu8AcCFs4GmlXps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongtao Lee <lihongtao@kylinos.cn>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 012/522] tools/bootconfig: Fix buf leaks in apply_xbc
Date: Tue, 16 Jun 2026 20:22:39 +0530
Message-ID: <20260616145126.016664113@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongtao Lee <lihongtao@kylinos.cn>

[ Upstream commit f42d01aadcedd7bbf4f9a466cabe25c1781dedad ]

If data calloc failed, free the buf before return.

Link: https://lore.kernel.org/all/20260520030126.147782-1-lihongtao@kylinos.cn/

Fixes: 950313ebf79c ("tools: bootconfig: Add bootconfig command")
Signed-off-by: Hongtao Lee <lihongtao@kylinos.cn>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bootconfig/main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/bootconfig/main.c b/tools/bootconfig/main.c
index d302235f6b9743..49573044e93a58 100644
--- a/tools/bootconfig/main.c
+++ b/tools/bootconfig/main.c
@@ -384,8 +384,10 @@ static int apply_xbc(const char *path, const char *xbc_path)
 
 	/* Backup the bootconfig data */
 	data = calloc(size + BOOTCONFIG_ALIGN + BOOTCONFIG_FOOTER_SIZE, 1);
-	if (!data)
+	if (!data) {
+		free(buf);
 		return -ENOMEM;
+	}
 	memcpy(data, buf, size);
 
 	/* Check the data format */
-- 
2.53.0



