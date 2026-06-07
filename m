Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 783FD78C9C;
	Sun,  7 Jun 2026 10:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780826824; cv=none; b=ZirGgoDxsRf+OWarHT8nZhUgkMAI5kLx1ybSUPw/OCxbIzhyfKPwhs3UTqviN05ItqyWVl9QFD2i8x7KQNE8+pZNSV2qrapimG4DpmDSf+cQdCU6Rb//ytdVF3gDEwOCB2b7cskQ50s2yn7ncGHBdgQg0RCi0x5UGKzdd3NWPlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780826824; c=relaxed/simple;
	bh=XgHvVWaHWQMggL7l2YcGvtUV1naZTNMhPyQnxRwDTOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d24YYGQBfqO+lXLnjXCPgVjGMeBn/I8l4LqE/DeiG/Qr18P4MrWQA9zhGsE3yPl8QEuDnoOPLSl+M6tif4lioQif5VXIeXYigZgMJHfAkWJOKP+ktcnUlm/Bsz2DPQemZMISnqs8bGZo7yutuXTGUzxR1YK5kpNcDUc1vnWM9Wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gjb1pHaO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gjb1pHaO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C01BE1F00893;
	Sun,  7 Jun 2026 10:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780826823;
	bh=wZoPvcdK8nY5KJvoPKD2N57jLi8/e5910T7S09qmeJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gjb1pHaO4e2bbtof3V0ofqVXKs/E6phhM3rssl3jIOVOm+PrIUTIKt6Q6+FnhGjw8
	 eRsWJXjJerRJLP2ICbNy/VxtXDJ94G7AJF5Qnnn3k/+fhI1ZO8qGkLiwh5VwQATWji
	 BV9l20s9lrEaFfqsNuK2REiMucxNZ+jNcU+8vroA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongtao Lee <lihongtao@kylinos.cn>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 011/315] tools/bootconfig: Fix buf leaks in apply_xbc
Date: Sun,  7 Jun 2026 11:56:38 +0200
Message-ID: <20260607095727.916259717@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



