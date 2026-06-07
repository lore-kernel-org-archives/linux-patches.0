Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B35E2E7360;
	Sun,  7 Jun 2026 10:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780826797; cv=none; b=ulR6itb7J+yM++8leAhNUcH7JK9/svHd2Bdvx7SDdnifGgziV/susdg8B4aIjuLiYX2lOzEF5YrXdVFClW4cwb4VfAl3bXBDgEhvaeYQB40lbfy816B6nvvasr59d4KoMMIjAHgKjMNYbDm4U4t0eJjsgwv4G5qD7gW5oUTsRaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780826797; c=relaxed/simple;
	bh=8TJMihczcbS8V0jpLTN/DeyfwQCtBpBYKmu5+PsiV/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kHDlXuH78r/cOPGarVJAY0khsfxZMJZ8CHNtlkoBFfSmv/XlWZOaol9IohnHVLcEMmtwH5VjxeR9yJwM0lmxNNU5S11tuHSgMz17OrZeLLcoHK3G8H3aCtfQN/PGZpMoIWM7bmZ3kkZXhbzXAXua+bdJCvXy4TrWhyeqMj0yNwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RnkaUmTE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RnkaUmTE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFB8A1F00893;
	Sun,  7 Jun 2026 10:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780826796;
	bh=TEKGS4Y+5oBZwJbMOVe1MD2DltCbd1dvm0NQRjGKwlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RnkaUmTENNZBqwI2fM1VCpFzhFFadaoA7waQWhg447tuTy5kvcSgGtk2EBSBBodfE
	 /gwwy+xVirXf+kYKjxwdcwU7p4gu6x2OEoGisFDyahRpxFXmX6T5EWG0S8ObTZkbMu
	 jxV8e6mY/a+RFmlpMhxcobra/B/EgUCtC3pDFvKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongtao Lee <lihongtao@kylinos.cn>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 011/332] tools/bootconfig: Fix buf leaks in apply_xbc
Date: Sun,  7 Jun 2026 11:56:20 +0200
Message-ID: <20260607095728.437409193@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 643f707b8f1da1..ddabde20585f21 100644
--- a/tools/bootconfig/main.c
+++ b/tools/bootconfig/main.c
@@ -390,8 +390,10 @@ static int apply_xbc(const char *path, const char *xbc_path)
 
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



