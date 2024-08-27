Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D8BF1C57A0;
	Tue, 27 Aug 2024 14:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724769832; cv=none; b=E0bI9bT7L6DZZS7aE3TAhgAANgHTVSPTKyPx1uS5Ug9UpTXeHQsUC4aQkwIT/0TawcCP+pnpaiBn4GEb2xKaZC3CPCqevRoGDyUxxQzXKG4VZiQBplQ4e3qa6wguFW6soRZBoGPXNm8yaJdConrHaGAsOctkCyv8iMjXqy2fA1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724769832; c=relaxed/simple;
	bh=0pxAUy0Ex4tHlzx0AbqgFfBdZeFzIcLUIOe9VeJpukw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j+FE/WFb9ZFrKQdisR9SKmA2WKNaRXpVKFW3iS9YIFOpMLHOFSjgRUjRSi52oUOCrnMS6lAaT9JdJSsolN7HDgJuQrNp9zxYlyE63ALAkYv4zjp8qn+TRb0hGuypZKSTycyyi5g3dK+Vzy8Ed4g2WVNO4LOkP+Pink3jn0fveDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ycwlUFK4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ycwlUFK4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99084C6105A;
	Tue, 27 Aug 2024 14:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724769832;
	bh=0pxAUy0Ex4tHlzx0AbqgFfBdZeFzIcLUIOe9VeJpukw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ycwlUFK4xV12l2Flw084GAEwOOilZwtHOy5oPKx8qxXCr6GTxOtDWJNvi8jpepYX9
	 i1s2uD//55jBjvyctkIWnAzHz1RRWyOTYxoTynF3hsy1ULEW8ZgoBHMnh22/IcNwPM
	 8cIBxmi5wag65dBFWWs4ETQgQkAxssP3pLe+n+9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 047/341] s390/uv: Panic for set and remove shared access UVC errors
Date: Tue, 27 Aug 2024 16:34:38 +0200
Message-ID: <20240827143845.205322304@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0e7bd3873907f..b2e2f9a4163c5 100644
--- a/arch/s390/include/asm/uv.h
+++ b/arch/s390/include/asm/uv.h
@@ -442,7 +442,10 @@ static inline int share(unsigned long addr, u16 cmd)
 
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



