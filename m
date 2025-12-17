Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28236339701;
	Wed, 17 Dec 2025 15:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765985051; cv=none; b=DveICrDdEyzA7iIpm4mt+HTztGfdXyNQXAHZpW9Vdo9DQz/6kQqGUGEFbwyW7IDVrY3KHqp9raqiSVljxmB3VTJbPI0B6+tFHDElxVS2dSlhmjTElMV3WTSGEYWshIUJATj+cU4oryuHhYSXQKdiTQD4iZICi31LjF+ZcEOWkP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765985051; c=relaxed/simple;
	bh=optZ3FgMsY63sd4mZYgFdkTLgZVEYpWxOlXpKN3Haqo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RgNAGzw8D8t2oUmsJyAV8zew8jmZXyPydiqRD7BaZ+MrN9qaQ2lqbzolPn64t/t9yvHk2GYiTDeDPc8p+ZwuevLWrRzZmRQ8ZYyVJd2pkyWJ3M2bReKmVEUXsIF2y/uZqoJ6Hd21fTeGjzisOM66yerBGp494QmxHuTD1fBgbYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OnOVTaYR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OnOVTaYR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A362C4CEF5;
	Wed, 17 Dec 2025 15:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765985050;
	bh=optZ3FgMsY63sd4mZYgFdkTLgZVEYpWxOlXpKN3Haqo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OnOVTaYRCNCql5++Nj13Ih8ne9IWeujuNZ2YhohjPpieQTHed6/7TTaIq8Lou53NG
	 EOrFZuW0by1H/wXAlOJfnA9GlenxgdARVIEHtAgkjhg8LrVo3LBp2B11b3fzrXtR6p
	 m3SPmBBAltgWxff2a45Mt0UoKuFrA2zVTfooO48A=
Date: Wed, 17 Dec 2025 16:24:02 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Barry K. Nathan" <barryn@pobox.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jonathan Corbet <corbet@lwn.net>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.18 159/614] docs: kdoc: fix duplicate section warning
 message
Message-ID: <2025121754-drainer-blitz-9aa0@gregkh>
References: <20251216111401.280873349@linuxfoundation.org>
 <20251216111407.097805254@linuxfoundation.org>
 <153a28b8-5933-470a-b1af-e91f6f3e8a5a@pobox.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153a28b8-5933-470a-b1af-e91f6f3e8a5a@pobox.com>

