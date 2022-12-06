Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73081180
	for <patches@lists.linux.dev>; Tue,  6 Dec 2022 00:16:26 +0000 (UTC)
Received: by mail-pj1-f43.google.com with SMTP id q17-20020a17090aa01100b002194cba32e9so16484013pjp.1
        for <patches@lists.linux.dev>; Mon, 05 Dec 2022 16:16:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m0MaHRRiqHIESS4RVFnR6xMW+UY9asEzeHWMqoFz84s=;
        b=RIpE3NyGcARnWYcRj4bwZYE7KpnzVzhZAG+qcWvD/jwMkPbcboDs3SQEPdUY/g0Ri6
         BI0rP7Aznv7nG7eZ4ag25ya8XISq5m0z0s0lq6cGN4rSTGjYrIODpJ5n8rcw+c6P8JRN
         B0K2mfz7VVgwAkSLCuoAZw7dbA3rJecVyX0cU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m0MaHRRiqHIESS4RVFnR6xMW+UY9asEzeHWMqoFz84s=;
        b=My8vXbVrfGKemqxewhQlQuzz/MLBYAff1ScF+HU6GKZGNK+ogWu0oTf0pALCQzLTJX
         Lge1H0NuOR/30OyypVsF/mACdyCHX89gyywKS33tm4RTuF8xJFizbFAWrkHYSoddB0/1
         Lm61EFKz4kzBnxLTyNI5TtTlpv4TDU7BJVWbf51VqsYHDe8b0Uu+QD/IMvUMpCRYMmkE
         KUBy+C2IxYuMxJQPzfUWWpfN2ktC0OP3mKA51XJnxy8ZC2PGq32JIoy3XhDE49swdtM3
         I5r5RP5dfEeviZssuO6q+2MrZxZq+jeNud1/zMw8GKP0k2tJ98siajQwyxm/VPrmVbXk
         gvVA==
X-Gm-Message-State: ANoB5pmVqjS02jxz49kNHddWt9JjemXbYpj5IT7zCjczDN5s6FYb1Gho
	fVvWlh92ayQBLQ4OPkjBx5NY1A==
X-Google-Smtp-Source: AA0mqf5TTCbWD9D7sGsaPw7m1v7kOKJUqiRLJ0Y9f2Vfc0df+ZdSBMs/omk302+37+Z8oddO1AxsCA==
X-Received: by 2002:a17:902:a703:b0:187:137c:b2ea with SMTP id w3-20020a170902a70300b00187137cb2eamr67052434plq.52.1670285785755;
        Mon, 05 Dec 2022 16:16:25 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id e8-20020a056a0000c800b0053e38ac0ff4sm3482136pfj.115.2022.12.05.16.16.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 16:16:24 -0800 (PST)
From: Kees Cook <keescook@chromium.org>
To: Tony Luck <tony.luck@intel.com>,
	swboyd@chromium.org,
	anton@enomsg.org,
	ccross@android.com
Cc: Kees Cook <keescook@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	rppt@kernel.org,
	bgeffon@google.com
Subject: Re: [PATCH] pstore: Avoid kcore oops by vmap()ing with VM_IOREMAP
Date: Mon,  5 Dec 2022 16:16:15 -0800
Message-Id: <167028577239.2860027.4300649046470353371.b4-ty@chromium.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221205233136.3420802-1-swboyd@chromium.org>
References: <20221205233136.3420802-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Mon, 5 Dec 2022 15:31:36 -0800, Stephen Boyd wrote:
> An oops can be induced by running 'cat /proc/kcore > /dev/null' on
> devices using pstore with the ram backend because kmap_atomic() assumes
> lowmem pages are accessible with __va().
> 
>  Unable to handle kernel paging request at virtual address ffffff807ff2b000
>  Mem abort info:
>  ESR = 0x96000006
>  EC = 0x25: DABT (current EL), IL = 32 bits
>  SET = 0, FnV = 0
>  EA = 0, S1PTW = 0
>  FSC = 0x06: level 2 translation fault
>  Data abort info:
>  ISV = 0, ISS = 0x00000006
>  CM = 0, WnR = 0
>  swapper pgtable: 4k pages, 39-bit VAs, pgdp=0000000081d87000
>  [ffffff807ff2b000] pgd=180000017fe18003, p4d=180000017fe18003, pud=180000017fe18003, pmd=0000000000000000
>  Internal error: Oops: 96000006 [#1] PREEMPT SMP
>  Modules linked in: dm_integrity
>  CPU: 7 PID: 21179 Comm: perf Not tainted 5.15.67-10882-ge4eb2eb988cd #1 baa443fb8e8477896a370b31a821eb2009f9bfba
>  Hardware name: Google Lazor (rev3 - 8) (DT)
>  pstate: a0400009 (NzCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
>  pc : __memcpy+0x110/0x260
>  lr : vread+0x194/0x294
>  sp : ffffffc013ee39d0
>  x29: ffffffc013ee39f0 x28: 0000000000001000 x27: ffffff807ff2b000
>  x26: 0000000000001000 x25: ffffffc0085a2000 x24: ffffff802d4b3000
>  x23: ffffff80f8a60000 x22: ffffff802d4b3000 x21: ffffffc0085a2000
>  x20: ffffff8080b7bc68 x19: 0000000000001000 x18: 0000000000000000
>  x17: 0000000000000000 x16: 0000000000000000 x15: ffffffd3073f2e60
>  x14: ffffffffad588000 x13: 0000000000000000 x12: 0000000000000001
>  x11: 00000000000001a2 x10: 00680000fff2bf0b x9 : 03fffffff807ff2b
>  x8 : 0000000000000001 x7 : 0000000000000000 x6 : 0000000000000000
>  x5 : ffffff802d4b4000 x4 : ffffff807ff2c000 x3 : ffffffc013ee3a78
>  x2 : 0000000000001000 x1 : ffffff807ff2b000 x0 : ffffff802d4b3000
>  Call trace:
>  __memcpy+0x110/0x260
>  read_kcore+0x584/0x778
>  proc_reg_read+0xb4/0xe4
> 
> [...]

Applied to for-next/pstore, thanks!

[1/1] pstore: Avoid kcore oops by vmap()ing with VM_IOREMAP
      https://git.kernel.org/kees/c/e6b842741b4f

-- 
Kees Cook

