Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028098;
	b=jQGCuTr5+kyEMW48aEj6AvNyTv0nT8ZmorlO90OuK6wKrvcWkW35a0+Q+wh1QTW1hWdq
	 b32OZEwi0n1pRTHAqSsKjkJuuXDwYkD64NuULJTYMQT7pPIlNvVBH/hBPhJ0jSa35Vu0w
	 4aD80TbwzfENR9JlXT0TyWf0GmnVw8FPBRPK/6PDLgGqX8Qv9Kn7zuORhKcnl7cWHXFqG
	 CGBZFtslrQDf2dRaLJG9j8AE0TY1EqdqtvGh9yg0QARedzhEGvooUqaUpjnW+amAR0DiN
	 WFEzmYs6VtuUnrs4LebD86/21j3lD6CXXGiJRVof5lJSR6E5YUF+yTVCLTpllkxXoUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028098;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=21L7KbBG/+KML5u2BIb46L338t5rHE0uJPYPqNAzkKE=;
	b=knGmiBmXSeT6vinVetPWIppavad8b9YdKporuC4+XzrwNne8hODekjlyGPkeBpvkoL1L
	 4N7qCv1poDaqVqmHWA1eq1Mi4qVaw2g49giKN5IT9wEY7v3wAblC0t7yPz4+1Jn4zoo4v
	 ZUL7iI3Q8gcuoGh84ktzKzlj2BlZJjE6FQlhzan84VjU2Wh8DkxiVvK7BlxrHz/TmbYkc
	 YJRwORwXP43z2ix4FYfNYP47luyS3G3x4yn+aRSK7/GMIVm/JbVYFVhDXjFBDotknkfdg
	 OIYLaw8zc9fKNDxHB8BmZQm4kuBBfsOwBw24dVLrhHyPQjnxMbA00yqSQfLC799YZ2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uwqg3Wsl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63031606A31C;
	Wed, 18 Nov 2026 18:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uwqg3Wsl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6EC01F000C4;
	Wed, 18 Nov 2026 18:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028098;
	bh=21L7KbBG/+KML5u2BIb46L338t5rHE0uJPYPqNAzkKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uwqg3WslJQYGc1NbNOAvSM3cbed9X+BBzVjGDDTy+cFEvut78l2ed1H/FHRD0sL+6
	 r0k2s1PVq5yknJ5giXELjdvP1ydPHscBAcmOTU/UYxxPSn0Ig1w76l78wPKVkeRXBc
	 j/LeAydpoyJeQSn+TVItuTi1Ns+Tx63Yo6zPQdzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naveen Kumar Chaudhary <naveen.osdev@gmail.com>,
	Douglas Anderson <dianders@chromium.org>,
	Daniel Thompson <daniel@riscstar.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2024/2151] kdb: fix memory leak in kdb_setenv() when environment is full
Date: Wed, 18 Nov 2026 16:02:39 +0100
Message-ID: <20261118150235.463952504@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naveen Kumar Chaudhary <naveen.osdev@gmail.com>

[ Upstream commit 22d59ccad2935b7dea7f818793b739343de433a8 ]

When kdb_setenv() fails to find a free slot in __env[], the function
returns KDB_ENVFULL without freeing the previously allocated string
buffer 'ep', leaking memory on every failed call.

Add the missing kfree(ep) before returning KDB_ENVFULL.

Fixes: a30d4ff8193e ("kdb: remove usage of static environment buffer")
Signed-off-by: Naveen Kumar Chaudhary <naveen.osdev@gmail.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/mbwhul34esbxkdbmlbjaquv5lgyzznn6pdapohry3lsiidbz6n@zucvm5os363q
Signed-off-by: Daniel Thompson <daniel@riscstar.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/debug/kdb/kdb_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index dddf2b5aad575..f989f23545657 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -341,6 +341,7 @@ static int kdb_setenv(const char *var, const char *val)
 		}
 	}
 
+	kfree(ep);
 	return KDB_ENVFULL;
 }
 
-- 
2.53.0



