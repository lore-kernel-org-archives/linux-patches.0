Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A19C8471261;
	Tue, 21 Jul 2026 18:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658425; cv=none; b=U0/ZHE9anO+hLfXvY2WgcUdiqL7pbVDCmopoOsJbTIor7nwQG+wx9MDQZHd5pq/jOPxORMI1E6uUcGBQt2AGaZHkcO8RhMowL0roJ3u8l02shvu6arRVrVImkpYMqWq6POMbewv+VdbO/IlOu/69poiQ7F3sTPVvcXY5ixv8T3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658425; c=relaxed/simple;
	bh=2lA1+URMxwJIZxjCvHS9dPSHvB2kXzOx4lYcPogrvaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QwbMg0ZvZY31aJLiON46b6wkTim6ATly6SBFjlL0+h7sjqRT/H52xvMLbK3uajDh/lpZqKZ8yn3CMe+5uhCNI9BADLAgRD2iBWAfD9U1ON/jTwbnx6rJsDAF2tWQMn5zmqCP2k0WCBXKb04aNaOA0HbM8Fd0rNZvZDIfmy2NqJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rgQUEjdH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rgQUEjdH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA57A1F000E9;
	Tue, 21 Jul 2026 18:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658423;
	bh=mrS8UVF7yn9wtA5sq9EQrSBeGocy9WSPj4VuU4G/Qg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rgQUEjdHxPXBvfmySizOgRAMjjGGmvIqH4mWWpIHPyTgHVWfw4e49oZnpWAnwyE83
	 0ihhMJVuqtL3OdKN+SxtDAswL3beKn0KqRRn31Uq+DlbxO3fyhKaMBul4IRQuiY6rm
	 eYC5jVVK0yrQN3aLe1fO1NBwLg+T9uOxSg/yoNso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.18 1138/1611] KVM: arm64: nv: Drop bogus WARN for write to ZCR_EL2
Date: Tue, 21 Jul 2026 17:20:54 +0200
Message-ID: <20260721152541.021056718@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Upton <oupton@kernel.org>

commit 9f1667098c6ae7ec81a9a56859cfdacb822aa0d0 upstream.

It is entirely possible for a guest to write to the ZCR_EL2 sysreg alias
while in a nested context, as it is expected if FEAT_NV2 is advertised
to the L1 hypervisor.

Get rid of the bogus WARN which, since the hyp vectors were installed at
this point, has the effect of a hyp_panic...

Cc: stable@vger.kernel.org
Fixes: 0cfc85b8f5cf ("KVM: arm64: nv: Load guest FP state for ZCR_EL2 trap")
Signed-off-by: Oliver Upton <oupton@kernel.org>
Link: https://patch.msgid.link/20260615051324.830045-1-oupton@kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h |    2 --
 1 file changed, 2 deletions(-)

--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -568,8 +568,6 @@ static inline bool kvm_hyp_handle_fpsimd
 			return false;
 		break;
 	case ESR_ELx_EC_SYS64:
-		if (WARN_ON_ONCE(!is_hyp_ctxt(vcpu)))
-			return false;
 		fallthrough;
 	case ESR_ELx_EC_SVE:
 		if (!sve_guest)


