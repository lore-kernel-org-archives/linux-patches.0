Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7BB5144D36;
	Thu, 13 Jun 2024 12:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281577; cv=none; b=jQMKkDKOLO972ZgQbCRF/SawUyI/YbN6e0zAFaae5eakYYSVWxmu9Ra2xa9PbtKalzcvNuEy+iUvoltVb8yYKHnZlSsHiZhqOUJcu+oVIYB3wsATl8yJq4Ng6M9exWnsFO+Fit41rsrDheYJEU2+MdKr20JzFtKyMBWf53zQMxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281577; c=relaxed/simple;
	bh=WRXFY1uJaC7bN5jNUfx/X7ubUJVEg9/tKWXw3DISmBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ee2Fvzo1i2TpMgzrus/36XyQal3e6f+xj2EKd8RjRLT59ZyiepsvFynH7c85WQTntgS5IuQHpx8/YUKK9TPtxIoST5hoXUC4xCr0PwSA8PpIOxGsTtfSKDrmo6NdPQKhOn7QooRBt3QG6nDdkklNeNO6Xqcp46mUPwuUW7XFBik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yo6n7tye; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yo6n7tye"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EF88C2BBFC;
	Thu, 13 Jun 2024 12:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281577;
	bh=WRXFY1uJaC7bN5jNUfx/X7ubUJVEg9/tKWXw3DISmBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yo6n7tyeTI9pOlR8mDSSHV48GLKjaRzDJ94MjxRUzQ0N9dlB6tHZaLY06wJi8vpFP
	 fvZORg8K1lSTd90aIjP9NatMBJJYoZ9D1ZsXvGYvFvLY+rEO16BzuvICmoefN/OOEr
	 7NoS76lLKukfoIBnk9ajN/Nn+VskjtkhblXF1JDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.10 295/317] KVM: arm64: Allow AArch32 PSTATE.M to be restored as System mode
Date: Thu, 13 Jun 2024 13:35:13 +0200
Message-ID: <20240613113258.961981837@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -234,6 +234,7 @@ static int set_core_reg(struct kvm_vcpu
 		case PSR_AA32_MODE_SVC:
 		case PSR_AA32_MODE_ABT:
 		case PSR_AA32_MODE_UND:
+		case PSR_AA32_MODE_SYS:
 			if (!vcpu_el1_is_32bit(vcpu))
 				return -EINVAL;
 			break;


