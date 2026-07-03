Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8BBD2D12EE;
	Fri,  3 Jul 2026 07:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783063367; cv=none; b=BxHKVdny4aoJup7ZPyhxVLi/2F6LB1kmDiJUfKWbTylW0E0lwojsfQardW2ra0Kp18M18FiHm+sooTwgj1+hBmRuNK7/MtsShuSON4A0xcbP4L2NdMvEvqpU3QT363J4NkcfpBd6l69xTAQORZVwFAtJrUH/upSWd6OGzVGvM3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783063367; c=relaxed/simple;
	bh=fD17sJm6qMgQUWbV24VZ4X7GyDfCtcb+3ui89c9fKTg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CvoD6bsbjnwRgjcLjNnGusVaZuliriungir/ADw9Yzsf5CH3Yd4IzbRwfg5zVL4U4c13X8ZkBMd/wgKxceY+BccA1o0EpYSLaueQA8AynidJSoMKzWjHkXqMnxfmtoiQBPYdA5aGLJf/CoVK3Cym+x9Jy1FHfCcVboAVTj/xO38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jj7zGV8+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jj7zGV8+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E59B1F000E9;
	Fri,  3 Jul 2026 07:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783063364;
	bh=KPQ/hqp7+IoeeLRZZ95TzYtVzI5oPezbZfRhfL0DqDA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jj7zGV8+OdxPqGD/EaoMavi8r9h+JO2bSbUjDwaB+KV4jItMKpXFtO2mT5qWn45D3
	 ceENTfE7c4+jdjF6iiJ05HuCPL8+TsE4YIHhXAEILIe8ci8jzOyRvqKE+S8aU0rSVo
	 NOLKa6gvb+rM4FxYTb7hoSQ7rD1aR2Ly2SbRAowk=
Date: Fri, 3 Jul 2026 09:22:54 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: =?utf-8?B?6ZmI5Y2O5omN?= <chenhuacai@loongson.cn>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Guo Ren <guoren@kernel.org>
Subject: Re: [PATCH 6.1 095/129] LoongArch: Report dying CPU to RCU in
 stop_this_cpu()
Message-ID: <2026070318-monotone-mug-74d6@gregkh>
References: <20260702155112.163984240@linuxfoundation.org>
 <20260702155114.109325852@linuxfoundation.org>
 <329cd36.6ac7d.19f25f6d0e3.Coremail.chenhuacai@loongson.cn>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <329cd36.6ac7d.19f25f6d0e3.Coremail.chenhuacai@loongson.cn>

On Fri, Jul 03, 2026 at 11:12:40AM +0800, 陈华才 wrote:
> Hi, Greg,
> 
> 
> > -----原始邮件-----
> > 发件人: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
> > 发送时间:2026-07-03 00:20:14 (星期五)
> > 收件人: stable@vger.kernel.org
> > 抄送: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, patches@lists.linux.dev, "Guo Ren" <guoren@kernel.org>, "Huacai Chen" <chenhuacai@loongson.cn>
> > 主题: [PATCH 6.1 095/129] LoongArch: Report dying CPU to RCU in stop_this_cpu()
> > 
> > 6.1-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Huacai Chen <chenhuacai@loongson.cn>
> > 
> > commit f2539c56c74691e7a88af6372ba2b48c06ed2fe4 upstream.
> > 
> > This is a port of MIPS commit 9f3f3bdc6d9dac1 ("MIPS: smp: report dying
> > CPU to RCU in stop_this_cpu()"). smp_send_stop() parks all secondary
> > CPUs in stop_this_cpu(). And the function marks the CPU offline for the
> > scheduler via set_cpu_online(false) but never informs RCU, so RCU keeps
> > expecting a quiescent state from CPUs that are now spinning forever with
> > interrupts disabled.
> > 
> > As long as nothing waits for an RCU grace period after smp_send_stop()
> > this is harmless, which is why it went unnoticed. However, since commit
> > 91840be8f710370 ("irq_work: Fix use-after-free in irq_work_single() on
> > PREEMPT_RT"), irq_work_sync() calls synchronize_rcu() on architectures
> > without an irq_work self-IPI, i.e. where arch_irq_work_has_interrupt()
> > returns false. Any irq_work_sync() issued in the reboot/shutdown/halt
> > path after smp_send_stop() then blocks on a grace period that can never
> > complete, hanging the reboot:
> > 
> >   WARNING: CPU: 0 PID: 15 at kernel/irq_work.c:144 irq_work_queue_on
> >   ...
> >   rcu: INFO: rcu_sched detected stalls on CPUs/tasks:
> >   rcu: Offline CPU 1 blocking current GP.
> >   rcu: Offline CPU 2 blocking current GP.
> >   rcu: Offline CPU 3 blocking current GP.
> > 
> > This issue needs some hacks to reproduce, and it was not noticed on
> > LoongArch because arch_irq_work_has_interrupt() usually returns true.
> > 
> > Call rcutree_report_cpu_dead() once interrupts are disabled, mirroring
> > the generic CPU-hotplug offline path, so RCU stops waiting on the parked
> > CPUs and grace periods can still complete. LoongArch shuts down all CPUs
> > here without going through the CPU-hotplug mechanism, so this report is
> > not otherwise issued.
> > 
> > Cc: <stable@vger.kernel.org>
> > Fixes: 91840be8f710 ("irq_work: Fix use-after-free in irq_work_single() on PREEMPT_RT")
> > Reviewed-by: Guo Ren <guoren@kernel.org>
> > Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  arch/loongarch/kernel/smp.c |    1 +
> >  1 file changed, 1 insertion(+)
> > 
> > --- a/arch/loongarch/kernel/smp.c
> > +++ b/arch/loongarch/kernel/smp.c
> > @@ -517,6 +517,7 @@ static void stop_this_cpu(void *dummy)
> >  	set_cpu_online(smp_processor_id(), false);
> >  	calculate_cpu_foreign_map();
> >  	local_irq_disable();
> > +	rcutree_report_cpu_dead();
> For 6.1 & 6.6 this should be "rcu_report_dead(smp_processor_id())". If you don't want to modify please just drop this patch, and I will send for them.

Now dropped from those queues.

> 本邮件及其附件含有龙芯中科的商业秘密信息，仅限于发送给上面地址中列出的个人或群组。禁止任何其他人以任何形式使用（包括但不限于全部或部分地泄露、复制或散发）本邮件及其附件中的信息。如果您错收本邮件，请您立即电话或邮件通知发件人并删除本邮件。 
> This email and its attachments contain confidential information from Loongson Technology , which is intended only for the person or entity whose address is listed above. Any use of the information contained herein in any way (including, but not limited to, total or partial disclosure, reproduction or dissemination) by persons other than the intended recipient(s) is prohibited. If you receive this email in error, please notify the sender by phone or email immediately and delete it. 

Watch out for footers like this, normally my email system just deletes
the message as you shouldn't be sending any "confidential" info to me or
a public list.

thanks,

greg k-h
