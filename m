Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213931;
	b=IcyjjHA8hV4PE/iyNFtWNZgf3MLB6XG/x9lrYErIeppxP9BRuIyTA7fuZHeVexbmlick
	 xTrBzuyKXgkmvOj+/0g01aEvx4AoFxRj+mX8hX7J+znwdoug/oFxdrU1vH+wBb9O0uUza
	 YbDlgBH2Juy4ubBDivQ2LRqZGOvEuWRC+CqSiUF/YbiGeo1/FZjpYnHZ5iowJTIOU9kY4
	 XUIjvHo0xCTyyXpp1ZJbROnZOLFvPV4t6ImPxYsDLfS15fP9YZNv643TiNFHvlFtPfu23
	 nqcu1YoUgd1s80IO5KyIIf5QYmk0fnBhfwDpadyWtbopIXR89Wmnfu22scOiEbbGL3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213931;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ygBD66y3jOSD2mO3szfTQzKPivJJcLSdfbBNGWebSjs=;
	b=lonXeRhmU7A+A8Mpe7mRbu70AWcqnTMnX4YMd+N0cc3ZrxdxhUAK5yAzxdr1RwNdveyN
	 XxHDDD5SRI9jAozokv+aXT+fiAp72/BLa/RWYTzdcVaALgXa7XNBz4IRQPvFK3mL7RfPa
	 ot9i8VMLo5zAeCnEOmlvrwZHWX2D5AfuzKYVyldy3SUdTo97GuHpYiW65oimgOAxJ/doo
	 SUPptjzoc2bah4aX2kqmiW/24U9qpR6eZ3UBCqCD7pxS0JncsnojEQAcDIcPv6pGMLIp/
	 uXEImqYAz5s76uJSj22Uenw5Gwt5e4JFayBTlpo+AosCy2HWDPlQ5DT8TBPsezuIDvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lhpuG3xq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87CD0606A31D;
	Wed, 28 Oct 2026 18:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lhpuG3xq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA9421F01825;
	Wed, 28 Oct 2026 18:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213931;
	bh=ygBD66y3jOSD2mO3szfTQzKPivJJcLSdfbBNGWebSjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lhpuG3xq0MBHGB7N1AX///cMhHDkkZjRm+PbPNAAUSDJ8WUZ1ZCbkhOxCj4ow6G/l
	 BMP2GiLxLZ7jME/R+CGhRg1vsCKdSivHrKQJNCqyKIhIRa2F+9x6CoPfkHPpFJCBaH
	 kJUMy8qHec+pXYVNsZnaegH6NXbMnK5l+96Cfoxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0681/1887] drm/msm/gem: prevent integer overflow in msm_ioctl_gem_submit()
Date: Wed, 28 Oct 2026 17:46:17 +0100
Message-ID: <20261028170514.910909927@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 3a47f4b439beb98e955d501c609dfd12b7836d61 ]

The "submit->cmd[i].size" and "submit->cmd[i].offset" variables are u32
values that come from the user via the submit_lookup_cmds() function.
This addition could lead to an integer wrapping bug so use size_add()
to prevent that.

Fixes: 198725337ef1 ("drm/msm: fix cmdstream size check")
Cc: stable@vger.kernel.org
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/624696/
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_gem_submit.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/msm_gem_submit.c b/drivers/gpu/drm/msm/msm_gem_submit.c
index 6a02f790624a9..df2f1348897c6 100644
--- a/drivers/gpu/drm/msm/msm_gem_submit.c
+++ b/drivers/gpu/drm/msm/msm_gem_submit.c
@@ -856,8 +856,7 @@ int msm_ioctl_gem_submit(struct drm_device *dev, void *data,
 			goto out;
 
 		if (!submit->cmd[i].size ||
-			((submit->cmd[i].size + submit->cmd[i].offset) >
-				msm_obj->base.size / 4)) {
+		    (size_add(submit->cmd[i].size, submit->cmd[i].offset) > msm_obj->base.size / 4)) {
 			DRM_ERROR("invalid cmdstream size: %u\n", submit->cmd[i].size * 4);
 			ret = -EINVAL;
 			goto out;
-- 
2.53.0



