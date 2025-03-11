Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07C2C25E808;
	Tue, 11 Mar 2025 15:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705588; cv=none; b=CaOxe+U4VS6vfJyrqBAEnO8tk1396XMafyqF1KjGvdMU4of2BAJ6hjUwKvk9vUPPBIpW5phU4I6fQ1FwaXGNzTN/Fb59ahPCF84uXVjByJhuEfusKRUT7UMEnyPqi4ubOScZhTsQKflL3CRWtEZYWDVgTcUKl70BSKfBosuxXto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705588; c=relaxed/simple;
	bh=hn1DtNsiWbNuidKA+ATWAmUri529VLRwxoaiPPT2PKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E/v7DFeDE9BD8w63K4LqMFWznYPgP+Xp3Ca++jdKhIhHnHEmT4IDg0Q56rKOrXrvVog8DWqvtEhisZl1098gNdXBXDtsnFDe93WwD+Ot+grYh71S0JnowdwPu2qo2gNkAoahulMnFK8zNum+Jm7FHvlnVKrgABX+v6lk8s0bhJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mj4TpuKm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mj4TpuKm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83A4FC4CEE9;
	Tue, 11 Mar 2025 15:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705587;
	bh=hn1DtNsiWbNuidKA+ATWAmUri529VLRwxoaiPPT2PKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mj4TpuKmxGSVQofBFVGOF77aG5iYRQquxQQpTSZn8mQu3FJf94ZGa9FYT2FRBWWPV
	 vxjcUW4RjVntrcmbTrD4N74VulTXo5NLu5ZEdVPmT/Ggy1DtK1iANESpFmATNr4e0t
	 QnKMKW9TEz0axTV9u7O4DVQZ04t6C7/hGl7+O1Kk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	Petr Mladek <pmladek@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 087/328] printk: Fix signed integer overflow when defining LOG_BUF_LEN_MAX
Date: Tue, 11 Mar 2025 15:57:37 +0100
Message-ID: <20250311145718.345963109@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuan-Wei Chiu <visitorckw@gmail.com>

[ Upstream commit 3d6f83df8ff2d5de84b50377e4f0d45e25311c7a ]

Shifting 1 << 31 on a 32-bit int causes signed integer overflow, which
leads to undefined behavior. To prevent this, cast 1 to u32 before
performing the shift, ensuring well-defined behavior.

This change explicitly avoids any potential overflow by ensuring that
the shift occurs on an unsigned 32-bit integer.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Acked-by: Petr Mladek <pmladek@suse.com>
Link: https://lore.kernel.org/r/20240928113608.1438087-1-visitorckw@gmail.com
Signed-off-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/printk/printk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index ae1a97dd0c3cb..f6e1e154d9c18 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -457,7 +457,7 @@ static u32 clear_idx;
 /* record buffer */
 #define LOG_ALIGN __alignof__(struct printk_log)
 #define __LOG_BUF_LEN (1 << CONFIG_LOG_BUF_SHIFT)
-#define LOG_BUF_LEN_MAX (u32)(1 << 31)
+#define LOG_BUF_LEN_MAX ((u32)1 << 31)
 static char __log_buf[__LOG_BUF_LEN] __aligned(LOG_ALIGN);
 static char *log_buf = __log_buf;
 static u32 log_buf_len = __LOG_BUF_LEN;
-- 
2.39.5



