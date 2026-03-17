Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E353A2EF67A
	for <patches@lists.linux.dev>; Tue, 17 Mar 2026 17:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773768012; cv=none; b=o8pRfjZd9CXVF2XgEw82BJX76iMaLnrcI8HgYqESrjPgUYI0MbyQcgTXcjjx6Vr58oN+XC6M1IFCJjaNLlzCINruwYd9LMCD9HhkoJh3D8wkB1kDKscZKvy4UsDPlpbir/a7hCI3KX0Mh0SV7+Cz5KhlT0r0Pbb7T8ed1y/YcJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773768012; c=relaxed/simple;
	bh=gnKs2wrfDyl8RJBMPsUwsgi2N0XQUT1Kl8Z5ISgInzQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BFrHh4qyFVjzm74UYMRPum7Qo5QXguWRZPR0eogoaRTf/e9AA5X4Zs2S2eY9C5qZufwaEG2OEOg3i3hjxLSeI38+07Y/W2rnPtgOyekNKP7ynENZkD3p0dsjqDfCVwtuAPSPRX5qjl44lTigfpJBa+nFGgT92v6idYO9kj7OFEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 285EE1477;
	Tue, 17 Mar 2026 10:20:04 -0700 (PDT)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8CF273F778;
	Tue, 17 Mar 2026 10:20:08 -0700 (PDT)
Message-ID: <371b3d40-55dc-40a2-8f5c-a5f1c1585733@arm.com>
Date: Tue, 17 Mar 2026 17:20:07 +0000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Thunderbird Daily
Subject: Re: [PATCH 10/11] fs/resctrl: Change last_cmd_status custom during
 input parsing
To: Reinette Chatre <reinette.chatre@intel.com>, tony.luck@intel.com,
 james.morse@arm.com, Dave.Martin@arm.com, babu.moger@amd.com, bp@alien8.de,
 tglx@linutronix.de, dave.hansen@linux.intel.com
Cc: x86@kernel.org, hpa@zytor.com, fustini@kernel.org, fenghuay@nvidia.com,
 peternewman@google.com, linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <cover.1772476561.git.reinette.chatre@intel.com>
 <021f736612186e9fd653d107b0642e8c1cf110d2.1772476561.git.reinette.chatre@intel.com>
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <021f736612186e9fd653d107b0642e8c1cf110d2.1772476561.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Reinette,

On 3/2/26 18:46, Reinette Chatre wrote:
> A pattern of usage of last_cmd_status was introduced during its enabling in
> commit
> 
> c377dcfbee80 ("x86/intel_rdt: Add diagnostics when writing the schemata file")
> 
> and since copied throughout resctrl to result in the following custom:
> 
> 	..._write()
> 	{
> 		/* Early parsing of input, exit on failure. */
> 
> 		/* Obtain rdtgroup_mutex */
> 		rdt_last_cmd_clear(); /* Clear last_cmd_status buffer */
> 
> 		/*
> 		 * Act on user command, failures result in detail
> 		 * error message in last_cmd_status buffer via
> 		 * rdt_last_cmd_puts()/rdt_last_cmd_printf().
> 		 */
> 
> 		/* Release rdtgroup_mutex */
> 	}
> 
> If resctrl exits with failure during early parsing of input there are two
> possible scenarios:
>  - The last_cmd_status buffer is empty and a user's read of
>    info/last_cmd_status returns "ok".
>  - The last_cmd_status buffer contains details from an earlier ...write()
>    failure and a user's read of info/last_cmd_status returns this outdated
>    error description.
> 
> Writing to a resctrl file is considered a "resctrl command" and the
> resctrl documentation states the following about the last_cmd_status file:
>    "If the command failed, it will provide more information that can be
>     conveyed in the error returns from file operations."
> Neither of the current scenarios is correct behavior.
> 
> Move early input parsing to be done with rdtgroup_mutex held after the
> last_cmd_status buffer is cleared. Let info/last_cmd_status be accurate
> when an error is encountered during parsing of user command.

This seems useful and the patch looks good to me.

Reviewed-by: Ben Horgan <ben.horgan@arm.com>

Thanks,

Ben


