Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2D1478C9C;
	Sat, 12 Sep 2026 15:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225920; cv=none; b=e+RiVooQr0DDSYMn5cVWbyfJ7CuOUWSkq0uV9iXIFgjA4u93yJcpt+lGAYFb75/b1bHKR1a136G7tgrrv0ypuMm1T2QYP4gWyx1B/eENj+K7mp8h+4Gn13CR/K2a9msA+0qpriKcl+y3oYu4G0GcpJYhjmFykDZMvzROsXnf920=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225920; c=relaxed/simple;
	bh=Bpr6wcD9yhE4KFjO/iaiwoo6yHzsIAIzoxlEdWUlsKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jXcaWbr7W+eoAEWV7T8aVmr/2kqshNW0f2/Fz4FQH2iSJvqa+PbdfFLyZzV9oCWOEym5Gbk7OHdL8NrfHd1j+AFXNQ0d50i28P/siwuT/hyTh/N8k96FIZedfSUfZwlA9Iw6UIEtkmYn2ivFKGdrQZkYdiPgZrO0KuYsVv/RwLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RFx9GcAe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RFx9GcAe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6D371F000FF;
	Sat, 12 Sep 2026 15:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225918;
	bh=UzITmjxXcHABGpfdneVkglhArkOalvcQ4U1PxYXXu08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RFx9GcAeVlSlDtIlcxagJxsatcCqgFSDLvMghUxAkSSi9jCeaXfjuTK9kK/qNjmou
	 8wT1DzAFglX4czeFfw2wr/d5kJnySvohIAzopd1+FWLaPjzo6FkyPVjkY2UtHKbDoX
	 Dq6KcDbZyDSzBgFK1U+16QaIgzOuNFzZGpaOqHzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1296/1424] platform/x86: dell-wmi-sysman: Fix instance ID bounds
Date: Sat, 12 Sep 2026 09:02:08 +0200
Message-ID: <20260912065636.292050882@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit 5ab078e3241da0beec2022254b5811a8a52cff84 ]

The get_instance_id() macro walks the per-type attribute array with
'i <= instances_count'.  Each array is allocated with exactly
instances_count entries, so the valid range is [0, instances_count)
and the last iteration reads one element past the end.  On a name miss
that out-of-bounds attribute_name is handed to strcmp(), which reads on
until it finds a NUL byte.

Every kobject in these ksets is built from an entry that was populated,
so a miss does not look reachable from sysfs today.  The bound is wrong
either way and the read is out of bounds.

The matching macro in hp-bioscfg carried the same off-by-one and was
corrected by commit 25150715e0b0 ("platform/x86: hp-bioscfg: Fix kernel
panic in GET_INSTANCE_ID macro").  That macro takes a kobject pointer
out of the out-of-bounds element and dereferences it, so it could fault.
This one reads a char array.

Use '<' to match the allocation.

Fixes: e8a60aa7404b ("platform/x86: Introduce support for Systems Management Driver over WMI for Dell Systems")
Assisted-by: Claude:claude-opus-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/20260814132535.4169956-1-sammiee5311@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/dell/dell-wmi-sysman/dell-wmi-sysman.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/dell/dell-wmi-sysman/dell-wmi-sysman.h b/drivers/platform/x86/dell/dell-wmi-sysman/dell-wmi-sysman.h
index 817ee7ba07ca0..b0810a02e6dac 100644
--- a/drivers/platform/x86/dell/dell-wmi-sysman/dell-wmi-sysman.h
+++ b/drivers/platform/x86/dell/dell-wmi-sysman/dell-wmi-sysman.h
@@ -107,7 +107,7 @@ enum {
 static int get_##type##_instance_id(struct kobject *kobj)			\
 {										\
 	int i;									\
-	for (i = 0; i <= wmi_priv.type##_instances_count; i++) {		\
+	for (i = 0; i < wmi_priv.type##_instances_count; i++) {			\
 		if (!(strcmp(kobj->name, wmi_priv.type##_data[i].attribute_name)))\
 			return i;						\
 	}									\
-- 
2.53.0



