Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 261BF368
	for <patches@lists.linux.dev>; Fri, 11 Nov 2022 18:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668192532; x=1699728532;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=cPvINtLB33xYjofGkhy4PsIph/HjXemLXjTdWzqkIB0=;
  b=NSOyef2Ec4dc4ycUqltdr5RlY8HkGVWzz5tnToV87D0v0VG1kTztJ3rJ
   3p0THhQBsTYguHAZTfIq7csGGN0b1/sJiUzFthufrZbzuXUT3me2I26h0
   uYX5xEwZJPVkbVq9pEztKDTizq4LtKGeySe/AYHuoAt1+/c7XoZxfcESa
   p1Tqzk0KAViQ/mpnKug7I7HB0Mqnv9XjtGIRpvoh/BEyXiHhhYh2YaQn0
   pJci6MfOoYJmPLyPZvoCKkafjOe81tad5aTHbRgliIC8fCezJsD4Ha3Z5
   x87SyWLb0jHT1EMgalOMvCPI9Fo6Q9idE8wL0oBQjW/4DR2M3OP7lFRca
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10528"; a="299162770"
X-IronPort-AV: E=Sophos;i="5.96,157,1665471600"; 
   d="scan'208";a="299162770"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2022 10:48:51 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10528"; a="966902129"
X-IronPort-AV: E=Sophos;i="5.96,157,1665471600"; 
   d="scan'208";a="966902129"
Received: from nmpoonaw-mobl1.amr.corp.intel.com (HELO [10.252.134.46]) ([10.252.134.46])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2022 10:48:49 -0800
Message-ID: <82d6137f-4183-d994-f8b1-56b4be3d620f@intel.com>
Date: Fri, 11 Nov 2022 10:48:49 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v2 10/14] platform/x86/intel/ifs: Add metadata validation
Content-Language: en-US
To: Borislav Petkov <bp@alien8.de>, Jithu Joseph <jithu.joseph@intel.com>
Cc: hdegoede@redhat.com, markgross@kernel.org, tglx@linutronix.de,
 mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org,
 hpa@zytor.com, gregkh@linuxfoundation.org, ashok.raj@intel.com,
 tony.luck@intel.com, linux-kernel@vger.kernel.org,
 platform-driver-x86@vger.kernel.org, patches@lists.linux.dev,
 ravi.v.shankar@intel.com, thiago.macieira@intel.com,
 athenas.jimenez.gonzalez@intel.com, sohil.mehta@intel.com
References: <20221021203413.1220137-1-jithu.joseph@intel.com>
 <20221107225323.2733518-1-jithu.joseph@intel.com>
 <20221107225323.2733518-11-jithu.joseph@intel.com> <Y26W+emSSL5Xik0G@zn.tnic>
From: Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <Y26W+emSSL5Xik0G@zn.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/11/22 10:39, Borislav Petkov wrote:
>> +struct meta_data {
>> +	unsigned int meta_type;		// metadata type
>> +	unsigned int meta_size;		// size of this entire struct including hdrs.
>> +	unsigned int test_type;		// IFS test type
>> +	unsigned int fusa_info;		// Fusa info
>> +	unsigned int total_images;	// Total number of images
>> +	unsigned int current_image;	// Current Image #
>> +	unsigned int total_chunks;	// Total number of chunks in this image
>> +	unsigned int starting_chunk;	// Starting chunk number in this image
>> +	unsigned int size_per_chunk;	// size of each chunk
>> +	unsigned int chunks_per_stride;	// number of chunks in a stride
>> +	unsigned int reserved[54];	// Align to 256 bytes for chunk alignment.
> That looks weird.
> 
> __packed and __aligned doesn't work?

... and don't we try to use fixed-size typed in hardware structures,
like u32?

There are also much nicer ways to do this:

union meta_data {
	struct {
		u32 meta_type;		// metadata type
		u32 meta_size;		// size of ...
	};
	u8 padding[IFS_CHUNK_ALIGNMENT];
}

That doesn't have any magic linkage between the magic "54" (times 4) and
IFS_CHUNK_ALIGNMENT.  It makes the compiler do the hard work for you.

Voila, you have a union that's always IFS_CHUNK_ALIGNMENT in size,  No
magic 54's necessary.
