Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040568;
	b=0yQjxV1/Gt7jpBnTb+wZjcs1FhA+P8/ALcsfcbu9hhhl8XaV9kEJqtC6etlLHFa3yU5d
	 zIpmaqlkkS/PZ4s8Hj47sE370yO9biD5yswDZIZn0GfkZYDWs+IJWNyZ8bcID+fXPAhiB
	 5YxT4gnHPWqgEQ20YvmGpbszQl5/kDcNtAKQoHvy8yuafkTJ5G8LMs5MRh40mFS8X5+C+
	 7/o7BFtCGBxuazle5IeG27bwoeShAVMHirayHw5ANDVhZ5cOeMymPWQzHqUltQgYwgxV3
	 hfj+htXOpX9aXSUlj1ZOFWEMlEOaOy5xPWgWKyPUC5VQxx8bxR9vzfhnvqSmvLVaVaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040568;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=223AdwcfYIr7NCe4htqWKIiIllaA7uOwbl3ohH55fu0=;
	b=34/+cfgbN7/14kMdDvs/+w0wGrSN7j2YWWlQbqap2JV+P2ef6a9lYbvKk75+wZ5KNjvU
	 0VWNVC/uvaEq/1rPxLxAVPIlrJSvhhW5Tp04I5IpQJmzf/s8KLvX5vGXJRYM+qy3hailT
	 d/dHOLVNht0BSQBSgQvFhaHFjZ0Y2o/gNnn8YxB+2jjRl9IDgaXanx6WhV3qW+yeJZ0yc
	 paLZxjVJiaump16kgrOgOunwKJvT8xWS+gI4O1Fw0D7fhHQitznwViMGhNWAz3Lh39eeP
	 R5/SanPPd2P5036jKg9Hip0Ks/b4RVzNPnj+P0yCwGQq32rjetjY+oONJIWMkg4OqHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nC3vcReA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F4220606A320;
	Wed, 18 Nov 2026 22:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nC3vcReA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 527231F000C5;
	Wed, 18 Nov 2026 22:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040567;
	bh=223AdwcfYIr7NCe4htqWKIiIllaA7uOwbl3ohH55fu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nC3vcReAYdNL9b44WpWmfg5e5rIAzLt9QakdYRwZS6JdKhRKKqs8F8dUgttcxSLuJ
	 OwgfxTxBYYzrVjKwdhNi7ZfRgVM7WYgLJZWDP9LSGXPY5WCL/XG1olXRI4+kwdrFE+
	 21ox3VhTg5W+F1fW2mb/6Ja/3qZOD9xs+drr+HEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2496/3318] misc: enclosure: fix UAF on device_register() failure
Date: Wed, 18 Nov 2026 15:51:58 +0100
Message-ID: <20261118150436.269627810@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linkai Gong <gonglinkai@kylinos.cn>

[ Upstream commit 0f3b12bab74e13a2b8686a49c5b83099da61e032 ]

After device_register() fails, the embedded struct device has already been
initialized and must be released with put_device() so that
enclosure_release() can drop the parent reference and free edev.

The error path currently does put_device(parent) + kfree(edev), which
skips the device lifetime rules and can free the object while the device
core still owns a reference (use-after-free).

Fixes: d569d5bb3fd9 ("[SCSI] enclosure: add support for enclosure services")
Signed-off-by: Linkai Gong <gonglinkai@kylinos.cn>
Link: https://patch.msgid.link/20260806070358.1599627-1-gonglinkai@kylinos.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/enclosure.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c
index 76511d279aff8..7cc0505f694af 100644
--- a/drivers/misc/enclosure.c
+++ b/drivers/misc/enclosure.c
@@ -147,8 +147,7 @@ enclosure_register(struct device *dev, const char *name, int components,
 	return edev;
 
  err:
-	put_device(edev->edev.parent);
-	kfree(edev);
+	put_device(&edev->edev);
 	return ERR_PTR(err);
 }
 EXPORT_SYMBOL_GPL(enclosure_register);
-- 
2.53.0



