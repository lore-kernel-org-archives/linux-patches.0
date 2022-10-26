Received: from relayaws-01.paragon-software.com (relayaws-01.paragon-software.com [35.157.23.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 616961C11;
	Wed, 26 Oct 2022 16:56:50 +0000 (UTC)
Received: from dlg2.mail.paragon-software.com (vdlg-exch-02.paragon-software.com [172.30.1.105])
	by relayaws-01.paragon-software.com (Postfix) with ESMTPS id DC9B51D17;
	Wed, 26 Oct 2022 16:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=paragon-software.com; s=mail; t=1666803244;
	bh=bUaFzx51Y3McLSXkoVjYqSdbgP//EcB99FWcLekE2kI=;
	h=Date:Subject:To:CC:References:From:In-Reply-To;
	b=e8jkaWH/O9ByNEKPkrf+Kvw/NxgehNdUaaB06GQ7qIq7z0sYfGKSpHFr+QP9XsFn0
	 Y82eMxDV5AVR0AZwKv1e5bP6fYwaNai5V8vKOU7zyjMv8xrVQgGLFtig0l7PMAxhXY
	 xdrcnFjgme1dR9NO7+SnsW2Qfk21J/c17ViRl3NI=
Received: from [172.30.8.65] (172.30.8.65) by
 vdlg-exch-02.paragon-software.com (172.30.1.105) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Wed, 26 Oct 2022 19:56:41 +0300
Message-ID: <f5c18c15-6fdf-d7fe-627b-080dd7af93cc@paragon-software.com>
Date: Wed, 26 Oct 2022 19:56:41 +0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH -next v2 1/2] fs/ntfs3: Don't use uni1 uninitialized in
 ntfs_d_compare()
Content-Language: en-US
To: Nathan Chancellor <nathan@kernel.org>
CC: Nick Desaulniers <ndesaulniers@google.com>, Tom Rix <trix@redhat.com>,
	<ntfs3@lists.linux.dev>, <llvm@lists.linux.dev>, <patches@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>
References: <20221004232359.285685-1-nathan@kernel.org>
 <Y1LSn+O44lCRR3qE@dev-arch.thelio-3990X>
From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
In-Reply-To: <Y1LSn+O44lCRR3qE@dev-arch.thelio-3990X>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.30.8.65]
X-ClientProxiedBy: vdlg-exch-02.paragon-software.com (172.30.1.105) To
 vdlg-exch-02.paragon-software.com (172.30.1.105)



On 10/21/22 20:10, Nathan Chancellor wrote:
> Ping? This is still breaking our builds in -next...
> 

Thanks for patch, applied!

> On Tue, Oct 04, 2022 at 04:23:58PM -0700, Nathan Chancellor wrote:
>> Clang warns:
>>
>>    fs/ntfs3/namei.c:445:7: error: variable 'uni1' is used uninitialized whenever 'if' condition is true [-Werror,-Wsometimes-uninitialized]
>>                    if (toupper(c1) != toupper(c2)) {
>>                        ^~~~~~~~~~~~~~~~~~~~~~~~~~
>>    ./include/linux/ctype.h:64:20: note: expanded from macro 'toupper'
>>    #define toupper(c) __toupper(c)
>>                      ^
>>    fs/ntfs3/namei.c:487:12: note: uninitialized use occurs here
>>            __putname(uni1);
>>                      ^~~~
>>    ./include/linux/fs.h:2789:65: note: expanded from macro '__putname'
>>    #define __putname(name)         kmem_cache_free(names_cachep, (void *)(name))
>>                                                                          ^~~~
>>    fs/ntfs3/namei.c:445:3: note: remove the 'if' if its condition is always false
>>                    if (toupper(c1) != toupper(c2)) {
>>                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>    fs/ntfs3/namei.c:434:7: error: variable 'uni1' is used uninitialized whenever 'if' condition is true [-Werror,-Wsometimes-uninitialized]
>>                    if (!lm--) {
>>                        ^~~~~
>>    fs/ntfs3/namei.c:487:12: note: uninitialized use occurs here
>>            __putname(uni1);
>>                      ^~~~
>>    ./include/linux/fs.h:2789:65: note: expanded from macro '__putname'
>>    #define __putname(name)         kmem_cache_free(names_cachep, (void *)(name))
>>                                                                          ^~~~
>>    fs/ntfs3/namei.c:434:3: note: remove the 'if' if its condition is always false
>>                    if (!lm--) {
>>                    ^~~~~~~~~~~~
>>    fs/ntfs3/namei.c:430:22: note: initialize the variable 'uni1' to silence this warning
>>            struct cpu_str *uni1, *uni2;
>>                                ^
>>                                = NULL
>>    2 errors generated.
>>
>> There is no point in calling __putname() in these particular error
>> paths, as there has been no corresponding __getname() call yet. Just
>> return directly in these blocks to clear up the warning.
>>
>> Fixes: a3a956c78efa ("fs/ntfs3: Add option "nocase"")
>> Link: https://github.com/ClangBuiltLinux/linux/issues/1729
>> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
>> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
>> ---
>>
>> v2:
>>      * Pick up Nick's reviewed-by tag.
>> v1: https://lore.kernel.org/20221004144145.1345772-1-nathan@kernel.org/
>>
>>   fs/ntfs3/namei.c | 12 ++++--------
>>   1 file changed, 4 insertions(+), 8 deletions(-)
>>
>> diff --git a/fs/ntfs3/namei.c b/fs/ntfs3/namei.c
>> index 315763eb05ff..5d3a6ce3f05f 100644
>> --- a/fs/ntfs3/namei.c
>> +++ b/fs/ntfs3/namei.c
>> @@ -431,10 +431,8 @@ static int ntfs_d_compare(const struct dentry *dentry, unsigned int len1,
>>   
>>   	/* First try fast implementation. */
>>   	for (;;) {
>> -		if (!lm--) {
>> -			ret = len1 == len2 ? 0 : 1;
>> -			goto out;
>> -		}
>> +		if (!lm--)
>> +			return len1 == len2 ? 0 : 1;
>>   
>>   		if ((c1 = *n1++) == (c2 = *n2++))
>>   			continue;
>> @@ -442,10 +440,8 @@ static int ntfs_d_compare(const struct dentry *dentry, unsigned int len1,
>>   		if (c1 >= 0x80 || c2 >= 0x80)
>>   			break;
>>   
>> -		if (toupper(c1) != toupper(c2)) {
>> -			ret = 1;
>> -			goto out;
>> -		}
>> +		if (toupper(c1) != toupper(c2))
>> +			return 1;
>>   	}
>>   
>>   	/*
>>
>> base-commit: d45da67caedacd500879de5e649360cc70777af7
>> -- 
>> 2.37.3
>>
>>
