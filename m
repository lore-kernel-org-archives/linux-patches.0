Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54AD015A492;
	Mon, 29 Jan 2024 17:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548284; cv=none; b=pVHnxKRt5ZgMcWo5TQMqTS+MEXIQpRMOsCaHJnONLjnkeZIHdYBuI6nTHA+IJdw03N7okYbOKOKkCnCqILRm7otpZrdBk9NvdqYpoFbW59QDIg5UZDsCcPk1tHD2KKPhtr2+CzW6XedhqqX+aLfmfRfxhUvV8KE6le8Bwk90wfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548284; c=relaxed/simple;
	bh=GOmj4yQo8zzDhudY76VRDptTLSfeu23oVIUQGYhgggs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OQGQjtNbFmXVa6h5WtaVqHXnvw0VJlClhIlKIFvISAnQ20tukBvMqskRGp24lwoQV64YP0Myi3pYpEdZr6mMb2FPr4icBeIlMpEjffJvrzyTPJK63nllKy/SdSQq5tKpp/Fq7CGSxdkJoxSMTDBO0ZoLt55TRUuVYeX2u6o8/MQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qtK6xlBl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qtK6xlBl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20021C433C7;
	Mon, 29 Jan 2024 17:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548284;
	bh=GOmj4yQo8zzDhudY76VRDptTLSfeu23oVIUQGYhgggs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qtK6xlBlRpgDK8045dJVRMC+4rv9i7M14ydwdeWU3NkAN3Y4tX/QmKvOjK/YinXPS
	 vj4694NBMvpPd9l2BkJ7T/NsS73QNM+JGsSGDY7tPP0B0Isfrqv/YkEbVD6hyw9kYt
	 QJB1Za9YKUf49VTJ5TbKZjWUh5Y9oPIxhV2jdEvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Tom Talpey <tom@talpey.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 069/185] ksmbd: set v2 lease version on lease upgrade
Date: Mon, 29 Jan 2024 09:04:29 -0800
Message-ID: <20240129170000.814281452@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 fs/smb/server/oplock.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -1036,6 +1036,7 @@ static void copy_lease(struct oplock_inf
 	lease2->duration = lease1->duration;
 	lease2->flags = lease1->flags;
 	lease2->epoch = lease1->epoch++;
+	lease2->version = lease1->version;
 }
 
 static int add_lease_global_list(struct oplock_info *opinfo)


