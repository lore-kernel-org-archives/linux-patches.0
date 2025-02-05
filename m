Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2DC91519BF;
	Wed,  5 Feb 2025 15:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768011; cv=none; b=DNR10LPpvch8wcuGwVVkiveDb7Qt2fmRdgQqFr+eErmbqAl1rDJe9slI3X67PgKpV7PGCIvmaftbZQOrgf9gFx6bBNXW2JsgiX8XTz4wxK3Vv08EmKSaoIec2V6vUa1+CkhDl3TkVQ9ARMbgwO1zPPbFI/0nxjyjz/h78rzWhD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768011; c=relaxed/simple;
	bh=dejaLlQ9PaZaWX3kJ36CXtzimgYL5S8kyI1pC5ElmFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=roOi5uvcacIO34i/KBbSLLptD3rvOkGAveFZjn9VRRaYd53mpKU+ItsBOb+seSKKYRqOgVWrfQ/YYQRzqR4Cn52gjDQIwlTE29oHHZ9VP0lKW8SV2IMDyZuNCBDDvMZQWZV7ZQIJ7QU7i4N7Qo+4YvWKFFbFXNpS50cMLgQEPZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gYxlHAiK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gYxlHAiK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D9E5C4CED1;
	Wed,  5 Feb 2025 15:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768010;
	bh=dejaLlQ9PaZaWX3kJ36CXtzimgYL5S8kyI1pC5ElmFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gYxlHAiK3lVZklnYSMgVEM2Uvmke6DM1h/uAjVUz5AJXsQxcpT97xdqIB509zBsoS
	 fV8h5aovNquycM2FmENBclZRHCFn+N36W8Pgz2eUM6JUKE/Ov2TsnUkTHcEVDIGvXn
	 aiC/Fs2gOiZLGr2gsRhjajt9WGO94MsedfK6oKis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 484/623] module: Dont fail module loading when setting ro_after_init section RO failed
Date: Wed,  5 Feb 2025 14:43:46 +0100
Message-ID: <20250205134514.733897916@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit 110b1e070f1d50f5217bd2c758db094998bb7b77 ]

Once module init has succeded it is too late to cancel loading.
If setting ro_after_init data section to read-only fails, all we
can do is to inform the user through a warning.

Reported-by: Thomas Gleixner <tglx@linutronix.de>
Closes: https://lore.kernel.org/all/20230915082126.4187913-1-ruanjinjie@huawei.com/
Fixes: d1909c022173 ("module: Don't ignore errors from set_memory_XX()")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Link: https://lore.kernel.org/r/d6c81f38da76092de8aacc8c93c4c65cb0fe48b8.1733427536.git.christophe.leroy@csgroup.eu
Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/module/main.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/module/main.c b/kernel/module/main.c
index 5399c182b3cbe..c740d208b52aa 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -2950,7 +2950,10 @@ static noinline int do_init_module(struct module *mod)
 #endif
 	ret = module_enable_rodata_ro(mod, true);
 	if (ret)
-		goto fail_mutex_unlock;
+		pr_warn("%s: module_enable_rodata_ro_after_init() returned %d, "
+			"ro_after_init data might still be writable\n",
+			mod->name, ret);
+
 	mod_tree_remove_init(mod);
 	module_arch_freeing_init(mod);
 	for_class_mod_mem_type(type, init) {
@@ -2989,8 +2992,6 @@ static noinline int do_init_module(struct module *mod)
 
 	return 0;
 
-fail_mutex_unlock:
-	mutex_unlock(&module_mutex);
 fail_free_freeinit:
 	kfree(freeinit);
 fail:
-- 
2.39.5



