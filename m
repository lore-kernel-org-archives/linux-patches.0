Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6FAE2D23A8;
	Thu,  3 Jul 2025 15:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554864; cv=none; b=ipJIA4fchp4+i7hPYbENU6PPf0jGUQ7QS52sVfb8EnRUY0gM3aZW3Ids3eEZ9ERuP1lQWx+7fPDCe/QONsEoGsJmM+VCx0jJbh9TcslWL+wX9SVYwtvkS9lyG8zFCbO2iMD3cMry+I5iABZxrddD9TN0vsYK380oC/OVp1mZSCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554864; c=relaxed/simple;
	bh=124PkYgn8dyV2FYHr2rowbddlivC4k0xahTJdiNSDzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OtnA3B6/vwm1HeYXZMt+GszHrU2+VglOwdWfQYzGDr1kFn3vSwKFw+NZNIMwn0+KG3pLMobjmD987b4MLTuMJsE0eEDOB0j4iyOaTJIBkKUla3Y3d9Kx+K2WpM7HrEp1nYvanI7uur4JKXWEB/GHykCRcGn2JkQ1vy004bL+d0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OgXTWc8Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OgXTWc8Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C99EC4CEE3;
	Thu,  3 Jul 2025 15:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554863;
	bh=124PkYgn8dyV2FYHr2rowbddlivC4k0xahTJdiNSDzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OgXTWc8ZTkrYw/3hAbd1ix6WzGANN0a07am1x7PTctSx1J+0nup9lkimAAmkm/J7n
	 nztJT7zP5wnJ4YoiDhgwviHlKFbZm48sBT5yMTeJlWPF4Y7IzhajsClnZur0XuGbmG
	 XKsHstZeTe/EgLUSIixq5o+OkQmHXaAgOOys2/ic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.15 103/263] LoongArch: KVM: Disable updating of "num_cpu" and "feature"
Date: Thu,  3 Jul 2025 16:40:23 +0200
Message-ID: <20250703144008.435111120@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bibo Mao <maobibo@loongson.cn>

commit 955853cf83657faa58572ef3f08b44f0f88885c1 upstream.

Property "num_cpu" and "feature" are read-only once eiointc is created,
which are set with KVM_DEV_LOONGARCH_EXTIOI_GRP_CTRL attr group before
device creation.

Attr group KVM_DEV_LOONGARCH_EXTIOI_GRP_SW_STATUS is to update register
and software state for migration and reset usage, property "num_cpu" and
"feature" can not be update again if it is created already.

Here discard write operation with property "num_cpu" and "feature" in
attr group KVM_DEV_LOONGARCH_EXTIOI_GRP_CTRL.

Cc: stable@vger.kernel.org
Fixes: 1ad7efa552fd ("LoongArch: KVM: Add EIOINTC user mode read and write functions")
Signed-off-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kvm/intc/eiointc.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/loongarch/kvm/intc/eiointc.c
+++ b/arch/loongarch/kvm/intc/eiointc.c
@@ -905,9 +905,15 @@ static int kvm_eiointc_sw_status_access(
 	data = (void __user *)attr->addr;
 	switch (addr) {
 	case KVM_DEV_LOONGARCH_EXTIOI_SW_STATUS_NUM_CPU:
+		if (is_write)
+			return ret;
+
 		p = &s->num_cpu;
 		break;
 	case KVM_DEV_LOONGARCH_EXTIOI_SW_STATUS_FEATURE:
+		if (is_write)
+			return ret;
+
 		p = &s->features;
 		break;
 	case KVM_DEV_LOONGARCH_EXTIOI_SW_STATUS_STATE:


