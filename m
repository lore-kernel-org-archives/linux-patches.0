Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045437;
	b=vymLO9ZOyKMVMykaZhHnQNEjpMVpToogHgi0L0G/qHOiJTxpDFnUKYu8ZxiGtK08x9Nr
	 oDlLg5V4JIKnGFphrN2vS/NR0a3QgxH0EE4jOQpjbd4BjNsP+qiUVe3ehySTK3WoFrgd8
	 LSycnpV8koRIES34xn4UHQ+U2X5l9v0eUC8yixRD4ACIcr6YX6dMe2Gl7B+sRgY/m45hf
	 P+XgdbAdMcaeV6ixRF22j5li0PeH3k0C26EGWBIDBQk7dtkhAb5HcB6yrE+Fblb9ngl/N
	 Sg6cX/pAOoiZZ/nNIfnw05zJAHwUOqDArUfUboLXCSthme7CHhweCS7a4y5OFo+0rNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045437;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UE/VZbt9GW9vI+WU/ru+mgz8C/99M7yD+KN00k/9yCs=;
	b=Frh/I86r0CmdoNkSwspxKL/ciaIuDYlN//IZmO4MQumt396SXA9/MDecxlV+aMwfYbHA
	 m+VmBWUpH5wH+OpY2Gp0INMkWVSceKI1Q4WclXyAOxXJrJRWwswJlAqG/6HtT4y+/r01x
	 qKSS3xIMeB1HjppmyhSVFBRN8fNrOg0G3fsbbrVPMyoOGShqLrYN3QVy5NC/gYGzaH5tT
	 bhW1HKEaBc+96VZOMaNOP5dlC0hdt7FFkJvB5dYHfIMh/86fKm91Mmv9eity+XtteSlQP
	 rVxb1IoqiynoLPdNt/obx+FfNC3I6/z8LqxJ9Wh7rgrmDKaEqNmveVNn6j1fNocQVXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GO1BsZNK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66A39606A332;
	Wed, 18 Nov 2026 23:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GO1BsZNK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AF231F000C5;
	Wed, 18 Nov 2026 23:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045437;
	bh=UE/VZbt9GW9vI+WU/ru+mgz8C/99M7yD+KN00k/9yCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GO1BsZNK43qj8T5YC05j1Xv6LyoeB5IaiQ67bHrGa7SPglIN8gEntfOid76YsrbVS
	 EImFKSzwsS9bb+l4sRNgRAyyT9FB9hrDA/h6PIHBc1s5DX+26i1pl61MJPPrFjBWQZ
	 8lWXUobatBjGtlrrmVjcQXPGscHMd/KdZkzNv8/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0922/2857] dm-snapshot: fix crash if dm_io_client_create fails
Date: Wed, 18 Nov 2026 15:32:36 +0100
Message-ID: <20261118150234.784171222@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 829c4d21148a205eca864429e06530319e1f92d5 ]

If dm_io_client_create() fails, it stores error into the ps->io_client
variable. The code would try to free it later with
dm_io_client_destroy(ps->io_client), causing an invalid pointer
dereference. Fix this by setting ps->io_client = NULL.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-5
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-snap-persistent.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-snap-persistent.c b/drivers/md/dm-snap-persistent.c
index 1b61a7a54c117..c28e08c15ead3 100644
--- a/drivers/md/dm-snap-persistent.c
+++ b/drivers/md/dm-snap-persistent.c
@@ -324,8 +324,11 @@ static int read_header(struct pstore *ps, int *new_snapshot)
 	}
 
 	ps->io_client = dm_io_client_create();
-	if (IS_ERR(ps->io_client))
-		return PTR_ERR(ps->io_client);
+	if (IS_ERR(ps->io_client)) {
+		r = PTR_ERR(ps->io_client);
+		ps->io_client = NULL;
+		return r;
+	}
 
 	r = alloc_area(ps);
 	if (r)
-- 
2.53.0



