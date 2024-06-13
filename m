Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C0FC13CFA4;
	Thu, 13 Jun 2024 12:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280303; cv=none; b=XL0pQJ4otj0ZVDu7z1VhChDHdfnOEa8JZr+Wn6mUF2EM8MM0gdOXW6L8ltWWCfs3x9WPT2/9q2S8uHzi2c53St0JCu/sb82caFMdG6gBOWhr82EVEJoGkElsquuV/I8ZP+AvaGDYeSM3Dee0zRaQrbNSIf5gGyC56rHzhy5CkHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280303; c=relaxed/simple;
	bh=LixZY1+V9UWxCPP6141/97Qh5XCM2PF0C8tcYu44i7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LtPZs+h67sdVjJID4hn0bSViPeS/Nv7dOLWIF4JyR5cTTcbctd0GPyftEsyJ1JYnJR5jRJicB1db9hMrqtAZhncZOjt8UBflkp/f2c/Av3BafhImS1XGGq1GUJXn/iclxVmt0/FHowJLnZRi6Xq0yZaUvhpgNt1sU12wYJuX9HA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ncwYHP2w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ncwYHP2w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 514A5C2BBFC;
	Thu, 13 Jun 2024 12:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280302;
	bh=LixZY1+V9UWxCPP6141/97Qh5XCM2PF0C8tcYu44i7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ncwYHP2wWKW6E5BBfhEIyM+aIwubpMoAPSQg6pXhk/VcDYqtaRid1b+bV3J33Kyp8
	 TuDsad5nAe7CQ828MM0065VFUTf+CMFRb+cSxXKKXzc3NyFC68DUQwRKWwYJcIFhOL
	 2qPWB1H6ktnOVylS/w9kHMNtFiibbRpsUHLHLwu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.4 185/202] KVM: arm64: Allow AArch32 PSTATE.M to be restored as System mode
Date: Thu, 13 Jun 2024 13:34:43 +0200
Message-ID: <20240613113234.877417084@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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
@@ -186,6 +186,7 @@ static int set_core_reg(struct kvm_vcpu
 		case PSR_AA32_MODE_SVC:
 		case PSR_AA32_MODE_ABT:
 		case PSR_AA32_MODE_UND:
+		case PSR_AA32_MODE_SYS:
 			if (!vcpu_el1_is_32bit(vcpu))
 				return -EINVAL;
 			break;


