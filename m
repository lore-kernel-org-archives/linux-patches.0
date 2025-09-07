Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 101001DF246;
	Sun,  7 Sep 2025 20:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277310; cv=none; b=MaknGofTXYSoN4UKUe72zfgrmTHV6dNpJIeLWzQHarj1oQzykYOOD7WdBT8/YmBpHkJZIWNjolAog4Ft+b6qeQ4ukU5znnAiVaN9PRY3kteLXPDfvec38SeF9mHjg2bEl6W1Y2gwIb79cYO3yUuzywu8+PSLMKK1yuRq2MW6d/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277310; c=relaxed/simple;
	bh=uMi6u899tckvjFCJT4hcehMsJVZZ7UURJRSWqp3M/c8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iph7bG0lSYGVWRS95ZChAxNMC6bxXm/TdzC5k6WymjBh4xb8yHgvLj/WqM+/MQuCjF+o6CZOWrmzgKkc1M8NcNBriGQJ1zstSr4i1LBwPQeMuWdzaa2bDiosIXWAF15qAzicVu4D7xpYS1RXbApeHx2Yn5GFf8Pvh+VRIsKe2p8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H9DpbP/C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H9DpbP/C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86151C4CEF0;
	Sun,  7 Sep 2025 20:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277309;
	bh=uMi6u899tckvjFCJT4hcehMsJVZZ7UURJRSWqp3M/c8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H9DpbP/C8+t2ywAKipK4kLHlhaqabnPrE+opg+2ygckiBGiLeLW4kXQ+VtHAHPLnG
	 zV5bclLhV0o+Io6w3+OuvsnMouACcD9uTFNNfERRbyer2B0sRlHGIqw7EMnjOT+WzF
	 wuog38zwvbYnb0rZXLlwgNYyk/hoO1emwdBcDdQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 151/175] pcmcia: Add error handling for add_interval() in do_validate_mem()
Date: Sun,  7 Sep 2025 21:59:06 +0200
Message-ID: <20250907195618.428545557@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 4a81f78caa53e0633cf311ca1526377d9bff7479 ]

In the do_validate_mem(), the call to add_interval() does not
handle errors. If kmalloc() fails in add_interval(), it could
result in a null pointer being inserted into the linked list,
leading to illegal memory access when sub_interval() is called
next.

This patch adds an error handling for the add_interval(). If
add_interval() returns an error, the function will return early
with the error code.

Fixes: 7b4884ca8853 ("pcmcia: validate late-added resources")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pcmcia/rsrc_nonstatic.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/pcmcia/rsrc_nonstatic.c b/drivers/pcmcia/rsrc_nonstatic.c
index bf9d070a44966..da494fe451baf 100644
--- a/drivers/pcmcia/rsrc_nonstatic.c
+++ b/drivers/pcmcia/rsrc_nonstatic.c
@@ -375,7 +375,9 @@ static int do_validate_mem(struct pcmcia_socket *s,
 
 	if (validate && !s->fake_cis) {
 		/* move it to the validated data set */
-		add_interval(&s_data->mem_db_valid, base, size);
+		ret = add_interval(&s_data->mem_db_valid, base, size);
+		if (ret)
+			return ret;
 		sub_interval(&s_data->mem_db, base, size);
 	}
 
-- 
2.51.0



