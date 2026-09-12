Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2A0333993;
	Sat, 12 Sep 2026 09:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204334; cv=none; b=bwHeGjcWrspUgspDpx2K+iHO4Ygu0thsLPngUOQ+hBQtEBgv38V3zlgH5Yd2NpAbnEPY8E1tdKiNghnOHgayjMDHO0QkyWf41LX9bXXc1foPzxSuj+D/em8ILkjekG1LVK2QMBcnO4kmDLGDAcDmE2YZ2wo6LTadzjrEAL6g7l0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204334; c=relaxed/simple;
	bh=loRRr/tDjYKQlqtEOWZHvVSOwP7UAeOs3p9pIujs5fU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JDk4AObbyNdS2Dalf0VNJSGGYYCVIcoy6gye4cmvgL/RpQDXp4KTngDW+S7jSMSshMI7EEVJZy2wFUPwcfjDU1R1WRZA/4/PT1Q3WPx8sUwStnGr4i3YPXjVbWgzOpy6D66krQdeaEMDRYyDwahn3JtuyWBqjhOldzaJbyCS3yI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D8GuR/+o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D8GuR/+o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6962C1F000FF;
	Sat, 12 Sep 2026 09:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204332;
	bh=3LxXXO4+LgkSBC+Yzq6XQIneApZELEVPcLBrT+y+3Yw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D8GuR/+oRk73rV6TWfN4Uo3ujyzAXvXuau76wr/4K/eN5prw4XSzux2fYJVKQbRF1
	 /Aedor2ByIjO0x/WT6dDn7v4sqq4x+eT9ktAHbIaEbZZYHn9xqMmIvGaPLlh2+20C6
	 GGM1MsD6ZXBXtvK00TPE0hscRN7x+p+sr7Eb0md8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1590/1815] platform/x86: dell-wmi-sysman: Fix instance ID bounds
Date: Sat, 12 Sep 2026 08:55:40 +0200
Message-ID: <20260912065726.317715191@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 3bddedad5eba2..eb48ced558232 100644
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



