Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87B6D7E
	for <patches@lists.linux.dev>; Wed, 27 Apr 2022 02:42:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 139C0C385A4;
	Wed, 27 Apr 2022 02:42:25 +0000 (UTC)
Date: Tue, 26 Apr 2022 22:42:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "hdegoede@redhat.com" <hdegoede@redhat.com>, "markgross@kernel.org"
 <markgross@kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
 "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
 "corbet@lwn.net" <corbet@lwn.net>, "gregkh@linuxfoundation.org"
 <gregkh@linuxfoundation.org>, "andriy.shevchenko@linux.intel.com"
 <andriy.shevchenko@linux.intel.com>, "Joseph, Jithu"
 <jithu.joseph@intel.com>, "Raj, Ashok" <ashok.raj@intel.com>, "Williams,
 Dan J" <dan.j.williams@intel.com>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, "linux-doc@vger.kernel.org"
 <linux-doc@vger.kernel.org>, "platform-driver-x86@vger.kernel.org"
 <platform-driver-x86@vger.kernel.org>, "patches@lists.linux.dev"
 <patches@lists.linux.dev>, "Shankar, Ravi V" <ravi.v.shankar@intel.com>
Subject: Re: [PATCH v4 09/10] trace: platform/x86/intel/ifs: Add trace point
 to track Intel IFS operations
Message-ID: <20220426224224.597dd732@rorschach.local.home>
In-Reply-To: <YmiF6Rsy04pUHVQo@agluck-desk3.sc.intel.com>
References: <20220419163859.2228874-1-tony.luck@intel.com>
	<20220422200219.2843823-1-tony.luck@intel.com>
	<20220422200219.2843823-10-tony.luck@intel.com>
	<20220425105251.3f5e8021@gandalf.local.home>
	<1752057af33e4eb28bcea0fd75e44048@intel.com>
	<20220425214928.2aac3391@gandalf.local.home>
	<YmiF6Rsy04pUHVQo@agluck-desk3.sc.intel.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 26 Apr 2022 16:53:13 -0700
"Luck, Tony" <tony.luck@intel.com> wrote:
>=20
> I looked at the examples in samples/trace_events/trace-events-sample.h
> and tried to use this. But I'm doing something wrong because the
> compiler barfs on something defined but not used.
>=20
> Maybe my problem is the TP_printk() in the DECLARE_EVENT_CLASS() that
> is over-ridden by DEFINE_EVENT_PRINT(). I wasn't at all sure what to
> put here ... or how to use the base tracepoint that doesn't have the
> printk() over-ridden.

Yeah, that could be confusing.

Basically, TRACE_EVENT() is simply defined as:

DECLARE_EVENT_CLASS()
DEFINE_EVENT();

So technically you could create the class and event with the same name,
and then you could create a second event on top of that. But I usually
suggest people explicitly specify the DECLARE_EVENT_CLASS() and
DEFINE_EVENT().

I would not do this until you have more than one event. The what you
would do is create one event where the print matches the
DECLARE_EVENT_CLASS() TP_printk(), and have that event defined with
just DEFINE_EVENT(). Then create other events with the
DEFINE_EVENT_PRINT().

