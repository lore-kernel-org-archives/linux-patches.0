Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043195;
	b=fTABP3efqr3hlBHfpqE1YO3viHd0Po18WFszS/suB6osMa7JF8f3zKV6PIg8ifhtbuSv
	 nFS7T5Nfy7UX5jZtvZnEx0z4fd7htGCtw94NY8in7kcGgq3VJGPT94cdOS7q8iq1OwuFY
	 5Z1TL4HOHPoTeP53edNyzc0SpWmLojEzuxy/egXLSfbU8ZmEw4VmInZHl4+ab+7YwjlO1
	 fbCLLm3LFV3cpNF1NwQr3sLfyoPBhVQ5eAFJ/dN+1pdmHO/z0gNigj7Zi1HIh+FbJsmaT
	 xmz854gmo3zr32O8XUqPDcbERa/DhSTyTainGHn2rEYIQL22YSbRO10K58uuhiV2nNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043195;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XiucSZeRAPtv3PICvy0U00J10F87YsaiCNaD9yhR6Oo=;
	b=uGIeTDIZ5l3Py8Zfnq2oj0XLlnhlmU1tcDtt1Ixlab4TQ0oeHtlpWj+1L4pmuWaZjp5A
	 CTMdZ91llYKKCWaWZDziRmRCHFOlC/PXEsZfRjMYyddNfhOpOy8BCD4ApGc99v4/D9ngk
	 C2IJpuPnXdeIw+m96DSIDyzdlQo2UhvrNBnXYrU6ncEY03QDSQGJaIok/dMemlNKzm9cu
	 Tms1iIDGXzhgsD6hJqi/ab75yRaqj5XDe8KMdyMYlpfnTMPGGUy3hbYPrURWcBmzwiskZ
	 wLwbUsVDeR36bQeaKYzbKfKT8IukPpgDcF4cXMGrfAfblyqV8I5itK95ltLhNeJLr1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DOQdxI2D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BE79606A325;
	Wed, 18 Nov 2026 23:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DOQdxI2D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42EE21F000C5;
	Wed, 18 Nov 2026 23:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043194;
	bh=XiucSZeRAPtv3PICvy0U00J10F87YsaiCNaD9yhR6Oo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DOQdxI2DJwqGFJA80K7dzPQA8GPz5Unly6BpTK02g05yuhTOfVugA0LBMyGaMSGiE
	 JRUDN2KHwW6GpCxP9bc/UE/Bo6zl7I93f9CEYdJb1HRInJp6HldwCJPROB1MQS0BbJ
	 lwtBtsxl1zA4x1uFxoQnE0FNXWwZb0xhuPZ0G5Ao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0124/2857] driver core: attribute_container: Unwind device_add() on attr failure
Date: Wed, 18 Nov 2026 15:19:18 +0100
Message-ID: <20261118150205.812752825@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuho Choi <dbgh9129@gmail.com>

[ Upstream commit 8cfe7ad274bb42c4653b645267410d4a3a23db98 ]

attribute_container_add_class_device() first calls device_add() and then
creates the container attributes. If attribute_container_add_attrs() fails,
the helper returns the error with the class device still registered.

Callers use an error from this helper as a failed add and do not call
device_del() on that path. Undo the successful device_add() before
returning the attribute creation error.

Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Link: https://patch.msgid.link/20260608172717.88657-1-dbgh9129@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/attribute_container.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/base/attribute_container.c b/drivers/base/attribute_container.c
index 01ef796c2055a..aa93a0756e16a 100644
--- a/drivers/base/attribute_container.c
+++ b/drivers/base/attribute_container.c
@@ -455,7 +455,12 @@ attribute_container_add_class_device(struct device *classdev)
 
 	if (error)
 		return error;
-	return attribute_container_add_attrs(classdev);
+
+	error = attribute_container_add_attrs(classdev);
+	if (error)
+		device_del(classdev);
+
+	return error;
 }
 
 /**
-- 
2.53.0



