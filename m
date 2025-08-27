Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ECFB1FF1A1;
	Wed, 27 Aug 2025 03:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756265467; cv=none; b=DzYh9ixJbgB9f14avvMwWrvViuH4Jl0x7J+nupUNmFr+j8BHJSXF9HTbQZooBPuPSrDqgdPRvKlw3XCk5e6qQiMTear0n4iNsNkehLPb6NUW4YDo1Uw48KEgrXK4PguSG+vg5aBnWoOkP7gNdQopDGYqeS127KH+S8LRna/5w1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756265467; c=relaxed/simple;
	bh=e7xVinN1DKv/LfINZQZ99Qeb7FvC2LDy5qAEZGht7s0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ta6DVi0EWqjhR4T8UGS7xUXKhcZ1heDaBurVOo9Qm1LEZz9Y9ET7GUa3AuCktLup3ZfdRBFBn+KJtv6g1PX0WI/znWaUhRisq+DosR6KHlkKI7rX4D3P/skY2x+/uDt4CwKw+4qcY5U9d5e3S87q0ra1oqfPOHAZ2B5hZZKpCic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ReOlTIS4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ReOlTIS4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2110FC4CEEB;
	Wed, 27 Aug 2025 03:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756265467;
	bh=e7xVinN1DKv/LfINZQZ99Qeb7FvC2LDy5qAEZGht7s0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ReOlTIS4pMklpwdQBIe7Tyr2QKilJmSpzeQ0FkTdLiBDXVMwKUJyJCdOkpOyx1pc1
	 GEfnrgPSXHrUKGoeW1g86KZZgRUCteslZ99xPYU+FasTlFkDslCVAo1QA8vUAVV/R8
	 Z9b16xMHBJmCSvbN0HYhGT8MCbDwjVtWEugeOXGTz3bGVy6FperQ+qchp4GhIiOMLh
	 tfg8jYLpu6o1X5wPIX6Qsn65zPJ6Y7Vb6poAACsUpIZWLetFhrWSdo8lYOzY2DmOKO
	 1HM4auazOt3cZUas0zluo89/Sl/MXiqVwEJm8LBGmMusgzlAl2J6iFubvm6zt/JZ0g
	 3MWWJEO2k5V9g==
Date: Tue, 26 Aug 2025 23:31:05 -0400
From: Sasha Levin <sashal@kernel.org>
To: Salvatore Bonaccorso <carnil@debian.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH 6.6 028/587] fs: Prevent file descriptor table
 allocations exceeding INT_MAX
Message-ID: <aK57-fMeclMVck7S@laps>
References: <20250826110952.942403671@linuxfoundation.org>
 <20250826110953.666871765@linuxfoundation.org>
 <aK355BFz6ErdVI7j@eldamar.lan>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <aK355BFz6ErdVI7j@eldamar.lan>

