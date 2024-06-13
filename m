Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C017143733;
	Thu, 13 Jun 2024 11:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279287; cv=none; b=hFWsIYeI8IlFLELogKPjM4I/oDwB/qloYJhRJAmZv3yDl0lSEiWTaU9yIK7bYZkYVwO8HTK2qsSlDfshOtcWIsNIW3KmLI3/tau9qALDL5oONhHV2ISNnG0vO5pn8bTf5IaKqVFLcFvWUKpULEqmbMcmWJ64gkKtHajgt+Mukak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279287; c=relaxed/simple;
	bh=9PgRjtLYcDcPGqFeEo3VH0stqOCWYA3XNhfoo/uzG8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QdYApIbU9YwWm/lIKjQhgduixhn/UlTC8kgkzkssB06V3PXz5ZzX4lTGmjsp1Os2id5EHoCaqSh30ewACfzPWDhBYulImY7R0hZsMB5QJ+Vfk0xlfJghz78o1dZ3f/Xon6nWBoB/JSasQ+fUYqAmW00MzpDN0gfcsXLceE0KCfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wnn/VtpL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wnn/VtpL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83EE0C2BBFC;
	Thu, 13 Jun 2024 11:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279286;
	bh=9PgRjtLYcDcPGqFeEo3VH0stqOCWYA3XNhfoo/uzG8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wnn/VtpLGgif9dmKDmiHLe+4BWoVEVw3KhnQd0DWuWjbAIdePUb5WVG87c5HwXIPk
	 Nyk9cFL0HPFfWMvGbbPMdBwrgYLNdajgJ6am0Epmkr2RrMmdR4XDpjl8y1xJzUtO54
	 X5RXmyZ2BkE+kvAtVvHpvVJmBoygYv5bvJoydZY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Teichmann <teichmanntim@outlook.de>,
	Christian Heusel <christian@heusel.eu>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.9 005/157] x86/topology/amd: Evaluate SMT in CPUID leaf 0x8000001e only on family 0x17 and greater
Date: Thu, 13 Jun 2024 13:32:10 +0200
Message-ID: <20240613113227.609089248@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 34bf6bae3286a58762711cfbce2cf74ecd42e1b5 upstream.

The new AMD/HYGON topology parser evaluates the SMT information in CPUID leaf
0x8000001e unconditionally while the original code restricted it to CPUs with
family 0x17 and greater.

This breaks family 0x15 CPUs which advertise that leaf and have a non-zero
value in the SMT section. The machine boots, but the scheduler complains loudly
about the mismatch of the core IDs:

  WARNING: CPU: 1 PID: 0 at kernel/sched/core.c:6482 sched_cpu_starting+0x183/0x250
  WARNING: CPU: 0 PID: 1 at kernel/sched/topology.c:2408 build_sched_domains+0x76b/0x12b0

Add the condition back to cure it.

  [ bp: Make it actually build because grandpa is not concerned with
    trivial stuff. :-P ]

Fixes: f7fb3b2dd92c ("x86/cpu: Provide an AMD/HYGON specific topology parser")
Closes: https://gitlab.archlinux.org/archlinux/packaging/packages/linux/-/issues/56
Reported-by: Tim Teichmann <teichmanntim@outlook.de>
Reported-by: Christian Heusel <christian@heusel.eu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Tested-by: Tim Teichmann <teichmanntim@outlook.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/7skhx6mwe4hxiul64v6azhlxnokheorksqsdbp7qw6g2jduf6c@7b5pvomauugk
Signed-off-by: Christian Heusel <christian@heusel.eu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/topology_amd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/cpu/topology_amd.c
+++ b/arch/x86/kernel/cpu/topology_amd.c
@@ -84,9 +84,9 @@ static bool parse_8000_001e(struct topo_
 
 	/*
 	 * If leaf 0xb is available, then the domain shifts are set
-	 * already and nothing to do here.
+	 * already and nothing to do here. Only valid for family >= 0x17.
 	 */
-	if (!has_0xb) {
+	if (!has_0xb && tscan->c->x86 >= 0x17) {
 		/*
 		 * Leaf 0x80000008 set the CORE domain shift already.
 		 * Update the SMT domain, but do not propagate it.


