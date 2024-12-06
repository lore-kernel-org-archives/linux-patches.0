Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FCC7148832;
	Fri,  6 Dec 2024 15:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497948; cv=none; b=hebjM77+FQm/VzAMhnrFdJnu5Vr0QhTY4fVO7kZfu00VUGwb/R15WH6IP/EjXjt9A6z1R8mUhfPl1ADgYWdRU1slsf9M5DwvTasQQrK18KJzjVOMIwESN894rk3FvCqNYWL5sa99CnBfI9igf6puM9FyDQo9ROc6gUvKrlHz3yA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497948; c=relaxed/simple;
	bh=WHciIxuI5Mz31Md1FZ0vQiBdhjooWLb300sTRikSpIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=noIKlxL9SKspiJQXTnhghgZKcpNBmPETsFMuJEIIAoQulOLAe/9fCLMbaSTRxwSl7+tLYpXdKJsvIRaSMArwo5pefCb/UGjOEXSBIKTUxbjJPrGrc5zLQaC7zGtqOkmhLSH0xoPaqj+kVLIgDfkR2eS4oi45KMG4lMqI67WI+fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uD+Vnwyi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uD+Vnwyi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FA94C4CED1;
	Fri,  6 Dec 2024 15:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497948;
	bh=WHciIxuI5Mz31Md1FZ0vQiBdhjooWLb300sTRikSpIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uD+VnwyidVypzix+b7K1euQijS+4tXj7OMUyLasiBFC8wTcRFtKDP8/SHB6SsGSi/
	 RkllNivOj1yPyvjhetvUUxsw0hSQCQSsxB/wUKMw6/uBIgGJKnSP3yj9ZFP1XAQfH7
	 Vp7oz6W3U3cTIzezeuJTi9R8So8MSiDZMK2BCaBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	chao liu <liuzgyid@outlook.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 440/676] apparmor: fix Do simple duplicate message elimination
Date: Fri,  6 Dec 2024 15:34:19 +0100
Message-ID: <20241206143710.537668623@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: chao liu <liuzgyid@outlook.com>

[ Upstream commit 9b897132424fe76bf6c61f22f9cf12af7f1d1e6a ]

Multiple profiles shared 'ent->caps', so some logs missed.

Fixes: 0ed3b28ab8bf ("AppArmor: mediation of non file objects")
Signed-off-by: chao liu <liuzgyid@outlook.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/capability.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/security/apparmor/capability.c b/security/apparmor/capability.c
index 2fb6a2ea0b998..8248597200623 100644
--- a/security/apparmor/capability.c
+++ b/security/apparmor/capability.c
@@ -96,6 +96,8 @@ static int audit_caps(struct apparmor_audit_data *ad, struct aa_profile *profile
 		return error;
 	} else {
 		aa_put_profile(ent->profile);
+		if (profile != ent->profile)
+			cap_clear(ent->caps);
 		ent->profile = aa_get_profile(profile);
 		cap_raise(ent->caps, cap);
 	}
-- 
2.43.0



