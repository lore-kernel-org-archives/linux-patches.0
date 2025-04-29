Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDBD5254850;
	Tue, 29 Apr 2025 17:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947305; cv=none; b=YjcCqYSKmzcNvGFHO3MuJnOTBca8LKIiH/xFqPYOxlNzfzj3Dxa+addnTHedjR8Wl4NbBYtRyr/Fn1GZXLg9l99lmMbhAevpZrhfpF7bL2kDyuhGobiTTAkCmWw6UqXOoVl3MROz77N3WbB7qU5I/qj4sYb96gSmZ7ryvmEG1Zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947305; c=relaxed/simple;
	bh=HHl9DuPgeOcecT7Z4SyStQPmw+FMxjIRsKNM84mMnLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HLzJGXpFKSz+8Yum4wWprmP9slBxecC/gvXN2Cxr1vrl+xLj0frQ/xB7LByrMyrL43/bfhKuQbna8K8l4rmO5B8maN4LojRwu0ULGfIsk1cEYKvIG9yOuKG0i5kBRUmjnub7V28wNKOc7CXLt5/5TpJN7W8gNWjfAF6L6hk0des=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tG1PR6OI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tG1PR6OI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6340EC4CEE3;
	Tue, 29 Apr 2025 17:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947304;
	bh=HHl9DuPgeOcecT7Z4SyStQPmw+FMxjIRsKNM84mMnLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tG1PR6OI0v+copXIkWC5Q8eSWz/ZRZkJ1fAUN6DvxM3Zr+33+oKrp/kVnS2ko4v4h
	 DEZ5d1MqiEY4sIqLRN8nUmdDSaDLh96dEKYgEiRIex0tfMkrnX7atoSs9FMPghxdz/
	 5IX6WnGMpVWix2zaAGDcTOjpPFpZpgQ264fF+ix8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Johannes Thumshirn <jth@kernel.org>
Subject: [PATCH 5.10 239/286] mcb: fix a double free bug in chameleon_parse_gdd()
Date: Tue, 29 Apr 2025 18:42:23 +0200
Message-ID: <20250429161117.758359271@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 