On Tue, Aug 26, 2025 at 08:16:04PM +0200, Salvatore Bonaccorso wrote:
>Hi Greg,
>
>On Tue, Aug 26, 2025 at 01:02:57PM +0200, Greg Kroah-Hartman wrote:
>> 6.6-stable review patch.  If anyone has any objections, please let me know.
>>
>> ------------------
>>
>> From: Sasha Levin <sashal@kernel.org>
>>
>> commit 04a2c4b4511d186b0fce685da21085a5d4acd370 upstream.
>>
>> When sysctl_nr_open is set to a very high value (for example, 1073741816
>> as set by systemd), processes attempting to use file descriptors near
>> the limit can trigger massive memory allocation attempts that exceed
>> INT_MAX, resulting in a WARNING in mm/slub.c:
>>
>>   WARNING: CPU: 0 PID: 44 at mm/slub.c:5027 __kvmalloc_node_noprof+0x21a/0x288
>>
>> This happens because kvmalloc_array() and kvmalloc() check if the
>> requested size exceeds INT_MAX and emit a warning when the allocation is
>> not flagged with __GFP_NOWARN.
>>
>> Specifically, when nr_open is set to 1073741816 (0x3ffffff8) and a
>> process calls dup2(oldfd, 1073741880), the kernel attempts to allocate:
>> - File descriptor array: 1073741880 * 8 bytes = 8,589,935,040 bytes
>> - Multiple bitmaps: ~400MB
>> - Total allocation size: > 8GB (exceeding INT_MAX = 2,147,483,647)
>>
>> Reproducer:
>> 1. Set /proc/sys/fs/nr_open to 1073741816:
>>    # echo 1073741816 > /proc/sys/fs/nr_open
>>
>> 2. Run a program that uses a high file descriptor:
>>    #include <unistd.h>
>>    #include <sys/resource.h>
>>
>>    int main() {
>>        struct rlimit rlim = {1073741824, 1073741824};
>>        setrlimit(RLIMIT_NOFILE, &rlim);
>>        dup2(2, 1073741880);  // Triggers the warning
>>        return 0;
>>    }
>>
>> 3. Observe WARNING in dmesg at mm/slub.c:5027
>>
>> systemd commit a8b627a introduced automatic bumping of fs.nr_open to the
>> maximum possible value. The rationale was that systems with memory
>> control groups (memcg) no longer need separate file descriptor limits
>> since memory is properly accounted. However, this change overlooked
>> that:
>>
>> 1. The kernel's allocation functions still enforce INT_MAX as a maximum
>>    size regardless of memcg accounting
>> 2. Programs and tests that legitimately test file descriptor limits can
>>    inadvertently trigger massive allocations
>> 3. The resulting allocations (>8GB) are impractical and will always fail
>>
>> systemd's algorithm starts with INT_MAX and keeps halving the value
>> until the kernel accepts it. On most systems, this results in nr_open
>> being set to 1073741816 (0x3ffffff8), which is just under 1GB of file
>> descriptors.
>>
>> While processes rarely use file descriptors near this limit in normal
>> operation, certain selftests (like
>> tools/testing/selftests/core/unshare_test.c) and programs that test file
>> descriptor limits can trigger this issue.
>>
>> Fix this by adding a check in alloc_fdtable() to ensure the requested
>> allocation size does not exceed INT_MAX. This causes the operation to
>> fail with -EMFILE instead of triggering a kernel warning and avoids the
>> impractical >8GB memory allocation request.
>>
>> Fixes: 9cfe015aa424 ("get rid of NR_OPEN and introduce a sysctl_nr_open")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> Link: https://lore.kernel.org/20250629074021.1038845-1-sashal@kernel.org
>> Signed-off-by: Christian Brauner <brauner@kernel.org>
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> ---
>>  fs/file.c |   15 +++++++++++++++
>>  1 file changed, 15 insertions(+)
>>
>> --- a/fs/file.c
>> +++ b/fs/file.c
>> @@ -126,6 +126,21 @@ static struct fdtable * alloc_fdtable(un
>>  	if (unlikely(nr > sysctl_nr_open))
>>  		nr = ((sysctl_nr_open - 1) | (BITS_PER_LONG - 1)) + 1;
>>
>> +	/*
>> +	 * Check if the allocation size would exceed INT_MAX. kvmalloc_array()
>> +	 * and kvmalloc() will warn if the allocation size is greater than
>> +	 * INT_MAX, as filp_cachep objects are not __GFP_NOWARN.
>> +	 *
>> +	 * This can happen when sysctl_nr_open is set to a very high value and
>> +	 * a process tries to use a file descriptor near that limit. For example,
>> +	 * if sysctl_nr_open is set to 1073741816 (0x3ffffff8) - which is what
>> +	 * systemd typically sets it to - then trying to use a file descriptor
>> +	 * close to that value will require allocating a file descriptor table
>> +	 * that exceeds 8GB in size.
>> +	 */
>> +	if (unlikely(nr > INT_MAX / sizeof(struct file *)))
>> +		return ERR_PTR(-EMFILE);
>> +
>>  	fdt = kmalloc(sizeof(struct fdtable), GFP_KERNEL_ACCOUNT);
>>  	if (!fdt)
>>  		goto out;
>
>I see you picked this commit for the current stable series, but TTBOMK
>this introduces a regression as it was as well present in 6.12.43:
>
>https://lore.kernel.org/regressions/20250825152725.43133-1-zcgao@amazon.com/
>
>and the current 6.12.44 contains a followup. If I'm not mistaken Sasha
>has picked up 1d3b4bec3ce5 ("alloc_fdtable(): change calling
>conventions.") to fix that.
>
>So unless I'm wrong, if you pick up 04a2c4b4511d ("fs: Prevent file
>descriptor table allocations exceeding INT_MAX"), then as well
>1d3b4bec3ce5 ("alloc_fdtable(): change calling conventions.")  is
>needed.

I've just queued it up for the rest of the trees too, thanks!

-- 
Thanks,
Sasha
