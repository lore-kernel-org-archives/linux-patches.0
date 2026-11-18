Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057273;
	b=1KftZ6Ga6cZlvhkUDhcYjYsUgWb6dtGQ687eWNFe7aWwrEmF6YNlACW0QPRnOhvdOYKi
	 l6LEZLS8KAaUOvLXkBTTOdBfmaPUCgHzu0PscRP04mtTu5WbtWSsDG5iioeFb/5mFA7yF
	 4u2q3TCYorM7apqfl3fxzkLh8T38cBvVWBZheK7IvlrgHif/VhvsLDeSnSg+Q+W1wFAi/
	 OL4n9us0phT/bIUqdZXD5GP7YRPVUD9IQM8x+R7EJPIKYQPt/za1KUiMdNPSM6IoBPQBk
	 mbRL9US6LmdHlY3TbfKYVHfwyAtCJGe8lHPyS9Eh0zGYcOB2xcmJ/2koUZxu46ccl/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057273;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eJiBI+0MpPrkR5Fp60A6E7TLjj7QR6uUbjQHvOkQiWY=;
	b=IF3pOz+qbR17WgPmeBVvcTfPnlHOv7FowW3Du+O1dj2F9dCl/nNi6TqR3oIaQ4TgP7Z9
	 RgyM/XbSiARExe0t8P39ta+7xzRDpkr5xQgZ34abmyzHSdcXcb6Hc8TVq/qpBN4XDZnY9
	 bwd3M/F85dO6jKLCaKbmW0+MGwPkcVYn7oZWEiy9xRzO/aRGlJ4DO24zqAf8WtaStce0e
	 cb+rsjneaBt9r76lW5axRUM1xyZUes3cmy2DtF08pvS4HXTtmbg3uMY0gDXcNlx98N2L6
	 wh7ZuGipllLJmcqLhnKwLLy8kq55V2486wVlMpcG9LiYrlZGYrkF7J5CO+h3qC6uNiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VgyPxi6b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF59606A338;
	Thu, 19 Nov 2026 03:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VgyPxi6b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F8711F000CC;
	Thu, 19 Nov 2026 03:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057272;
	bh=eJiBI+0MpPrkR5Fp60A6E7TLjj7QR6uUbjQHvOkQiWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VgyPxi6bfbNKIDDa3dK9ZtaQMB0/I6JkjwAXA2ZVvVqHmLpE+uC87BQek/W1mxfox
	 TbwdpfQd9ST+sz4F+m9y9hFZtNbuyZifGv4tFtKj1CYntDk4VG8cBw5wN6w2KZbQzT
	 z+sHcMU+IKc8YBEsD6smPm+VRJhArP/KiLNxYE6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko Review <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0072/1848] tools/lib/api: Fix potential double-free from fdarray__grow()
Date: Wed, 18 Nov 2026 15:35:10 +0100
Message-ID: <20261118145914.184545100@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit eadce0f46a1d066b812c7e5aa46a33711c78a755 ]

If the realloc for fda->entries succeeds but the realloc for fda->priv
fails, the error path frees the newly allocated entries.

However, fda->entries is neither updated to point to the new entries block
nor cleared to NULL. If realloc moved the allocation to a new block, the
old fda->entries pointer is now freed memory.

When fdarray__exit() is later called to clean up, it executes
free(fda->entries), which would trigger a double-free on that old pointer.

Reported-by: Sashiko Review <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/linux-perf-users/20260710200150.11FE71F00A3A@smtp.kernel.org
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/api/fd/array.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/lib/api/fd/array.c b/tools/lib/api/fd/array.c
index 5e6cb9debe37e..d49b560664a1f 100644
--- a/tools/lib/api/fd/array.c
+++ b/tools/lib/api/fd/array.c
@@ -31,7 +31,8 @@ int fdarray__grow(struct fdarray *fda, int nr)
 
 	priv = realloc(fda->priv, psize);
 	if (priv == NULL) {
-		free(entries);
+		/* this will be freed by fdarray__exit() */
+		fda->entries = entries;
 		return -ENOMEM;
 	}
 
@@ -50,7 +51,7 @@ struct fdarray *fdarray__new(int nr_alloc, int nr_autogrow)
 
 	if (fda != NULL) {
 		if (fdarray__grow(fda, nr_alloc)) {
-			free(fda);
+			fdarray__delete(fda);
 			fda = NULL;
 		} else {
 			fda->nr_autogrow = nr_autogrow;
-- 
2.53.0



