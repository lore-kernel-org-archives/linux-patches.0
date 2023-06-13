Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF13B2415C;
	Tue, 13 Jun 2023 09:27:08 +0000 (UTC)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
	by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
	id 1q90Is-0004W8-FQ; Tue, 13 Jun 2023 11:27:06 +0200
Message-ID: <23d5f9d6-f0db-a9af-1291-e9d6ac3cd126@leemhuis.info>
Date: Tue, 13 Jun 2023 11:27:05 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
Subject: Re: [PATCH 6.3 136/286] media: dvb-core: Fix use-after-free on race
 condition at dvb_frontend
Content-Language: en-US, de-DE
To: Stefan Lippers-Hollmann <s.l-h@gmx.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 Hyunwoo Kim <imv4bel@gmail.com>, Mauro Carvalho Chehab <mchehab@kernel.org>,
 Sasha Levin <sashal@kernel.org>,
 Linux kernel regressions list <regressions@lists.linux.dev>
References: <20230607200922.978677727@linuxfoundation.org>
 <20230607200927.531074599@linuxfoundation.org> <20230613053314.70839926@mir>
 <20230613110006.7c660162@mir>
From: "Linux regression tracking (Thorsten Leemhuis)"
 <regressions@leemhuis.info>
In-Reply-To: <20230613110006.7c660162@mir>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1686648429;5ed6639a;
X-HE-SMSGID: 1q90Is-0004W8-FQ

On 13.06.23 11:00, Stefan Lippers-Hollmann wrote:
> On 2023-06-13, Stefan Lippers-Hollmann wrote:
>> On 2023-06-07, Greg Kroah-Hartman wrote:
>>> From: Hyunwoo Kim <imv4bel@gmail.com>
>>>
>>> [ Upstream commit 6769a0b7ee0c3b31e1b22c3fadff2bfb642de23f ]
>>>
>>> If the device node of dvb_frontend is open() and the device is
>>> disconnected, many kinds of UAFs may occur when calling close()
>>> on the device node.
>>>
>>> The root cause of this is that wake_up() for dvbdev->wait_queue
>>> is implemented in the dvb_frontend_release() function, but
>>> wait_event() is not implemented in the dvb_frontend_stop() function.
>>>
>>> So, implement wait_event() function in dvb_frontend_stop() and
>>> add 'remove_mutex' which prevents race condition for 'fe->exit'.
>>>
>>> [mchehab: fix a couple of checkpatch warnings and some mistakes at the error handling logic]
>>>
>>> Link: https://lore.kernel.org/linux-media/20221117045925.14297-2-imv4bel@gmail.com
>> [...]
>>
>> I'm noticing a regression relative to kernel v6.3.6 with this change
>> as part of kernel v6.3.7 on my ivy-bridge system running
>> Debian/unstable (amd64) with vdr 2.6.0-1.1[0] and two DVB cards
>> TeVii S480 V2.1 (DVB-S2, dw2102) and an Xbox One Digital TV Tuner
>> (DVB-T2, dvb_usb_dib0700). The systemd unit starting vdr just times
>> out and hangs forever, with vdr never coming up and also preventing
>> a clean system shutdown (hard reset required). Apart from the systemd
>> unit timing out, there don't really appear to be any further issues
>> logged.
> [...]
> 
> I've now also tested v6.4-rc6-26-gfb054096aea0 and can reproduce
> this regression there as well, with the same fix of reverting this
> corresponding patch.
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=6769a0b7ee0c3b31e1b22c3fadff2bfb642de23f

Earlier report about problem due to 6769a0b7ee0c:
https://lore.kernel.org/all/da5382ad-09d6-20ac-0d53-611594b30861@lio96.de/

Proposed revert:
https://lore.kernel.org/all/20230609082238.3671398-1-mchehab@kernel.org/

Mauro, now that the patch made it into a stable tree, could you help
getting the revert quickly to Linus? Or shall we maybe ask him to pick
it up straight from the list?

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
--
Everything you wanna know about Linux kernel regression tracking:
https://linux-regtracking.leemhuis.info/about/#tldr
If I did something stupid, please tell me, as explained on that page.
