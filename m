Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53D23185B72;
	Tue, 10 Sep 2024 09:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962237; cv=none; b=Aew/5AyTrlpPaWRW+2qG2eV8OubcSnXpL4K9RRGaGIpiRQitDZfneiMeo6w/qkxqMAyxmGufyOoVqAm7Wp0GM2M+SPPBh7qoUSpnL2gLdmcFkBfAKJyt/llYVGzEKNDzWqaryWme2hPgZ3pPo+lWA69bHooOyayls8GeTL9Y9ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962237; c=relaxed/simple;
	bh=mE1/RG4Aj3rcGcWD6bYgrfQTkcBXiBkeYi179mMk+NE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LXYJ3hFzCPwTeGELpUCBI9h+ohDazp4P7Dvx3FfDuuEOP2SKgmEJqeACdZl23TV2FIhWWbF8Y4t0e2UA5K3U2jpnDCP3QVeArLnM2D9YKAyLmLcQUJXfE3PPtBUfLGwqdkwfx1kKt+V0+Ksuls7LcLWcuDI4kfWd5GNvyU+jf7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YsZ34Pei; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YsZ34Pei"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDDF1C4CEC3;
	Tue, 10 Sep 2024 09:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962237;
	bh=mE1/RG4Aj3rcGcWD6bYgrfQTkcBXiBkeYi179mMk+NE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YsZ34PeipnD8rqjLbTXmcJ9LxlMi4iuDnLUWDwlWNgJsQ4csN/oOOM6cEuVBFwYt6
	 wzVkIrl/MxJWfsDHjdWWYuUxga2fM8lLXTSK0wSNeypii9EbJat6nCijJ+u6+UqvgD
	 sa1tpyobchVU8EFChwaUWJZbeuINUnNw3Rw+gHqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 314/375] path: add cleanup helper
Date: Tue, 10 Sep 2024 11:31:51 +0200
Message-ID: <20240910092633.108418352@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit ff2c570ef7eaa9ded58e7a02dd7a68874a897508 ]

Add a simple cleanup helper so we can cleanup struct path easily.
No need for any extra machinery. Avoid DEFINE_FREE() as it causes a
local copy of struct path to be used. Just rely on path_put() directly
called from a cleanup helper.

Link: https://lore.kernel.org/r/20240607-vfs-listmount-reverse-v1-2-7877a2bfa5e5@kernel.org
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: dd7cb142f467 ("fs: relax permissions for listmount()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/path.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/path.h b/include/linux/path.h
index 475225a03d0d..ca073e70decd 100644
--- a/include/linux/path.h
+++ b/include/linux/path.h
@@ -24,4 +24,13 @@ static inline void path_put_init(struct path *path)
 	*path = (struct path) { };
 }
 
+/*
+ * Cleanup macro for use with __free(path_put). Avoids dereference and
+ * copying @path unlike DEFINE_FREE(). path_put() will handle the empty
+ * path correctly just ensure @path is initialized:
+ *
+ * struct path path __free(path_put) = {};
+ */
+#define __free_path_put path_put
+
 #endif  /* _LINUX_PATH_H */
-- 
2.43.0



