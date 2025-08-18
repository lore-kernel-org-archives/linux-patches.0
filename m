Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A46F334700;
	Mon, 18 Aug 2025 14:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526210; cv=none; b=HiA8zclahzk58zy4xKV308/bpi8ijwv6nDBblHuk5K9nigzxkzXeP8dD0bhCVQ+LZbvSw8Rqy6dB7k542cWyMAil+c6MZoBAOwsAeXPCC70F7XW7ajlZJwcGVRNuZzUeZreENFKMlNxyCFYORB5xC23prOGwl35X0at+xOPJrSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526210; c=relaxed/simple;
	bh=edy7oyT8Usr9ZC61e72XcdVnnUeiqRb3j/KTKiEMoj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AqT1faK/W+uH/gh8oIiMUVHnT9k3X+0rm0LTH5Akk3ZE73Hb/R48G88BJpj1iB0fnCt2B9z2MEAdgL3jZMOsFrDY5S9698aRM9UIPYXBGEXilxGY+w7+SOJBXUTYu+6XH/bEuyAc8s/Zs3zrnJEA0DvgKXEbL+GyW9niwCmKcfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UxMXsq38; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UxMXsq38"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C102C4CEEB;
	Mon, 18 Aug 2025 14:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526210;
	bh=edy7oyT8Usr9ZC61e72XcdVnnUeiqRb3j/KTKiEMoj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UxMXsq38U9A8OkXHSrXE+IOYRVcVSNsJvIIK4VLDDWGM/tu96PeCpn9bDmYre7qFk
	 Pnz01o/CMo3ZPONy2CDTuQy35q4dtZnCgDVp4jhnLP8oR4JjI9CtNDZQ0RDzqo1Ad8
	 +eUVJussHqrHza6MSMGqzwZmiGHP2txThBWfgktI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.16 490/570] samples/damon/mtier: support boot time enable setup
Date: Mon, 18 Aug 2025 14:47:57 +0200
Message-ID: <20250818124524.753272322@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

commit 964314344eab7bc43e38a32be281c5ea0609773b upstream.

If 'enable' parameter of the 'mtier' DAMON sample module is set at boot
time via the kernel command line, memory allocation is tried before the
slab is initialized.  As a result kernel NULL pointer dereference BUG can
happen.  Fix it by checking the initialization status.

Link: https://lkml.kernel.org/r/20250706193207.39810-4-sj@kernel.org
Fixes: 82a08bde3cf7 ("samples/damon: implement a DAMON module for memory tiering")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 samples/damon/mtier.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/samples/damon/mtier.c
+++ b/samples/damon/mtier.c
@@ -151,6 +151,8 @@ static void damon_sample_mtier_stop(void
 	damon_destroy_ctx(ctxs[1]);
 }
 
+static bool init_called;
+
 static int damon_sample_mtier_enable_store(
 		const char *val, const struct kernel_param *kp)
 {
@@ -176,6 +178,14 @@ static int damon_sample_mtier_enable_sto
 
 static int __init damon_sample_mtier_init(void)
 {
+	int err = 0;
+
+	init_called = true;
+	if (enable) {
+		err = damon_sample_mtier_start();
+		if (err)
+			enable = false;
+	}
 	return 0;
 }
 


