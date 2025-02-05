Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0ED814F9E7;
	Wed,  5 Feb 2025 13:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763897; cv=none; b=XfnbwVDcWNVm0Egk+Yz0HHwUlyDJsHr7ulHx91vDrxJxCR6obFr2ikzC9NZgjoR/jZjoUC24HnMdJdvpnsnm8P+Htudyhviza4/e7+YYSvdlfFFoi/RmCM1/fcrgnv3ftQnA9vmi0vs7kRszcO2JRTrEiIvzM1oBJlzCG/1eF+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763897; c=relaxed/simple;
	bh=NZ52NvtS9ZcCsQK+AAqvc1vCf7v3dj3pMNc4c1q+mA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b0C1A5gVN06kNHqQV/k20VRNGwpQLH9S91LCzcSJoPTSoNYLS766QgFgLEg1dQOKQ7DvE/6Zyrc0jEbXS0+51zBsGK/6afNGSYNICGWB6ZPW9++Gi+UIsyu9yPZhyyj0PNVeujxNMPj5KYJnQRRvmMrvnc+1S6C6inD7UDUuFao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qzkhre8t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qzkhre8t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D833C4CED1;
	Wed,  5 Feb 2025 13:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763897;
	bh=NZ52NvtS9ZcCsQK+AAqvc1vCf7v3dj3pMNc4c1q+mA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qzkhre8tCI+VMaQB/xDjmHz9QKOP+HhSdh+PEjdy/Zp8b8Fl6lh2tVplKIVz+EocH
	 XoiUr1w46DB4Y/OTHKmljGoGLJIYcKpE8I34cgNNm/sXhlygjrszERQrgF8o5Hjjfp
	 WVSGmeXt4GacIMQAmlL0y0UwXh0Lt9UHQr3jWa28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 028/623] select: Fix unbalanced user_access_end()
Date: Wed,  5 Feb 2025 14:36:10 +0100
Message-ID: <20250205134457.305794514@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit 344af27715ddbf357cf76978d674428b88f8e92d ]

While working on implementing user access validation on powerpc
I got the following warnings on a pmac32_defconfig build:

	  CC      fs/select.o
	fs/select.o: warning: objtool: sys_pselect6+0x1bc: redundant UACCESS disable
	fs/select.o: warning: objtool: sys_pselect6_time32+0x1bc: redundant UACCESS disable

On powerpc/32s, user_read_access_begin/end() are no-ops, but the
failure path has a user_access_end() instead of user_read_access_end()
which means an access end without any prior access begin.

Replace that user_access_end() by user_read_access_end().

Fixes: 7e71609f64ec ("pselect6() and friends: take handling the combined 6th/7th args into helper")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Link: https://lore.kernel.org/r/a7139e28d767a13e667ee3c79599a8047222ef36.1736751221.git.christophe.leroy@csgroup.eu
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/select.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/select.c b/fs/select.c
index e223d1fe9d554..7da531b1cf6be 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -786,7 +786,7 @@ static inline int get_sigset_argpack(struct sigset_argpack *to,
 	}
 	return 0;
 Efault:
-	user_access_end();
+	user_read_access_end();
 	return -EFAULT;
 }
 
@@ -1355,7 +1355,7 @@ static inline int get_compat_sigset_argpack(struct compat_sigset_argpack *to,
 	}
 	return 0;
 Efault:
-	user_access_end();
+	user_read_access_end();
 	return -EFAULT;
 }
 
-- 
2.39.5



