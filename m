Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1056A46B2
	for <patches@lists.linux.dev>; Sun, 13 Nov 2022 16:58:30 +0000 (UTC)
Received: from zn.tnic (p200300ea9733e71a329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e71a:329c:23ff:fea6:a903])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id D58EF1EC008F;
	Sun, 13 Nov 2022 17:58:22 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1668358702;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=eB/hC3tGZeJADbPXtdKZGPPgu/jWHckff1IDi4hbfsg=;
	b=Ji4HYYYbpsV4WMX6qTt/HajNGQTw5Ysj4UBgFSfemcuXmmV3RTigUJS37NepjYccA4XA0S
	RCkwnsSQab6YU3XqZse5KIhGkKiAA5f0AEnjXjmiytImR0eICK361NCiJi+7zJ0fAzToCE
	fVOtbbnVzNiMcBN72B83JjFBbFv31gU=
Date: Sun, 13 Nov 2022 17:58:17 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Joseph, Jithu" <jithu.joseph@intel.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	Thiago Macieira <thiago.macieira@intel.com>,
	"Luck, Tony" <tony.luck@intel.com>,
	"hdegoede@redhat.com" <hdegoede@redhat.com>,
	"markgross@kernel.org" <markgross@kernel.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
	"Raj, Ashok" <ashok.raj@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"platform-driver-x86@vger.kernel.org" <platform-driver-x86@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	"Shankar, Ravi V" <ravi.v.shankar@intel.com>,
	"Jimenez Gonzalez, Athenas" <athenas.jimenez.gonzalez@intel.com>,
	"Mehta, Sohil" <sohil.mehta@intel.com>
Subject: Re: [PATCH v2 12/14] platform/x86/intel/ifs: Add current_batch sysfs
 entry
Message-ID: <Y3EiKUzpShqwzEf6@zn.tnic>
References: <20221021203413.1220137-1-jithu.joseph@intel.com>
 <20221107225323.2733518-1-jithu.joseph@intel.com>
 <20221107225323.2733518-13-jithu.joseph@intel.com>
 <Y2/JNAmSoYlLKq3A@zn.tnic>
 <CC3629D6-B205-4150-80E5-FC7A7A76DD25@intel.com>
 <Y3CevK2zhAmiUyG9@kroah.com>
 <Y3DZmKYV+8HBtZ+Q@zn.tnic>
 <5e65889d-d68c-b29d-6cea-7b4ce4c87b4a@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5e65889d-d68c-b29d-6cea-7b4ce4c87b4a@intel.com>

On Sun, Nov 13, 2022 at 08:41:47AM -0800, Joseph, Jithu wrote:
> Do you think it is better to restrict filename input to confirm
> to ff-mm-ss-xy.<test> format rather than accepting any string and
> treating it as a file-name and trying to load it, if it is present ?

Yap, that way you pre-filter filenames. Yeah, the header checks *must*
absolutely happen too but it would be a simple first test.

Also, you can check for:

ff-mm-ss-X.<test>

where X is a [0-9]+ of arbitrary length and this way won't have the
artificial 256 limit you have now.

> (Given that, before loading, We do intel_find_matching_signature(),
> which validates if the signature/pf entries in header confirms to the
> machine we are on before loading)
>
> We did accepting file-name as input before [1] (except for validating
> if the filename confirms to ff-mm-ss format)

Yeah, except now you want to do multiple sets of scan files.

But yeah, you can extend the interface even more:

echo <fname> /sysfs/file

* if f/m/s matches, you execute

    if still within the timeout, you return -EAGAIN from
    current_batch_store() to tell userspace, take a nap and try again.

* if the f/m/s doesn't match you return -EINVAL to say, wrong filename,
try the next one.

And this way, the user script can simply look at the retvals and act
accordingly - it won't even need to parse dmesg or wnatnot.

For example.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
