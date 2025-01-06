Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E1341ADFE3;
	Mon,  6 Jan 2025 15:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178082; cv=none; b=jilkJRL0Mjp4ejBv1+VLJaPwv2ATucYmVM0JlQs6RQqsucdTAeQtvCXXnXZfhThg+cSzM53skTplQO7r65InpPHjXrQPyee8OtC5stxtJd2m+aCauGZKVt4BSvhtQEZwLucoLSyCpojiDAmL+5eA4m7V0/7X50QPrUXdAFfezxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178082; c=relaxed/simple;
	bh=rBB4ffMLEdnILfBffsHlDM22aDV3TXFUT48X3s0AEiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u+qx3Ux4gHREoPRJvF3N9z+35OMptfuOd3vstoTR3Bw8acOk0I+Cq4hzNThReJ+SgcirU+PbjLyBeRUEgCL4ffOiILeuellNiNviUvef+gFK6UdFJLZWdTN2qlGIIoE4eD5yCDW1LI5BETDj3dHgFqRszLhKxgHp5XulfeDBMeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dsaGcskH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dsaGcskH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93E7FC4CED2;
	Mon,  6 Jan 2025 15:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178082;
	bh=rBB4ffMLEdnILfBffsHlDM22aDV3TXFUT48X3s0AEiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dsaGcskH59DrU90FtI/bLj4/tUTFa3cEySk1HMu1zN9RH0OPYARGoRJOgSJc7Cbyz
	 ut4bXPwYhjuSj4RaPfuubVfJPTE4qk5tGZUVzdMqCjfbmt69Ej/1xjX7YpgtF7hawb
	 bpA76fc7DTuiK2OhgaEH7xTzlHEtViN4B/CrEvl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Ihor Solodrai <ihor.solodrai@pm.me>
Subject: [PATCH 6.12 124/156] sched_ext: Fix invalid irq restore in scx_ops_bypass()
Date: Mon,  6 Jan 2025 16:16:50 +0100
Message-ID: <20250106151146.401182127@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 18b2093f4598d8ee67a8153badc93f0fa7686b8a upstream.

While adding outer irqsave/restore locking, 0e7ffff1b811 ("scx: Fix raciness
in scx_ops_bypass()") forgot to convert an inner rq_unlock_irqrestore() to
rq_unlock() which could re-enable IRQ prematurely leading to the following
warning:

  raw_local_irq_restore() called with IRQs enabled
  WARNING: CPU: 1 PID: 96 at kernel/locking/irqflag-debug.c:10 warn_bogus_irq_restore+0x30/0x40
  ...
  Sched_ext: create_dsq (enabling)
  pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
  pc : warn_bogus_irq_restore+0x30/0x40
  lr : warn_bogus_irq_restore+0x30/0x40
  ...
  Call trace:
   warn_bogus_irq_restore+0x30/0x40 (P)
   warn_bogus_irq_restore+0x30/0x40 (L)
   scx_ops_bypass+0x224/0x3b8
   scx_ops_enable.isra.0+0x2c8/0xaa8
   bpf_scx_reg+0x18/0x30
  ...
  irq event stamp: 33739
  hardirqs last  enabled at (33739): [<ffff8000800b699c>] scx_ops_bypass+0x174/0x3b8
  hardirqs last disabled at (33738): [<ffff800080d48ad4>] _raw_spin_lock_irqsave+0xb4/0xd8

Drop the stray _irqrestore().

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Ihor Solodrai <ihor.solodrai@pm.me>
Link: http://lkml.kernel.org/r/qC39k3UsonrBYD_SmuxHnZIQLsuuccoCrkiqb_BT7DvH945A1_LZwE4g-5Pu9FcCtqZt4lY1HhIPi0homRuNWxkgo1rgP3bkxa0donw8kV4=@pm.me
Fixes: 0e7ffff1b811 ("scx: Fix raciness in scx_ops_bypass()")
Cc: stable@vger.kernel.org # v6.12
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -4367,7 +4367,7 @@ static void scx_ops_bypass(bool bypass)
 		 * sees scx_rq_bypassing() before moving tasks to SCX.
 		 */
 		if (!scx_enabled()) {
-			rq_unlock_irqrestore(rq, &rf);
+			rq_unlock(rq, &rf);
 			continue;
 		}
 


