Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061198;
	b=bdo6TzHBUmdQG0Jgv9x+O6ACoP9IALjaYBelU2myopKEcVozDs2jE7IF4semDduoTf7J
	 6dBSNmqcFEP4Q53NbzUZz7/JvANXYEkHY2dBXigiuMfQjAsQ5dA3ZrjNhImpDO1u+/Cjg
	 Sy1zkDJQATjsMuTJbgPetdg7pLLCNj2gqtdThvWF0XN2B5pgCrK4KU6OIKBtJ0qgKT9q6
	 Ws6k06BPhiNT5/YFmAoc5YTwY8CHK/odY/l1zRQ6S7X6f8IyMDmY4ZkZGurMVqLJ18UBC
	 bO2KxtVxoYvrMM26tY9lBb5RNS9VmoEQ2QEvDctryeaCTxIOKWcsE8xQ5RuOWy3qNDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061198;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lxVUiwGLzR3Lf9AHvrzsn56ZYjr3ErKk+ob5o+kvBsk=;
	b=obHMhlqz0s8sPv0300Xx6x6oMC02UkZn2UAHlYZ04kNu2BelXIitMTJzLrEdY4RCnnRC
	 y8yte6GLmLRIDXAFxnjrjZucEqPgtaPF5+5P2jWK2R1E9JOoMYwqPAfitDFox1xCZDssX
	 kJhRLB/QXGNjFtf9RDU+4dx3k+QSfb5mIYB2QMtAgptOcZuj1b6jTdW/hM2GpSYn5W41j
	 xI3532/mUK8YIHJPFvfAsHM8lOw9rVqbYGHYmKrZSLj1hadws5bMsuMqyl2n/g/5koLNz
	 gf+ACz+xbOuKc7L6dcJ6ixxSPUX3k3M7TKKAw2iaYwO52suP36e3TveHfV64yr7NXYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="RiZZ/WzU";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B0E606A325;
	Thu, 19 Nov 2026 04:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RiZZ/WzU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10B371F000C4;
	Thu, 19 Nov 2026 04:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061198;
	bh=lxVUiwGLzR3Lf9AHvrzsn56ZYjr3ErKk+ob5o+kvBsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RiZZ/WzUPf1troV7GJRqGF9qsEWvyjBSYV/AOTUZ2bqxPd84PBl79N+T21I2BkSLs
	 2Z9xF51FFOURXV3YxhQL7f0BvRye1+bErL0UpUE14zSJ5TJEFsqf2Dg+QIglf3Fpwi
	 J2gMdJNQgCAN3GIsuSB7cfHjQy+RKqmaJhwL0F6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1426/1848] misc: enclosure: fix UAF on device_register() failure
Date: Wed, 18 Nov 2026 15:57:44 +0100
Message-ID: <20261118150019.237188987@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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
index f950d0155876a..6ac14c2e614b5 100644
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



