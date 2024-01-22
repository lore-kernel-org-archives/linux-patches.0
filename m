Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43BAC13540A;
	Tue, 23 Jan 2024 00:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969640; cv=none; b=dGqKdCpFRcjA8KwzBirs5U0qDrz+8ZiRC6++ia/vVIB+7PpolBFrKPdAFGvfX7KHB/fpENCjacgO4NGli2vAKTHOyCzjKYumquH8mcCmV6/ar4DpWxqI73YEjay/8qgsmbXLfEH/1UmXudK/1xK4WOkrzoZzI1w8cQl0PCyA9ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969640; c=relaxed/simple;
	bh=TgT/cH4jJmgzg3c6kUFIDwJcr0OfGDJpSrvUm3U7iac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GLt/G/eqd7bjjTo31ZI6BJs4oQR6ZcNsQ44YUxe53FzxzVj3jzx11CIkpEYzAw2YkZLMmEavIdF2Hc1UYXPtLIx5+77VzisbuLnBUUWSddEnFg6kFs6OrtL/+n3NKf4T+vx6LsgkB/1E82SkDIKNgq8F7Oz9rEUec5caCnstdnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TNAxs0Lt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TNAxs0Lt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 015D7C433C7;
	Tue, 23 Jan 2024 00:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969640;
	bh=TgT/cH4jJmgzg3c6kUFIDwJcr0OfGDJpSrvUm3U7iac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TNAxs0Ltp+iZkrQOYgZtHUj1J3kirBt6x0Q/Zh8z22CIm8xqHL6UU6tp3enXw12O/
	 ri0ZK6kAIvULFViV2VR5bDW0cbGE+cIJrxMCD4b7nN7ZBczi3dWAFHbfHfQYslv0th
	 TXUJGYXfo3aS4qsKE+bA1eppXup0HBIPFoWlkABc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jing Xia <jing.xia@unisoc.com>,
	Xuewen Yan <xuewen.yan@unisoc.com>
Subject: [PATCH 6.7 377/641] class: fix use-after-free in class_register()
Date: Mon, 22 Jan 2024 15:54:41 -0800
Message-ID: <20240122235829.756276267@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jing Xia <jing.xia@unisoc.com>

commit 93ec4a3b76404bce01bd5c9032bef5df6feb1d62 upstream.

The lock_class_key is still registered and can be found in
lock_keys_hash hlist after subsys_private is freed in error
handler path.A task who iterate over the lock_keys_hash
later may cause use-after-free.So fix that up and unregister
the lock_class_key before kfree(cp).

On our platform, a driver fails to kset_register because of
creating duplicate filename '/class/xxx'.With Kasan enabled,
it prints a invalid-access bug report.

KASAN bug report:

BUG: KASAN: invalid-access in lockdep_register_key+0x19c/0x1bc
Write of size 8 at addr 15ffff808b8c0368 by task modprobe/252
Pointer tag: [15], memory tag: [fe]

CPU: 7 PID: 252 Comm: modprobe Tainted: G        W
 6.6.0-mainline-maybe-dirty #1

Call trace:
dump_backtrace+0x1b0/0x1e4
show_stack+0x2c/0x40
dump_stack_lvl+0xac/0xe0
print_report+0x18c/0x4d8
kasan_report+0xe8/0x148
__hwasan_store8_noabort+0x88/0x98
lockdep_register_key+0x19c/0x1bc
class_register+0x94/0x1ec
init_module+0xbc/0xf48 [rfkill]
do_one_initcall+0x17c/0x72c
do_init_module+0x19c/0x3f8
...
Memory state around the buggy address:
ffffff808b8c0100: 8a 8a 8a 8a 8a 8a 8a 8a 8a 8a 8a 8a 8a 8a 8a 8a
ffffff808b8c0200: 8a 8a 8a 8a 8a 8a 8a 8a fe fe fe fe fe fe fe fe
>ffffff808b8c0300: fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe
                                     ^
ffffff808b8c0400: 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03

As CONFIG_KASAN_GENERIC is not set, Kasan reports invalid-access
not use-after-free here.In this case, modprobe is manipulating
the corrupted lock_keys_hash hlish where lock_class_key is already
freed before.

It's worth noting that this only can happen if lockdep is enabled,
which is not true for normal system.

Fixes: dcfbb67e48a2 ("driver core: class: use lock_class_key already present in struct subsys_private")
Cc: stable <stable@kernel.org>
Signed-off-by: Jing Xia <jing.xia@unisoc.com>
Signed-off-by: Xuewen Yan <xuewen.yan@unisoc.com>
Link: https://lore.kernel.org/r/20231220024603.186078-1-jing.xia@unisoc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/class.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -213,6 +213,7 @@ int class_register(const struct class *c
 	return 0;
 
 err_out:
+	lockdep_unregister_key(key);
 	kfree(cp);
 	return error;
 }


