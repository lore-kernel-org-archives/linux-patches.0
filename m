Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043287;
	b=dsyKzMJBNmThO/9p8fJJFbp017BgYc4dbLtc86+yjeC6edexrStoYzdb9sKSrtRXa7Ql
	 a3WiObbmpjSsHhnV4dRqMixZ/MJvMWeNw7+YWaKbMkF/xtPHrNRafqFyWZ90QpfRcyDSa
	 FuBRwm350vVL8gLb3/EFik/f7Fe+yEJsr05FIvqoF6BcxGQN31TG0qSVExto4l+z11tBv
	 TzkdoAgi3I1ueC72pahQ9PulPG+MSvSwAcI+oPQjbYOia3TMgjMiHiTd+A2Efx4ZP3+aJ
	 VYKjpRSsGOov8yVQLc1Mzc0K1ut4m/U9HuStEVD2FF7hIUiNOAsaybEf36aZK1C0uQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043287;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=20ml6lG+B11J+ExnSXsTbM8ZzV6Q3WBz5vCG3FbB+jk=;
	b=e4wAgosKCUq9jrZ5puiIOC5j186Ru4kpU6v2+VblJvQbXLxKuWnbuCuYjd/3xajpguMX
	 27AEx1G3ll/qLJWLWZ+S08nqqNnhxt4kNVu0qJ2Pog0HmEu7XbUuYhDkzc3WKi2d18271
	 2lyiamreQwJCrsucNnIKX6tnAbZ3cAm+KYoIMZETq2n+u26CBfHQWTePWoacDv6m4jhC2
	 wVzrXP8nFACcVMgkLDpFW+1Keuae/JAkiUSiLBTk8QaT4M0fhhpDW/z+z3TWSojPzMBIH
	 bWhBSWhUPROZVBxNiIjHg15vKF6B1MOjDDR3RJL/LtRxkJ8f/MEmBeLAsjNIJgErqgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=feq4yV39;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88230606A320;
	Wed, 18 Nov 2026 23:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=feq4yV39
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDF161F000C4;
	Wed, 18 Nov 2026 23:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043287;
	bh=20ml6lG+B11J+ExnSXsTbM8ZzV6Q3WBz5vCG3FbB+jk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=feq4yV39ZCkwIAKxei8z/zPgb/341vPFGDJ5lbf2wkPBFCz/eO7okiLbqNL4wyIK4
	 6s8Bkw2FYZrjWVIHzCqdL5LfV186UUFHYcpYeFFduYIRSPzeO6tzkHfTXZ9q4yH5He
	 JK/KtRYbOiwfWSgT+4Mez14VtI+uOvHqs9qQGHT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0158/2857] udf: Fix bh leak for unallocated space entries
Date: Wed, 18 Nov 2026 15:19:52 +0100
Message-ID: <20261118150207.040524952@linuxfoundation.org>
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

From: Jan Kara <jack@suse.cz>

[ Upstream commit d95094d4c0a62ea17b8a7c6399b42381b8a55bc0 ]

When processing unallocated space entries we didn't properly release the
inode bh. Fix it.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 6e8ae5e98017a..2bda409bf07b7 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -1333,6 +1333,7 @@ static int udf_read_inode(struct inode *inode, bool hidden_inode)
 		memcpy(iinfo->i_data,
 		       bh->b_data + sizeof(struct unallocSpaceEntry),
 		       bs - sizeof(struct unallocSpaceEntry));
+		brelse(bh);
 		return 0;
 	}
 
-- 
2.53.0



