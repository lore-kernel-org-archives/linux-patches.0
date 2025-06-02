Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40F1C2C324D;
	Mon,  2 Jun 2025 14:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874465; cv=none; b=nMvE3IZrJnIkkjr9n1hTKY0GgVTyaLDRzJI1fAFUalSa2D1L6YalHC0d0eUsOEjwLKNY0cs9YE0hKIWqVGSTLbIJWWh6bEyzuyLs/B3E5URFQA1UHPh58FqahW/2lYdIp6BsgQJszUajyfDYB3l1beLbWA19moDfAsQf03vqV6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874465; c=relaxed/simple;
	bh=qRsKP2jsrR4I++2ivhLPPrrKDoCdzqn/sGVUc3Z7c1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fWqUaRqRJSrHiDQzMS0lUmMYiGvojV+kFARCN7Y0+S/HOhGQzcv6jgPlWIN6hQ8BX/7ysPQP1o3hIbcuiZyCU+O//4/rEled1hPdlCGTEdvzAdtHifBDVaWJaEMbC9BIN+cXyy4JN+17RoU4j8dbYQCTRmQOFqss6vR7TUo/2Yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SJiveRut; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SJiveRut"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC8B7C4CEEB;
	Mon,  2 Jun 2025 14:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874465;
	bh=qRsKP2jsrR4I++2ivhLPPrrKDoCdzqn/sGVUc3Z7c1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SJiveRut51FMKp489JWGKqs0QBhjfPtROKvuEJTua93mLtZI9hlksV/OSsK/0hfDS
	 4UEt/WNG6J/W00AZNFqKwbiH3fZV5aLV6UFQ1z9xiVUOfvubaUi7hh93lu1XCSC2gK
	 nCUQ7M9+tI3e9l1xdiDtI2M0Ypl1IL/98SeMOMMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.4 032/204] dm: fix copying after src array boundaries
Date: Mon,  2 Jun 2025 15:46:05 +0200
Message-ID: <20250602134256.942010488@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -574,9 +574,9 @@ static char **realloc_argv(unsigned *siz
 	}
 	argv = kmalloc_array(new_size, sizeof(*argv), gfp);
 	if (argv) {
-		*size = new_size;
 		if (old_argv)
 			memcpy(argv, old_argv, *size * sizeof(*argv));
+		*size = new_size;
 	}
 
 	kfree(old_argv);


