Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 059E22F0C62;
	Wed, 20 May 2026 16:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296022; cv=none; b=bgdcRIPIcdc7gsvdrnwRtPDix8NCmndBX5tAX5A2Vv4OzwBCRburquZAAaNkd9QoBcO4OsTQlywyq20FoFp3wDt8Alq9l+Ja2liP2t+vpcAmJ2RkSdGWkriS7zP55OXWSPRWW2i3F37rIIfj29f83nS6h4x/Q7QqZ+OQ6wRFDUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296022; c=relaxed/simple;
	bh=wvmQN88uUlW0rDGpKP/iG05QXMQDt7gxsQhUduc7n4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pnObe295OoO9/dRc9WNhTK8IYAwiDigaa5cOzwNKVDUQvZ1QK0J0uyUM0Z3VYz8nOI0Z3LGtOvAt9fuFbC1wp/faSkEmAvN0ji1TEOnO4VLZVKfCNxAQ3nxQKqv5g+Z61KZkPCKhH3Bha1sQUJjFHLfwsZRrBaDKdbdYKKeE1sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0ccdO5sM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0ccdO5sM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69BB41F000E9;
	Wed, 20 May 2026 16:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296020;
	bh=Q/vUjfT5GU8Sdc7PJa3erTv9HHIqZC1X0iqRqTBFjBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0ccdO5sM8+IHB0InmhFbbHwrZ8m0Lh7fYM0QFvIOMZVgPHXmv12+loZ7+GVpVgnMZ
	 VVDzVb66s+v4PKn+aqKCPFEhk62+nWQDYhI9ZOThndcTF4Dtx5Ctl7/l8gXN/Csbi5
	 vqDJHBUa+1CWDuuFNM3Di7mQ8uzY3nFPWB2cM10E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0640/1146] memblock: reserve_mem: fix end caclulation in reserve_mem_release_by_name()
Date: Wed, 20 May 2026 18:14:50 +0200
Message-ID: <20260520162202.664655882@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

From: Mike Rapoport (Microsoft) <rppt@kernel.org>

[ Upstream commit c12c3e1507809ad1fc0448f51c933f52e17d13cd ]

free_reserved_area() expects end parameter to point to the first address
after the area, but reserve_mem_release_by_name() passes it the last
address inside the area.

Remove subtraction of one in calculation of the area end.

Fixes: 74e2498ccf7b ("mm/memblock: Add reserved memory release function")
Link: https://patch.msgid.link/20260323074836.3653702-2-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memblock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index b3ddfdec7a809..d4a02f1750e91 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -2434,7 +2434,7 @@ int reserve_mem_release_by_name(const char *name)
 		return 0;
 
 	start = phys_to_virt(map->start);
-	end = start + map->size - 1;
+	end = start + map->size;
 	snprintf(buf, sizeof(buf), "reserve_mem:%s", name);
 	free_reserved_area(start, end, 0, buf);
 	map->size = 0;
-- 
2.53.0



