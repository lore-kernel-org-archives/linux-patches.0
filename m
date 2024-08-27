Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E455148302;
	Tue, 27 Aug 2024 15:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772318; cv=none; b=L3Y/MYHcXpENAWYxIEUHGYB0iJA6fk5KjhvipixDlfboUbzHmWQMBnSJQrypSkReEc84bHFSA0dUXhJPx2tOdUtexZ3obVbE0ZlIAB+SXclZonGgY5zWtCiQRBuGPw7JYDUmWba2FByCie5cvCFct6WJPK4U+KGb5OedhkUN6FY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772318; c=relaxed/simple;
	bh=EJGCWiUGHUZJjMq6ezCCKJE5XdbibBQ7ykgAeDivKo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mb2s9AN0/ku9CLuRizHo/3sT6Tz6pJ5NFjXU0zvDgLRFOeNIlce8g8MvkgjOE8xudswHMU5R/XnA/bv6zQFUwgwqSrIQDm01IHU4mSSHK91NIXLyx2d4NVTL8o0XByOKD8sVo1sRgEEuhe1zI0vKPk9xZtH4nmm6YfJaVqpRoDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j7NMIkbg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j7NMIkbg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85ADAC61071;
	Tue, 27 Aug 2024 15:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772317;
	bh=EJGCWiUGHUZJjMq6ezCCKJE5XdbibBQ7ykgAeDivKo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j7NMIkbgLssU0e31lA742LmI0Bn64EscxTUFzG/UYrxXfW74bEtzfTd7WIeu0x2Qk
	 +o7pnBu3fnbRMUv4rEHtvYtXFzrb6wkJpUFpsyd8IAW6gCEqXEj1z8k1nkXsalA9J9
	 olZWsvDMKIkrsxNSg6O07EEp0LIEP4DAG4M0HRrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 179/321] powerpc/boot: Only free if realloc() succeeds
Date: Tue, 27 Aug 2024 16:38:07 +0200
Message-ID: <20240827143845.044082846@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit f2d5bccaca3e8c09c9b9c8485375f7bdbb2631d2 ]

simple_realloc() frees the original buffer (ptr) even if the
reallocation failed.

Fix it to behave like standard realloc() and only free the original
buffer if the reallocation succeeded.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20240229115149.749264-1-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/boot/simple_alloc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/boot/simple_alloc.c b/arch/powerpc/boot/simple_alloc.c
index db9aaa5face3f..d07796fdf91aa 100644
--- a/arch/powerpc/boot/simple_alloc.c
+++ b/arch/powerpc/boot/simple_alloc.c
@@ -112,10 +112,11 @@ static void *simple_realloc(void *ptr, unsigned long size)
 		return ptr;
 
 	new = simple_malloc(size);
-	if (new)
+	if (new) {
 		memcpy(new, ptr, p->size);
+		simple_free(ptr);
+	}
 
-	simple_free(ptr);
 	return new;
 }
 
-- 
2.43.0



