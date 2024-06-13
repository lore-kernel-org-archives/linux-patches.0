Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D37D1448E0;
	Thu, 13 Jun 2024 11:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279481; cv=none; b=T0muIltmfSR6CWM+iy2Hcfi+z6mXBr+EYbtIh9p9XxC1M2Dsh/gs2bvrMqbvIFBlSzDAWWD0gd9vtDla2AcHNsDycsl2Osdn215vd9Uq9DVMjeK+5+4nUAc+e8dP/JzmeC/Ym1DYhaRX2CPw2yEmeeTbKslwgybWwzgw8TXw8so=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279481; c=relaxed/simple;
	bh=/0ApgjhoEewSxNR8Nh/ESbflx9BJgFzLiq/DG9YB7zY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IcbLGYjMeIy8rdS5t8KsBPZZWCOcIeFqnp7VSz+zUU1C/KmkmfiNP+xNp4yjyDQqfJzZBmwSMsPpR9x9kZlsEFhqSRSPD7Zs2snqWhbTMQqx43D8NPKUDqYw7C73uk0oYIpHCUCPjduZ6W94ge/Yr7GpCz/evQrYBvuosmvHRo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=crrUudxl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="crrUudxl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8432C32786;
	Thu, 13 Jun 2024 11:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279481;
	bh=/0ApgjhoEewSxNR8Nh/ESbflx9BJgFzLiq/DG9YB7zY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=crrUudxlPothqEgjio84E8Ct4Cs+Yp13phpIa/Rl9LQrkDV6LaiS9p5hZ9F5wVCKD
	 pgnxCyziXxVXQPW91aaqqgeM0U1PLpI+yMJCVjmjJ2V/loIXeX4yUf/sh6U/FFIpre
	 Wvv2lSlelQDKIm2JIZST+jpsdGliHGWoEbbyUJKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.9 059/157] KVM: arm64: Allow AArch32 PSTATE.M to be restored as System mode
Date: Thu, 13 Jun 2024 13:33:04 +0200
Message-ID: <20240613113229.709183300@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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


