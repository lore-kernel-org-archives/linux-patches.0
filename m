Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 472B02AE72;
	Tue, 29 Apr 2025 18:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950406; cv=none; b=UNoHk/RbOXfpG/Ode1v6PERyXV7LONXMRRRR5tYpyNgSYT0oHeWzVDdKdWBy3fzXNhRNYVUak1hgAJ+leTrxIi3Ym4qcZ1oybbKo3j5LLJrGAmNj4pmQhTohc7S+DCygJ/v+T1eRyv9Fh8Qt/OCR7uavN960qj4xht+RxqDTQTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950406; c=relaxed/simple;
	bh=/wccCfPHGlUQY87JgBfZHnAsE8SVRA+av9BKCV21SQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T5JCDkbykxdhij8M2WXjP08kgPnyblhlAlCOyCCwvD1jGwJZHund13510YZZWHSyTgGT/XYhyiuUwoHJa6icg4VZffGtzwzybAwFQEzX/Oh2+acyv62DtxaiEAQpmbHVYdArtT6CN74jxW1Vvnpan0Hu+bLH95ZuSXOvf3+R2wE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NtxlyU1F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NtxlyU1F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C72BDC4CEE3;
	Tue, 29 Apr 2025 18:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950406;
	bh=/wccCfPHGlUQY87JgBfZHnAsE8SVRA+av9BKCV21SQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NtxlyU1FPrOdov09f6wYXgiU4zosLHVBU3TSup88i/nxAyaYRvp2sO84AxdCzyjD+
	 MXOEhanbtiRqxpeYKKcR1nivbMAvvHz1o5WqcumAB15gw/5KeyNz0xYogbtjLePS2U
	 sxH4swkkAP/+7fVoalnoiyWdG7EgVGHxqqS9gfwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Johannes Thumshirn <jth@kernel.org>
Subject: [PATCH 6.6 085/204] mcb: fix a double free bug in chameleon_parse_gdd()
Date: Tue, 29 Apr 2025 18:42:53 +0200
Message-ID: <20250429161102.898283277@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

commit 7c7f1bfdb2249f854a736d9b79778c7e5a29a150 upstream.

In chameleon_parse_gdd(), if mcb_device_register() fails, 'mdev'
would be released in mcb_device_register() via put_device().
Thus, goto 'err' label and free 'mdev' again causes a double free.
Just return if mcb_device_register() fails.

Fixes: 3764e82e5150 ("drivers: Introduce MEN Chameleon Bus")
Cc: stable <stable@kernel.org>
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Signed-off-by: Johannes Thumshirn <jth@kernel.org>
Link: https://lore.kernel.org/r/6201d09e2975ae5789879f79a6de4c38de9edd4a.1741596225.git.jth@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mcb/mcb-parse.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mcb/mcb-parse.c
+++ b/drivers/mcb/mcb-parse.c
@@ -101,7 +101,7 @@ static int chameleon_parse_gdd(struct mc
 
 	ret = mcb_device_register(bus, mdev);
 	if (ret < 0)
-		goto err;
+		return ret;
 
 	return 0;
 


