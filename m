Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11A3413CA99;
	Thu, 13 Jun 2024 11:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279172; cv=none; b=qxGNWoYFx7G8j1FU0AtpVzRPKJtPM239QB8LPN3OqZoQRfW36xXQxHkTSJqvVEKPI4XuLjolc5Fb/bYjSqVNxAAWmIw71FIlnsBQ+iMg3xND8s+gw+avb4/FO56uU/cOeAyakiHTZjsxeFNp4+shmghk8ncLG/I4qOoESVxirps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279172; c=relaxed/simple;
	bh=5SMrO+DqoQ8OSg5f/8SJ0lQ2/eG+6ifVSWAuC4lduh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JLvPrBzS/gEm95vysbkDfOLU90BqMXw3CUrSKhOfHp4bWawCzyQPOOvD0qXAf623Xm1VhoGPuy7elZmE0MLkkSXq9Mb2W7qXmLzhSoeNJiWepNP5FXHTek1tMTGkcC9CIMUreWCMul5EesfdyNyLrgXcbo6XpU3TeIZMzo4uxgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e34opGk4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e34opGk4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90330C32786;
	Thu, 13 Jun 2024 11:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279171;
	bh=5SMrO+DqoQ8OSg5f/8SJ0lQ2/eG+6ifVSWAuC4lduh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e34opGk4+JPcBaNzF07ggDuHx/R8cCPQyzQCzn5rCvot+mUfEQcZqrx2I6KNEO55F
	 soS/DDo0n9TfhVNu1TJM+9yXQcaotu/4QmsC0ttCvE95CJ0pN4+B4x/l9b/9z0LLMy
	 n2WfrO3egyWzxVbX6aJCcbwcXqedvV5vnTft1JVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 4.19 199/213] KVM: arm64: Allow AArch32 PSTATE.M to be restored as System mode
Date: Thu, 13 Jun 2024 13:34:07 +0200
Message-ID: <20240613113235.654786459@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -175,6 +175,7 @@ static int set_core_reg(struct kvm_vcpu
 		case PSR_AA32_MODE_SVC:
 		case PSR_AA32_MODE_ABT:
 		case PSR_AA32_MODE_UND:
+		case PSR_AA32_MODE_SYS:
 			if (!vcpu_el1_is_32bit(vcpu))
 				return -EINVAL;
 			break;


