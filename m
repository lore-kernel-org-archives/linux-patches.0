Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C7C518801A;
	Tue, 30 Jul 2024 16:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358769; cv=none; b=oah84gU1X8jAlzRk4L85iXZ74kWEy0ztWQmUOvrmYt2VITMtgNiX9Re12b1KnD0FBD2/yBDF8Jvf2KoNcxs/2argDhBsom3ueYwraUNy3Y3Pfi8AETocd5fCzrwltVggQENMtcCgSS/p/nA9+n1wIpd3cJRszGcwOe6d6U28FzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358769; c=relaxed/simple;
	bh=cUpt7kxihs1o2i+tmiCFOL69wFQEvmItj7GDKIFmuIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MdpVj8Mh5/8wqh4P/CZDJIozQ1uNoJVndaWQ8H3icCjoYaZR2Mf1e8ydVpWWWidKSAawvh1rvN3kXxVS6SXppQZ49UVHqpuHRZDZB9AI3ZEtaHq3OB8P+pxy3eAGY4Os+9EChKdiFFE/PjndZEzQZ/63C/Ac5NmqWl/aSg1sLBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YtfXLtf8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YtfXLtf8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0579C4AF0A;
	Tue, 30 Jul 2024 16:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358769;
	bh=cUpt7kxihs1o2i+tmiCFOL69wFQEvmItj7GDKIFmuIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YtfXLtf8m8JEabfPp8fnis+m4bAB7PriTEpQBoICMFZQqNSNenBzYLRd2pi5r56Za
	 3/w0zeUzpfssQoIUEEyhJphUSOo3vGywawUe3NCvuGQ6cz64PIvAVwG6o9sPQ99RGN
	 WOBGrffjxoyzaCtgOSuonJTV0BzMM/sScpLb3Ifs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 420/440] powerpc: fix a file leak in kvm_vcpu_ioctl_enable_cap()
Date: Tue, 30 Jul 2024 17:50:53 +0200
Message-ID: <20240730151632.190022653@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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
index b850b0efa201a..98ac5d39ad9cf 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -1998,8 +1998,10 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
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



