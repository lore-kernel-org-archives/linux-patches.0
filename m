Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E4C471276;
	Tue, 21 Jul 2026 18:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658389; cv=none; b=HTcQ485lvO1oZdEMiXTGTEL6XfQSMi9MvES9LPvenNlGJIKEK4xZKnGCQwQ7E8WSQZdtSeSXQgJm+CbIkg3G0/itoFNwqxbKdu/j+kWYAOkd7eUF3Dhb9qL+q4Z/VPy+3wJjA96VfjwQQScX9wdc07t9frdOBlLx/aflweh92ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658389; c=relaxed/simple;
	bh=vz0xGbSLgmGWx6Gqhl3bC7dsPdyHqkg91/QqoNk8CxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C6948UMm+UaBIa2e0TLTpjKBLWoV8fS8d4fmCmag6wbvWEN5r70HTFC5CC5ISzn+Mk4IkHg2ZD4nKRh9M7HDvt9NmrmOxfAIdXss0U48yRGQpzsMlkuBl1pgUfKZLC/jBkbgRO96p39A0Iryl4ObccCRyY3y+U4k0mzRYnW1QKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tM850yyP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tM850yyP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B38F41F000E9;
	Tue, 21 Jul 2026 18:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658386;
	bh=aC/tVkUOwUjj+2xnAqssyh3yjwSLYVVHQeASG71SanA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tM850yyPkXFCiQoskPoF9vLVnoVsPqF7pNeKztW9OFIny/8R2v+ECOowqWcWiB+5h
	 r5zzHkqyKbopaoZ284rW1x10RQZNuNNLOlShQNG1h/WfXDOMAmG+xaN+oP9ZN1ahKz
	 gThG2D2yHKIRmXOFnNO67g2vcm387KpQ6X7Z+HoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Qiang Ma <maqianga@uniontech.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.18 1125/1611] LoongArch: KVM: Check the return values for put_user()
Date: Tue, 21 Jul 2026 17:20:41 +0200
Message-ID: <20260721152540.722998418@linuxfoundation.org>
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

From: Qiang Ma <maqianga@uniontech.com>

commit fb89e0fe2dc4246c86ad0eb0fa2b7cb2f8ba9728 upstream.

put_user() may return -EFAULT, so, when the user space address is
invalid, the caller should return -EFAULT.

Cc: stable@vger.kernel.org
Reviewed-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Qiang Ma <maqianga@uniontech.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kvm/vcpu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -1061,7 +1061,8 @@ static int kvm_loongarch_cpucfg_get_attr
 		return -ENXIO;
 	}
 
-	put_user(val, uaddr);
+	if (put_user(val, uaddr))
+		return -EFAULT;
 
 	return ret;
 }


