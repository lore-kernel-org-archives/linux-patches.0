Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030549;
	b=u2s2Aqs1AaehHF9uRreH0AH3dHPl4Zd75/KlB5FejsQEVxSxQK+t6+0iTIK9gIFIjjGN
	 1f/X01pldSrkVM5F00Zlf36+U6LL2n9Y5Bk4x9Ay2P2NymfAsAwYyAKr7NrfYa7uPRPu1
	 RGxr6jUOJlRzjnAkvlot6T1vqBH+8VFPOLpgMiW6Je6Wsx5gGYPyuaP2xUMDYFWlVstdc
	 q+UrPj4y3kKm134ezs++3IOqrTznUweGDG27U5bz6XcCJ/9rwgqbJml4dxExDvsgmYHpv
	 z6aSU2nc6bx2vP/OqwOxVWJN/BBD6k3zpCyrMDAJKE0AaNadSUZllntK0qAcwBAok/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030549;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IK8/3rOnC71I/72cgEeaMcggCwObThQeEIJBaRTCUNI=;
	b=kfEyGiS3YEHxeSgBNvbJ/Kz6SNm4u3EU9ndC/iOpFitcdsYDHOWog1MnAMMIAWz1p12c
	 8RcdZfIgqp8Wr9WT7c8JaWB6xZkHIHrQHnzDmPFrtTQkb8U7sDMQyV0EftF86+LTR7Ydy
	 r66uUrhKFcXdifDaWKTPeOsZ0XNBUs5Sc6QdI72lbx+lzeT53CD3fLHZ3jhqAEP+KGQ0H
	 KR5r7uVcUQvAk3gOpnzyjilIldsFKn3kHbzSucgzLayohXHX9j240eC8lpqVGvOzlGxaI
	 WRO+rH81A8D1U4q2B/btw56GorWKMVqTHigTF7eDrxVE8KIKZVoY3zJQ+DsTsAael8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FFmi3Ret;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D251606A335;
	Wed, 18 Nov 2026 19:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FFmi3Ret
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E5E71F000C6;
	Wed, 18 Nov 2026 19:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030549;
	bh=IK8/3rOnC71I/72cgEeaMcggCwObThQeEIJBaRTCUNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FFmi3RetJbFwfGJypFI01u8fnnwRVhwKcDT9d7I41wQJFbD2eH4W34raIZCWAlSK/
	 67Tk23+uczubvbxdwCr6qNr83KZHSz80LaOdb2EGYo5aM30T3zekKnWyEH9mec8ZEI
	 xfu70lVorZ1YeUY1tYSArsuIODUX4vyfxJkt3i/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0737/1756] misc: enclosure: fix UAF on device_register() failure
Date: Wed, 18 Nov 2026 15:47:44 +0100
Message-ID: <20261118150038.976679219@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



