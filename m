Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208920;
	b=TO3RF+iv05uGjAIsixmbP/EtqMe/ZXONLiBbxoHfRXLQ57QdtWhFhKSkEj9lSYPkqsgJ
	 T1whPPxG8/f/b0xmRin/6SrIeV7ZzVziLTWshfen+bzkY4uhBHtIoLVeSmImyFF4+hY6h
	 uRWVJExhefz7f/lSsEVM7jMPtrX7ptrzqXH+qeNZERHqGFuSIQqNSEQp0QR10Xn/DIIh3
	 KTdMsgj4/BVQYHEDlfiFCxfvDOmDTvd4oWHdkdit40J/g3Do/YOEr1ChUCddotXn7xlSL
	 ZmwKfHG+BOl/v2mxe/18P28uGDwUaHK5hiLJ05v94A4pXGNoNRzmxwhxgGzPhbXAV4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208920;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L63kT0ljBurTBwQXfcbA2jmNoYxiT1/Oxj4SUGuXYdM=;
	b=2dWlV9AaclC3BxGIzTJ+8phJ8iEo2KkZTTIlB2YhUoswzOqN+Wb289pfU+6tZoa/JAJK
	 +Dr7T+TPiFeOf75r1/MB1/G1PTYT1wM6zXc2XqR1dm7fZBDcsHL2fDZVaQ+SC21relR6T
	 khdlCW0KyAI+s4yF6/ML6sR8pe5QULpaFEK1tAPQxiGJ7O2p4H1kcmCK9tFz7MtAF5m6h
	 3sqY93XWiFu21clGf/BZnpzgw1rtV7wo4yMF6fk0vfUMz5XXrNI5Dstu+QEEptbQMUQCQ
	 201+DAyiapUlDvwORchW0hYc7KPJrQaGo5buSyCPfbpAl/7q25MQiTW+cRnm2EsrUew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LOxm8Mqw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67405606A31C;
	Wed, 28 Oct 2026 17:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LOxm8Mqw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA3A81F01828;
	Wed, 28 Oct 2026 17:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208920;
	bh=L63kT0ljBurTBwQXfcbA2jmNoYxiT1/Oxj4SUGuXYdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LOxm8Mqwrqocj3BbvCyQ1P1tgM9Ry1tepF9bmopWZNAsBkkf28k0dLYI/f8yqwGEd
	 gsn73iG7GY4ZTka7wGqvoHGVy2ym9d59gxYpzorsDj5MRFxyLGoCrpmCWcuVMsw4XR
	 UCnEnDLaX/W0WdUdM9pf+6c2OzPU+X9T0GusEblA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Mingyu Wang <25181214217@stu.xidian.edu.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 290/516] tty: vt: fix memory leak in vc_allocate()
Date: Wed, 28 Oct 2026 17:57:22 +0100
Message-ID: <20261028170010.363695875@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mingyu Wang <25181214217@stu.xidian.edu.cn>

[ Upstream commit 5b114bfc1dfd88f9d50822d532f7f1fce0f7388a ]

If the screen buffer allocation fails in vc_allocate(), the error handling
path jumps to `err_free`. However, this path fails to release the unicode
screen map attached to `vc->uni_pagedict_loc`.

During the early stages of vc_allocate(), the unicode screen map is either
newly allocated via con_set_default_unimap() or shares the default unicode
map from a previously initialized console (which increments its refcount).
If the subsequent kzalloc() for the screen buffer fails, the err_free path
frees the vc structure but leaves the attached uni_pagedict with an
elevated refcount. This results in an unreferenced object memory leak, as
the reference to the dictionary is lost and its refcount can never reach
zero.

This issue was discovered by DevGen (an automated virtual device modeling
fuzzer based on Syzkaller). During fuzzing with kernel fault injection
(failslab) enabled, the fuzzer forcefully failed the kzalloc() for the
screen buffer, exposing this error-handling path leak.

Fix this by checking *vc->uni_pagedict_loc and calling con_free_unimap(vc)
in the err_free path before kfree(vc). This safely decrements the refcount
and releases the dictionary memory if this was the last reference. The
explicit check is added to maintain consistency with other callers.

Fixes: 34902b7f2754 ("tty: vt, get rid of weird source code flow")
Cc: stable <stable@kernel.org>
Signed-off-by: Mingyu Wang <25181214217@stu.xidian.edu.cn>
Link: https://patch.msgid.link/20260803144556.163856-1-25181214217@stu.xidian.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ sashal: Replaced uni_pagedict_loc with the existing vc_uni_pagedir_loc field name. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/vt/vt.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index 30be40d3dcffa..474f6abc900b0 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -1161,6 +1161,8 @@ int vc_allocate(unsigned int currcons)	/* return 0 on success */
 	return 0;
 err_free:
 	visual_deinit(vc);
+	if (*vc->vc_uni_pagedir_loc)
+		con_free_unimap(vc);
 	kfree(vc);
 	vc_cons[currcons].d = NULL;
 	return err;
-- 
2.53.0



