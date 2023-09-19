Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B40AB33981
	for <patches@lists.linux.dev>; Tue, 19 Sep 2023 10:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=iogearbox.net; s=default2302; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
	bh=aIQOB48bI/MFjGoY4oDKGUiOlcn6mIR+zgNw1c4ehnw=; b=HEzK36QtTIDNvoaO6f9z7vc780
	j/vTwQI6TNF16zmsTFDGDhF+B9xcdwuKVM/Jua1RST9DS4QBUMx4DNgeWFDYizi8COW+nL476TwME
	xNEht5FCmmtO9ip+kYBtjpT/yiiNukHioHKeo9hXOcPxtJbx7HuyYujT7rPSjnG7cMDq/vI1uOw6j
	XXNrqkO+mO/s+tHtWa7SaoSWxjwsSOrTm7rELgPTGUZN2HIQgFugqEVSKk/RH9h5V1V7tt8s/w1sF
	LktjK++4lcg7rQNMswoaSNegP4AlaGtVPrm15UVMj8+ufuV3wlx/TMXHTm6rW6pl7UwJMDFHk4gq/
	tnHzCqHA==;
Received: from sslproxy01.your-server.de ([78.46.139.224])
	by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <daniel@iogearbox.net>)
	id 1qiXld-000E0R-8G; Tue, 19 Sep 2023 12:15:41 +0200
Received: from [85.1.206.226] (helo=linux-3.home)
	by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <daniel@iogearbox.net>)
	id 1qiXlc-000AMG-Pk; Tue, 19 Sep 2023 12:15:40 +0200
Subject: Re: [PATCH 6.1 562/600] bpf: Fix issue in verifying allow_ptr_leaks
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
 Greg KH <gregkh@linuxfoundation.org>
Cc: Luis Gerhorst <gerhorst@cs.fau.de>, Alexei Starovoitov <ast@kernel.org>,
 Eddy Z <eddyz87@gmail.com>, Yafang Shao <laoar.shao@gmail.com>,
 patches@lists.linux.dev, stable <stable@vger.kernel.org>,
 Yonghong Song <yonghong.song@linux.dev>,
 Hagar Gamal Halim Hemdan <hagarhem@amazon.de>,
 Puranjay Mohan <puranjay12@gmail.com>, Luis Gerhorst <gerhorst@amazon.de>
References: <20230911134650.200439213@linuxfoundation.org>
 <20230914085131.40974-1-gerhorst@amazon.de>
 <2023091653-peso-sprint-889d@gregkh>
 <b927046b-d1e7-8adf-ebc0-37b92d8d4390@iogearbox.net>
 <2023091959-heroics-banister-7d6d@gregkh>
 <CAADnVQKXqaEC3SOP9eNQH1f3YF0E3A_54kSEsU2LvCL_4Awe8g@mail.gmail.com>
From: Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <7ae0274b-7a46-7fef-1a7b-0999d21a4099@iogearbox.net>
Date: Tue, 19 Sep 2023 12:15:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CAADnVQKXqaEC3SOP9eNQH1f3YF0E3A_54kSEsU2LvCL_4Awe8g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.10/27036/Tue Sep 19 09:42:31 2023)

On 9/19/23 10:39 AM, Alexei Starovoitov wrote:
> On Tue, Sep 19, 2023 at 1:34 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>>
>> On Tue, Sep 19, 2023 at 08:26:28AM +0200, Daniel Borkmann wrote:
>>> On 9/16/23 1:35 PM, Greg KH wrote:
>>>> On Thu, Sep 14, 2023 at 08:51:32AM +0000, Luis Gerhorst wrote:
>>>>>> 6.1-stable review patch.  If anyone has any objections, please let me know.
>>>>>>
>>>>>> From: Yafang Shao <laoar.shao@gmail.com>
>>>>>>
>>>>>> commit d75e30dddf73449bc2d10bb8e2f1a2c446bc67a2 upstream.
>>>>>
>>>>> I unfortunately have objections, they are pending discussion at [1].
>>>>>
>>>>> Same applies to the 6.4-stable review patch [2] and all other backports.
>>>>>
>>>>> [1] https://lore.kernel.org/bpf/20230913122827.91591-1-gerhorst@amazon.de/
>>>>> [2] https://lore.kernel.org/stable/20230911134709.834278248@linuxfoundation.org/
>>>>
>>>> As this is in the tree already, and in Linus's tree, I'll wait to see
>>>> if any changes are merged into Linus's tree for this before removing it
>>>> from the stable trees.
>>>>
>>>> Let us know if there's a commit that resolves this and we will be glad
>>>> to queue that up.
>>>
>>> Commit d75e30dddf73 ("bpf: Fix issue in verifying allow_ptr_leaks") is not
>>> stable material. It's not really a "fix", but it will simply make direct
>>> packet access available to applications without CAP_PERFMON - the latter
>>> was required so far given Spectre v1. However, there is ongoing discussion [1]
>>> that potentially not much useful information can be leaked out and therefore
>>> lifting it may or may not be ok. If we queue this to stable and later figure
>>> we need to revert the whole thing again because someone managed to come up
>>> with a PoC in the meantime, then there's higher risk of breakage.
>>
>> Ick, ok, so just this one commit should be reverted?  Or any others as
>> well?
> 
> I don't think revert is necessary. Just don't backport any further.

Yeah agree lets not backport further.
