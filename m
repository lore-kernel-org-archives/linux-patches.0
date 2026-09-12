Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9714233993;
	Sat, 12 Sep 2026 14:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221740; cv=none; b=LiUkuMdRHJI/bi5ZSuXPJznzreihNR4G6TmdaNVevzd8NX6ssMGhk4JVI2mmkBpakaB9i3XTABhsj1BghHhRWHVRWRhiPzw/yH0/27kRKR8DpfCP4o+LtGUknyJ6AiLf6N3LzsDOzpE69z5QqzL+JUETD581XeRHsrt6mgF9Ha8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221740; c=relaxed/simple;
	bh=Bq/SwdaQBMYmktKuJUYvDtubJIIS1u7+LSLy9sef/RQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EHgRpRhonb1Qs8ul9p9bVA3eUHE6hZAqDTWNbKoQscA9OjNdkgaFXDX9jG52i7MVkL9OOOc5xAkJxy8cahZYqkECmyF6WDsunlo3uxoq++ouzh9PkWa5CC11c6EsrQHniRdrwjMyK9Tc0BvBOmaBQ92ribns4nRGIfjx3cbP3jM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wDR8TSNh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wDR8TSNh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3A831F000FF;
	Sat, 12 Sep 2026 14:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221739;
	bh=MKJaGNuUs8sH9M8SbOZK7c+1ajiEoR3TXiIIeCgJsv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wDR8TSNh5X37JoVcGSCmUbk38EwPMZ9mcGD5UhRLm2vSqawTosdepFzaZUuQqRW/o
	 gXrh1lPpx3WfdZ6Cbxu792BXPQ6fxBxhe5uXkzzkgasgfJn3iHNKxnpZwY9RhxGiPM
	 Z75hte5ZvYxNOfPhf6Nqd+1gmdA6yfA/RJMJwsxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [PATCH 6.6 0437/1424] KVM: s390: pv: Fix rc/rrc offset for PVM_DUMP
Date: Sat, 12 Sep 2026 08:47:49 +0200
Message-ID: <20260912065617.069945619@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5728,7 +5728,7 @@ long kvm_arch_vcpu_ioctl(struct file *fi
 		r = kvm_s390_handle_pv_vcpu_dump(vcpu, &cmd);
 
 		/* Always copy over UV rc / rrc data */
-		if (copy_to_user((__u8 __user *)argp, &cmd.rc,
+		if (copy_to_user(argp + offsetof(struct kvm_pv_cmd, rc), &cmd.rc,
 				 sizeof(cmd.rc) + sizeof(cmd.rrc)))
 			r = -EFAULT;
 		break;


