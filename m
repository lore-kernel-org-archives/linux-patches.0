Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB0752EA155;
	Tue, 17 Jun 2025 16:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177776; cv=none; b=Z9Zcvl0KLxeueM0geQTfxd4bfY/Nc0V/NrlAi+P1Fpwhe68tIKNnf660w2YEPn4k6u6NJKizblz9Ln9CdR/Rht0W2imFlMykFnjwa45EurOoB3Tmm6hMtLO9ViHxTARgPLX4Fr3RRwNUo3deaedi7Vu+QGyQ73dDDfynwnXkk6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177776; c=relaxed/simple;
	bh=P8sq/tKoSqaeJzUrjcbwadIpDuMrADqFN+mLKZeBAZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xo1O6ftUKvZ51/gTLX3G7BnrMdu6Es2DtyqRJyIWGIVsrknrMAaS1Xhgu1niQuMZ2Ts+VQvf7pbk0sHVAkVj84vnLt31nof3hL8i3XrRuVPtyyTgAgp+LpAcIDKmRIWbK+L/nFIhpLbaizBbDe+F9eJ2jo4OH3HQR6Izm1Hsd3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EXWDNo0p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EXWDNo0p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AB69C4CEE3;
	Tue, 17 Jun 2025 16:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177776;
	bh=P8sq/tKoSqaeJzUrjcbwadIpDuMrADqFN+mLKZeBAZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EXWDNo0psx9HL5j9Vft0ADl1wPmZiV7melBGRHFxgn6H7etbzru+cq37Mu3Z7/fcl
	 iwQx5rsVJ+lIeqON/90MLS5SebX9BBs6QNa+81fZbj6yyAj2DqS33ppwOcdftqlzjP
	 oFDsOMmbUl9GZbdRN/2A0jGgPULKNM6hUgYJ5HVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	"Orlando, Noah" <Noah.Orlando@deshaw.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 395/512] do_change_type(): refuse to operate on unmounted/not ours mounts
Date: Tue, 17 Jun 2025 17:26:01 +0200
Message-ID: <20250617152435.596799898@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 1022a5af691d6..843bc6191f30b 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2714,6 +2714,10 @@ static int do_change_type(struct path *path, int ms_flags)
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



