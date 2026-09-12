Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A9B548F84C;
	Sat, 12 Sep 2026 19:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240369; cv=none; b=E2RWQqGOUsWgoGhZIE11sH6QoqpWaLOxNiUquQozYjd+q3JLGVr5t9jjh7apf7tegArt8TTKhN97STGzbmNzfV1hoeRLACAWftW9Gb2ShB8bNFL/jmbERvSqjSK8+SJC7rX7w3dPeRizmsM5x1dWY6wWXCK79TtgJoD35hExuwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240369; c=relaxed/simple;
	bh=68buKY5ky82eZUzN03YFKjnpSfY0PbpV+ruGKUDj8AQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VchODAsqTTuqlsbEwsrux77I3gTlDtxgqOnSAlYjg/m3lNRg4bsLB11KmOObpHZTsuwX+22Eq6t22ga5uUMGgaa+R+S8Ym9BLPwJb1Ik7a9jdDDCRaJiD/agOWNVxraS7cNabQd7rM2/ApeJwi3ONoJVuoxDNEY7J0ZeRCgz9ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QZ3H6hC9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QZ3H6hC9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6718F1F00898;
	Sat, 12 Sep 2026 19:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240368;
	bh=wB781K0+MprBhMarQXeq6s5h0oeqLzh+ecbDdudS3Ys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QZ3H6hC9kkYz+kXshx0LMYUwYFl0s0lxaRHESVArwPydOQ8oilnsG7EYojEPJOuVF
	 0HbqGHP6pRJ1XoMTcOhkeaMW7XYwK9JEIt5KdHFOG8EwfAhJALgh8P+AX38ydI3/it
	 QBgEQCkZZbz0EYb7uw3nRXj4CBRwf+FJ2AGpJho8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 852/935] platform/x86: dell-wmi-sysman: Fix instance ID bounds
Date: Sat, 12 Sep 2026 09:04:42 +0200
Message-ID: <20260912065546.368678357@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



