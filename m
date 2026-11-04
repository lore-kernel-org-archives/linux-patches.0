Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829448;
	b=muls3bJYJhBozCReeQHmmxJiwxRMI4MX/yyzhtiDZP224Vc7tYRO1aPOMOFDBiqoSrl/
	 1i9hunZofPB7UxOFiH8QExG3llvd16Z7n6jQl8M+g5NU17IETZCNKS8nCiqGUBtJRGuax
	 IB6MJ4BNgROsMTNClgi22/y6pgEp5lfB0hj6c38/0FI5H3kN+GwJesKMp55m2sJphMTt4
	 CnsVoLguGWkn4WVIeHdXj9TytVIaFp04U5KAoyM4HxRcVC0QmD2/vk1yrCw1hVoEb+bQz
	 XoIyQOs/A0jLkORrg77Zg1B+alZ27KONBLL7vmFLmBRdodHzyHUdww/OBiwzqetQvqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829448;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0B45U/CqgILhe8mNqYFvFrUzlPt+Bj6YnIhdt88C22M=;
	b=KFpl187We8uZYDPOKws4izM5BESlYXMsBc+K5PVMzNwSDxCUiodR2VmsHxRclFRTXStU
	 Fok1OFpuQGKvZRxMfjtvkyCE0ZEBiZe09s97BJ6TH+IiS+v+1hI7Fj+J7RU8gOji6w7T6
	 xw8pzaZfRpxZOKGy2XgATAcingAgkVkcyUf+ee/8c0of9k/ZNNNyQUqMKFlkKC6hz/Exc
	 nSKrEdB/XLS5mZnHLUiM1SYgGdBslcOJsSe9GRQgMEeB1E2xCaMHVb6IhlT4Y6YNtLQlw
	 lhDWf9697jnGRuuy86yuPil42WfQtVgl+1KfUCWFU6GU4Quc5xppz+W+qMmzeM1GIaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fC3uZs2I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B20B606A862;
	Wed,  4 Nov 2026 21:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fC3uZs2I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEC2E1F000C1;
	Wed,  4 Nov 2026 21:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829448;
	bh=0B45U/CqgILhe8mNqYFvFrUzlPt+Bj6YnIhdt88C22M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fC3uZs2IwaDtMWC9eP2COHJefK52a4DJ9clw/Vlb3XTlroosO6MLVaAxKol8XsqtH
	 59qOue/8aaIhtmrTKpqVNVexX2AlKLuGHcgYQkIPhmh4DhUAVBjzwGQPbNoZujigkE
	 lFybDAlNxj93obI6mR5EbayKxp2u/iccAOi342N4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Laight <david.laight.linux@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0131/1005] usb_string_copy: Use kzalloc() to avoid leaking old data
Date: Wed,  4 Nov 2026 15:57:44 -0500
Message-ID: <20261104211047.359735657@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Laight <david.laight.linux@gmail.com>

[ Upstream commit 057df423bf4747091cf942af57307627e941e1fb ]

If the string is read while being updated (which is why the copy is done
in place) and the new string is longer than the old one, then the reader
can read memory that isnt part of either string.

Use memcpy() to copy the known length string instead of strcpy.

Signed-off-by: David Laight <david.laight.linux@gmail.com>
Link: https://patch.msgid.link/20260608095523.2606-37-david.laight.linux@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/configfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/configfs.c b/drivers/usb/gadget/configfs.c
index aa0a25efb6aa0..b6237a2e02003 100644
--- a/drivers/usb/gadget/configfs.c
+++ b/drivers/usb/gadget/configfs.c
@@ -125,11 +125,11 @@ static int usb_string_copy(const char *s, char **s_copy)
 	if (copy) {
 		str = copy;
 	} else {
-		str = kmalloc(USB_MAX_STRING_WITH_NULL_LEN, GFP_KERNEL);
+		str = kzalloc(USB_MAX_STRING_WITH_NULL_LEN, GFP_KERNEL);
 		if (!str)
 			return -ENOMEM;
 	}
-	strcpy(str, s);
+	memcpy(str, s, ret + 1);
 	if (str[ret - 1] == '\n')
 		str[ret - 1] = '\0';
 	*s_copy = str;
-- 
2.53.0