On Wed, Dec 17, 2025 at 03:22:50AM -0800, Barry K. Nathan wrote:
> On 12/16/25 03:08, Greg Kroah-Hartman wrote:
> > 6.18-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Jacob Keller <jacob.e.keller@intel.com>
> > 
> > [ Upstream commit e5e7ca66a7fc6b8073c30a048e1157b88d427980 ]
> > 
> > The python version of the kernel-doc parser emits some strange warnings
> > with just a line number in certain cases:
> > 
> > $ ./scripts/kernel-doc -Wall -none 'include/linux/virtio_config.h'
> > Warning: 174
> > Warning: 184
> > Warning: 190
> > Warning: include/linux/virtio_config.h:226 No description found for return value of '__virtio_test_bit'
> > Warning: include/linux/virtio_config.h:259 No description found for return value of 'virtio_has_feature'
> > Warning: include/linux/virtio_config.h:283 No description found for return value of 'virtio_has_dma_quirk'
> > Warning: include/linux/virtio_config.h:392 No description found for return value of 'virtqueue_set_affinity'
> > 
> > I eventually tracked this down to the lone call of emit_msg() in the
> > KernelEntry class, which looks like:
> > 
> >    self.emit_msg(self.new_start_line, f"duplicate section name '{name}'\n")
> > 
> > This looks like all the other emit_msg calls. Unfortunately, the definition
> > within the KernelEntry class takes only a message parameter and not a line
> > number. The intended message is passed as the warning!
> > 
> > Pass the filename to the KernelEntry class, and use this to build the log
> > message in the same way as the KernelDoc class does.
> > 
> > To avoid future errors, mark the warning parameter for both emit_msg
> > definitions as a keyword-only argument. This will prevent accidentally
> > passing a string as the warning parameter in the future.
> > 
> > Also fix the call in dump_section to avoid an unnecessary additional
> > newline.
> > 
> > Fixes: e3b42e94cf10 ("scripts/lib/kdoc/kdoc_parser.py: move kernel entry to a class")
> > Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> > Signed-off-by: Jonathan Corbet <corbet@lwn.net>
> > Message-ID: <20251030-jk-fix-kernel-doc-duplicate-return-warning-v2-1-ec4b5c662881@intel.com>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >   scripts/lib/kdoc/kdoc_parser.py | 16 ++++++++++------
> >   1 file changed, 10 insertions(+), 6 deletions(-)
> > 
> > diff --git a/scripts/lib/kdoc/kdoc_parser.py b/scripts/lib/kdoc/kdoc_parser.py
> > index 2376f180b1fa9..ccbc1fe4b7ccd 100644
> > --- a/scripts/lib/kdoc/kdoc_parser.py
> > +++ b/scripts/lib/kdoc/kdoc_parser.py
> > @@ -274,6 +274,8 @@ class KernelEntry:
> >           self.leading_space = None
> > +        self.fname = fname
> > +
> >           # State flags
> >           self.brcount = 0
> >           self.declaration_start_line = ln + 1
> > @@ -288,9 +290,11 @@ class KernelEntry:
> >           return '\n'.join(self._contents) + '\n'
> >       # TODO: rename to emit_message after removal of kernel-doc.pl
> > -    def emit_msg(self, log_msg, warning=True):
> > +    def emit_msg(self, ln, msg, *, warning=True):
> >           """Emit a message"""
> > +        log_msg = f"{self.fname}:{ln} {msg}"
> > +
> >           if not warning:
> >               self.config.log.info(log_msg)
> >               return
> > @@ -336,7 +340,7 @@ class KernelEntry:
> >                   # Only warn on user-specified duplicate section names
> >                   if name != SECTION_DEFAULT:
> >                       self.emit_msg(self.new_start_line,
> > -                                  f"duplicate section name '{name}'\n")
> > +                                  f"duplicate section name '{name}'")
> >                   # Treat as a new paragraph - add a blank line
> >                   self.sections[name] += '\n' + contents
> >               else:
> > @@ -387,15 +391,15 @@ class KernelDoc:
> >               self.emit_msg(0,
> >                             'Python 3.7 or later is required for correct results')
> > -    def emit_msg(self, ln, msg, warning=True):
> > +    def emit_msg(self, ln, msg, *, warning=True):
> >           """Emit a message"""
> > -        log_msg = f"{self.fname}:{ln} {msg}"
> > -
> >           if self.entry:
> > -            self.entry.emit_msg(log_msg, warning)
> > +            self.entry.emit_msg(ln, msg, warning=warning)
> >               return
> > +        log_msg = f"{self.fname}:{ln} {msg}"
> > +
> >           if warning:
> >               self.config.log.warning(log_msg)
> >           else:
> 
> On 6.18.2-rc1 and 6.17.13-rc2, this patch causes amd64 kernel builds with my
> usual configs to fail with the following error:
> 
>   CC      drivers/gpu/drm/i915/i915_driver.o
> Traceback (most recent call last):
>   File "/home/barryn/src/linux/build-amd64/linux-6.18.2-rc1/./scripts/kernel-doc.py",
> line 339, in <module>
>     main()
>   File "/home/barryn/src/linux/build-amd64/linux-6.18.2-rc1/./scripts/kernel-doc.py",
> line 310, in main
>     kfiles.parse(args.files, export_file=args.export_file)
>   File "/home/barryn/src/linux/build-amd64/linux-6.18.2-rc1/scripts/lib/kdoc/kdoc_files.py",
> line 222, in parse
>     self.parse_file(fname)
>   File "/home/barryn/src/linux/build-amd64/linux-6.18.2-rc1/scripts/lib/kdoc/kdoc_files.py",
> line 120, in parse_file
>     export_table, entries = doc.parse_kdoc()
>                             ^^^^^^^^^^^^^^^^
>   File "/home/barryn/src/linux/build-amd64/linux-6.18.2-rc1/scripts/lib/kdoc/kdoc_parser.py",
> line 1648, in parse_kdoc
>     self.state_actions[self.state](self, ln, line)
>   File "/home/barryn/src/linux/build-amd64/linux-6.18.2-rc1/scripts/lib/kdoc/kdoc_parser.py",
> line 1123, in process_normal
>     self.reset_state(ln)
>   File "/home/barryn/src/linux/build-amd64/linux-6.18.2-rc1/scripts/lib/kdoc/kdoc_parser.py",
> line 447, in reset_state
>     self.entry = KernelEntry(self.config, ln)
>                  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>   File "/home/barryn/src/linux/build-amd64/linux-6.18.2-rc1/scripts/lib/kdoc/kdoc_parser.py",
> line 277, in __init__
>     self.fname = fname
>                  ^^^^^
> NameError: name 'fname' is not defined
> make[6]: *** [scripts/Makefile.build:287:
> drivers/gpu/drm/i915/i915_driver.o] Error 1
> make[6]: *** Deleting file 'drivers/gpu/drm/i915/i915_driver.o'
> make[5]: *** [scripts/Makefile.build:556: drivers/gpu/drm/i915] Error 2
> make[4]: *** [scripts/Makefile.build:556: drivers/gpu/drm] Error 2
> make[3]: *** [scripts/Makefile.build:556: drivers/gpu] Error 2
> make[2]: *** [scripts/Makefile.build:556: drivers] Error 2
> make[1]: ***
> [/home/barryn/src/linux/build-amd64/linux-6.18.2-rc1/Makefile:2010: .] Error
> 2
> make: *** [Makefile:248: __sub-make] Error 2
> 
> Here is a minimal config to reproduce (make a .config with just these 6
> lines, then run `make olddefconfig`):
> 
> CONFIG_64BIT=y
> CONFIG_EXPERT=y
> CONFIG_PCI=y
> CONFIG_DRM=y
> CONFIG_DRM_I915=y
> CONFIG_DRM_I915_WERROR=y
> 
> This bug happens if and only if CONFIG_DRM_I915_WERROR=y. (By the way,
> allyesconfig and allmodconfig set CONFIG_COMPILE_TEST=y, which disables
> CONFIG_DRM_I915_DEBUG and CONFIG_DRM_I915_WERROR. So neither allyesconfig
> nor allmodconfig reproduce this.)
> 
> It happens whether building for amd64 or i386 (so CONFIG_64BIT=y is not
> strictly necessary). It happens on both fully updated Debian 12 Bookworm and
> fully updated Debian 13 Trixie. It happens both when compiling natively on
> amd64 and when cross-compiling from an arm64 system.
> 
> It happens on 6.18.2-rc1 and 6.17.13-rc2, but not on 6.19-rc1. Also, if I
> revert this patch on 6.18.2-rc1 or 6.17.13-rc2, the bug no longer
> reproduces.

Thanks, I'll go drop this from all queues.

greg k-h
