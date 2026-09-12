Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C51893264F4;
	Sat, 12 Sep 2026 15:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228314; cv=none; b=fR7Ma3XTKeUFWhrLtbwGcDusWSKg3k7+opOzRpM+stZMDigOeNBrOhJS4KRrJxlf2RdlnqnzWIW2fFTM8Eff8scUaqR6cXg9aXoIGAZr2bxx6pSOn+ENokSeswQZkQvIfWhpdJbu+HxLKci0E1OVxMLSymwwbYClBmp1sV6yuZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228314; c=relaxed/simple;
	bh=OpMdSGBUesFQ2OawGaJfIem5u0aSKrv19tQfao+mlZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hWTk1UXA+phWKztQZPvB9Oi14NQAddqTUzf8rvGknZjFdLEwPqMQG5CAiNTWWilnUO3FGqXl7vGF4rE+/6Rev+LuYe/2FYY+n0fxoW/mozmeCkWO8qsf1N7dyCx3sm39fH+hD254kv5snQGyLu2RDEn8vJeElJDqu/XTHl5tPeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YMrlhyxy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YMrlhyxy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C976A1F000FF;
	Sat, 12 Sep 2026 15:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228313;
	bh=RIjG9lfBbkzLGViH6yLmIZLPq8IWrhcFZN9izgAFfuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YMrlhyxyfEFnlzUFUwuDsk0vwSHN2T4dVeTcu0o9tzSNBz9u1zjyscCy+mAQqI6/c
	 tp7ow0XvwD5/Q5cifRtwlcINUNLzkr9ANRqIAlu/1TrQB01ExmxyfrpYT0ZvVUiLwG
	 DhbLXaxV3h6x3Soq14/TFd8/H5EXXxLoTZp5q2Nc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [PATCH 6.1 0359/1191] KVM: s390: pv: Fix rc/rrc offset for PVM_DUMP
Date: Sat, 12 Sep 2026 08:51:27 +0200
Message-ID: <20260912065556.291692616@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Borntraeger <borntraeger@linux.ibm.com>

commit 1e3c8e7b3465fb8a49d3623d2d0f449c0b5b48f3 upstream.

The rc/rrc value is copied to the cmd location of the cmd in the kvm_pv_cmd
structure. Fix the offset.

Fixes: 8aba09588d2a ("KVM: s390: Add CPU dump functionality")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-ID: <20260811153738.206885-4-borntraeger@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kvm/kvm-s390.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -5551,7 +5551,7 @@ long kvm_arch_vcpu_ioctl(struct file *fi
 		r = kvm_s390_handle_pv_vcpu_dump(vcpu, &cmd);
 
 		/* Always copy over UV rc / rrc data */
-		if (copy_to_user((__u8 __user *)argp, &cmd.rc,
+		if (copy_to_user(argp + offsetof(struct kvm_pv_cmd, rc), &cmd.rc,
 				 sizeof(cmd.rc) + sizeof(cmd.rrc)))
 			r = -EFAULT;
 		break;


