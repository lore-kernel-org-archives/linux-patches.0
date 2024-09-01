Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4370E16B391;
	Sun,  1 Sep 2024 16:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209383; cv=none; b=JoUxpBCeAywrT4Zdq7qBAQIUasHDsnJjRjZZM8uIHl60uHESW6qClqb9lgivrmINHh0xd3bpCCV6KXZABpq4Y1YkGbCR+JhAJvDYdfWdLPJ+0GlIKbF6KYPXv/Cb2Z/xKFjENrl1IwNrrGiRSnG+caemztaVsy6RUthyJPxlP5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209383; c=relaxed/simple;
	bh=VXvRQDq+F4k1o++gPfTC4ikE3qH4itKa3SYb4onxm3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sBCW0dmjuMz4/TAtMfQo44nSl5WCI0YKKR6iecq2/XkU9RvNZWbOeltranOQKObuWmKlXGCuQQnSXofjBHjCVPZaHg3KLHm28fS7ArBEwgmlJIlcFiklfso5MsmJx6QtHB/ifFk+IeswHR2ztfHoxhJI0+TPmE/N/KmctXK+80M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hPbJ2ry7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hPbJ2ry7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8452FC4CEC3;
	Sun,  1 Sep 2024 16:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209383;
	bh=VXvRQDq+F4k1o++gPfTC4ikE3qH4itKa3SYb4onxm3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hPbJ2ry7zG/4ntbJmbGbK0SHDO9NjTYkYF4mMQrlcJZlXebpq5FvcfyBqv/jMHsFT
	 4FBzoMZ6pdOYgnwcHFe/HYFyvFU+7SOCZF3nkzhhVHxgL6ZwjqulFrAYCi6YGLT7Hs
	 Dqhbb6ChBhfCW04W2xJEiF2NTbmyUsXMEew+mpE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 019/151] s390/uv: Panic for set and remove shared access UVC errors
Date: Sun,  1 Sep 2024 18:16:19 +0200
Message-ID: <20240901160814.823492587@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

[ Upstream commit cff59d8631e1409ffdd22d9d717e15810181b32c ]

The return value uv_set_shared() and uv_remove_shared() (which are
wrappers around the share() function) is not always checked. The system
integrity of a protected guest depends on the Share and Unshare UVCs
being successful. This means that any caller that fails to check the
return value will compromise the security of the protected guest.

No code path that would lead to such violation of the security
guarantees is currently exercised, since all the areas that are shared
never get unshared during the lifetime of the system. This might
change and become an issue in the future.

The Share and Unshare UVCs can only fail in case of hypervisor
misbehaviour (either a bug or malicious behaviour). In such cases there
is no reasonable way forward, and the system needs to panic.

This patch replaces the return at the end of the share() function with
a panic, to guarantee system integrity.

Fixes: 5abb9351dfd9 ("s390/uv: introduce guest side ultravisor code")
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Link: https://lore.kernel.org/r/20240801112548.85303-1-imbrenda@linux.ibm.com
Message-ID: <20240801112548.85303-1-imbrenda@linux.ibm.com>
[frankja@linux.ibm.com: Fixed up patch subject]
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/uv.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index 12c5f006c1364..8fd441150a4e6 100644
--- a/arch/s390/include/asm/uv.h
+++ b/arch/s390/include/asm/uv.h
@@ -312,7 +312,10 @@ static inline int share(unsigned long addr, u16 cmd)
 
 	if (!uv_call(0, (u64)&uvcb))
 		return 0;
-	return -EINVAL;
+	pr_err("%s UVC failed (rc: 0x%x, rrc: 0x%x), possible hypervisor bug.\n",
+	       uvcb.header.cmd == UVC_CMD_SET_SHARED_ACCESS ? "Share" : "Unshare",
+	       uvcb.header.rc, uvcb.header.rrc);
+	panic("System security cannot be guaranteed unless the system panics now.\n");
 }
 
 /*
-- 
2.43.0



