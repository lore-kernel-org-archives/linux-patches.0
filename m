Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF37913D635;
	Thu, 13 Jun 2024 12:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280465; cv=none; b=S3RfAIPJwhYrF2I9B3rVb3Lu9U9Z59kjbMFH9Fbj5bmSZrnftAc22yT6NtycK6xdPX2XXKaZAmw5ATS+b6/XY6WbT09Dj61j7sXAlFn+FWKfXAtdf+FXC1N5VgwEO5fluPV38Ol9uAyerLi1TxWoR2iHDmPjWdoTIYIdXz+MuBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280465; c=relaxed/simple;
	bh=YKpGH1V9ANrdti50wc73LhwYNQQW81N4qqBOkvwdnmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hj0R+k47nqFcXvMU7AVk+chKHRM2vgooLRAtQ/9ZAlX0jss9Of2rX1GVODoQBevnXP2OPRSwKhNSADseTO4zguyO+YePJGS2ihocJJAl49rkB4VnoeS1CqxkkNXp1MBbwSZrVVBMHExznqkyOxDZumK4uSWaYCTC2CwpzE3450U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IM5ZZm71; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IM5ZZm71"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64B3EC2BBFC;
	Thu, 13 Jun 2024 12:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280464;
	bh=YKpGH1V9ANrdti50wc73LhwYNQQW81N4qqBOkvwdnmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IM5ZZm71HscGVTf9MrbwraVB3gTxQsOr1HLallKqtJ/B2t3IKS3t/wQyBv9E7nXw/
	 nOIcBOk9q/slfP++RpaJiDISaeZ0jZ6lqR0fvyRYe38VYTIOgqf5e6ng8BTVHmosnM
	 iCBWeKz1vBfYNgLEtGZAST8qKbbT3zeDGyyHAovQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.6 062/137] KVM: arm64: Allow AArch32 PSTATE.M to be restored as System mode
Date: Thu, 13 Jun 2024 13:34:02 +0200
Message-ID: <20240613113225.707915132@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
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
@@ -251,6 +251,7 @@ static int set_core_reg(struct kvm_vcpu
 		case PSR_AA32_MODE_SVC:
 		case PSR_AA32_MODE_ABT:
 		case PSR_AA32_MODE_UND:
+		case PSR_AA32_MODE_SYS:
 			if (!vcpu_el1_is_32bit(vcpu))
 				return -EINVAL;
 			break;


