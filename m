Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063179;
	b=VT8G1BDNTivwGmxF5bDKM3mnKaCJ7yRLOUM8WfPQ+LNJ6mjdK2gbCSQ5sqMbAtylTPad
	 u8ZSMqQQOz/0cY8K76LVuvuhIuoPyriURUAoNMmMIVejDt7bcbogN2UqYlvDxY9MHurB6
	 l9bAtDP6Di0FQ3z7fw9DKf42mCRrYeU6OKj641On7JTyFyx1/Ow8pmm6NXjy69NPLhSPG
	 HkjZ5/TQIQ9jZvpW0YfBmtm5OnxmYOxi0divJgQ50/g0QIeXMvdiyMUKvf7IpO5KOqtwt
	 /20yktmKLGoHFAsASSCeM8wWP2gYPBD9QtTNKFWhx/j8c9JTuDEytExIkSa+9hXirgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063179;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Cw2ymBVzuqvcb5rggo0cWcwEH1y2p31QVcePQNAVBEA=;
	b=dSiBYJgIKwXkfDpe8aIUSqd9/EDCDcor6U/1E0D7R6XHLgot31ESsTVmaX6U6XyLg4t1
	 UIhY/MY+AmcVtqYtchUFbCalCbLHdExR/414TuofHRsLCCGlFP2EdrC62sc8y8aBviKPw
	 iNIi7KxMvFUEl0qqRk4Y8vF5cpbjV9EQHI2dKl4loBwSaYZgmoWL0pj5rOOT37AZJaUge
	 k4n4a281Ac/fpRTYhGZVnHiiW4wMZSD0+yO9SZMDzPdZq4MA++maa5OZUR3aSj3bqyIaR
	 wjzpkHKwi1dStvjcMKmrQQUoUfwwCHk93STxcfAaXfnkr4GMMOk6dVueG5y+gbtpaHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dq+J3R+X;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15C27606A330;
	Sat,  7 Nov 2026 14:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dq+J3R+X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7BB31F0089F;
	Sat,  7 Nov 2026 14:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063178;
	bh=Cw2ymBVzuqvcb5rggo0cWcwEH1y2p31QVcePQNAVBEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dq+J3R+XydcPRslWW1D4dCc9y9GuG3mk0LNuShP6PZTx1p7NUCmYzzL9+nPYPVR9r
	 tEQyk5yv4+vONKNktmj89SmfZuR1vB2AQB7oy3PbSC0UZ+vCOiYeCXMGMbV8kHSwJw
	 QJaUK1OYnIbRTXvPwLcJxev+4P6jz7jqtgdqssTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Liu <1298662399@qq.com>,
	Ming Qian <ming.qian@nxp.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 358/869] media: amphion: fix runtime PM imbalance on probe failure
Date: Sat,  7 Nov 2026 08:50:40 -0500
Message-ID: <20261107134904.619400717@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Jiawen Liu <1298662399@qq.com>

[ Upstream commit 0cabf27cf1e6f7ee5f3c5893c0f1930814d949af ]

vpu_core_probe() enables runtime PM before calling
pm_runtime_resume_and_get().

If pm_runtime_resume_and_get() fails, it has already dropped the runtime PM
usage counter that it acquired before trying to resume the device.  Calling
pm_runtime_put_noidle() again on this error path drops the counter one
extra time.

Remove the extra put and keep the existing cleanup that marks the device
suspended before disabling runtime PM.

Fixes: 9f599f351e86ac ("media: amphion: add vpu core driver")
Cc: stable@vger.kernel.org
Signed-off-by: Jiawen Liu <1298662399@qq.com>
Reviewed-by: Ming Qian <ming.qian@nxp.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/amphion/vpu_core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/platform/amphion/vpu_core.c b/drivers/media/platform/amphion/vpu_core.c
index 56f6888f101cb..538ef56823b4c 100644
--- a/drivers/media/platform/amphion/vpu_core.c
+++ b/drivers/media/platform/amphion/vpu_core.c
@@ -690,7 +690,6 @@ static int vpu_core_probe(struct platform_device *pdev)
 	pm_runtime_enable(dev);
 	ret = pm_runtime_resume_and_get(dev);
 	if (ret) {
-		pm_runtime_put_noidle(dev);
 		pm_runtime_set_suspended(dev);
 		goto err_runtime_disable;
 	}
-- 
2.53.0



