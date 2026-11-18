Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056894;
	b=payr2kaxHs/GzbBb73oWUEwaoNivaWa7uP8kY2U0qDY+XB68rRqYOqyHYT7C+aktPfZC
	 QweLyySAMb1GyO06b9CHq9pbKBqAiBtXRqW9fS1237e94SRvSpwEmyS4WD9NiWtXGbneb
	 5+v++hC2n3+iXMEAKaEl1omCptYmPzSg/mTyJcIqZGrvT/qJgG6tOqzr17bedmXsT4mx1
	 AZmmOtBpzA+I/WHKtkIhk5ngU3iGIl+kFNO/iM4zonfzGRB6qHV0C/2ctBn0aGpLw/mRF
	 1E02ky+m05/jPYG0rA+ms3XM1fdD/C9nWZm6arnXq5yOQ14SXwmy6lQEZcTaEV9qrcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056894;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=m66sJnASVylCU0wtJqxlQJ3TPc4iIXl8fAJrejurDMU=;
	b=ulH04HUnzsnUSc0Q6tbfA0fWPzpjws6L6MXcfI5EX08EUjzFkQlivuScgN5HdV5ysWTd
	 xagF7GSZwCTOr+AvFK22hdcKb71E/UgWT+pA/j0IZB9ofVv2yITnGfVPILzzoi5vebHbz
	 BKNSxOWUgGbSqarJpRw8+knGZpSj/Box+/jw/i1B36tlGTouvKBBf9Ei3uxJVq8QYCPE6
	 qCLTs5ptUUjH9KYqjSbtS94ijKTIE5tZs9AuH45pZ4As875+FhaPbQ2jawH2l00m/Ebo5
	 grsRVQJWC7maMFvQcvXsP3bs6x0A4G/tTnOVb0DejJKOXVOUuWlMXFCWRSvVbBJavzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HCr3B507;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B531606A31C;
	Thu, 19 Nov 2026 02:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HCr3B507
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86C381F000C4;
	Thu, 19 Nov 2026 02:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056894;
	bh=m66sJnASVylCU0wtJqxlQJ3TPc4iIXl8fAJrejurDMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HCr3B507GlOLIrDX1P9csQHhUVjt0eXtGd7M/U3y5abI/tgBBvPkI+wW7yf65cj7O
	 VC/BD5j7PK8f6HKdBee5QsU+QuSpQVOxO5fC6uUDixkI4CmvIFKXLykyPOJwtwy6Kc
	 IgW9xbXjXoLRdnnIthqc+c687fGDOOdSMbCjlgsk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2150/2214] nvmet: prevent double-free after metadata SGL allocation failure
Date: Wed, 18 Nov 2026 16:03:46 +0100
Message-ID: <20261118150136.471392621@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avi Weiss <thnkslprpt@gmail.com>

[ Upstream commit 2f61b9d1d54edf75a352c43eebe3804144b5d44e ]

If metadata SGL allocation fails, nvmet_req_alloc_sgls() frees
req->sg without clearing it. The RDMA error completion path later
frees the same scatterlist again.

Use nvmet_req_free_sgls() instead so that the scatterlist pointers
and counts are cleared before response cleanup.

Fixes: c6e3f13398123 ("nvmet: add metadata support for block devices")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index 5dd23446a91a7..8e2ac39ce3263 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -1075,7 +1075,7 @@ int nvmet_req_alloc_sgls(struct nvmet_req *req)
 
 	return 0;
 out_free:
-	sgl_free(req->sg);
+	nvmet_req_free_sgls(req);
 out:
 	return -ENOMEM;
 }
-- 
2.53.0



