Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851F46D1B3;
	Tue, 23 Jan 2024 02:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975379; cv=none; b=LownTp/DHS7kKnCFxhyZO9gqvvgTdHaS0I8X2vgLcrurys0/iRwOw+TK1NhVGAPuHo8Xi3FS5owJnQbKvs61PF7UAsWyyegkNi0yNijbCJIeEEPN/S29Ex5g1u8xehGQFxHDHyETg1WTlmBkfVAIXF5UwqeWfTRItzYTebALnxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975379; c=relaxed/simple;
	bh=5I++2Xdk+nct1G4jbSKF9jf6ZjMJVk4iBv6grXojD34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OyS5rG64+mCntdiZ2k0Ir0mUhTcTKVxKHpoejOwMI7jhu2HyjCdek7G8rYn94dotgAU50ocG/vziGcex43WGwyn6a9eZASEN19M9nGkZODayvc6Ka5ckR/Ec7ZXhq2Yb+3iw8L5JcdzrRRgiKb9yEIUSLzNjZoHqhMz36UKmva0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PJCQiYAW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PJCQiYAW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ABECC433C7;
	Tue, 23 Jan 2024 02:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975379;
	bh=5I++2Xdk+nct1G4jbSKF9jf6ZjMJVk4iBv6grXojD34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PJCQiYAW9M+4QRbDrVsN7cjaraD1Cm9Ubuz/WMj/6SiV6LXyxQoeJQT52Ebcc+t2j
	 L9WjH4BJJOB871ByZoZBSZVQ/txw86cU9mwv8CO0AHCsc9TWxzLnk/5bqOONS9p3Wy
	 bIy9TMjKNUx0v/cTC932Ap7F9suozENwFs71kLtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jing Xia <jing.xia@unisoc.com>,
	Xuewen Yan <xuewen.yan@unisoc.com>
Subject: [PATCH 6.6 341/583] class: fix use-after-free in class_register()
Date: Mon, 22 Jan 2024 15:56:32 -0800
Message-ID: <20240122235822.460941963@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -215,6 +215,7 @@ int class_register(const struct class *c
 	return 0;
 
 err_out:
+	lockdep_unregister_key(key);
 	kfree(cp);
 	return error;
 }


