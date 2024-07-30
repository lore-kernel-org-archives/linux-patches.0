Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 610931A76A5;
	Tue, 30 Jul 2024 17:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360681; cv=none; b=Os6JUHakWKP2bIeObnQle6mvHsZpettrC2Gs7j85xkNUZcTPgvw4424gRF3LYFwJS2JLm4X6ILE1XZuob1mxLktnQEdPVXTf5QJH8HGbajYyp03SwTWnD+adgxeoEkMK4WOa+rqPTxRp/EceW100h1E3sspHYLlJZ1sKDtVRBHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360681; c=relaxed/simple;
	bh=AzjUt5OUoXDCJG5qij4XxX7prv8irbwifaqKc2/104U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GzqlBtSL7C5VG5aWc60xhZlhYSI90Jds8FOBbyeCwhGARPOg3v9l3mwm1HO2z+pFcQN8H5x6y9GM0lMGUfxJhiyxgQ049ekYbi8IlXqigjbU9kIlN641ugeSrGW7trub7quoNnilpA6jLrAljty/cw3mHXOc8jLHzd4NK/lxEDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NSA9RTZX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NSA9RTZX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD5DFC4AF0E;
	Tue, 30 Jul 2024 17:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360681;
	bh=AzjUt5OUoXDCJG5qij4XxX7prv8irbwifaqKc2/104U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NSA9RTZX9QLxmZkljHvpIaL7zMJuXzquIKelbUrCGiiiUnmpRmRMWZ7H8bHRKkmLD
	 COvi13vd7H4QlgYxFsw6Xf+4LSMTsI3ohZV2QktMqecWiRRy7oUrw72QnSl1/vexPG
	 dS9k968jN7VXsCAwRJwvqHQOwQ4Oz7RKPXk2rDnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 775/809] powerpc: fix a file leak in kvm_vcpu_ioctl_enable_cap()
Date: Tue, 30 Jul 2024 17:50:51 +0200
Message-ID: <20240730151755.579213047@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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
index d32abe7fe6ab7..d11767208bfc1 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -1984,8 +1984,10 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
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



