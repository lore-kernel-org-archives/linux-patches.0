Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033923;
	b=c9QlPOizqaNdCtXzJgH9PU2wCRs0rc0CI3BAlUcUC5vu6mQqMQoXeDPd4h74mYIVlmXh
	 ndW6XLCQfpc39jdbrx3POui2WFZIRC6Wta2X9MI/pOWYaxgnrI7cq2ZlmPptNGG7e83Du
	 drpmkv2D+2ZrSRFGjQEyNWW8X4uorqc3+1z8EzBXC/Bv01CUj/ybtUkjdAeqn7v22hUuX
	 kv6dH8ZnT+boht5A6rM7vdbeyfTuIXLF6VfZSRjvp7LU/1cHRNSBUVMbiywNgmayfZFF+
	 zO9m1SelJD+dCTHSREo58wtCHirXSFCeJACAw9+zK67IxFvpuIBpQrdq6LwqOPikKsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033923;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aomhX2ty5liOXN6wsosWoaIilNlqR1R7hFxmut2GHQI=;
	b=oZmuazQbA2n6YILjO9Cnx9TLQiqNUy4aCRO7BdQeNxOIVFGc/qIHLJYIWNAKX9/I2XDd
	 iyKm3aTIhZqEzrah3/OJrtESuklaeiOE7jmgFBqZT8s0b/Um6/FORQ2Vew4evc58hFhI7
	 wQMuLcT6SwXSlh054J5ulEU9NKOgel//5x2MrkfML0SMI/vwdZ5SqwlT2gC6md7NJnF9N
	 5O70ovx8id67wztuN1BBfAnt/MDlfUAONFt/WCV+8MsTncMeG1mOC9gyfOvci9XofRtT3
	 FY7t51fobLR7Zw8voua7Mooz9iAl+tcZU3mNHsDWbam7VJFx6zr9WsQvLGaOgiKBNrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MzB8dvEz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45703606A32C;
	Wed, 18 Nov 2026 20:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MzB8dvEz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 936221F000C4;
	Wed, 18 Nov 2026 20:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033923;
	bh=aomhX2ty5liOXN6wsosWoaIilNlqR1R7hFxmut2GHQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MzB8dvEzJ6YmY0ZM6xpmQi21vK23PJOe14C5GCNnsjhvVdOrdoYiVoput3VkuV9Kr
	 AnsP6ihMmBPSzQVk9v3S0mlr9vggNtLmo/w0yj8Y9M1lyD/M1CXp9dmfuk0YgyWA4u
	 fk2bKI0whc5yVgOIXdG7f43DGG5rzFX8O4Qq/Ptw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Changcheng <chenchangcheng@kylinos.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0187/3318] media: cx88: fix memory leak in cx8802_register_driver() error path
Date: Wed, 18 Nov 2026 15:13:29 +0100
Message-ID: <20261118150320.378165082@linuxfoundation.org>
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

From: Chen Changcheng <chenchangcheng@kylinos.cn>

[ Upstream commit e228b8b1a5b47a72b265671dc6d864c0da5528d0 ]

In cx8802_register_driver(), when drv->probe(driver) fails (non-zero),
the allocated cx8802_driver struct is freed neither in the else branch
nor later in cx8802_unregister_driver() (which only frees entries that
were added to dev->drvlist on success). Each failed probe leaks the
driver struct.

Add kfree(driver) in the else branch to fix the leak.

Signed-off-by: Chen Changcheng <chenchangcheng@kylinos.cn>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/cx88/cx88-mpeg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/pci/cx88/cx88-mpeg.c b/drivers/media/pci/cx88/cx88-mpeg.c
index 2c1d5137ac470..bc08b35e247e0 100644
--- a/drivers/media/pci/cx88/cx88-mpeg.c
+++ b/drivers/media/pci/cx88/cx88-mpeg.c
@@ -640,6 +640,7 @@ int cx8802_register_driver(struct cx8802_driver *drv)
 			list_add_tail(&driver->drvlist, &dev->drvlist);
 		} else {
 			pr_err("cx8802 probe failed, err = %d\n", err);
+			kfree(driver);
 		}
 		mutex_unlock(&drv->core->lock);
 	}
-- 
2.53.0



