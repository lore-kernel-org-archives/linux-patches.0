Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 913D81C5781;
	Tue, 27 Aug 2024 14:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770286; cv=none; b=SQ5qh4/IOSyrXNB9yMbZLc4Vd9GhoEbG9XV3IJQ8nfXXdm0cuUy29CEcnJGe9rEfJqSqFwRJjGTk9RBqmPfkoraPVBWJAMR6WSFkjQFWU0WjL3hT887DCwq3CVA3Be1Et6jHLYcDhTVbzUEWCBT9v4s58AsUc1BGLpk+4zByPrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770286; c=relaxed/simple;
	bh=/6/sNJ+enfvyAq9+3G7Eon0aIIV2o48nEq9Q0N5Fsgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pv0318n1LfQgoIzAy7WDz0H+SW+rGwlC8/rJdE3nnV0BHUC4rVJM+bHzJvWW41Ab/A0fVF6fegEb2X9IPimCmqpaMSewyoU6v6NcV1CAIhxjbVyNYdcF0FExcqXA/PvfmfrcaR3YRfe0JdrvlrlXtKqBmsjjzHcQSGPJUCEh8Hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Li13lxe6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Li13lxe6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 183BFC4DE03;
	Tue, 27 Aug 2024 14:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770286;
	bh=/6/sNJ+enfvyAq9+3G7Eon0aIIV2o48nEq9Q0N5Fsgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Li13lxe6HT6lKSF86wVRpZRjVClwx0Shv9kAX5i8IStEOoM6W5zD7oXt3yUIoHeSY
	 4oCWhSLQameH9/eRVpGM2/amx9JqKYayN9CfQ+JiVbqDyWH72BeAebEiZ1qi8/KBO/
	 Qhc2SIZOE97I6hkDBjnJu7xzJ7lMsFLRldEIH3LE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li zeming <zeming@nfschina.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 182/341] powerpc/boot: Handle allocation failure in simple_realloc()
Date: Tue, 27 Aug 2024 16:36:53 +0200
Message-ID: <20240827143850.339403506@linuxfoundation.org>
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
index 267d6524caac4..db9aaa5face3f 100644
--- a/arch/powerpc/boot/simple_alloc.c
+++ b/arch/powerpc/boot/simple_alloc.c
@@ -112,7 +112,9 @@ static void *simple_realloc(void *ptr, unsigned long size)
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



