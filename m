Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06E6E811
	for <patches@lists.linux.dev>; Fri,  6 May 2022 13:30:32 +0000 (UTC)
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1651843830;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wZT4vpKjh29qyIrnPoc3fuhpC7Rcupj4xp4jJbaitm0=;
	b=lyxMJI1c7/bjcUC/0uaoPfrBDisjmcy1aRbtVcCUe6jpvyqZHJ+GJQrLENoe/pP6ncW2c7
	Kc4G8e56XxkYdHFGvIkaVRECgrnS4YpoTsGvQralepmfGpDBMEwpd8xCqjfIUFJsbRXKTk
	4yOrW/Dx9bRWOesgwhTLoiJ8fD6AYpm1QwwYbjBzN/EN4sfzqbcr5NaKkfUKFMCuPYB16P
	P6Sxwp8Bh9bali6WmcfkHJxKIrmURPZKmrYQPhX/TFRdI0q5EdI01y9PQAr9KyF5N72wIy
	5KOACG4W6wOSeJzT3gfwX3CDcPgYifckyM8ppFWWQKqxcP6un1C1lSYwOyrEYw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1651843830;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wZT4vpKjh29qyIrnPoc3fuhpC7Rcupj4xp4jJbaitm0=;
	b=y14yn9YwzJ+hhYfkB0MjQdCOMV74S1yrsUYx4GjRmexAl8grOu5L+7DELCDn8g4FMCqTGw
	AREyL5xsCBUtO3Ag==
To: Tony Luck <tony.luck@intel.com>, hdegoede@redhat.com, markgross@kernel.org
Cc: mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
 x86@kernel.org, hpa@zytor.com, corbet@lwn.net, gregkh@linuxfoundation.org,
 andriy.shevchenko@linux.intel.com, jithu.joseph@intel.com,
 ashok.raj@intel.com, tony.luck@intel.com, rostedt@goodmis.org,
 dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, platform-driver-x86@vger.kernel.org,
 patches@lists.linux.dev, ravi.v.shankar@intel.com
Subject: Re: [PATCH v6 08/11] platform/x86/intel/ifs: Add scan test support
In-Reply-To: <20220506014035.1173578-9-tony.luck@intel.com>
References: <20220428153849.295779-1-tony.luck@intel.com>
 <20220506014035.1173578-1-tony.luck@intel.com>
 <20220506014035.1173578-9-tony.luck@intel.com>
Date: Fri, 06 May 2022 15:30:30 +0200
Message-ID: <87r156hjpl.ffs@tglx>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

On Thu, May 05 2022 at 18:40, Tony Luck wrote:
> +/*
> + * Note all code and data in this file is protected by
> + * ifs_sem. On HT systems all threads on a core will
> + * execute together, but only the first thread on the
> + * core will update results of the test.
> + */
> +struct workqueue_struct *ifs_wq;

Seems to be unused.

> +static bool oscan_enabled = true;

What changes this?

> +static void message_not_tested(struct device *dev, int cpu, union ifs_status status)
> +{
> +	if (status.error_code < ARRAY_SIZE(scan_test_status))

Please add curly brackets as these are not one-line statements.

> +		dev_info(dev, "CPU(s) %*pbl: SCAN operation did not start. %s\n",
> +			 cpumask_pr_args(topology_sibling_cpumask(cpu)),
> +			 scan_test_status[status.error_code]);
> +/*
> + * Execute the scan. Called "simultaneously" on all threads of a core
> + * at high priority using the stop_cpus mechanism.
> + */
> +static int doscan(void *data)
> +{
> +	int cpu = smp_processor_id();
> +	u64 *msrs = data;
> +	int first;
> +
> +	/* Only the first logical CPU on a core reports result */
> +	first = cpumask_first(topology_sibling_cpumask(cpu));

Shouldn't that be cpu_smt_mask()?

> +	/*
> +	 * This WRMSR will wait for other HT threads to also write
> +	 * to this MSR (at most for activate.delay cycles). Then it
> +	 * starts scan of each requested chunk. The core scan happens
> +	 * during the "execution" of the WRMSR. This instruction can
> +	 * take up to 200 milliseconds before it retires.

200ms per test chunk?

> +	 */
> +	wrmsrl(MSR_ACTIVATE_SCAN, msrs[0]);
> +

> +	while (activate.start <= activate.stop) {
> +		if (time_after(jiffies, timeout)) {
> +			status.error_code = IFS_SW_TIMEOUT;
> +			break;
> +		}
> +
> +		msrvals[0] = activate.data;
> +		stop_core_cpuslocked(cpu, doscan, msrvals);
> +
> +		status.data = msrvals[1];
> +
> +		/* Some cases can be retried, give up for others */
> +		if (!can_restart(status))
> +			break;
> +
> +		if (status.chunk_num == activate.start) {
> +			/* Check for forward progress */
> +			if (retries-- == 0) {
> +				if (status.error_code == IFS_NO_ERROR)
> +					status.error_code = IFS_SW_PARTIAL_COMPLETION;
> +				break;
> +			}
> +		} else {
> +			retries = MAX_IFS_RETRIES;
> +			activate.start = status.chunk_num;
> +		}
> +	}

Looks way better now.

> +}
> +/*
> + * Initiate per core test. It wakes up work queue threads on the target cpu and
> + * its sibling cpu. Once all sibling threads wake up, the scan test gets executed and
> + * wait for all sibling threads to finish the scan test.
> + */
> +int do_core_test(int cpu, struct device *dev)
> +{
> +	int ret = 0;
> +
> +	if (!scan_enabled)
> +		return -ENXIO;
> +
> +	/* Prevent CPUs from being taken offline during the scan test */
> +	cpus_read_lock();
> +
> +	if (!cpu_online(cpu)) {
> +		dev_info(dev, "cannot test on the offline cpu %d\n", cpu);
> +		ret = -EINVAL;
> +		goto out;
> +	}

Coming back to my points from the previous round:

1) How is that supposed to work on a system which has HT enabled in BIOS,
   but disabled on the kernel command line or via /sys/..../smt/control or
   when a HT sibling is offlined temporarily?

   I assume it cannot work, but I can't see anything which handles those
   cases.

2) That documentation for the admin/user got eaten by the gremlins in
   the intertubes again.

Thanks,

        tglx
