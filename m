Received: from smtp.gentoo.org (woodpecker.gentoo.org [140.211.166.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05A484426
	for <patches@lists.linux.dev>; Thu, 26 Oct 2023 21:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gentoo.org
Authentication-Results: smtp.subspace.kernel.org; dkim=none
References: <87fs1x1p93.fsf@gentoo.org>
 <02e8fca0-43bd-ad60-6aec-6bcc74d594ee@applied-asynchrony.com>
 <740c38b1-60eb-41da-93e0-7d7671f0b3fc@suse.com>
User-agent: mu4e 1.10.7; emacs 30.0.50
From: Sam James <sam@gentoo.org>
To: Qu Wenruo <wqu@suse.com>
Cc: Holger =?utf-8?Q?Hoffst=C3=A4tte?= <holger@applied-asynchrony.com>, Sam
 James
 <sam@gentoo.org>, gregkh@linuxfoundation.org, dsterba@suse.com,
 patches@lists.linux.dev, stable@vger.kernel.org,
 linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 6.5 211/285] btrfs: scrub: fix grouping of read IO
Date: Thu, 26 Oct 2023 22:12:27 +0100
Organization: Gentoo
In-reply-to: <740c38b1-60eb-41da-93e0-7d7671f0b3fc@suse.com>
Message-ID: <878r7paxys.fsf@gentoo.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


Qu Wenruo <wqu@suse.com> writes:

> On 2023/10/27 00:30, Holger Hoffst=C3=A4tte wrote:
>> On 2023-10-26 15:31, Sam James wrote:
>>> 'btrfs: scrub: fix grouping of read IO' seems to intorduce a
>>> -Wmaybe-uninitialized warning (which becomes fatal with the kernel's
>>> passed -Werror=3D...) with 6.5.9:
>>>
>>> ```
>>> /var/tmp/portage/sys-kernel/gentoo-kernel-6.5.9/work/linux-6.5/fs/btrfs=
/scrub.c: In function =E2=80=98scrub_simple_mirror.isra=E2=80=99:
>>> /var/tmp/portage/sys-kernel/gentoo-kernel-6.5.9/work/linux-6.5/fs/btrfs=
/scrub.c:2075:29:
>>> error: =E2=80=98found_logical=E2=80=99 may be used uninitialized
>>> [-Werror=3Dmaybe-uninitialized[https://gcc.gnu.org/onlinedocs/gcc/Warni=
ng-Options.html#index-Wmaybe-uninitialized]]
>>> =C2=A0 2075 |=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cur_logical =3D found_logical + BTR=
FS_STRIPE_LEN;
>>> /var/tmp/portage/sys-kernel/gentoo-kernel-6.5.9/work/linux-6.5/fs/btrfs=
/scrub.c:2040:21: note: =E2=80=98found_logical=E2=80=99 was declared here
>>> =C2=A0 2040 |=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 found_logical;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 ^~~~~~~~~~~~~
>>> ```
>> Good find! found_logical is passed by reference to
>> queue_scrub_stripe(..) (inlined)
>> where it is used without ever being set:
>> ...
>>  =C2=A0=C2=A0=C2=A0=C2=A0/* Either >0 as no more extents or <0 for error=
. */
>>  =C2=A0=C2=A0=C2=A0=C2=A0if (ret)
>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ret;
>>  =C2=A0=C2=A0=C2=A0=C2=A0if (found_logical_ret)
>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 *found_logical_ret =3D strip=
e->logical;
>>  =C2=A0=C2=A0=C2=A0=C2=A0sctx->cur_stripe++;
>> ...
>> Something is missing here, and somehow I don't think it's just the
>> top-level
>> initialisation of found_logical.
>
> This looks like a false alert for me.
>
> @found_logical is intentionally uninitialized to catch any
> uninitialized usage by compiler.
>

I feel like this sort of thing is going to be inevitable with -Wmaybe-unini=
tialized.

> It would be set by queue_scrub_stripe() when there is any stripe found.
>
> If there is no stripe found, queue_scrub_stripe() would return >0,
> then we know there is no more extent and break the loop.
> If there is any error, we error out too, thus no problem with that.
>
> So to me this looks like a false alert.
>
> Mind to share the compiler and its version?
>

Sure, GCC 14.0.0 20231022 (experimental). Sorry, I'd meant to include
that in the original post..

> Thanks,
> Qu
>> -h

