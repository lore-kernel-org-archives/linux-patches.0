Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B98A2330B3F;
	Fri, 17 Oct 2025 15:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715573; cv=none; b=Mf0V0VxBdA9FLhVmo3HxuAxparA8vVzK4lF2FpNMySjWmAMsQB+pEItqu4iY/3n94zfryqzF8F3i+IW5Sy8nJc5UCCw9U1FD1ummV1m0saHbLStThck7IUSgAHsFkgV8XyP8DLcUL1mWqwauV7JpnbEfbMulKfGRLM9sj4ccj1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715573; c=relaxed/simple;
	bh=6OItmhq2sMhSbffNK2NgQiyKO4TwDCVKTBsBWrxW7ss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HpGJEsxZgJfU07gKzFNP22VUldj9k+TZ7c7YbtUpOpNpMRbhv5o/hs/WbZL/xfDqKbHU2rhilXC/5N85P8dEXkaKxNBxp6HcBGHiYK9Z9IDTIlhQcrpBHLf/Kf6zXJEYMi35akZumidsX6rq2wLOncVtwjd1tsv7vnX7Bqjtdbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xtqm/sRk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xtqm/sRk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E615C4CEE7;
	Fri, 17 Oct 2025 15:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715573;
	bh=6OItmhq2sMhSbffNK2NgQiyKO4TwDCVKTBsBWrxW7ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xtqm/sRkwe8Tt5tCkpm7b7ql9huIat6Cp0OEbAW5y975HZWohmdcS40GGC3qafLtX
	 /evGeno7YI9WjZsgnSNKXgg1ItSVN1Up3M/aIOkhG+KZTzlKBaymuFl8h129mebHbF
	 qTyjic04QKQoLRvswjqVYaz/gz1lEQxyyvbNcXbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH 6.17 262/371] xtensa: simdisk: add input size check in proc_write_simdisk
Date: Fri, 17 Oct 2025 16:53:57 +0200
Message-ID: <20251017145211.559244075@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miaoqian Lin <linmq006@gmail.com>

commit 5d5f08fd0cd970184376bee07d59f635c8403f63 upstream.

A malicious user could pass an arbitrarily bad value
to memdup_user_nul(), potentially causing kernel crash.

This follows the same pattern as commit ee76746387f6
("netdevsim: prevent bad user input in nsim_dev_health_break_write()")

Fixes: b6c7e873daf7 ("xtensa: ISS: add host file-based simulated disk")
Fixes: 16e5c1fc3604 ("convert a bunch of open-coded instances of memdup_user_nul()")
Cc: stable@vger.kernel.org
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Message-Id: <20250829083015.1992751-1-linmq006@gmail.com>
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/xtensa/platforms/iss/simdisk.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/arch/xtensa/platforms/iss/simdisk.c
+++ b/arch/xtensa/platforms/iss/simdisk.c
@@ -231,10 +231,14 @@ static ssize_t proc_read_simdisk(struct
 static ssize_t proc_write_simdisk(struct file *file, const char __user *buf,
 			size_t count, loff_t *ppos)
 {
-	char *tmp = memdup_user_nul(buf, count);
+	char *tmp;
 	struct simdisk *dev = pde_data(file_inode(file));
 	int err;
 
+	if (count == 0 || count > PAGE_SIZE)
+		return -EINVAL;
+
+	tmp = memdup_user_nul(buf, count);
 	if (IS_ERR(tmp))
 		return PTR_ERR(tmp);
 


