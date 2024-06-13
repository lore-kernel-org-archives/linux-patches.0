Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91C9384;
	Thu, 13 Jun 2024 12:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282958; cv=none; b=IWKgOFQGtivhj52Vc52lf/MmWdYd+wT+vOHtIsMIwo/n+vbFeO4ALdikNZJQSro+il94zl7Or3KZR3V7/w0Y8cuXxT27INN4eQSYnvITDagXCB3Y3vwsbToWQkS9PReRsmnmZphXN/NsDxYiaSPLs8l0LbDiSqhpMd02goeKwiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282958; c=relaxed/simple;
	bh=M9sN0tyLSHBU5Q+K+jqOO648NPHYAD8dPNERg0Qm++Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iHJe6OEEmurZ8ZsqyxHQAxPjU0MibrG/mks6+txYJPsBNOCKxAF1F8MgNezo6O6SA04j/3YME0D6UFrsZRmSzM2NSRWk+03S6iiG3Av4Qdk/ykb0W7OPDyERFAYPnSIkYbncG54zKVseiDg5iVJoaxrfqdgq1DuZeVR+TC09j/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TDejnGdb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TDejnGdb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 726A1C2BBFC;
	Thu, 13 Jun 2024 12:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282957;
	bh=M9sN0tyLSHBU5Q+K+jqOO648NPHYAD8dPNERg0Qm++Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TDejnGdbPuRwrNmwd07+7Vrrr0TpMuyaopTNW6msFFS31zRgfimhYxaiM6TJDQwK4
	 Ol/Gf0ZFj2Fz7OajS+oCt/gT7aORhbtE5B4dGitTz+UZGgSnlkEUa6pBzki5+GNc/R
	 h2AJzABDh1XyU5/dU7P2t7Z95jFQ+06ut590whV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.1 49/85] KVM: arm64: Allow AArch32 PSTATE.M to be restored as System mode
Date: Thu, 13 Jun 2024 13:35:47 +0200
Message-ID: <20240613113216.032151307@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113214.134806994@linuxfoundation.org>
References: <20240613113214.134806994@linuxfoundation.org>
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

From: Marc Zyngier <maz@kernel.org>

commit dfe6d190f38fc5df5ff2614b463a5195a399c885 upstream.

It appears that we don't allow a vcpu to be restored in AArch32
System mode, as we *never* included it in the list of valid modes.

Just add it to the list of allowed modes.

Fixes: 0d854a60b1d7 ("arm64: KVM: enable initialization of a 32bit vcpu")
Cc: stable@vger.kernel.org
Acked-by: Oliver Upton <oliver.upton@linux.dev>
Link: https://lore.kernel.org/r/20240524141956.1450304-3-maz@kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/guest.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -250,6 +250,7 @@ static int set_core_reg(struct kvm_vcpu
 		case PSR_AA32_MODE_SVC:
 		case PSR_AA32_MODE_ABT:
 		case PSR_AA32_MODE_UND:
+		case PSR_AA32_MODE_SYS:
 			if (!vcpu_el1_is_32bit(vcpu))
 				return -EINVAL;
 			break;


