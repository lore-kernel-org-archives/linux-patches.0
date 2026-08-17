Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 881163B811F;
	Mon, 17 Aug 2026 14:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975789; cv=none; b=LNDM7a8JBpDNnudfuynGRvP2HEwwF6BZH6/Gyqlyoaj9XD5tHN+dGGyByF76I/xjzvL2xXhEeIWwaYZiKqWJvV0J3nxdXtmkcU6R5okI2z9iYhbYPGWbDKjqxdP8Kk7yRL1eiAB3juIryOty4Kf0bIaWEsZAXFKYV/UocRjYJYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975789; c=relaxed/simple;
	bh=Az6Y/nMgPPybSOaUiKd3O3RHN5/0QKthmZ0T79mDlIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pfyu61717J/z8fkfFvkFsiEjrz6uqJzLzqMYDQY0wHRluroPfl02HTUpoL4DczNCCh+4/GkRzEIPJ0e8+KmBhZQGOEejSxHZxCC2hpUnhnpVyx/hPa1/50Mz4yHgrnHYcmW4DtYP4DAqA77Jy28qBckmPCrRqvrtWMnYsRi/ElA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AwANxbe9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AwANxbe9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE7BA1F00A3A;
	Mon, 17 Aug 2026 14:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975788;
	bh=dgu8FLZS5rrei8vT/5z52WnRdEaIljF6ka6J1zRGROA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AwANxbe9BbCOdgPe29RTbte4X+vvZLqeh/3FHvto7Mw93JaqKa5622bnLee927J8Y
	 UYplxo+SCJX78BCdDvHFT1pnFHyzJBnTR8bQcZoccYnhBZUw5nfzS5AX78WH2Lvpq/
	 2CkCzBUxdHBc1fXmRmpyeLJerYm2YVkc/mPMTKwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 5.10 147/389] exec: fix unsigned loop counter wrap in transfer_args_to_stack()
Date: Mon, 17 Aug 2026 15:29:46 +0200
Message-ID: <20260817132544.906518276@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

commit 16cc4f5c1c4b9e45eca7f7deefa5410a292db599 upstream.

The stop value is derived from bprm->p >> PAGE_SHIFT. The index variable
is an unsigned long. If bprm->p drops below PAGE_SIZE and stop becomes
zero the loop condition index >= stop is always true.

After the index == 0 iteration the decrement wraps to ULONG_MAX and
bprm->page[ULONG_MAX] reads sizeof(void *) bytes in front of the array.
The pointer has wrapped to -1. That garbage pointer is then passed to
kmap_local_page() and PAGE_SIZE bytes are copied from wherever that
lands into the stack of the process being created. And the loop doesn't
terminate either...

Getting there only requires bprm->p < PAGE_SIZE. On !MMU
bprm_set_stack_limit() and bprm_hit_stack_limit() are empty. So the only
constraint on how far bprm->p is pushed down is valid_arg_len(), i.e.
that each individual string still fits in what is left.

bprm->p starts at PAGE_SIZE * MAX_ARG_PAGES - sizeof(void *) so a
single argument or environment string of a little over 31 pages leaves
it in the first page:

  Oops - load access fault [#1]
  CPU: 0 UID: 0 PID: 1 Comm: victim Not tainted 7.2.0-rc4 #1
  epc : __memcpy+0xd4/0xf8
   ra : transfer_args_to_stack+0xaa/0xae
   s4 : ffffffffffffffff   s2 : 0000000000000000
   a1 : ffffffdc98000000   a2 : 0000000000001000
  status: 0000000a00001880 badaddr: ffffffdc98000000 cause: 0000000000000005
  [<801a5324>] __memcpy+0xd4/0xf8
  [<800d5f6a>] load_flat_binary+0x43a/0x65e
  [<800a2de4>] bprm_execve+0x1d4/0x316
  [<800a351a>] do_execveat_common+0x12e/0x138
  [<800a3d44>] __riscv_sys_execve+0x38/0x4e
  Kernel panic - not syncing: Fatal exception in interrupt

This is an arcane bug but we should still fix it.

Count down from MAX_ARG_PAGES so the loop ends when index reaches stop,
stop == 0 included. The iterations performed are unchanged for every
other value of stop.

Only CONFIG_MMU=n builds are affected, transfer_args_to_stack() is used
by binfmt_flat and binfmt_elf_fdpic on nommu only.

The loop predates git history. commit 7e7ec6a93434
("elf_fdpic_transfer_args_to_stack(): make it generic") only moved it
from binfmt_elf_fdpic.c into fs/exec.c and narrowed the copy to the used
part of the first page. The condition and the decrement are unchanged
from 2.6.12-rc2.

Link: https://patch.msgid.link/20260721-hochachtung-staumauer-pigmente-15d71f7d7d04@brauner
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exec.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/exec.c
+++ b/fs/exec.c
@@ -876,7 +876,7 @@ int transfer_args_to_stack(struct linux_
 	stop = bprm->p >> PAGE_SHIFT;
 	sp = *sp_location;
 
-	for (index = MAX_ARG_PAGES - 1; index >= stop; index--) {
+	for (index = MAX_ARG_PAGES; index-- > stop; ) {
 		unsigned int offset = index == stop ? bprm->p & ~PAGE_MASK : 0;
 		char *src = kmap(bprm->page[index]) + offset;
 		sp -= PAGE_SIZE - offset;


