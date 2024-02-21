Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7690C7F492;
	Wed, 21 Feb 2024 13:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521954; cv=none; b=ppaL2SpwInLnT8qNT8HPYs1mLG6MHFHg7/5+qfL8M8M0RttAVCroSYnp+JN6InQU+OW1inxjtq4ySuKXV84UF80Y8TVmqmh6S4BiNDYRGNu3KlV/6lkPNpjS3nEze/+xBSWw0R+NIY0VzlgsgaFF7IZBxwalpY4+g8PjHIulhm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521954; c=relaxed/simple;
	bh=LXbBtoFf7pKhL1faYz7CUlznS0rAlpSVo0//zp/BBfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ty0wIUutdMaY+l/KZqVNOXuuVx2hPxLqQ5M34+yqPADp6f7ebYGCFB+9znWlDFwaL6uUbvWWz6R4EVdOEc/ID/aPYjFOG5u4mtwU6TIi487ggu+MQO7ysIHjscYldVjMIPkkblLHeYYaPYzRZDAaeNnKCnYM5oqwopgEK/GQ1ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OcChuKlw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OcChuKlw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9894FC433C7;
	Wed, 21 Feb 2024 13:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521954;
	bh=LXbBtoFf7pKhL1faYz7CUlznS0rAlpSVo0//zp/BBfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OcChuKlw6f3e2dU388WTe3/1pDCB3EEnH9oZFoihNKwGBtHlOFM2wp1YfjRyhILLB
	 iKXSMnn0tn/lOCIQARlPY06yaZ2k5Sqe6810dkEeviai8A2wHgx190wpzaqxP9031N
	 8Tme21FNMO9z1OGKtj7nnLiMD5LE8fWc2HvAKNvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Tom Talpey <tom@talpey.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 040/476] ksmbd: set v2 lease version on lease upgrade
Date: Wed, 21 Feb 2024 14:01:31 +0100
Message-ID: <20240221130009.418029504@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit bb05367a66a9990d2c561282f5620bb1dbe40c28 ]

If file opened with v2 lease is upgraded with v1 lease, smb server
should response v2 lease create context to client.
This patch fix smb2.lease.v2_epoch2 test failure.

This test case assumes the following scenario:
 1. smb2 create with v2 lease(R, LEASE1 key)
 2. smb server return smb2 create response with v2 lease context(R,
LEASE1 key, epoch + 1)
 3. smb2 create with v1 lease(RH, LEASE1 key)
 4. smb server return smb2 create response with v2 lease context(RH,
LEASE1 key, epoch + 2)

i.e. If same client(same lease key) try to open a file that is being
opened with v2 lease with v1 lease, smb server should return v2 lease.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Acked-by: Tom Talpey <tom@talpey.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/oplock.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ksmbd/oplock.c
+++ b/fs/ksmbd/oplock.c
@@ -1036,6 +1036,7 @@ static void copy_lease(struct oplock_inf
 	lease2->duration = lease1->duration;
 	lease2->flags = lease1->flags;
 	lease2->epoch = lease1->epoch++;
+	lease2->version = lease1->version;
 }
 
 static int add_lease_global_list(struct oplock_info *opinfo)


