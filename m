Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D76422C9C
	for <patches@lists.linux.dev>; Thu, 10 Feb 2022 00:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=8tAXBdMHmhsPxpj72W8RLxxKSvKvThhvAKBFL3y1s/k=; b=27LXNhz0gSmDbxa4J+ev+gKEhz
	Szc1XF5FqaSNWUBizGK2IH46NOjpDIpeqel18k5WYjhLkflJ8jcjukDAGBPNf+cFNKftmBMfljKzK
	89UDC8pHWuTQHsategxCd9gML9DvArxHXaTsZMlnad78GMnAfd14IxJn7T5869yUjXz5wyHDOOPoy
	Ir7hxXTzr4Ln9fGB3s1Mtfw8Ur10hanGX6NtRtOcN70I8JrKjpqjkj4xvgkh1q7F5bSQ5KmZe2RkR
	fnfNo3pKl7IdVUXmSmpbsR0kdBt0iFhmZbRbLBtFw9dTnBvQmktH9C21DaBy/EWzyLKTPUalWLkEv
	ic+9qMuQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nHxFQ-00277T-Vp; Thu, 10 Feb 2022 00:23:44 +0000
Date: Wed, 9 Feb 2022 16:23:44 -0800
From: Luis Chamberlain <mcgrof@kernel.org>
To: Tong Zhang <ztong0001@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Kees Cook <keescook@chromium.org>,
	Iurii Zaikin <yzaikin@google.com>, nixiaoming@huawei.com,
	Eric Biederman <ebiederm@xmission.com>,
	Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
	patches@lists.linux.dev,
	Domenico Andreoli <domenico.andreoli@linux.com>
Subject: Re: [PATCH v2] fs: move binfmt_misc sysctl to its own file as
 built-in
Message-ID: <YgRbEG21AUrLSFKX@bombadil.infradead.org>
References: <20220209225758.476724-1-mcgrof@kernel.org>
 <CAA5qM4BBHj44NgH2210nfZCBru0NV04gd1t8Yp7Et6M7LmJK-w@mail.gmail.com>
 <YgROSgDA3keJowks@bombadil.infradead.org>
 <CAA5qM4C2g6=6mWsQW4vkbSV0ykEjBgNYGp8oVFKtQfKFn5OFjA@mail.gmail.com>
 <CAA5qM4CGCfLUv8o0Er1FL-2+ntqsTgw1FQODnCH9FA8WvuSr=w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA5qM4CGCfLUv8o0Er1FL-2+ntqsTgw1FQODnCH9FA8WvuSr=w@mail.gmail.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Wed, Feb 09, 2022 at 04:14:08PM -0800, Tong Zhang wrote:
> On Wed, Feb 9, 2022 at 3:39 PM Tong Zhang <ztong0001@gmail.com> wrote:
> >
> > On Wed, Feb 9, 2022 at 3:29 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
> > >
> > > On Wed, Feb 09, 2022 at 03:15:53PM -0800, Tong Zhang wrote:
> > > > On Wed, Feb 9, 2022 at 2:58 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
> > > > >
> > > > > This is the second attempt to move binfmt_misc sysctl to its
> > > > > own file. The issue with the first move was that we moved
> > > > > the binfmt_misc sysctls to the binfmt_misc module, but the
> > > > > way things work on some systems is that the binfmt_misc
> > > > > module will load if the sysctl is present. If we don't force
> > > > > the sysctl on, the module won't load. The proper thing to do
> > > > > is to register the sysctl if the module was built or the
> > > > > binfmt_misc code was built-in, we do this by using the helper
> > > > > IS_ENABLED() now.
> > > > >
> > > > > The rationale for the move:
> > > > >
> > > > > kernel/sysctl.c is a kitchen sink where everyone leaves their dirty
> > > > > dishes, this makes it very difficult to maintain.
> > > > >
> > > > > To help with this maintenance let's start by moving sysctls to places
> > > > > where they actually belong.  The proc sysctl maintainers do not want to
> > > > > know what sysctl knobs you wish to add for your own piece of code, we
> > > > > just care about the core logic.
> > > > >
> > > > > This moves the binfmt_misc sysctl to its own file to help remove clutter
> > > > > from kernel/sysctl.c.
> > > > >
> > > > > Cc: Domenico Andreoli <domenico.andreoli@linux.com>
> > > > > Cc: Tong Zhang <ztong0001@gmail.com>
> > > > > Reviewed-by: Tong Zhang <ztong0001@gmail.com>
> > > > > Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> > > > > ---
> > > > >
> > > > > Andrew,
> > > > >
> > > > > If we get tested-by from Domenico and Tong I think this is ready.
> > > > >
> > > > > Demenico, Tong, can you please test this patch? Linus' tree
> > > > > should already have all the prior work reverted as Domenico requested
> > > > > so this starts fresh.
> > > > >
> > > > >  fs/file_table.c |  2 ++
> > > > >  kernel/sysctl.c | 13 -------------
> > > > >  2 files changed, 2 insertions(+), 13 deletions(-)
> > > > >
> > > > > diff --git a/fs/file_table.c b/fs/file_table.c
> > > > > index 57edef16dce4..4969021fa676 100644
> > > > > --- a/fs/file_table.c
> > > > > +++ b/fs/file_table.c
> > > > > @@ -119,6 +119,8 @@ static struct ctl_table fs_stat_sysctls[] = {
> > > > >  static int __init init_fs_stat_sysctls(void)
> > > > >  {
> > > > >         register_sysctl_init("fs", fs_stat_sysctls);
> > > > > +       if (IS_ENABLED(CONFIG_BINFMT_MISC))
> > > > > +               register_sysctl_mount_point("fs/binfmt_misc");
>                              ^^^^
> 
> 
> I'm looking at this code again and we need to mark this return value
> in kmemleak to avoid a false positive.
> 
> 
> diff --git a/fs/file_table.c b/fs/file_table.c
> index 4969021fa676..7303aa33b3fd 100644
> --- a/fs/file_table.c
> +++ b/fs/file_table.c
> @@ -27,6 +27,7 @@
>  #include <linux/task_work.h>
>  #include <linux/ima.h>
>  #include <linux/swap.h>
> +#include <linux/kmemleak.h>
> 
>  #include <linux/atomic.h>
> 
> @@ -119,8 +120,10 @@ static struct ctl_table fs_stat_sysctls[] = {
>  static int __init init_fs_stat_sysctls(void)
>  {
>         register_sysctl_init("fs", fs_stat_sysctls);
> -       if (IS_ENABLED(CONFIG_BINFMT_MISC))
> -               register_sysctl_mount_point("fs/binfmt_misc");
> +       if (IS_ENABLED(CONFIG_BINFMT_MISC)) {
> +               struct ctl_table_header *hdr =
> register_sysctl_mount_point("fs/binfmt_misc");
> +               kmemleak_not_leak(hdr);
> +    }

Good catch, will ammend. I'll give it a few days for others to review and test
before a new iteration.

  Luis
