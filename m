Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9EB438CFE7;
	Wed,  2 Sep 2026 06:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788330594; cv=none; b=DjT7uNkCBnRnxLhpAuj34uBIviUAVlJ8PeFg8gNqwWINIBDiuQIxbUXBq+dhiR821dFE5IT/fnKHOA+9zjKSR7iDNl9OsqdDI+48wsyMtHld5hsmD8lF8Jk1g9ek4OuM0bQ7ffO7LsZgHePGvxsk9ThDvutVM1Tp3RaK1ilafMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788330594; c=relaxed/simple;
	bh=p7pVIHcF+v5InapvcwA0+b1hKrVe6y1L9rtG/3lihNQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dThbchLbx0Cc86pgvyMHS/Hp3SL6sbuMukJcpe27m/nLVi08Lh7iGcF2+vLplM1sBT8rFg+m9bPacGTa+2uP0YypYd/Ep0/Ch9X6+5KSRsyd8BZI6LK9MLkk1MjdYX+euzqhr+EeQoTXGZNKtyZ9JgO2kowfWdAkI57j4nF9fQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z7vuOrhe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z7vuOrhe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA35B1F00A3D;
	Wed,  2 Sep 2026 06:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788330592;
	bh=5QKb53dfppE3ODd0ICOTgThrzRgUoUErwUPy0Ymaocg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Z7vuOrheqSj4RAmGWewuILXngQ9Oc3k4ZggQCCQBklzY9jZ/inWu8COMIWAsjyBeO
	 jbFfjUdMReJXoPghuXvMqnPYr5tl2B0q5S8b+HIfnNo638GtKjIMgYSFov3uYU+hqH
	 plu5T2eLzcm25QEstV0lOhwfiKSXdWS/93HELGcA=
Date: Wed, 2 Sep 2026 08:29:48 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Tengda Wu <wutengda@huaweicloud.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Raushan Patel <raushan.jhon@gmail.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: Re: [PATCH 6.6 095/261] tracing/probes: Reject $arg0 in meta
 argument expansion
Message-ID: <2026090227-clash-peroxide-8872@gregkh>
References: <20260807143415.358597922@linuxfoundation.org>
 <20260807143417.434454264@linuxfoundation.org>
 <7a6417ca-fb4c-40da-8ad1-b9d76a2fa142@huaweicloud.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7a6417ca-fb4c-40da-8ad1-b9d76a2fa142@huaweicloud.com>

On Wed, Sep 02, 2026 at 11:17:24AM +0800, Tengda Wu wrote:
> Hi Greg,
> 
> On 2026/8/7 22:37, Greg Kroah-Hartman wrote:
> > 6.6-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Raushan Patel <raushan.jhon@gmail.com>
> > 
> > commit 00a8ce2a2a9fa17674e1feec4d9105c1a5d6a419 upstream.
> > 
> > traceprobe_expand_meta_args() parses $argN with simple_strtoul() and
> > calls sprint_nth_btf_arg(n - 1, ...). For $arg0, n is 0 so the index is
> > -1. Because ctx->nr_params is signed, the "idx >= nr_params" guard in
> > sprint_nth_btf_arg() does not catch the negative index, and
> > ctx->params[-1].name_off is read out of bounds.
> > 
> > The normal per-argument path (parse_probe_vars()) already rejects
> > $arg0 via its argument-number check, but meta-argument expansion runs
> > before per-argument parsing and substitutes the value first, bypassing
> > that check.
> > 
> > Reject $arg0 explicitly during expansion.
> > 
> > Link: https://lore.kernel.org/all/20260724054435.146279-1-raushan.jhon@gmail.com/
> > 
> > Fixes: 18b1e870a496 ("tracing/probes: Add $arg* meta argument for all function args")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Raushan Patel <raushan.jhon@gmail.com>
> > Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  kernel/trace/trace_probe.c |    6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> > 
> > --- a/kernel/trace/trace_probe.c
> > +++ b/kernel/trace/trace_probe.c
> > @@ -1721,7 +1721,11 @@ const char **traceprobe_expand_meta_args
> >  				ret = -ENOENT;
> >  				goto error;
> >  			}
> > -			/* Note: $argN starts from $arg1 */
> > +			/* Note: $argN starts from $arg1, so $arg0 is invalid. */
> > +			if (n == 0) {
> > +				trace_probe_log_err(0, BAD_ARG_NUM);
> > +				return ERR_PTR(-EINVAL);
> 
> The control flow here is not quite right.
> 
> Returning directly within this branch fails to free the new_argv memory,
> resulting in a memory leak.
> 
> The mainline does not have this issue because the preceding patch
> 4af0532a0f47 ("tracing: Use __free() in trace_probe for cleanup") introduced
> __free to manage the release of new_argv memory. However, due to the extensive
> changes involved, directly cherry-picking that patch does not seem to be that
> straightforward.
> 
> Therefore, it might be more appropriate to simply change it to goto here:

Thanks for the review, can you send a fix-up patch for this as it is
already in a release?

greg k-h
