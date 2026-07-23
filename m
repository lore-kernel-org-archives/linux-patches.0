Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A1383E95A4;
	Thu, 23 Jul 2026 07:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784792713; cv=none; b=ff3KjbnvKlAKhZXldWUhj+LjdgGiGxieeBXjYs28cXLx7jRXUoNTTHh5wIjDTtyjHNz48RmsycTTgqJeW/MFnuOS8VmhOpwOQvqgS/hUmtTpvLSIeMMhoUA9ETu3ttm1sh6ssqJP7CvqICAAWCvWWWLh3vx6aqwCVQb5T01Thw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784792713; c=relaxed/simple;
	bh=KzYZ0yy4BnRPU6KWTuJOmMFGWc4MtjURc+gGUmJfg+o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WPxLJ8ttBjhO6OLC5sYkk+6w4pXfDP8eCHL9iGGKTmEBJGu/YRa9G/W42OuMQUYIir9u02tgu/p67BSPcfSvvK1DPtKn6YCDgvLjY42/AhAnw8b96dw6GzU9nb65RW0EBZlUCaLbrVMUmEe54LfjevuhPk6nCMzWc+iWG/EA7u4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 651B91F000E9;
	Thu, 23 Jul 2026 07:45:11 +0000 (UTC)
Date: Thu, 23 Jul 2026 09:44:32 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Barry K. Nathan" <barryn@pobox.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Yuan Tan <yuantan098@gmail.com>, Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Zhengchuan Liang <zcliangcn@gmail.com>, Xin Liu <bird@lzu.edu.cn>,
	Huihui Huang <hhhuang@smu.edu.sg>, Ren Wei <n05ec@lzu.edu.cn>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 5.10 137/699] tracing: Prevent out-of-bounds read in glob
 matching
Message-ID: <2026072339-reshuffle-blizzard-42e9@gregkh>
References: <20260721152355.667394603@linuxfoundation.org>
 <20260721152358.800887633@linuxfoundation.org>
 <1d60d21d-ea26-4502-afee-c49c750df1e9@pobox.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1d60d21d-ea26-4502-afee-c49c750df1e9@pobox.com>

On Wed, Jul 22, 2026 at 07:42:14PM -0700, Barry K. Nathan wrote:
> On 7/21/26 8:18 AM, Greg Kroah-Hartman wrote:
> > 5.10-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Huihui Huang<hhhuang@smu.edu.sg>
> > 
> > commit 0a6070839b1ef276d5b05bedfb787743e140fb17 upstream.
> > 
> > String event fields are not necessarily NUL-terminated, so the filter
> > predicate functions (filter_pred_string(), filter_pred_strloc() and
> > filter_pred_strrelloc()) pass the field length to the regex match
> > callbacks, and the length-aware matchers honour it.
> > 
> > regex_match_glob() was the exception: it ignored the length and called
> > glob_match(), which scans the string until it hits a NUL byte. Some
> > string fields are not NUL-terminated. One example is the dynamic char
> > array of the xfs_* namespace tracepoints, which is copied without a
> > trailing NUL. For such a field, glob matching reads past the end of
> > the event field, causing a KASAN slab-out-of-bounds read in
> > glob_match(), reached via regex_match_glob() and filter_match_preds()
> > from the xfs_lookup tracepoint.
> > 
> > Add a length-bounded glob_match_len() and use it from regex_match_glob()
> > so glob matching always stops at the field boundary. The matching loop
> > is factored into a shared helper so glob_match() keeps its behaviour.
> > 
> > Fixes: 60f1d5e3bac4 ("ftrace: Support full glob matching")
> > Cc:stable@vger.kernel.org
> > Link:https://patch.msgid.link/da1aaf125fc3b63320b0c540fd6afa7c3d5b4f1a.1782836943.git.hhhuang@smu.edu.sg
> > Reported-by: Yuan Tan<yuantan098@gmail.com>
> > Reported-by: Yifan Wu<yifanwucs@gmail.com>
> > Reported-by: Juefei Pu<tomapufckgml@gmail.com>
> > Reported-by: Zhengchuan Liang<zcliangcn@gmail.com>
> > Reported-by: Xin Liu<bird@lzu.edu.cn>
> > Assisted-by: Codex:GPT-5.4
> > Signed-off-by: Huihui Huang<hhhuang@smu.edu.sg>
> > Signed-off-by: Ren Wei<n05ec@lzu.edu.cn>
> > Acked-by: Masami Hiramatsu (Google)<mhiramat@kernel.org>
> > Signed-off-by: Steven Rostedt<rostedt@goodmis.org>
> > Signed-off-by: Greg Kroah-Hartman<gregkh@linuxfoundation.org>
> 
> 5.10.261-rc2 does not build for me (nor does -rc1):
> 
> ...
>   LD      vmlinux.o
>   MODPOST vmlinux.symvers
>   MODINFO modules.builtin.modinfo
>   GEN     modules.builtin
>   LD      .tmp_vmlinux.btf
>   BTF     .btf.vmlinux.bin.o
>   LD      .tmp_vmlinux.kallsyms1
>   KSYMS   .tmp_vmlinux.kallsyms1.S
>   AS      .tmp_vmlinux.kallsyms1.o
>   LD      .tmp_vmlinux.kallsyms2
>   KSYMS   .tmp_vmlinux.kallsyms2.S
>   AS      .tmp_vmlinux.kallsyms2.o
>   LD      vmlinux
>   BTFIDS  vmlinux
> FAILED unresolved symbol filp_close
> make: *** [Makefile:1228: vmlinux] Error 255
> 
> I bisected it, and this patch is the culprit. Reverting it fixes the
> build for me.
> 
> This is happening on fully updated Debian 13 trixie, compiling with
> gcc 14.2.0-19. The kernel is being built for an amd64 target. This
> failure happens whether building natively on amd64 or doing a
> cross-compile on an arm64 build system.
> 
> For what it's worth, 5.15.212-rc2, 7.1.4, 7.1.5-rc2, 7.2-rc3, and
> 7.2-rc4 are all unaffected.

This is a much-reported issue that seems very flaky and can not be
reliably triggered.  Try rebuilding from scratch and see if it goes
away.  The archives of the list has more details, it's been showing up
for a while now.

thanks,
greg k-h
