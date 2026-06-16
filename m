Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83C0A38C437;
	Tue, 16 Jun 2026 15:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781622823; cv=none; b=IJyDict8TrDBJZsy01dkFM0QNbvJ0icMyRX7XBhYlR8N9tnGLMBohYy9+Pu0PVXE5HASKwAEwpsPpWisB7D1K9LVRSq3DoIEg7XW+W1PY2WUGy82sgwL4209pDgCjTjSBvo9RKR2Rkzq7uAcu8xIZiwU4ND1MkwAGemlS38lxdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781622823; c=relaxed/simple;
	bh=XR5ZC1WNe0QT+ca/fc5U1x0rkRNtPk6ClOwF5zftu1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TRFe8u1pSiKcFeotvqqlFfdC7wFfuv1/TINMWTIpTYEgMZgHw78zlS5ChLdD3hMATRyxdqASZmKVauj2VkB8XAvipuh4V9Im3E3hJhGxfEZ5lbrPufyOffDUMFJtGd8vArNzd0e5S7XiMujudNv1k3fiDz8i8x3B65an7fNz9sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SeuKzzsf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SeuKzzsf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A8321F000E9;
	Tue, 16 Jun 2026 15:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781622822;
	bh=wrDBwPhs1//pKQqIpPvp66hZpCDRwgu3JVZ91rUokxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SeuKzzsfS0DZNsSAS66VzPCfoZK3/rX1uOJJXviGhy9P8nnHArnkjsz8ZCpaW1mJF
	 tB+fs5N4w2JFt/DMcGCqeSnYT6F47IQitF5hfWTYW1oAyCfghA0u5JFrI1dp7QnnZP
	 yu+A/OHpY0pw8EXFMExNwTBurrobywDkW8Ru131A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Jens Wiklander <jens.wiklander@linaro.org>,
	Harshal Dev <harshal.dev@oss.qualcomm.com>,
	Sumit Garg <sumit.garg@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 012/378] tee: fix tee_ioctl_object_invoke_arg padding
Date: Tue, 16 Jun 2026 20:24:03 +0530
Message-ID: <20260616145110.446323820@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit c15d7a2a11ea055bcecc0b538ae8ba79475637f9 ]

The tee_ioctl_object_invoke_arg structure has padding on some
architectures but not on x86-32 and a few others:

include/linux/tee.h:474:32: error: padding struct to align 'params' [-Werror=padded]

I expect that all current users of this are on architectures that do
have implicit padding here (arm64, arm, x86, riscv), so make the padding
explicit in order to avoid surprises if this later gets used elsewhere.

Fixes: d5b8b0fa1775 ("tee: add TEE_IOCTL_PARAM_ATTR_TYPE_OBJREF")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Jens Wiklander <jens.wiklander@linaro.org>
Tested-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
Reviewed-by: Sumit Garg <sumit.garg@oss.qualcomm.com>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/tee.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/tee.h b/include/uapi/linux/tee.h
index cab5cadca8ef99..5203977ed35d1d 100644
--- a/include/uapi/linux/tee.h
+++ b/include/uapi/linux/tee.h
@@ -470,6 +470,7 @@ struct tee_ioctl_object_invoke_arg {
 	__u32 op;
 	__u32 ret;
 	__u32 num_params;
+	__u32 :32;
 	/* num_params tells the actual number of element in params */
 	struct tee_ioctl_param params[];
 };
-- 
2.53.0



