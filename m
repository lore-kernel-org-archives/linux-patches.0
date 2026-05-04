Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63CCC1ADC83;
	Mon,  4 May 2026 14:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903534; cv=none; b=PCAlE6sNTVYJsdFfTkXKCPELApG02MCfWaef/MFJuHVAiD37NObHrg73VxjGj5g4VP/ykYqahPaFyifKF/0eYu9tgfetJKC3WFhlAaDPvgcBosSVhFrdd25AyuGokkZ2vlxnPk/nZ1gwk/RYsKRG14WabMOcZnOfIassCDr5qOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903534; c=relaxed/simple;
	bh=z+HEB5ObMIO7bcZoGvccKn9bqxJpJbuJEEcd3zevF3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gi8chA8W3dLxFFZZHy6dEanazu1bbk55ZTrAxBCVJFczBoTFjOTi2NE5OKp61IGI2oK6hJ1wyGm4rgModRZb/XU9jwmsN3XxwjYhiqXiTZ1lkElj/IePq5n9Ej2qB46sxAkjJSZIOEA3jTryw+c8f+DL/dEHZuk3YhmC8pH8Hxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wV2dToGe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wV2dToGe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEACDC2BCB8;
	Mon,  4 May 2026 14:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903534;
	bh=z+HEB5ObMIO7bcZoGvccKn9bqxJpJbuJEEcd3zevF3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wV2dToGewAuXCH4zb+LcWxNGzgaFuZPfU6wy5hhTXiRykK5NcTsWME1erVHG0fpD3
	 V9nvo6xwwcmvkEMhdrEW82KmJ1tlxmeK3tEdNNShdKyDkdzACZDMKf5OUig+msWXM6
	 IHt2h6u8Jg4TkFnUSzMHrRKaAqenk+tGmiqFEygI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.0 270/307] dm mirror: fix integer overflow in create_dirty_log()
Date: Mon,  4 May 2026 15:52:35 +0200
Message-ID: <20260504135152.967036412@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

From: Junrui Luo <moonafterrain@outlook.com>

commit 4c788c6f921b22f9b6c3f316c4a071c05683e7de upstream.

The argument count calculation in create_dirty_log() performs
`*args_used = 2 + param_count` before validating against argc. When a
user provides a param_count close to UINT_MAX via the device mapper
table string, this unsigned addition wraps around to a small value,
causing the subsequent `argc < *args_used` check to be bypassed.

The overflowed param_count is then passed as argc to dm_dirty_log_create(),
where it can cause out-of-bounds reads on the argv array.

Fix by comparing param_count against argc - 2 before performing the
addition, following the same pattern used by parse_features() in the
same file. Since argc >= 2 is already guaranteed, the subtraction is
safe.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-raid1.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -993,13 +993,13 @@ static struct dm_dirty_log *create_dirty
 		return NULL;
 	}
 
-	*args_used = 2 + param_count;
-
-	if (argc < *args_used) {
+	if (param_count > argc - 2) {
 		ti->error = "Insufficient mirror log arguments";
 		return NULL;
 	}
 
+	*args_used = 2 + param_count;
+
 	dl = dm_dirty_log_create(argv[0], ti, mirror_flush, param_count,
 				 argv + 2);
 	if (!dl) {


