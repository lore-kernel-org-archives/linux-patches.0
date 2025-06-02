Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04A9A2236F4;
	Mon,  2 Jun 2025 14:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875137; cv=none; b=gNh9RfI3tW64bm+PBQexTlMrHaBBAJYzasxTKzhiV5WOkY8C05hEgxfpeDHvUYwZD4nZpkOl+ibnyVHKou8Ws5NGGqpKqYLIHMZsQekmZniq9e8MPg2qLEP3P0HxNndWz7NeUlqULu9I5x5lw7AcVQYknCDd+OMZ0r4szdbn9DM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875137; c=relaxed/simple;
	bh=cyXnlLgK6sDLIb64vSpZXu8koBGGecB34NEKb8KBzwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VU8gUFH3RwW8NatTpGMkDb/wsDkoJZqRgVsuSDz+c0ZIBbdNuspvOUi66WzZQXw6YoAYY+Xp+EhPijt41MqyE82+hvGf+EvaWbLkCAEL3kEmAQi+7m/jyghKnYSGK663WO58hUJxtSnwsu4oNZ1xn3htvoCBzuQkAxgnFRjb75Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VTsJTCz1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VTsJTCz1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66C6BC4CEEB;
	Mon,  2 Jun 2025 14:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875136;
	bh=cyXnlLgK6sDLIb64vSpZXu8koBGGecB34NEKb8KBzwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VTsJTCz14gXcSzhoJRA36s/QVe4+nHls3PMg3D/7U5JW/rlmKLI/Z9fmlVMhadhWT
	 rADkhckZcHpzigOntPekCTnfrY0tReSvxFUTzTLX74pa54vMfBltJr0+eveURaHtlH
	 0g25cKCZX7ZSH5kyElrzmwWu6/wa9zKS4Nivr66w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.10 040/270] dm: fix copying after src array boundaries
Date: Mon,  2 Jun 2025 15:45:25 +0200
Message-ID: <20250602134308.825505740@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tudor Ambarus <tudor.ambarus@linaro.org>

commit f1aff4bc199cb92c055668caed65505e3b4d2656 upstream.

The blammed commit copied to argv the size of the reallocated argv,
instead of the size of the old_argv, thus reading and copying from
past the old_argv allocated memory.

Following BUG_ON was hit:
[    3.038929][    T1] kernel BUG at lib/string_helpers.c:1040!
[    3.039147][    T1] Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
...
[    3.056489][    T1] Call trace:
[    3.056591][    T1]  __fortify_panic+0x10/0x18 (P)
[    3.056773][    T1]  dm_split_args+0x20c/0x210
[    3.056942][    T1]  dm_table_add_target+0x13c/0x360
[    3.057132][    T1]  table_load+0x110/0x3ac
[    3.057292][    T1]  dm_ctl_ioctl+0x424/0x56c
[    3.057457][    T1]  __arm64_sys_ioctl+0xa8/0xec
[    3.057634][    T1]  invoke_syscall+0x58/0x10c
[    3.057804][    T1]  el0_svc_common+0xa8/0xdc
[    3.057970][    T1]  do_el0_svc+0x1c/0x28
[    3.058123][    T1]  el0_svc+0x50/0xac
[    3.058266][    T1]  el0t_64_sync_handler+0x60/0xc4
[    3.058452][    T1]  el0t_64_sync+0x1b0/0x1b4
[    3.058620][    T1] Code: f800865e a9bf7bfd 910003fd 941f48aa (d4210000)
[    3.058897][    T1] ---[ end trace 0000000000000000 ]---
[    3.059083][    T1] Kernel panic - not syncing: Oops - BUG: Fatal exception

Fix it by copying the size of src, and not the size of dst, as it was.

Fixes: 5a2a6c428190 ("dm: always update the array size in realloc_argv on success")
Cc: stable@vger.kernel.org
Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-table.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -514,9 +514,9 @@ static char **realloc_argv(unsigned *siz
 	}
 	argv = kmalloc_array(new_size, sizeof(*argv), gfp);
 	if (argv) {
-		*size = new_size;
 		if (old_argv)
 			memcpy(argv, old_argv, *size * sizeof(*argv));
+		*size = new_size;
 	}
 
 	kfree(old_argv);


