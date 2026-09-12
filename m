Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E10723803CF;
	Sat, 12 Sep 2026 07:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197974; cv=none; b=TE06dcH06SwQ0OmByk05OXfvLM4qmckhvXt209r02EYpLrdmQBLn3PrHWJYdc3PxbOZdoPryDeSXPdopZ9Q7yksTDgeHmhE/KaP1bK4LE6qeeaDAetMxa1wQV6+9mvSMVI8vsLtT3VMW4K+chvxRas+NZiGMlNO3gyIn1of7eDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197974; c=relaxed/simple;
	bh=h7l5IeBLWJGe4HpXpsRS0fhcINWiRNUfSKOIVUS3nGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UPdONEgj7DX2W4CtN5jFdTb4Zu+wfQHYEfwKAr0PUTeKPYtZK74DyRqIcTE/KMSM80ZpQO7kzu43Lj/8iHU6cFNgHR+rdOdr9hznLxVx09zHwPiZCh51wiEdcR710diZtDFTFMqNhAdnekUf8PAj+AzKN2PUTSyDkUWT5Jzfyb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=icsTg682; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="icsTg682"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4AED1F000FF;
	Sat, 12 Sep 2026 07:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197972;
	bh=n67xFC8C/O2DZ3Wvue5pnLCCKhheVmhH7nSqFhcm8xY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=icsTg682t+9nDSSNwusm8WxKr/X5+n3GCRbis0juKhzn0VGe9abYaXCOxRnfl1OyD
	 4B1OtXk8DY6vSozYlAAVCnZdx6omwfSIfapZX8/MP3h+C9ielYclEkmaIy1sqSh/3B
	 EzwoZGSaHvIDeN0S75jQ5kvmo6H/DgcsvnNmZ6uE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0286/1815] bpf: Fix security_bpf_map_create error handling
Date: Sat, 12 Sep 2026 08:33:56 +0200
Message-ID: <20260912065655.674971376@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 36ffa86c42f91c8a57071e024afc4ffb51a8958f ]

Commit 5816bf4273ed ("lsm,selinux: Add LSM blob support for BPF objects")
made the LSM hook wrappers for BPF object creation clean up the LSM
state internally upon denial, e.g. security_bpf_map_create() internally
calls security_bpf_map_free() when the bpf_map_create hook returns an
error. map_create() however still routes a denial to its free_map_sec
label, which invokes security_bpf_map_free() a second time, so the
bpf_map_free hook fires twice for a single denied map.

In-tree LSMs are unaffected in practice since the blob kfree() inside
security_bpf_map_free() is NULL-safe and idempotent and none of them
implement bpf_map_free, but a BPF LSM program attached to that hook
observes double invocations. Route the denial to free_map instead.

Fixes: 5816bf4273ed ("lsm,selinux: Add LSM blob support for BPF objects")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20260709073422.379247-1-daniel@iogearbox.net
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/syscall.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 6db306d23b479..85f7d8a81eb01 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1657,7 +1657,7 @@ static int map_create(union bpf_attr *attr, bpfptr_t uattr, struct bpf_common_at
 
 	err = security_bpf_map_create(map, attr, token, uattr.is_kernel);
 	if (err)
-		goto free_map_sec;
+		goto free_map;
 
 	err = bpf_map_alloc_id(map);
 	if (err)
-- 
2.53.0



