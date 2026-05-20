Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E098C330D43;
	Wed, 20 May 2026 16:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294728; cv=none; b=qtP5CB60Idj5XJJCwz9SiSui8ZljCJ2lJovAWgICjbyWhylm3j+04+Sdp/q+h5vwAVwknvJ7M28vIdNaaVpzzf1vVWBf4Kq98jLEA8SkIcxSxCp71sa4DHAlJMIS2BaqSxiQi/GdapkW3XHD2JRtVAMSX91YXd2Cr/f2Ody87+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294728; c=relaxed/simple;
	bh=awiZyE71igO/HhDeHpQh+JttBY1qX295hMbWisAxCe0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jG7xWgr2FyWsETAhkIWtJ/8KUf+z3FYv2qr3mJzeR9HHu2G9bdjbTUzLj8nyy/QdkgU0fl4hlKdZ11FVvq6DWm3enqF1Nt0zZDhOHs4BdJZIJCjViJm0TT0gFogPpQ0etnNI4M7fEwMtWz4uleczuPyZLzUFUCGFdyZpmtD2oG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PLZhhtRq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PLZhhtRq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 595481F00893;
	Wed, 20 May 2026 16:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294726;
	bh=vJDiysOjbQkgEdLz9mdD3/HtzUm30MQV1yOgh9MYh6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PLZhhtRqpua6Poa1GwRe0Jc1NznApzULeU/+DX+0SlvsRr38bK9ZwM/5qXXJmkA+z
	 tZt7YRF8b/Qy5nac+ZTkKQFIhj+ObSQYJ0DBOGe8N8gDKGljICyf6ISOpIm4AmLpIV
	 VBeDt+D9PsK6hJCAPpRfyuWLg0b/r63W2bzNb8AQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Sun Jian <sun.jian.kdev@gmail.com>,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0149/1146] bpf: fix end-of-list detection in cgroup_storage_get_next_key()
Date: Wed, 20 May 2026 18:06:39 +0200
Message-ID: <20260520162151.678658165@linuxfoundation.org>
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

From: Weiming Shi <bestswngs@gmail.com>

[ Upstream commit 5828b9e5b272ecff7cf5d345128d3de7324117f7 ]

list_next_entry() never returns NULL -- when the current element is the
last entry it wraps to the list head via container_of(). The subsequent
NULL check is therefore dead code and get_next_key() never returns
-ENOENT for the last element, instead reading storage->key from a bogus
pointer that aliases internal map fields and copying the result to
userspace.

Replace it with list_entry_is_head() so the function correctly returns
-ENOENT when there are no more entries.

Fixes: de9cbbaadba5 ("bpf: introduce cgroup storage maps")
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Reviewed-by: Sun Jian <sun.jian.kdev@gmail.com>
Acked-by: Paul Chaignon <paul.chaignon@gmail.com>
Link: https://lore.kernel.org/r/20260403132951.43533-2-bestswngs@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/local_storage.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/local_storage.c b/kernel/bpf/local_storage.c
index 8fca0c64f7b1c..23267213a17fb 100644
--- a/kernel/bpf/local_storage.c
+++ b/kernel/bpf/local_storage.c
@@ -270,7 +270,7 @@ static int cgroup_storage_get_next_key(struct bpf_map *_map, void *key,
 			goto enoent;
 
 		storage = list_next_entry(storage, list_map);
-		if (!storage)
+		if (list_entry_is_head(storage, &map->list, list_map))
 			goto enoent;
 	} else {
 		storage = list_first_entry(&map->list,
-- 
2.53.0



