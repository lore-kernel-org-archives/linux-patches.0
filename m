Received: from mx01.omp.ru (mx01.omp.ru [90.154.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 652393D96D
	for <patches@lists.linux.dev>; Tue,  5 Dec 2023 09:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=omp.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=omp.ru
Received: from [192.168.1.104] (178.176.74.217) by msexch01.omp.ru
 (10.188.4.12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1258.12; Tue, 5 Dec
 2023 12:04:38 +0300
Subject: Re: [PATCH 5.15 44/67] ravb: Separate handling of irq enable/disable
 regs into feature
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
CC: <patches@lists.linux.dev>, Phil Edworthy <phil.edworthy@renesas.com>, Biju
 Das <biju.das.jz@bp.renesas.com>, "David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
References: <20231205031519.853779502@linuxfoundation.org>
 <20231205031522.365127466@linuxfoundation.org>
From: Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <d33f2fef-4623-1f74-0765-6998c2a65999@omp.ru>
Date: Tue, 5 Dec 2023 12:04:37 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20231205031522.365127466@linuxfoundation.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: msexch01.omp.ru (10.188.4.12) To msexch01.omp.ru
 (10.188.4.12)
X-KSE-ServerInfo: msexch01.omp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 6.0.0, Database issued on: 12/05/2023 08:44:32
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 59
X-KSE-AntiSpam-Info: Lua profiles 181841 [Dec 05 2023]
X-KSE-AntiSpam-Info: Version: 6.0.0.2
X-KSE-AntiSpam-Info: Envelope from: s.shtylyov@omp.ru
X-KSE-AntiSpam-Info: LuaCore: 5 0.3.5 98d108ddd984cca1d7e65e595eac546a62b0144b
X-KSE-AntiSpam-Info: {rep_avail}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: {relay has no DNS name}
X-KSE-AntiSpam-Info: {SMTP from is not routable}
X-KSE-AntiSpam-Info: {Found in DNSBL: 178.176.74.217 in (user)
 b.barracudacentral.org}
X-KSE-AntiSpam-Info: {Found in DNSBL: 178.176.74.217 in (user)
 dbl.spamhaus.org}
X-KSE-AntiSpam-Info:
	omp.ru:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2;178.176.74.217:7.1.2
X-KSE-AntiSpam-Info: ApMailHostAddress: 178.176.74.217
X-KSE-AntiSpam-Info: {DNS response errors}
X-KSE-AntiSpam-Info: Rate: 59
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dmarc=temperror header.from=omp.ru;spf=temperror
 smtp.mailfrom=omp.ru;dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 12/05/2023 08:50:00
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 12/5/2023 6:02:00 AM
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit

On 12/5/23 6:17 AM, Greg Kroah-Hartman wrote:

> 5.15-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Phil Edworthy <phil.edworthy@renesas.com>
> 
> [ Upstream commit cb99badde146c327f150773921ffe080abe1eb44 ]
> 
> Currently, when the HW has a single interrupt, the driver uses the
> GIC, TIC, RIC0 registers to enable and disable interrupts.
> When the HW has multiple interrupts, it uses the GIE, GID, TIE, TID,
> RIE0, RID0 registers.
> 
> However, other devices, e.g. RZ/V2M, have multiple irqs and only have
> the GIC, TIC, RIC0 registers.
> Therefore, split this into a separate feature.
> 
> Signed-off-by: Phil Edworthy <phil.edworthy@renesas.com>
> Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
> Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Stable-dep-of: eac16a733427 ("net: ravb: Stop DMA in case of failures on ravb_open()")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
[...]

   This and the following patch shouldn't be necessary If you have troubles
backporting the actual fix to 5.15, please ask me to look at it instead...

MBR, Sergey
