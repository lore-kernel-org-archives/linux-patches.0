Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9722C219E0;
	Mon, 23 Jun 2025 21:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750712794; cv=none; b=lQ5ouoFV3JLyxnZwErS9C79KZUn00rqhwLB7l4rXjSgy4pTHiRh1h8NXxkwtJ4h4VyhuPr90/qZkVAYiiRmhNSqWiOXgsQWjTTYllK9sJkVYJGIFoVj/rx7OeyD2RTcs0wY5d71TDv13H+etlBig/BJ4/w8slN7GKwv8/AecPEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750712794; c=relaxed/simple;
	bh=oqj/OzSWkY2qcDUGmoz0CJCu0IKmMGj0HmOaBBM1JeU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hq5RmoWJJviohz/VC8/T3TYSGkoX63VQFmapumxi0L1KKebcSycIA8nP2R3m1KPPVE+Tq46OII1yGARl11EdHv/iEjK+iWVGUq8v1tGBo7bh4S5TZmem0ZZyXks6JkG1H8jp1IQAPxt0BB7dX4iLNTuGBcevXj9WtGECyosB360=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pQt+IqQf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pQt+IqQf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30653C4CEF0;
	Mon, 23 Jun 2025 21:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750712794;
	bh=oqj/OzSWkY2qcDUGmoz0CJCu0IKmMGj0HmOaBBM1JeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pQt+IqQfVzr8baW3Drd3SUpm6HLSHuZCThrTgbgTop4abzhfYpa4a3n8pwluNCH5X
	 gbrkcUM0PalN7DquS3KyKm3W3ZFvZ5Bows1D0nEJu2Yi3VADKLSigz1PeDnGLntQlT
	 kODwgB6nWuxQLOmRQaurlefpWH1efv4dNsFiV0Pw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	"Orlando, Noah" <Noah.Orlando@deshaw.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 106/355] do_change_type(): refuse to operate on unmounted/not ours mounts
Date: Mon, 23 Jun 2025 15:05:07 +0200
Message-ID: <20250623130629.961297416@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 12f147ddd6de7382dad54812e65f3f08d05809fc ]

Ensure that propagation settings can only be changed for mounts located
in the caller's mount namespace. This change aligns permission checking
with the rest of mount(2).

Reviewed-by: Christian Brauner <brauner@kernel.org>
Fixes: 07b20889e305 ("beginning of the shared-subtree proper")
Reported-by: "Orlando, Noah" <Noah.Orlando@deshaw.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/namespace.c b/fs/namespace.c
index 869cc6e06d889..2d5af6653cd11 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2308,6 +2308,10 @@ static int do_change_type(struct path *path, int ms_flags)
 		return -EINVAL;
 
 	namespace_lock();
+	if (!check_mnt(mnt)) {
+		err = -EINVAL;
+		goto out_unlock;
+	}
 	if (type == MS_SHARED) {
 		err = invent_group_ids(mnt, recurse);
 		if (err)
-- 
2.39.5



