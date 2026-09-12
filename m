Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53B2147CA92;
	Sat, 12 Sep 2026 12:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217511; cv=none; b=XIeC0qKRmevmfSjtthqkLD3b40403BfbcZUz8QdFUvr3UhiDsn0pCAOhU2zfvN1xtoEGghpd3Qw4l45pvfLHfEZoMcm2UbfnaJI7NnxxfZqPjlPzSx2WUJNT+xCFgXRrtJckK/iIWM7Qya3+v/GXjqmjokXMD29V6oHKO5uAHDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217511; c=relaxed/simple;
	bh=yUcvta9l8DAgOT6oEwQTCfYoQpBmipdKMccwIDD/SnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TYMHl/lOGt4l8hwCXz7po5kuFga6PviBqT1xQJ72m3rnS24Kgi6/kVnMQxr/p/5WXt/Tz0cRBhDP0H38KVzRkJjyElZBn4XHsT5RTihzmj8SxEE5uZTReOK168dt9AxIViA9UqL8GSOzwIQVbEItxYzTllTMqf0Uj1MB22MXDU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LRkl9Vja; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LRkl9Vja"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13DBF1F00893;
	Sat, 12 Sep 2026 12:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217507;
	bh=0ZFC6st36xsuUlaYVKG+YMT3Ev/2iQOZwUAXpLeXoP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LRkl9Vjat9lGcKqm5jh/p4dgudbGwBEYjl14l1+gXNpv9lcsry9IX9SONqi4pnP7I
	 MisXP4+hQSyRXfKBgkh7jA9Peq6UNk27Bfx6mguN889K1yok/IRLX2ocqU/gPQ87wY
	 56/PqP2jtsIe97KyvgZWWoWgs/F5RdFaj9a2i9S0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naveen Kumar Chaudhary <naveen.osdev@gmail.com>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0928/1376] module: use strscpy() to copy module names in stats and dup tracking
Date: Sat, 12 Sep 2026 08:55:54 +0200
Message-ID: <20260912065628.247426271@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naveen Kumar Chaudhary <naveen.osdev@gmail.com>

[ Upstream commit 93c29ebd1622fb0670701e1c1b3a978a5cac08b7 ]

Both try_add_failed_module() and kmod_dup_request_exists_wait() use
memcpy() with strlen() to copy module names into fixed-size
char[MODULE_NAME_LEN] buffers. Neither performs a bounds check on the
copy. Current callers always pass names originating from
mod->name (itself char[MODULE_NAME_LEN]), so this is not exploitable
today. However both functions accept a plain const char * with no
documented length contract, making them latent buffer overflows if a
future caller passes a longer string.

Replace memcpy() with strscpy() in both sites, which bounds the copy
to MODULE_NAME_LEN and always NUL-terminates.

Signed-off-by: Naveen Kumar Chaudhary <naveen.osdev@gmail.com>
Reviewed-by: Petr Pavlu <petr.pavlu@suse.com>
Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
Stable-dep-of: 5eecb11b543f ("module/dups: Fix use-after-free in kmod_dup_req lifetime handling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/module/dups.c  | 2 +-
 kernel/module/stats.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/module/dups.c b/kernel/module/dups.c
index 0b633f2edda6b..6ecc42193de24 100644
--- a/kernel/module/dups.c
+++ b/kernel/module/dups.c
@@ -129,7 +129,7 @@ bool kmod_dup_request_exists_wait(char *module_name, bool wait, int *dup_ret)
 	if (!new_kmod_req)
 		return false;
 
-	memcpy(new_kmod_req->name, module_name, strlen(module_name));
+	strscpy(new_kmod_req->name, module_name);
 	INIT_WORK(&new_kmod_req->complete_work, kmod_dup_request_complete);
 	INIT_DELAYED_WORK(&new_kmod_req->delete_work, kmod_dup_request_delete);
 	init_completion(&new_kmod_req->first_req_done);
diff --git a/kernel/module/stats.c b/kernel/module/stats.c
index 3ba0e98b3c910..2a4e2f6708965 100644
--- a/kernel/module/stats.c
+++ b/kernel/module/stats.c
@@ -253,7 +253,7 @@ int try_add_failed_module(const char *name, enum fail_dup_mod_reason reason)
 	mod_fail = kzalloc(sizeof(*mod_fail), GFP_KERNEL);
 	if (!mod_fail)
 		return -ENOMEM;
-	memcpy(mod_fail->name, name, strlen(name));
+	strscpy(mod_fail->name, name);
 	__set_bit(reason, &mod_fail->dup_fail_mask);
 	atomic_long_inc(&mod_fail->count);
 	list_add_rcu(&mod_fail->list, &dup_failed_modules);
-- 
2.53.0



