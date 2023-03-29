Received: from sipsolutions.net (s3.sipsolutions.net [144.76.43.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8E48538F;
	Wed, 29 Mar 2023 17:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=ndV/uVcgkkvqmSP7Qrduc49yJn9Zllur/T1MQQBPJbk=;
	t=1680111500; x=1681321100; b=Lj/g5CKHbpZ2v9lKWoSAXKEma922HxX1VjU7/faVY6Yc3rA
	sI3SuoQccp8s7ROUKnRGEIjPM/FR4LutB/7m/PDa+wirAiJOVaeet4EF1leMK07MA1SdYvZYH/p16
	LtK2zc7jJOeHE5VmBCDPVuTjGCL1jShIF8pRxxJ9pIIRZYKDrXoVSftfu8j99iKdNz8i7Urp2hMeE
	yvlvpRcQwKXZqLGYfFBtslUkkInZTCcazhcGKKlox3pO575psIoDaNXTbgiHh92i/kpwDS5gOCTw+
	4cXSPsTknRFQQ7IRV/YXUr0OJ+v6A8ALH7GFohZuuxmu/ia+yWlBVJ4ztb03+R/Q==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <johannes@sipsolutions.net>)
	id 1phZTY-000AWN-1j;
	Wed, 29 Mar 2023 19:20:44 +0200
Message-ID: <9058a032c177e9b04adbf944ad34c5ed8090d9d6.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next] wifi: iwlwifi: mvm: Avoid 64-bit division
 in iwl_mvm_get_crosstimestamp_fw()
From: Johannes Berg <johannes@sipsolutions.net>
To: Nathan Chancellor <nathan@kernel.org>, gregory.greenman@intel.com, 
	kvalo@kernel.org
Cc: ndesaulniers@google.com, trix@redhat.com, avraham.stern@intel.com, 
 krishnanand.prabhu@intel.com, linux-wireless@vger.kernel.org, 
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
  patches@lists.linux.dev, Arnd Bergmann <arnd@arndb.de>, "kernelci.org bot"
 <bot@kernelci.org>
Date: Wed, 29 Mar 2023 19:20:43 +0200
In-Reply-To: <20230329-iwlwifi-ptp-avoid-64-bit-div-v1-1-ad8db8d66bc2@kernel.org>
References: 
	<20230329-iwlwifi-ptp-avoid-64-bit-div-v1-1-ad8db8d66bc2@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Wed, 2023-03-29 at 10:05 -0700, Nathan Chancellor wrote:
>=20
> GCC has optimizations for division by a constant that clang does not
> implement, so this issue is not visible when building with GCC.

Huh yeah, we did 32-bit builds with gcc ...

> Using div_u64() would resolve this issue, but Arnd points out that this
> can be quite expensive and the timestamp is being read at nanosecond
> granularity.=C2=A0

Doesn't matter though, all the calculations are based on just the
command response from the firmware, which (tries to) take it in a
synchronised fashion.

So taking more time here would be fine, as far as I can tell.

> Nick pointed out that the result of this division is being
> stored to a 32-bit type anyways, so truncate gp2_10ns first then do the
> division, which elides the need for libcalls.

That loses ~7 top bits though, no? I'd be more worried about that, than
the time div_u64() takes.

johannes
