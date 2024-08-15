Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7360B1A7076;
	Thu, 15 Aug 2024 14:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731498; cv=none; b=WKHMmz8FQXwpfKC1Ezbd9DLaJHN1odg0OiisA9fgGCbEhpa25S34QMEbF7UKW9nR1g430PBqRSY5IDLYUZWKLG8hEsJ70OAw4DY334waQ02rueAiQGQ0fd+1NMZf28CcGgqCo+z97j6TmXyxcIQYVycbLiZ4GjJFc0pE1FzA/dU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731498; c=relaxed/simple;
	bh=LN+TiXrDk5yDkDtqNNgZldjjmBrbm0CHv/1zAsBx56g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f8XBFTDgchV9TpvL8qs9QPKYMssBkiu/NBLEt5RC2ppb5OC0LUteaGksntyXhETf8G012xOiqjHJJG+AysRqOau4m+MiKMpIB474d/5fNfaS55erChi4sNlbH8t1Z6/S7ngWmeSeZRs6ogcOLKTSuzyRwEOin/joZqLs25BiVV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x4t5DcBp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x4t5DcBp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1998C32786;
	Thu, 15 Aug 2024 14:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731498;
	bh=LN+TiXrDk5yDkDtqNNgZldjjmBrbm0CHv/1zAsBx56g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x4t5DcBpAsT3dqgo0EZjYi2bCQgKLnfJwBXXd9hnHTDueMacF9qYvqx8bjS/efmrj
	 xqIIeIZnpnpx9+U3GTNVFjW9YQCBjWoLnpP9V7p8AXGVMpBElWKY2MGFbROECOlHYp
	 k8IEUV0gXqyyMQrgmlXP0fIlRnpCuLhmy46MeQj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 148/259] powerpc: fix a file leak in kvm_vcpu_ioctl_enable_cap()
Date: Thu, 15 Aug 2024 15:24:41 +0200
Message-ID: <20240815131908.504605611@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit b4cf5fc01ce83e5c0bcf3dbb9f929428646b9098 ]

missing fdput() on one of the failure exits

Fixes: eacc56bb9de3e # v5.2
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/powerpc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index eb8c72846b7fc..7c5986aec64e2 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -1950,8 +1950,10 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
 			break;
 
 		r = -ENXIO;
-		if (!xive_enabled())
+		if (!xive_enabled()) {
+			fdput(f);
 			break;
+		}
 
 		r = -EPERM;
 		dev = kvm_device_from_filp(f.file);
-- 
2.43.0



