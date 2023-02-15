Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30CFD2F2F
	for <patches@lists.linux.dev>; Wed, 15 Feb 2023 21:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676495903; x=1708031903;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=GTT4gNma+UDtlhtKszlXJRnKYRr1ieBb5P4RGFVL3g0=;
  b=AmAkGmz1reCooQPp6lT0ev071/ACKtzwSgUmIbef7QMEmsLOSFrKQ4ji
   UxhPNbx5Z+jFhLfxaHh7kpQecYPgK26jeMpdjKgAbRRQccYygBIgwzH8/
   9TBj0pp4sMPV9I0msPWTX3EnjN6Irm0hObvpxuqwY05p36AncBMc9s8Cw
   Y2V/CZ8gZgv7YfOyAaNo5uTVoQGXrtj54i6lD7Sr9H1y3fkfTwEny4GTJ
   kNoHTxny0Wg/jJcsxUdMMDmjH/3Fw2L5CBMil3kkCbQcl6yHv8oZgyR27
   ZwXAPcpVOlVrdoqPzj1x/nHh5x8M4hxEcXVTksNvMIlBD9E3J+oEfTDsj
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="330186703"
X-IronPort-AV: E=Sophos;i="5.97,300,1669104000"; 
   d="scan'208";a="330186703"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2023 13:18:22 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="733558396"
X-IronPort-AV: E=Sophos;i="5.97,300,1669104000"; 
   d="scan'208";a="733558396"
Received: from chakanog-mobl.amr.corp.intel.com (HELO [10.209.64.107]) ([10.209.64.107])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2023 13:18:21 -0800
Message-ID: <76c527e3-b376-18df-bc93-f5a75e029d76@intel.com>
Date: Wed, 15 Feb 2023 13:18:20 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 4/7] platform/x86/intel/ifs: Implement Array BIST test
Content-Language: en-US
To: "Joseph, Jithu" <jithu.joseph@intel.com>, hdegoede@redhat.com,
 markgross@kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 gregkh@linuxfoundation.org, rostedt@goodmis.org, ashok.raj@intel.com,
 tony.luck@intel.com, linux-kernel@vger.kernel.org,
 platform-driver-x86@vger.kernel.org, patches@lists.linux.dev,
 ravi.v.shankar@intel.com, thiago.macieira@intel.com,
 athenas.jimenez.gonzalez@intel.com, sohil.mehta@intel.com
References: <20230131234302.3997223-1-jithu.joseph@intel.com>
 <20230214234426.344960-1-jithu.joseph@intel.com>
 <20230214234426.344960-5-jithu.joseph@intel.com>
 <a24c65f8-978d-8968-7874-6b83e14b01ba@intel.com>
 <d9d18954-8434-4c85-88b8-8e1d99cd6a4b@intel.com>
 <dd501d6a-e7e9-be82-24fb-33b18fb6192b@intel.com>
 <b67d2125-4075-4eac-4cad-8e315b866144@intel.com>
 <5d57f42a-1bfc-5e6a-bb49-556ecb7402af@intel.com>
From: Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <5d57f42a-1bfc-5e6a-bb49-556ecb7402af@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/15/23 13:13, Joseph, Jithu wrote:
> 
> On 2/15/2023 12:26 PM, Dave Hansen wrote:
>> On 2/15/23 12:22, Joseph, Jithu wrote:
>>> 		trace_ifs_array(cpu, *((u64 *)&before), *((u64 *)&command));
>> Uhh, you control the types in the tracepoint.  Just make them compatible
>> so you don't need casts.
> will change it to:
> trace_ifs_array(cpu, before.array_bitmask, before.array_bank,  *((u64 *)&command));
> 
> i.e will pass compatible types for array_list and array_bank. And for the last argument, we need to dump the whole 64 bits within "command"
> into trace output . Since the suggested change replaced the union with a struct, it is simplest to cast it to u64 needed by traceoutput.
> So I would prefer to keep the cast for the last argument alone.

<sigh>

Your trace even can literally be:

+	TP_STRUCT__entry(
+		__field(struct ifs_foo,	before	)
+		__field(struct ifs_foo,	after	)
+		__field(	int,	cpu	)
+	),

and then you can just use structure assignment or a memcpy.  *That* is
what I mean by compatible types.

But, also, I'm not sure these tracepoints even make any sense.  You're
passing raw MSR contents back and forth.  Why not just use the MSR
tracepoints?  They'll give you the same data.
