Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABDA33D332C;
	Wed, 18 Mar 2026 11:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773834819; cv=none; b=uUcjO3qdZ9VnIvyrEpePx4tPjG42p7K3XbkFeo79upZ3fhqm+FB01JCGVhuDGLAfLj3rnrIWVrCn/Ovav3qpXyAHJQkCpSUWdNpmfxi5JCcoxRaWGLpMNvnGJk7Ts61xzSkOyQUqmeXKqUi+ql6hQc8Vl0RJNaYVviN2A20n9+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773834819; c=relaxed/simple;
	bh=z//2kPC9Rz51VaoDeS63jWuS/mqaaZ9jj7sDJMlZ5VM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EHtrDG/Vxax8yxmBJf6SLp4xJumArPSi5WhS5mudueTFmkJl4LJ06BUk9evjESy66C9h5hDbXWUNQYW2YnxYyfL6gFIzyAI/CncUBx5nZ/J2Mmtn5uHgd1es2vFp4dB6onYuFmKEkMDcXjbS3Prjba3HQiEej1qxJ7nS2bC8YGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EHZIdvYq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EHZIdvYq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF293C19421;
	Wed, 18 Mar 2026 11:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773834819;
	bh=z//2kPC9Rz51VaoDeS63jWuS/mqaaZ9jj7sDJMlZ5VM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EHZIdvYqUuLjJBEt0+LsU7GmeM9n814GDE0+Joxhd/jzMT+73QrjO++QgF/NGesvb
	 B0Y957gpP1BIymys+l7wJFLVPcJIn8AfyLXpq5dd1XnfE/dudzbjdXdXclEzT66pE7
	 IPNigswsbojdrxYVV/Wj+4jyShP9PY3HGpT1R4II=
Date: Wed, 18 Mar 2026 12:53:36 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Wentao Guan <guanwentao@uniontech.com>
Cc: brauner@kernel.org, broonie@kernel.org, davidgow@google.com,
	gtucker@gtucker.io, patches@lists.linux.dev, stable@vger.kernel.org
Subject: Re: kthread: consolidate kthread exit paths to prevent use-after-free
Message-ID: <2026031827-pruning-spindle-74fb@gregkh>
References: <20260317163006.067634764@linuxfoundation.org>
 <20260317175812.707723-1-guanwentao@uniontech.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317175812.707723-1-guanwentao@uniontech.com>

On Wed, Mar 18, 2026 at 01:58:12AM +0800, Wentao Guan wrote:
> Hello,
> 
> I want you know that need backport ("bpf: drop kthread_exit from noreturn_deny"),
> which commit 7fe44c4388146bdbb3c5932d81a26d9fa0fd3ec9 upstream,
> or will met "WARN: resolve_btfids: unresolved symbol kthread_exit" to cause build fail,
> I test v6.18.19-rc1 with the patch build ok for me.
> 
> BRs
> Wentao Guan
> 
> Log:
>  AR      drivers/gpu/built-in.a
>   AR      drivers/built-in.a
>   AR      built-in.a
>   AR      vmlinux.a
>   LD      vmlinux.o
>   GEN     .vmlinux.objs
>   MODPOST Module.symvers
>   CC      .vmlinux.export.o
>   UPD     include/generated/utsversion.h
>   CC      init/version-timestamp.o
>   KSYMS   .tmp_vmlinux0.kallsyms.S
>   AS      .tmp_vmlinux0.kallsyms.o
>   LD      .tmp_vmlinux1
>   BTF     .tmp_vmlinux1.btf.o
>   NM      .tmp_vmlinux1.syms
>   KSYMS   .tmp_vmlinux1.kallsyms.S
>   AS      .tmp_vmlinux1.kallsyms.o
>   LD      .tmp_vmlinux2
>   NM      .tmp_vmlinux2.syms
>   KSYMS   .tmp_vmlinux2.kallsyms.S
>   AS      .tmp_vmlinux2.kallsyms.o
>   LD      vmlinux.unstripped
>   BTFIDS  vmlinux.unstripped
> WARN: resolve_btfids: unresolved symbol kthread_exit

Thanks, I've now queued this up.

greg k-h
