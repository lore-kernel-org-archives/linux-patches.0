Received: from gateway33.websitewelcome.com (gateway33.websitewelcome.com [192.185.146.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3731128E4
	for <patches@lists.linux.dev>; Fri, 25 Mar 2022 18:55:31 +0000 (UTC)
Received: from cm14.websitewelcome.com (cm14.websitewelcome.com [100.42.49.7])
	by gateway33.websitewelcome.com (Postfix) with ESMTP id 36DFA5C92FE
	for <patches@lists.linux.dev>; Fri, 25 Mar 2022 13:30:33 -0500 (CDT)
Received: from 162-215-252-75.unifiedlayer.com ([208.91.199.152])
	by cmsmtp with SMTP
	id XohknZC6fHnotXohlnXp1Z; Fri, 25 Mar 2022 13:30:33 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=roeck-us.net; s=default; h=In-Reply-To:Content-Type:MIME-Version:References
	:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding
	:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=80vh7X070gDeOIjK2REY7MHyqK0ws37UQzBUZts92ps=; b=1kOb/uFZzFE60JKhI8A9JlpPuO
	mT9P0zueD1dmCLaMrvZOxC3Y1iT+N6JeZcuU86tJxvtwTDyU/At8hQP/TuUQT66bpab2QRFk+RbJW
	VG33fP9l29+UsdymQNpkhdPL/0ua+0ekVjEQAhx+qeWvPdB025E/ZVDB3o9Cz5+Fgw2u1MEABOjD1
	IRsRff2MvcBP3ZBadQ8pC97GvD0uCEXdEiE95LPpDEuMVSfGo1FDhGd/qAvXphGWNJ2qftldA/Jtr
	7EhA8lZ31eB8fdGA+Eo0PqIk2LkcSRqW/gUHQGo5JVLB2JvyA+KtXnvZqlRqXbcs0vsX7ZP4uLAYL
	2KX/ClTw==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:57662 helo=localhost)
	by bh-25.webhostbox.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@roeck-us.net>)
	id 1nXohk-0042ix-F5; Fri, 25 Mar 2022 18:30:32 +0000
Date: Fri, 25 Mar 2022 11:30:31 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Nathan Chancellor <nathan@kernel.org>
Cc: David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>,
	kernel test robot <lkp@intel.com>, llvm@lists.linux.dev,
	Nick Desaulniers <ndesaulniers@google.com>, patches@lists.linux.dev,
	dri-devel@lists.freedesktop.org, Claudio Suarez <cssk@net-c.es>
Subject: Re: [PATCH] drm/selftest: plane_helper: Put test structures in
 static storage
Message-ID: <20220325183031.GA1493950@roeck-us.net>
References: <20220302235909.784935-1-nathan@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220302235909.784935-1-nathan@kernel.org>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-BWhitelist: no
X-Source-IP: 108.223.40.66
X-Source-L: No
X-Exim-ID: 1nXohk-0042ix-F5
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net (localhost) [108.223.40.66]:57662
X-Source-Auth: guenter@roeck-us.net
X-Email-Count: 3
X-Source-Cap: cm9lY2s7YWN0aXZzdG07YmgtMjUud2ViaG9zdGJveC5uZXQ=
X-Local-Domain: yes

On Wed, Mar 02, 2022 at 04:59:09PM -0700, Nathan Chancellor wrote:
> Clang warns on certain 32-bit architectures:
> 
>   drivers/gpu/drm/selftests/test-drm_plane_helper.c:76:5: warning: stack frame size (1064) exceeds limit (1024) in 'igt_check_plane_state' [-Wframe-larger-than]
>   int igt_check_plane_state(void *ignored)
>       ^
>   1 warning generated.
> 
> The structures in igt_check_plane_state() total 1008 bytes, so any small
> amount of inlining will cause the stack frame to exceed the 32-bit limit
> of 1024, triggering the warning.
> 
> Move these structures to static storage, which dramatically reduces the
> amount of stack space in igt_check_plane_state(). There is no testing
> impact, as igt_check_plane_state() is only called once in the driver.
> 
> Fixes: 943e6a8beeac ("mock a drm_plane in igt_check_plane_state to make the test more robust")
> Link: https://github.com/ClangBuiltLinux/linux/issues/1600
> Reported-by: kernel test robot <lkp@intel.com>
> Suggested-by: Nick Desaulniers <ndesaulniers@google.com>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

Tested-by: Guenter Roeck <linux@roeck-us.net>

Note that the offending patch is now in mainline and results in test build
failures there.

Building csky:allmodconfig ... failed
--------------
Error log:
drivers/gpu/drm/selftests/test-drm_plane_helper.c: In function 'igt_check_plane_state':
drivers/gpu/drm/selftests/test-drm_plane_helper.c:223:1: error: the frame size of 1072 bytes is larger than 1024 bytes

This is with gcc 11.2.

Guenter
