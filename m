Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AAC02E823
	for <patches@lists.linux.dev>; Fri, 24 Nov 2023 22:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="Mso0afI9";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="ewopmSy5"
Date: Fri, 24 Nov 2023 23:39:56 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1700865600;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kUrKdYFYADHNMxpI0A1WZIbi+Sra6cC8W80+iBugDHw=;
	b=Mso0afI97ObwKe2SEKnUanWtKL0SooQ4nqCNsBE5jHL0ZjRLw/vaOao3IPyNc49czoF/bC
	kSmUTwKXIyx01ToU+UXIV2M2gzBZNHRjsFzLYS5386aqSTnJvL37XgBX7gQUTltoAyFJ5G
	C06NpqCyxvElxXTtPsK2OPHE9jXR6+ZZFU4nj0pBg1wZFRmoTywvQXxj5l5sEA3sJeNElP
	RSbmm9Y2HwSB5cMW5YitnXBU1yj/+14UbWrJUenW8PxQdoe65HXqhVAJxnwRQLQeq1hMRC
	n0JsoAlu2pnmGyr+2tw9YkS7WV/9Ucc4IkSp81kAZyGVwpysVa8u3SdHuwqv7A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1700865600;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kUrKdYFYADHNMxpI0A1WZIbi+Sra6cC8W80+iBugDHw=;
	b=ewopmSy5sjZ8GO+egKBblpaTkSdOFcN/lQvpEg5HOfv5fLCeC1gysU2FGt/pgifvwj54Jn
	1U40KkQmZzm+tfAQ==
From: Nam Cao <namcao@linutronix.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: Re: [PATCH 6.1 162/372] drivers: perf: Check find_first_bit() return
 value
Message-ID: <20231124223956.d-69n35w@linutronix.de>
References: <20231124172010.413667921@linuxfoundation.org>
 <20231124172015.883008311@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231124172015.883008311@linuxfoundation.org>

On Fri, Nov 24, 2023 at 05:49:09PM +0000, Greg Kroah-Hartman wrote:
> 6.1-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Alexandre Ghiti <alexghiti@rivosinc.com>
> 
> commit c6e316ac05532febb0c966fa9b55f5258ed037be upstream.
> 
> We must check the return value of find_first_bit() before using the
> return value as an index array since it happens to overflow the array
> and then panic:
> 
> [  107.318430] Kernel BUG [#1]
> [  107.319434] CPU: 3 PID: 1238 Comm: kill Tainted: G            E      6.6.0-rc6ubuntu-defconfig #2
> [  107.319465] Hardware name: riscv-virtio,qemu (DT)
> [  107.319551] epc : pmu_sbi_ovf_handler+0x3a4/0x3ae
> [  107.319840]  ra : pmu_sbi_ovf_handler+0x52/0x3ae
> [  107.319868] epc : ffffffff80a0a77c ra : ffffffff80a0a42a sp : ffffaf83fecda350
> [  107.319884]  gp : ffffffff823961a8 tp : ffffaf8083db1dc0 t0 : ffffaf83fecda480
> [  107.319899]  t1 : ffffffff80cafe62 t2 : 000000000000ff00 s0 : ffffaf83fecda520
> [  107.319921]  s1 : ffffaf83fecda380 a0 : 00000018fca29df0 a1 : ffffffffffffffff
> [  107.319936]  a2 : 0000000001073734 a3 : 0000000000000004 a4 : 0000000000000000
> [  107.319951]  a5 : 0000000000000040 a6 : 000000001d1c8774 a7 : 0000000000504d55
> [  107.319965]  s2 : ffffffff82451f10 s3 : ffffffff82724e70 s4 : 000000000000003f
> [  107.319980]  s5 : 0000000000000011 s6 : ffffaf8083db27c0 s7 : 0000000000000000
> [  107.319995]  s8 : 0000000000000001 s9 : 00007fffb45d6558 s10: 00007fffb45d81a0
> [  107.320009]  s11: ffffaf7ffff60000 t3 : 0000000000000004 t4 : 0000000000000000
> [  107.320023]  t5 : ffffaf7f80000000 t6 : ffffaf8000000000
> [  107.320037] status: 0000000200000100 badaddr: 0000000000000000 cause: 0000000000000003
> [  107.320081] [<ffffffff80a0a77c>] pmu_sbi_ovf_handler+0x3a4/0x3ae
> [  107.320112] [<ffffffff800b42d0>] handle_percpu_devid_irq+0x9e/0x1a0
> [  107.320131] [<ffffffff800ad92c>] generic_handle_domain_irq+0x28/0x36
> [  107.320148] [<ffffffff8065f9f8>] riscv_intc_irq+0x36/0x4e
> [  107.320166] [<ffffffff80caf4a0>] handle_riscv_irq+0x54/0x86
> [  107.320189] [<ffffffff80cb0036>] do_irq+0x64/0x96
> [  107.320271] Code: 85a6 855e b097 ff7f 80e7 9220 b709 9002 4501 bbd9 (9002) 6097
> [  107.320585] ---[ end trace 0000000000000000 ]---
> [  107.320704] Kernel panic - not syncing: Fatal exception in interrupt
> [  107.320775] SMP: stopping secondary CPUs
> [  107.321219] Kernel Offset: 0x0 from 0xffffffff80000000
> [  107.333051] ---[ end Kernel panic - not syncing: Fatal exception in interrupt ]---
> 
> Fixes: 4905ec2fb7e6 ("RISC-V: Add sscofpmf extension support")
> Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
> Link: https://lore.kernel.org/r/20231109082128.40777-1-alexghiti@rivosinc.com
> Cc: stable@vger.kernel.org
> Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This patch causes build failure with riscv64 defconfig, as reported in:
https://lore.kernel.org/stable/20231124222543.qaM-plhi@linutronix.de/

Reverting this, and everything build and boot fine (qemu riscv64)

Best regards,
Nam
