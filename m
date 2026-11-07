Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062218;
	b=1X0XMqEoL7Wgr1Iy7rdhX1kN8F9Fg6b3LCs+EatXEGJ0tLanAnJ117/ZiEh7X0gTo6Ba
	 vOx0kLrFl2SGZy0PlyWgF9vc0gWIhzfMdoFXbir2OoD0Gxvhkza428KuRHV4uyNinyWed
	 nlhN+mvMucjGW7TWZeiFZM2nCnYb7exiFUeSgarAgGkBYmqzLyp3otIYXQ02raQDWanXr
	 C0/ElFmJJ2ReewJyk9h7WMvynZHsX2LXsV/Ozrbm2DoMfjOMYlx+q7Y2E2bxKojO4xnZd
	 zeWW4NPEi79YI5KNpU9yN8Ck0pJzjKtyA/J7UZKwEp9xwOVnkj+pr0AN98MU90BXcaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062218;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hpj/QXjAhWS5JD7nRXwsq0K+40Gvc8iq9z43DXHdyck=;
	b=G0J0qLoV6wKfBRDvYJqqltb299kZ/49mNaw3lLTRdL7474d13j4p6Iuxpk2k265IhRW9
	 F/ghZdseDD1tifLLgMRy2vydUSaNTwQSHA32B4Lefz57665p0VlKLdKEU8OWVgcHI5KGx
	 /I3uUTCZ0mdLa6ZMRB7wkjyKipU7yKCJN9x+9hOCo99/fJZbtkBgGQQSeWhVd4CQeLGi4
	 +6+XizVMGmn0TMr15CpUTMLblP8cIG2DKqgSTtRhnnmdX1TK4NYh8FqwsLx/isRRoK6Zr
	 lJP9gJicsLyEcnkMYfHgpkX/j0H1+41f+grhc+xJjsYUDo40nAZCcXFDd9OhpAxdxgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qEbCEyru;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D1A8608361C;
	Sat,  7 Nov 2026 14:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qEbCEyru
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16D391F008A1;
	Sat,  7 Nov 2026 14:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062218;
	bh=hpj/QXjAhWS5JD7nRXwsq0K+40Gvc8iq9z43DXHdyck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qEbCEyruU/0v6V+pF3L0dh4eHEDGtpN6zg7uvMBlAI/FXCaNgm2gAxH/CDRt871kZ
	 ffIBCiO+mSPV6g6YAC7oy9VPOhDAfjpASHpLCLgnz5nWkWvIT6cdg0oeNsqA3XklBa
	 hu6XFFAri2K3KOQDqeUh1C6rPFy+T6So8gVKvqlc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Liu <1298662399@qq.com>,
	Ming Qian <ming.qian@nxp.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1154/1536] media: amphion: fix runtime PM imbalance on probe failure
Date: Sat,  7 Nov 2026 08:52:50 -0500
Message-ID: <20261107135030.137720571@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index 321f319d14a6a..d6e3b5042ec24 100644
--- a/drivers/media/platform/amphion/vpu_core.c
+++ b/drivers/media/platform/amphion/vpu_core.c
@@ -689,7 +689,6 @@ static int vpu_core_probe(struct platform_device *pdev)
 	pm_runtime_enable(dev);
 	ret = pm_runtime_resume_and_get(dev);
 	if (ret) {
-		pm_runtime_put_noidle(dev);
 		pm_runtime_set_suspended(dev);
 		goto err_runtime_disable;
 	}
-- 
2.53.0