>=20
> I think I need my class to just save both the u64 values to the trace
> buffer. Then the different trace points will extract the bits they want
> and print in a user friendly way. While this increases space used in
> the trace buffer, these events are not crazy high frequency. Usually=20
> one or two events per core with a gap 30 minutes or more between tests.
>=20
> In my ".c" file the tracepoint looks like this using the name from
> DEFINE_EVENT_PRINT(), and now passing the full u64 values:
>=20
> 	trace_ifs_status_saf(activate.data, status.data);
>=20
> and my #include file looks like this:
>=20
> ----------------------------------------------
> /* SPDX-License-Identifier: GPL-2.0 */
> #undef TRACE_SYSTEM
> #define TRACE_SYSTEM intel_ifs
>=20
> #if !defined(_TRACE_IFS_H) || defined(TRACE_HEADER_MULTI_READ)
> #define _TRACE_IFS_H
>=20
> #include <linux/ktime.h>
> #include <linux/tracepoint.h>
>=20
> DECLARE_EVENT_CLASS(ifs_status,
>=20
> 	TP_PROTO(u64 activate, u64 status),
>=20
> 	TP_ARGS(activate, status),
>=20
> 	TP_STRUCT__entry(
> 		__field(	u64,	activate	)
> 		__field(	u64,	status		)
> 	),
>=20
> 	TP_fast_assign(
> 		__entry->activate =3D activate;
> 		__entry->status	=3D status;
> 	),
>=20
> 	TP_printk("activate: %llx status: %llx",
> 		__entry->activate,
> 		__entry->status)
> );
>=20
> DEFINE_EVENT_PRINT(ifs_status, ifs_status_saf,
> 	TP_PROTO(u64 activate, u64 status),
> 	TP_ARGS(activate, status),
> 	TP_printk("start: %.2x, stop: %.2x, status: %llx",
> 		((union ifs_scan *)&(__entry->activate))->start,
> 		((union ifs_scan *)&(__entry->activate))->stop,
> 		__entry->status)
> );
>=20
> #endif /* _TRACE_IFS_H */
>=20
> /* This part must be outside protection */
> #include <trace/define_trace.h>
> -----------------------------------------------------
>=20
> GCC messages:
>=20
>=20
>   CC [M]  drivers/platform/x86/intel/ifs/runtest.o
> In file included from /home/agluck/GIT/mywork/include/trace/define_trace.=
h:102,
>                  from /home/agluck/GIT/mywork/include/trace/events/intel_=
ifs.h:44,
>                  from /home/agluck/GIT/mywork/drivers/platform/x86/intel/=
ifs/runtest.c:27:
> /home/agluck/GIT/mywork/include/trace/trace_events.h:426:13: warning: =E2=
=80=98print_fmt_ifs_status=E2=80=99 defined but not used [-Wunused-variable]
>   426 | static char print_fmt_##call[] =3D print;                        =
         \
>       |             ^~~~~~~~~~
> /home/agluck/GIT/mywork/include/trace/events/intel_ifs.h:11:1: note: in e=
xpansion of macro =E2=80=98DECLARE_EVENT_CLASS=E2=80=99
>    11 | DECLARE_EVENT_CLASS(ifs_status,
>       | ^~~~~~~~~~~~~~~~~~~
> In file included from /home/agluck/GIT/mywork/include/trace/define_trace.=
h:102,
>                  from /home/agluck/GIT/mywork/include/trace/events/intel_=
ifs.h:44,
>                  from /home/agluck/GIT/mywork/drivers/platform/x86/intel/=
ifs/runtest.c:27:
> /home/agluck/GIT/mywork/include/trace/trace_events.h:207:37: warning: =E2=
=80=98trace_event_type_funcs_ifs_status=E2=80=99 defined but not used [-Wun=
used-variable]
>   207 | static struct trace_event_functions trace_event_type_funcs_##call=
 =3D {   \
>       |                                     ^~~~~~~~~~~~~~~~~~~~~~~
> /home/agluck/GIT/mywork/include/trace/events/intel_ifs.h:11:1: note: in e=
xpansion of macro =E2=80=98DECLARE_EVENT_CLASS=E2=80=99
>    11 | DECLARE_EVENT_CLASS(ifs_status,
>       | ^~~~~~~~~~~~~~~~~~~
> make[1]: Leaving directory '/home/agluck/GIT/mywork/build/ifsv5-rc1'
>=20

Yeah, because you don't have more than one event, so the
DEFINE_EVENT_PRINT() does not make sense.  You still need one
DEFINE_EVENT() otherwise, you will get that static function not used
warning.

-- Steve

