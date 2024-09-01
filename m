Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB2EF208A7;
	Sun,  1 Sep 2024 16:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209612; cv=none; b=Uwr5ikKFDWn2FaH/V0m/SdpTU+RVXvIMVzla09UY+S2edrKJJg2pNV4Cq3DV0JlRnapNdaMG0n64tnoMAiASjUuzhcJZlorOtkK8ndiJQqlaspyS10xZfnfYuLSI+1YWVRgbmgpZVeEydDRQpl75Zzcsi1iiOqu+a2eRAL+T+cU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209612; c=relaxed/simple;
	bh=l7yyjopWC1u7I9zMIILbOx+l9rdowcwP4y7C0NtBPuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l6WJp4L3jEyc+jSDff03sRpl3wZEbtVqO1/wdhHv8DRfi7Om04BuHyKkW7OWlBlg3Xh4tVlhyQdyFkkDHGKX85qO26x37uz/61zToABdkliSsRxGVGseGwSRMGtnLhe6IX1csDq7vcNjCwC2g/csn+YXppAb1zeSOZ6/8C9SliI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KX3PAkHE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KX3PAkHE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C3E3C4CEC3;
	Sun,  1 Sep 2024 16:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209611;
	bh=l7yyjopWC1u7I9zMIILbOx+l9rdowcwP4y7C0NtBPuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KX3PAkHEfJHAFUOcT+cuAxh9gxZvq+iC7xSdg4aTwlJPwCD0aJO0j9QNd+/wjDGg0
	 pczHlVps7okjxEQXHDYGGkKrTxyN9x5ZK9hrFKFbsxoXyEvpLQXAI7Fc3KA9Psg4yD
	 ettjyN+uR66vMvXEC0qb2Em6aOGP/1ZfEP65t8pk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 063/151] powerpc/boot: Only free if realloc() succeeds
Date: Sun,  1 Sep 2024 18:17:03 +0200
Message-ID: <20240901160816.488742521@linuxfoundation.org>
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
index 188c4f996512a..bc99f75b8582d 100644
--- a/arch/powerpc/boot/simple_alloc.c
+++ b/arch/powerpc/boot/simple_alloc.c
@@ -114,10 +114,11 @@ static void *simple_realloc(void *ptr, unsigned long size)
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



