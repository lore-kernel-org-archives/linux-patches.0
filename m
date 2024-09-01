Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EDCF1DFD1;
	Sun,  1 Sep 2024 16:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209576; cv=none; b=UNyVxBodTELQXoOShMjlO9UUU8uF/wGzQXHLa+TqexyHjCcBAzCBubeHovp79bDpfrnRKCJ9ufUA9fl58Gy6GzmszgqxqWZnHt61DXFYwVut2450+vpa7K3vVAVKiyV1EnZn3+F/0X1bUcRHKstAXy65G8JILwxkyID2ahaCvgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209576; c=relaxed/simple;
	bh=mKrjhLzgqmZNxkB3V70cx0UC/7edfm3SAZKQ4s2esvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LHetQucc4Q0m4tFrJ68IPditY3ZZLen/rayEuBeTx/t/7n+mSJ8/RvqGoHNg4kUOj8619ebz0CrNQ2Iq7NEH2IY1IFEDw5m8J4hlDlnbzKiQ76VdU3HduVFn+nxrDC/CS7YUjY7PD3G5lhnSc5/JmMLZt0M7+FMnz3aTAh0PhsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ch2Es0pD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ch2Es0pD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1834EC4CEC3;
	Sun,  1 Sep 2024 16:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209576;
	bh=mKrjhLzgqmZNxkB3V70cx0UC/7edfm3SAZKQ4s2esvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ch2Es0pDCM1lK0PtHw9E+o014FEpW5ND/VrvJaYshcXx417TddY4tZgnAThMx366C
	 lkkv3/y06L6Go0WD+30l+xjYI6y45H0KtzXhp7R146BHeM56WYTtJ9DimcFMGoD9fg
	 7Zl5Rj1Rf/nVvYAIh9b9dilHW1as/4fw162wC9nc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li zeming <zeming@nfschina.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 062/151] powerpc/boot: Handle allocation failure in simple_realloc()
Date: Sun,  1 Sep 2024 18:17:02 +0200
Message-ID: <20240901160816.450817673@linuxfoundation.org>
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

From: Li zeming <zeming@nfschina.com>

[ Upstream commit 69b0194ccec033c208b071e019032c1919c2822d ]

simple_malloc() will return NULL when there is not enough memory left.
Check pointer 'new' before using it to copy the old data.

Signed-off-by: Li zeming <zeming@nfschina.com>
[mpe: Reword subject, use change log from Christophe]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20221219021816.3012-1-zeming@nfschina.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/boot/simple_alloc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/boot/simple_alloc.c b/arch/powerpc/boot/simple_alloc.c
index 65ec135d01579..188c4f996512a 100644
--- a/arch/powerpc/boot/simple_alloc.c
+++ b/arch/powerpc/boot/simple_alloc.c
@@ -114,7 +114,9 @@ static void *simple_realloc(void *ptr, unsigned long size)
 		return ptr;
 
 	new = simple_malloc(size);
-	memcpy(new, ptr, p->size);
+	if (new)
+		memcpy(new, ptr, p->size);
+
 	simple_free(ptr);
 	return new;
 }
-- 
2.43.0



